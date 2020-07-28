import 'package:clients/model/add_on.dart';

class AddOnsType {
  final String id;
  final String name;
  final String options;
  final List<AddOn> addOns;

  AddOnsType({this.id, this.name, this.options, this.addOns});

  factory AddOnsType.fromJson(Map<String, dynamic> parsedJson) {
    var adOnsJson = parsedJson['sub_item'] as List;
    List<AddOn> list = adOnsJson.map((i) {
      return AddOn.fromJson(i);
    }).toList();

    return AddOnsType(
        id: parsedJson['subcat_id'],
        name: parsedJson['subcat_name'],
        options: parsedJson['multi_option'],
        addOns: list);
  }

  double getAmount() {
    double amount = 0;

    this.addOns.forEach((e) {
      if (e.isSelected) {
        amount = amount + e.price * e.quantity;
      }
    });

    return amount;
  }

  List<AddOn> getSelectedAddOn(){
    List<AddOn> list = List();

    this.addOns.forEach((e) {
      if (e.isSelected){
        list.add(e);
      }
    });

    return list;
  }
}
