import 'package:clients/model/home_page_data.dart';
import 'package:clients/model/home_page_indicator.dart';

class HomeState {
  final HomePageData homePageData;
  final String appBarTitle;
  final bool isAppBarLoading;
  final bool isAppBarDropDownVisible;
  final bool isFlagVisible;
  final String leading;

  final HomePageIndicator indicator;

  HomeState(
      {this.appBarTitle,
      this.isAppBarLoading,
      this.isAppBarDropDownVisible,
      this.isFlagVisible,
      this.homePageData,
      this.leading,
      this.indicator});
}

class InitialHomeState extends HomeState {
  InitialHomeState()
      : super(
            appBarTitle: "",
            isAppBarLoading: false,
            isAppBarDropDownVisible: false,
            isFlagVisible: false,
            indicator: HomePageIndicator(
                topRestaurantPage: 0,
                dblRestaurantPage: 0,
                hasDblReachedMax: false,
                hasTopReachedMax: false,
                isDblRestaurantLoading: false,
                isTopRestaurantLoading: false));
}

class LoadingHomeState extends HomeState {
  LoadingHomeState({HomePageData homePageData})
      : super(
          homePageData: homePageData,
          appBarTitle: "Loading Data...",
          isAppBarLoading: true,
          isAppBarDropDownVisible: false,
          isFlagVisible: false,
          indicator: HomePageIndicator(
              topRestaurantPage: 0,
              dblRestaurantPage: 0,
              hasDblReachedMax: false,
              hasTopReachedMax: false,
              isDblRestaurantLoading: false,
              isTopRestaurantLoading: false),
        );
}

class ErrorHomeState extends HomeState {
  final String message;

  ErrorHomeState(this.message,
      {HomePageData homePageData, HomePageIndicator indicator})
      : super(
            homePageData: homePageData,
            appBarTitle: "Error Get Data",
            isAppBarLoading: false,
            isAppBarDropDownVisible: false,
            isFlagVisible: false,
            indicator: indicator);
}

class NoHomepageData extends HomeState {
  NoHomepageData(
      {HomePageData homePageData,
      String appBarTitle,
      String leading,
      bool isFlagVisible,
      HomePageIndicator indicator})
      : super(
            homePageData: homePageData,
            leading: leading,
            appBarTitle: appBarTitle,
            isAppBarLoading: false,
            isAppBarDropDownVisible: true,
            isFlagVisible: isFlagVisible ?? false,
            indicator: indicator);
}

class LoadingCurrentLocation extends HomeState {
  LoadingCurrentLocation(
      {HomePageData homePageData, HomePageIndicator indicator})
      : super(
            homePageData: homePageData,
            appBarTitle: "Loading Current Location...",
            isAppBarLoading: true,
            isAppBarDropDownVisible: false,
            isFlagVisible: false,
            indicator: indicator);
}

class ErrorCurrentLocation extends HomeState {
  final String message;

  ErrorCurrentLocation(this.message,
      {HomePageData homePageData, HomePageIndicator indicator})
      : super(
            homePageData: homePageData,
            appBarTitle: "Error Get Location",
            isAppBarLoading: false,
            isAppBarDropDownVisible: true,
            isFlagVisible: false,
            indicator: indicator);
}

class ErrorLoadingTopRestaurant extends HomeState {
  final String message;

  ErrorLoadingTopRestaurant(
    this.message, {
    HomePageData homePageData,
    HomePageIndicator indicator,
    String appBarTitle,
    bool isAppBarLoading,
    bool isAppBarDropDownVisible,
    bool isFlagVisible,
    String leading,
  }) : super(
            homePageData: homePageData,
            appBarTitle: appBarTitle,
            isAppBarLoading: isAppBarLoading,
            isAppBarDropDownVisible: isAppBarDropDownVisible,
            isFlagVisible: isFlagVisible,
            leading: leading,
            indicator: indicator);
}

class ErrorLoadingDblRestaurant extends HomeState {
  final String message;

  ErrorLoadingDblRestaurant(
      this.message, {
        HomePageData homePageData,
        HomePageIndicator indicator,
        String appBarTitle,
        bool isAppBarLoading,
        bool isAppBarDropDownVisible,
        bool isFlagVisible,
        String leading,
      }) : super(
      homePageData: homePageData,
      appBarTitle: appBarTitle,
      isAppBarLoading: isAppBarLoading,
      isAppBarDropDownVisible: isAppBarDropDownVisible,
      isFlagVisible: isFlagVisible,
      leading: leading,
      indicator: indicator);
}
