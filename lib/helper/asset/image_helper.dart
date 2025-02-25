enum ImageSize {
  small,
  medium,
  large,
}

String getImageUrl({required String id, ImageSize? size = ImageSize.small}) {
  return 'https://restaurant-api.dicoding.dev/images/${size?.name ?? 'small'}/$id';
}

String getLocalImagePath({required String name}) {
  return 'assets/images/$name';
}
