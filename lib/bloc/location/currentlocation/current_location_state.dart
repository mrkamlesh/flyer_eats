class CurrentLocationState {
  final double lat;
  final double lng;
  final String address;

  CurrentLocationState({this.lat, this.lng, this.address});
}

class InitialCurrentLocationState extends CurrentLocationState {
  InitialCurrentLocationState()
      : super(lat: 28.620446, lng: 77.227515, address: "...");
}

class LoadingCurrentLocationState extends CurrentLocationState {
  LoadingCurrentLocationState({double lat, double lng, String address})
      : super(lat: lat, lng: lng, address: address);
}

class SuccessCurrentLocationState extends CurrentLocationState {
  SuccessCurrentLocationState({double lat, double lng, String address})
      : super(lat: lat, lng: lng, address: address);
}

class ErrorCurrentLocationState extends CurrentLocationState {
  final String message;

  ErrorCurrentLocationState(this.message,
      {double lat, double lng, String address})
      : super(lat: lat, lng: lng, address: address);
}
