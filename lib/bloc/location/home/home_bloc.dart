import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:clients/classes/app_exceptions.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/data_repository.dart';
import 'package:clients/model/home_page_data.dart';
import 'package:clients/model/location.dart';
import 'package:clients/model/restaurant.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import './bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  DataRepository repository = DataRepository();

  @override
  HomeState get initialState => InitialHomeState();

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is GetHomeDataByLatLng) {
      yield* mapGetHomeDataByLatLngToState(event.token, event.lat, event.lng);
    } else if (event is GetHomeDataByLocation) {
      yield* mapGetHomeDataByLocationToState(event.token, event.location);
    } else if (event is InitGetData) {
      yield* mapInitGetDataToState(
          event.token, event.location, event.lastSavedLocation);
    } else if (event is LoadMoreTopRestaurant) {
      yield* mapLoadMoreTopRestaurantToState(event.token, event.location);
    } else if (event is LoadMoreDblRestaurant) {
      yield* mapLoadMoreDblRestaurantToState(event.token, event.location);
    }
  }

  Stream<HomeState> mapGetHomeDataByLatLngToState(
      String token, double lat, double lng) async* {
    yield LoadingHomeState();

    try {
      var data = await repository.getHomePageData(
          token: token,
          lat: lat,
          long: lng,
          topRestaurantPage: 0,
          foodCategoryPage: 0,
          dblPage: 0,
          adsPage: 0,
          time: DateFormat('hh:mm').format(DateTime.now()));
      if (data is HomePageData) {
        yield HomeState(
            homePageData: data,
            leading: getLeading(data.countryId),
            appBarTitle: data.location.address,
            isAppBarDropDownVisible: true,
            isFlagVisible: true,
            isAppBarLoading: false,
            indicator: state.indicator);
        /*try {
          repository.saveAddress(data.location.address);
        } catch (e) {
          print(e);
        }*/
      } else {
        List<Placemark> placeMark =
            await Geolocator().placemarkFromCoordinates(lat, lng);

        String thoroughfare = (placeMark[0].thoroughfare != "" &&
                placeMark[0].thoroughfare != null)
            ? placeMark[0].thoroughfare + " "
            : "";
        String subThoroughfare = (placeMark[0].subThoroughfare != "" &&
                placeMark[0].subThoroughfare != null)
            ? placeMark[0].subThoroughfare + " "
            : "";
        String subLocality =
            (placeMark[0].subLocality != "" && placeMark[0].subLocality != null)
                ? placeMark[0].subLocality + " "
                : "";
        String locality =
            (placeMark[0].locality != "" && placeMark[0].locality != null)
                ? placeMark[0].locality + " "
                : "";
        String subAdministrativeArea =
            (placeMark[0].subAdministrativeArea != "" &&
                    placeMark[0].subAdministrativeArea != null)
                ? placeMark[0].subAdministrativeArea + " "
                : "";
        String administrativeArea = (placeMark[0].administrativeArea != "" &&
                placeMark[0].administrativeArea != null)
            ? placeMark[0].administrativeArea + " "
            : "";
        String postalCode =
            (placeMark[0].postalCode != "" && placeMark[0].postalCode != null)
                ? placeMark[0].postalCode + " "
                : "";

        String leading = getLeading(placeMark[0].isoCountryCode);

        yield NoHomepageData(
            leading: leading != "" ? leading : null,
            isFlagVisible: leading != "" ? true : false,
            appBarTitle: thoroughfare +
                subThoroughfare +
                subLocality +
                locality +
                subAdministrativeArea +
                administrativeArea +
                postalCode,
            indicator: state.indicator);
      }
    } catch (e) {
      yield ErrorHomeState(e.toString());
    }
  }

  Stream<HomeState> mapGetHomeDataByLocationToState(
      String token, Location location) async* {
    yield LoadingHomeState();

    try {
      var data = await repository.getHomePageData(
          token: token,
          address: location.address,
          topRestaurantPage: 0,
          foodCategoryPage: 0,
          dblPage: 0,
          adsPage: 0,
          time: DateFormat('HH:mm').format(DateTime.now()));
      if (data is HomePageData) {
        yield HomeState(
            homePageData: data,
            leading: getLeading(data.countryId),
            appBarTitle: data.location.address,
            isAppBarDropDownVisible: true,
            isFlagVisible: true,
            isAppBarLoading: false,
            indicator: state.indicator);
      } else {
        yield NoHomepageData(appBarTitle: "This Location is not Available");
      }
    } catch (e) {
      yield ErrorHomeState(e.toString());
    }
  }

  Stream<HomeState> mapInitGetDataToState(
      String token, Location location, String lastSavedLocation) async* {
    yield LoadingCurrentLocation();

    if (location != null) {
      add(GetHomeDataByLocation(location, token));
    } else {
      try {
        //String address = await repository.getSavedAddress();
        if (lastSavedLocation != null && lastSavedLocation != "") {
          add(GetHomeDataByLocation(
              Location(address: lastSavedLocation), token));
        } else {
          try {
            await AppUtil.checkLocationServiceAndPermission();
            Position position = await Geolocator()
                .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium)
                .timeout(Duration(seconds: 3), onTimeout: () {
              throw AppException(
                  "Unable to fetch your Current Location, Click the MAP to select the address",
                  "");
            });

            add(GetHomeDataByLatLng(
                token, position.latitude, position.longitude));
          } catch (e) {
            yield ErrorCurrentLocation("Can not get location");
          }
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Stream<HomeState> mapLoadMoreTopRestaurantToState(
      String token, Location location) async* {
    if (!(state.indicator.hasTopReachedMax)) {
      yield HomeState(
          appBarTitle: state.appBarTitle,
          homePageData: state.homePageData,
          isAppBarDropDownVisible: state.isAppBarDropDownVisible,
          isAppBarLoading: state.isAppBarLoading,
          isFlagVisible: state.isFlagVisible,
          leading: state.leading,
          indicator: state.indicator.copyWith(isTopRestaurantLoading: true));

      try {
        List<Restaurant> top = await repository.getTopRestaurantList(
            token,
            location.address,
            state.indicator.topRestaurantPage + 1,
            DateFormat('HH:mm').format(DateTime.now()));
        if (top.isNotEmpty) {
          HomePageData homePageData = state.homePageData;
          homePageData.topRestaurants.addAll(top);
          yield HomeState(
              appBarTitle: state.appBarTitle,
              homePageData: homePageData,
              isAppBarDropDownVisible: state.isAppBarDropDownVisible,
              isAppBarLoading: state.isAppBarLoading,
              isFlagVisible: state.isFlagVisible,
              leading: state.leading,
              indicator: state.indicator.copyWith(
                  isTopRestaurantLoading: false,
                  topRestaurantPage: state.indicator.topRestaurantPage + 1,
                  hasTopReachedMax: false));
        } else {
          yield HomeState(
              appBarTitle: state.appBarTitle,
              homePageData: state.homePageData,
              isAppBarDropDownVisible: state.isAppBarDropDownVisible,
              isAppBarLoading: state.isAppBarLoading,
              isFlagVisible: state.isFlagVisible,
              leading: state.leading,
              indicator: state.indicator.copyWith(
                  isTopRestaurantLoading: false, hasTopReachedMax: true));
        }
      } catch (e) {
        yield ErrorLoadingTopRestaurant(e.toString(),
            indicator: state.indicator.copyWith(isTopRestaurantLoading: false),
            leading: state.leading,
            isFlagVisible: state.isFlagVisible,
            isAppBarLoading: state.isAppBarLoading,
            isAppBarDropDownVisible: state.isAppBarDropDownVisible,
            homePageData: state.homePageData,
            appBarTitle: state.appBarTitle);
      }
    }
  }

  Stream<HomeState> mapLoadMoreDblRestaurantToState(
      String token, Location location) async* {
    if (!(state.indicator.hasDblReachedMax)) {
      yield HomeState(
          appBarTitle: state.appBarTitle,
          homePageData: state.homePageData,
          isAppBarDropDownVisible: state.isAppBarDropDownVisible,
          isAppBarLoading: state.isAppBarLoading,
          isFlagVisible: state.isFlagVisible,
          leading: state.leading,
          indicator: state.indicator.copyWith(isDblRestaurantLoading: true));

      try {
        List<Restaurant> dbl = await repository.getDblRestaurantList(
            token,
            location.address,
            state.indicator.dblRestaurantPage + 1,
            DateFormat('HH:mm').format(DateTime.now()));
        if (dbl.isNotEmpty) {
          HomePageData homePageData = state.homePageData;
          homePageData.dblRestaurants.addAll(dbl);
          yield HomeState(
              appBarTitle: state.appBarTitle,
              homePageData: homePageData,
              isAppBarDropDownVisible: state.isAppBarDropDownVisible,
              isAppBarLoading: state.isAppBarLoading,
              isFlagVisible: state.isFlagVisible,
              leading: state.leading,
              indicator: state.indicator.copyWith(
                  isDblRestaurantLoading: false,
                  dblRestaurantPage: state.indicator.dblRestaurantPage + 1,
                  hasDblReachedMax: false));
        } else {
          yield HomeState(
              appBarTitle: state.appBarTitle,
              homePageData: state.homePageData,
              isAppBarDropDownVisible: state.isAppBarDropDownVisible,
              isAppBarLoading: state.isAppBarLoading,
              isFlagVisible: state.isFlagVisible,
              leading: state.leading,
              indicator: state.indicator.copyWith(
                  isDblRestaurantLoading: false, hasDblReachedMax: true));
        }
      } catch (e) {
        yield ErrorLoadingDblRestaurant(e.toString(),
            indicator: state.indicator.copyWith(isDblRestaurantLoading: false),
            leading: state.leading,
            isFlagVisible: state.isFlagVisible,
            isAppBarLoading: state.isAppBarLoading,
            isAppBarDropDownVisible: state.isAppBarDropDownVisible,
            homePageData: state.homePageData,
            appBarTitle: state.appBarTitle);
      }
    }
  }

  String getLeading(String countryId) {
    switch (countryId.toUpperCase()) {
      case "IN":
        return "assets/india_flag.svg";
        break;
      case "SG":
        return "assets/singapore_flag.svg";
        break;
      default:
        return "";
    }
  }
}
