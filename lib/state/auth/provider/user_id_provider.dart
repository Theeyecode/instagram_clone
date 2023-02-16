import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_course/state/auth/provider/auth_state_provider.dart';
import 'package:instagram_clone_course/state/posts/typdefs/user_id.dart';

final userIdProvider =
    Provider<UserId?>((ref) => ref.watch(authStateProvider).userId);
