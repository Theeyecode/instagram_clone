import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image/image.dart' as img;

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_course/state/constants/firebase_collection_name.dart';
import 'package:instagram_clone_course/state/image_upload/constants/constants.dart';
import 'package:instagram_clone_course/state/image_upload/exceptions/could_not_build_thumbnail_exception.dart';
import 'package:instagram_clone_course/state/image_upload/extensions/get_collection_name_from_file_type.dart';
import 'package:instagram_clone_course/state/image_upload/extensions/get_image_data_aspect_ratio.dart';
import 'package:instagram_clone_course/state/image_upload/models/file_type.dart';
import 'package:instagram_clone_course/state/image_upload/typedefs/is_loading.dart';
import 'package:instagram_clone_course/state/post_settings/models/post_settings.dart';
import 'package:instagram_clone_course/state/posts/models/post_payload.dart';
import 'package:instagram_clone_course/state/posts/typdefs/user_id.dart';
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ImageUploadNotifier extends StateNotifier<Isloading> {
  ImageUploadNotifier() : super(false);

  //!create a setter to tell the Application if its loading or not.... instead of saying state is true, you can say isLoading is true
  set isLoading(bool value) => state = value;

  Future<bool> upLoad(
      {required File file,
      required FileType fileType,
      required String message,
      required Map<PostSetting, bool> postSettings,
      required UserId userId}) async {
    isLoading = true;

    late Uint8List thumbnailUint8list;

    switch (fileType) {
      case FileType.image:
        final fileAsImage = img.decodeImage(file.readAsBytesSync());
        if (fileAsImage == null) {
          isLoading = false;
          throw const CouldNotBuildThumbnailException();
        }
        //!create thumbnail
        final thumbnail = img.copyResize(
          fileAsImage,
          width: Constants.imageThumbnailWidth,
        );
        final thumbnailData = img.encodeJpg(
          thumbnail,
        );
        thumbnailUint8list = Uint8List.fromList(
          thumbnailData,
        );
        break;
      case FileType.video:
        final fileAsVideo = await VideoThumbnail.thumbnailData(
          video: file.path,
          imageFormat: ImageFormat.JPEG,
          quality: Constants.videoThumbnailQuality,
          maxHeight: Constants.videoThumbnailMaxHeight,
        );
        if (fileAsVideo == null) {
          isLoading = false;
          throw const CouldNotBuildThumbnailException();
        }
        thumbnailUint8list = fileAsVideo;
        break;
    }

    //! calculate the aspect ratio... doesn't need to be in try and catch

    final thumbnailAspectRatio = await thumbnailUint8list.getAspectRatio();

    //!calculate refrence
    final fileName = const Uuid().v4();

    //! create references to the thumbnail and the image itself
    final thumbnailRef = FirebaseStorage.instance
        .ref()
        .child(userId)
        .child(FirebaseCollectionName.thumbnails)
        .child(fileName);

    final originalFileRef = FirebaseStorage.instance
        .ref()
        .child(userId)
        .child(fileType.collectionName)
        .child(fileName);

    try {
      //! upload thumbnail
      final thumbnailUploadTask =
          await thumbnailRef.putData(thumbnailUint8list);
      final thumbnailStorageId = thumbnailUploadTask.ref.name;

      //! upload original file
      final uploadFileTask = await originalFileRef.putFile(file);
      final originalFileStorageId = uploadFileTask.ref.name;

      //!upload the post itself
      final postPayload = PostPayload(
        userId: userId,
        message: message,
        thumbnailUrl: await thumbnailRef.getDownloadURL(),
        fileUrl: await originalFileRef.getDownloadURL(),
        fileType: fileType,
        fileName: fileName,
        aspectRatio: thumbnailAspectRatio,
        thumbnailStorageId: thumbnailStorageId,
        originalFileStorageId: originalFileStorageId,
        postSettings: postSettings,
      );
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.posts)
          .add(postPayload);
      return true;
    } catch (e) {
      isLoading = false;
    } finally {
      isLoading = false;
    }

    return true;
  }
}
