import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone_course/views/components/dialogs/alert_dialog_model.dart';
import 'package:instagram_clone_course/views/constants/strings.dart';

@immutable
class LogoutDialog extends AlertDialogModel<bool> {
  const LogoutDialog()
      : super(
            title: Strings.logout,
            message: Strings.areYouSureYouWantToLogoutfTheApp,
            buttons: const {Strings.cancel: false, Strings.logout: true});
}
