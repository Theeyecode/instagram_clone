class CouldNotBuildThumbnailException implements Exception {
  final message = 'Could not build thumbnail';
  const CouldNotBuildThumbnailException();
}

class CouldNotBuildAspectRatio implements Exception {
  final message = 'Could not get AspectRatio';
  const CouldNotBuildAspectRatio();
}
