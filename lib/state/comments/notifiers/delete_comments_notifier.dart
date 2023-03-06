import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_course/state/comments/typdefs/comment_id.dart';
import 'package:instagram_clone_course/state/constants/firebase_collection_name.dart';
import 'package:instagram_clone_course/state/image_upload/typedefs/is_loading.dart';

class DeleteCommentStateNotifier extends StateNotifier<Isloading> {
  DeleteCommentStateNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> deleteComment({required CommentId commentId}) async {
    try {
      isLoading = true;
      final query = FirebaseFirestore.instance
          .collection(FirebaseCollectionName.comments)
          .where(FieldPath.documentId, isEqualTo: commentId)
          .limit(1)
          .get(); //!to get data once or read it once

      await query.then((value) async {
        //! Knowing it only returns 1 document
        for (final doc in value.docs) {
         await doc.reference.delete();
        }
      }); 
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}
