import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_course/state/post_settings/models/post_settings.dart';
import 'package:instagram_clone_course/state/post_settings/notifiers/post_settings_notifier.dart';

final postSettingsProviders =
    StateNotifierProvider<PostSettingsNotifier, Map<PostSetting, bool>>(
        (ref) => PostSettingsNotifier());
