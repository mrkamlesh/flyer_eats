import 'package:flyereats/classes/data_provider.dart';
import 'package:flyereats/model/location.dart';

class DataRepository {
  DataProvider _provider = DataProvider();

  Future<List<Location>> getLocations(double lat, double long) async {
    final response = await _provider.getLocations(lat, long);
    var listLocations = response['data'] as List;
    List<Location> locations = listLocations.map((i) {
      return Location.fromJson(i);
    }).toList();
    return locations;
  }
}
