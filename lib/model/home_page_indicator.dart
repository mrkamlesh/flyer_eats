class HomePageIndicator {
  final int topRestaurantPage;
  final int dblRestaurantPage;
  final bool isTopRestaurantLoading;
  final bool isDblRestaurantLoading;
  final bool hasTopReachedMax;
  final bool hasDblReachedMax;

  HomePageIndicator(
      {this.topRestaurantPage,
      this.dblRestaurantPage,
      this.isTopRestaurantLoading,
      this.isDblRestaurantLoading,
      this.hasTopReachedMax,
      this.hasDblReachedMax});

  HomePageIndicator copyWith({
    int topRestaurantPage,
    int dblRestaurantPage,
    bool isTopRestaurantLoading,
    bool isDblRestaurantLoading,
    bool hasTopReachedMax,
    bool hasDblReachedMax,
  }) {
    return HomePageIndicator(
        isTopRestaurantLoading:
            isTopRestaurantLoading ?? this.isTopRestaurantLoading,
        isDblRestaurantLoading:
            isDblRestaurantLoading ?? this.isDblRestaurantLoading,
        hasTopReachedMax: hasTopReachedMax ?? this.hasTopReachedMax,
        hasDblReachedMax: hasDblReachedMax ?? this.hasDblReachedMax,
        dblRestaurantPage: dblRestaurantPage ?? this.dblRestaurantPage,
        topRestaurantPage: topRestaurantPage ?? this.topRestaurantPage);
  }
}
