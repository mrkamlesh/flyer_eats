class Ads {
  final String id;
  final String thumbnail;
  final String photo;
  final String type;
  final String url;
  final String videoUrl;

  Ads({this.id, this.thumbnail, this.photo, this.type, this.url, this.videoUrl});

  factory Ads.fromJson(Map<String, dynamic> parsedJson) {
    return Ads(
        id: parsedJson['ad_id'],
        photo: parsedJson['photo'],
        thumbnail: parsedJson['thumbnail'],
        url: parsedJson['url'],
        type: parsedJson['ads_type'],
        videoUrl: parsedJson['video_url']);
  }
}
