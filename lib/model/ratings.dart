class Rating {
  final String rating;
  final String votes;
  final String averageVotes;
  final String goodVotes;
  final String bestVotes;

  Rating({this.rating, this.votes, this.averageVotes, this.goodVotes, this.bestVotes});

  factory Rating.fromJson(Map<String, dynamic> parsedJson) {
    return Rating(
        rating: parsedJson['ratings'].toString(),
        votes: parsedJson['votes'].toString(),
        averageVotes: parsedJson['average_votes'],
        bestVotes: parsedJson['best_votes'],
        goodVotes: parsedJson['good_votes']);
  }

  List<String> getRollingText() {
    List<String> rollingText = [];
    if (this.votes != null) {
      rollingText.add(this.votes + " Ratings");
    }
    if (this.averageVotes != null) {
      rollingText.add(this.averageVotes);
    }
    if (this.goodVotes != null) {
      rollingText.add(this.goodVotes);
    }
    if (this.bestVotes != null) {
      rollingText.add(this.bestVotes);
    }
    return rollingText;
  }
}
