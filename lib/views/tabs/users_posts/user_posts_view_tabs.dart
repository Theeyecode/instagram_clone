import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_course/extensions/object/log.dart';
import 'package:instagram_clone_course/state/posts/provider/user_posts_provider.dart';
import 'package:instagram_clone_course/views/components/animations/empty_content_with_text_animation_view.dart';
import 'package:instagram_clone_course/views/components/animations/error_animation_view.dart';
import 'package:instagram_clone_course/views/components/animations/loading_animation_view.dart';
import 'package:instagram_clone_course/views/constants/strings.dart';
import 'package:instagram_clone_course/views/post/post_grid_view.dart';

class UserPostsView extends ConsumerWidget {
  const UserPostsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(userPostsProvider);
    return RefreshIndicator(
      onRefresh: () {
        ref.refresh(userPostsProvider);

        return Future.delayed(const Duration(seconds: 1));
      },
      child: posts.when(data: (posts) {
        if (posts.isEmpty) {
          return const EmptyContentWithTextAnimationView(
              text: Strings.youHaveNoPosts);
        } else {
          return PostsGridView(posts: posts);
        }
      }, error: (error, stackTrace) {
        error.log();
        return const ErrorAnimationVoew();
      }, loading: () {
        return const LoadingAnimationView();
      }),
    );
  }
}
