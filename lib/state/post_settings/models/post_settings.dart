import 'package:instagram_clone_course/state/post_settings/constants/constants.dart';

enum PostSetting {
  allowLikes(
    title: PostConstants.allowLikesTitle,
    description: PostConstants.allowLikesDescription,
    storageKey: PostConstants.allowLikesStorageKey,
  ),
  allowComments(
    title: PostConstants.allowCommentsTitle,
    description: PostConstants.allowCommentsDescription,
    storageKey: PostConstants.allowCommentsStorageKey,
  );

  final String title;
  final String description;

  // firebase storage key
  final String storageKey;

  const PostSetting({
    required this.title,
    required this.description,
    required this.storageKey,
  });
}
