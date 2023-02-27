import 'dart:io';

import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone_course/state/image_upload/models/file_type.dart';

@immutable
class ThumbnailRequest {
  final File file;
  final FileType fileType;

  const ThumbnailRequest({required this.file, required this.fileType});
}
