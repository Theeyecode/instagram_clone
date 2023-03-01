import 'dart:io';

import 'package:image_picker/image_picker.dart';

extension ToFile on Future<XFile?> {
  Future<File?> tofile() => then((xFile) => xFile?.path).then(
        (filepath) => filepath != null ? File(filepath) : null,
      );
}
