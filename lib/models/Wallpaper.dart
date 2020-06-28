class Wallpaper {
  final String wallpaperId;
  final int likes;
  final String previewWallpaper;
  final String srcUrl;
  final String fullWallpaperUrl;
  final String wallpaperDomain;
  final String dateAdded;

  Wallpaper(
      {this.wallpaperId,
      this.likes,
      this.previewWallpaper,
      this.srcUrl,
      this.fullWallpaperUrl,
      this.wallpaperDomain,
      this.dateAdded});

  factory Wallpaper.fromJson(Map<String, dynamic> json) {
    return Wallpaper(
        wallpaperId: json['_id'],
        likes: json['likes'],
        previewWallpaper: json['previewWallpaper'],
        srcUrl: json['srcUrl'],
        fullWallpaperUrl: json['fullWallpaperUrl'],
        wallpaperDomain: json['wallpaperDomain'],
        dateAdded: json['dateAdded']);
  }
}
