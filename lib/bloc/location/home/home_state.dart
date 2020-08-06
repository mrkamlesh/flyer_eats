import 'package:clients/model/home_page_data.dart';

class HomeState {
  final HomePageData homePageData;
  final String appBarTitle;
  final bool isAppBarLoading;
  final bool isAppBarDropDownVisible;
  final bool isFlagVisible;
  final String leading;

  HomeState(
      {this.appBarTitle,
      this.isAppBarLoading,
      this.isAppBarDropDownVisible,
      this.isFlagVisible,
      this.homePageData,
      this.leading});
}

class InitialHomeState extends HomeState {
  InitialHomeState()
      : super(appBarTitle: "", isAppBarLoading: false, isAppBarDropDownVisible: false, isFlagVisible: false);
}

class LoadingHomeState extends HomeState {
  LoadingHomeState({HomePageData homePageData})
      : super(
            homePageData: homePageData,
            appBarTitle: "Loading Data...",
            isAppBarLoading: true,
            isAppBarDropDownVisible: false,
            isFlagVisible: false);
}

class ErrorHomeState extends HomeState {
  final String message;

  ErrorHomeState(this.message, {HomePageData homePageData})
      : super(
            homePageData: homePageData,
            appBarTitle: "Error Get Data",
            isAppBarLoading: false,
            isAppBarDropDownVisible: false,
            isFlagVisible: false);
}

class NoHomepageData extends HomeState {
  NoHomepageData({HomePageData homePageData, String appBarTitle, String leading, bool isFlagVisible})
      : super(
            homePageData: homePageData,
            leading: leading,
            appBarTitle: appBarTitle,
            isAppBarLoading: false,
            isAppBarDropDownVisible: true,
            isFlagVisible: isFlagVisible ?? false);
}

class LoadingCurrentLocation extends HomeState {
  LoadingCurrentLocation({HomePageData homePageData})
      : super(
            homePageData: homePageData,
            appBarTitle: "Loading Current Location...",
            isAppBarLoading: true,
            isAppBarDropDownVisible: false,
            isFlagVisible: false);
}

class ErrorCurrentLocation extends HomeState {
  final String message;

  ErrorCurrentLocation(this.message, {HomePageData homePageData})
      : super(
            homePageData: homePageData,
            appBarTitle: "Error Get Location",
            isAppBarLoading: false,
            isAppBarDropDownVisible: true,
            isFlagVisible: false);
}
