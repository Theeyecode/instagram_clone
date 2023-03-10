import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_course/state/auth/backend/authenticator.dart';
import 'package:instagram_clone_course/state/auth/models/auth_results.dart';
import 'package:instagram_clone_course/state/auth/models/auth_states.dart';
import 'package:instagram_clone_course/state/posts/typdefs/user_id.dart';
import 'package:instagram_clone_course/state/user_info/backend/user_info_storage.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  final _authenticator = const Authenticator();
  final _userInfoStorage = const UserInfoStorage();

  AuthStateNotifier() : super(const AuthState.unknown()) {
    if (_authenticator.isAlreadyLoggedIn) {
      state = AuthState(
        result: AuthResult.success,
        isLoading: false,
        userId: _authenticator.userId,
      );
    }
  }

  Future<void> logOut() async {
    state = state.copyWithIsLoading(true);
    await _authenticator.logOut();
    state = const AuthState.unknown();
  }

  Future<void> loginWithGoogle() async {
    state = state.copyWithIsLoading(true);
    final result = await _authenticator.loginWithGoogle();
    final userId = _authenticator.userId;
    if (result == AuthResult.success && userId != null) {
      createUserInfo(userId: userId);
    }
    state = AuthState(
        result: result, isLoading: false, userId: _authenticator.userId);
  }

  Future<void> loginWithFacebook() async {
    state = state.copyWithIsLoading(true);
    final result = await _authenticator.loginWithFacebook();
    final userId = _authenticator.userId;
    if (result == AuthResult.success && userId != null) {
      createUserInfo(userId: userId);
    }
    state = AuthState(
        result: result, isLoading: false, userId: _authenticator.userId);
  }

  Future<void> createUserInfo({required UserId userId}) async {
    await _userInfoStorage.createUserInfo(
        userId: userId,
        displayName: _authenticator.displayName,
        email: _authenticator.email);
  }
}
