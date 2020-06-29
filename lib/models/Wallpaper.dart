class Wallpaper {
  final String wallpaperId;
  final int likes;
  final String previewWallpaper;
  final String srcUrl;
  final String fullWallpaperUrl;
  final String wallpaperDomain;
  final String dateAdded;
  final String uploadedDate;
  final String uploaderName;
  final String uploaderAvatar;
  final int views;
  final List tags;

  Wallpaper(
      {this.wallpaperId,
      this.likes,
      this.previewWallpaper,
      this.srcUrl,
      this.fullWallpaperUrl,
      this.wallpaperDomain,
      this.dateAdded,
      this.uploadedDate,
      this.tags,
      this.uploaderAvatar,
      this.uploaderName,
      this.views});

  factory Wallpaper.fromJson(Map<String, dynamic> json) {
    return Wallpaper(
        wallpaperId: json['_id'],
        likes: json['likes'],
        previewWallpaper: json['previewWallpaper'],
        srcUrl: json['srcUrl'],
        fullWallpaperUrl: json['fullWallpaperUrl'],
        wallpaperDomain: json['wallpaperDomain'],
        dateAdded: json['dateAdded'],
        uploadedDate: json['uploadedDate'],
        uploaderAvatar: json['uploaderAvatar'],
        uploaderName: json['uploaderName'],
        views: json['views'],
        tags: json['tags']);
  }
}
