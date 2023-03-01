import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_course/state/auth/provider/auth_state_provider.dart';
import 'package:instagram_clone_course/state/image_upload/providers/image_upload_provider.dart';

final isLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  final isUploacingImage = ref.watch(imageUploadProvider);
  return authState.isLoading || isUploacingImage ;
});
