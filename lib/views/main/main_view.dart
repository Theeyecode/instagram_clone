import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_course/state/auth/provider/auth_state_provider.dart';
import 'package:instagram_clone_course/state/image_upload/helper/image_picker_helper.dart';
import 'package:instagram_clone_course/state/image_upload/models/file_type.dart';
import 'package:instagram_clone_course/state/post_settings/providers/post_settings_provider.dart';
import 'package:instagram_clone_course/views/components/dialogs/alert_dialog_model.dart';
import 'package:instagram_clone_course/views/components/dialogs/logout_dialog.dart';
import 'package:instagram_clone_course/views/constants/strings.dart';
import 'package:instagram_clone_course/views/create_new_post/create_new_post_view.dart';
import 'package:instagram_clone_course/views/tabs/users_posts/user_posts_view_tabs.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            Strings.appName,
          ),
          actions: [
            IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.film,
              ),
              onPressed: () async {
                final imageFile =
                    await ImagePickerHelper.pickVideoFromGallery();
                if (imageFile == null) {
                  return;
                }
                ref.refresh(postSettingsProviders);
                if (!mounted) {
                  return;
                }

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => CreateNewPostView(
                            fileToPost: imageFile, fileType: FileType.image)));
              },
            ),
            IconButton(
              onPressed: () async {
                final videoFile =
                    await ImagePickerHelper.pickImageFromGallery();
                if (videoFile == null) {
                  return;
                }
                ref.invalidate(postSettingsProviders); // ref.refresh()
                if (!mounted) {
                  return;
                }
                //! Go to the screen to create new post
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => CreateNewPostView(
                            fileToPost: videoFile, fileType: FileType.video)));
              },
              icon: const Icon(
                Icons.add_photo_alternate_outlined,
              ),
            ),
            IconButton(
              onPressed: () async {
                final shouldLogOut =
                    await const LogoutDialog().present(context).then(
                          (value) => value ?? false,
                        );
                if (shouldLogOut) {
                  ref.read(authStateProvider.notifier).logOut();
                }
              },
              icon: const Icon(
                Icons.logout,
              ),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.person,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.search,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.home,
                ),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            UserPostsView(),
            UserPostsView(),
            UserPostsView(),
          ],
        ),
      ),
    );
  }
}
