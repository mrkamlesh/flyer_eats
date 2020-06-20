class Ads {
  final String id;
  final String thumbnail;
  final String content;
  final String type;
  final String url;

  Ads({this.id, this.thumbnail, this.content, this.type, this.url});

  factory Ads.fromJson(Map<String, dynamic> parsedJson) {
    return Ads(
        id: parsedJson['ad_id'],
        content: parsedJson['photo'],
        thumbnail: parsedJson['thumbnail'],
        url: parsedJson['url'],
        type: parsedJson['ads_type']);
  }
}
