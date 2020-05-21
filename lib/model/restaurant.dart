class Restaurant {
  final String name;
  final String image;
  final String location;
  final String review;
  final String description;
  final String discountTitle;
  final String discountDescription;

  Restaurant(
      this.name, this.location, this.review, this.image, this.description,
      {this.discountTitle, this.discountDescription});
}
