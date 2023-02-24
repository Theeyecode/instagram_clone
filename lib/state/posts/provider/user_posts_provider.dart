import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_course/state/auth/provider/user_id_provider.dart';
import 'package:instagram_clone_course/state/constants/firebase_collection_name.dart';
import 'package:instagram_clone_course/state/constants/firebase_field_name.dart';
import 'package:instagram_clone_course/state/posts/models/post.dart';
import 'package:instagram_clone_course/state/posts/models/post_key.dart';

final userPostsProvider = StreamProvider.autoDispose<Iterable<Post>>((ref) {
  final userId = ref.watch(userIdProvider);
  final controller = StreamController<Iterable<Post>>();
  controller.onListen = () {
    controller.sink.add([]);
  };

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.posts)
      .orderBy(FirebaseFieldName.createdAt, descending: true)
      .where(PostKey.userId == userId)
      .snapshots()
      .listen((snapshot) {
    final documents = snapshot.docs;
    final posts = documents
        .where(
          (element) => !element.metadata.hasPendingWrites,
        )
        .map((doc) => Post(postId: doc.id, json: doc.data()));
    controller.sink.add(posts);
  });

  return controller.stream;
});