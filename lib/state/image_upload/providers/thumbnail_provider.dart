import 'package:hooks_riverpod/hooks_riverpod.dart';

final thumbnailprovider = FutureProvider.family
    .autoDispose<ImageWithAspectRatio, ThumbnailRequest>(
        (ref, ThumbnailRequest request) async {
  final Image = image;

  switch (request.fileType) {
    case FileType.image:
      image = Image.file(
        image: request.file,
      );

      break;
    default:
  }
});
