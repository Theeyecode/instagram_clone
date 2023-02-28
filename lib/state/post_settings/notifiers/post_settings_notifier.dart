import 'dart:collection';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_course/state/post_settings/models/post_settings.dart';

class PostSettingsNotifier extends StateNotifier<Map<PostSetting, bool>> {
  PostSettingsNotifier()
      : super(
          UnmodifiableMapView(
            {
              for (final setting in PostSetting.values) setting: true,
            },
          ),
        );

  void setPostSetting(PostSetting) {}
}
