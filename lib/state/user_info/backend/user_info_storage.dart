import 'package:flutter/foundation.dart';
import 'package:instagram_clone_course/state/constants/firebase_collection_name.dart';
import 'package:instagram_clone_course/state/constants/firebase_field_name.dart';
import 'package:instagram_clone_course/state/posts/typdefs/user_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone_course/state/user_info/models/user_info_payload.dart';

@immutable
class UserInfoStorage {
  const UserInfoStorage();

  Future<bool> createUserInfo({
    required UserId userId,
    required String displayName,
    required String? email,
  }) async {
    try {
      // first we need to check if the user exist...
      final userInfo = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .where(FirebaseFieldName.userId, isEqualTo: userId)
          .limit(1)
          .get();

      if (userInfo.docs.isNotEmpty) {
        await userInfo.docs.first.reference.update({
          FirebaseFieldName.displayName: displayName,
          FirebaseFieldName.email: email
        });
        return true;
      }

      final payload = UserInfoPayload(
          userId: userId, displayName: displayName, email: email);

      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .add(payload);
      return true;
    } catch (_) {
      return false;
    }
  }
}
