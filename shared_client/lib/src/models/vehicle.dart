import 'package:shared_client/src/enums/car_type.dart';
import 'package:shared_client/src/models/identifiable.dart';
import 'package:shared_client/src/models/owner.dart';
import 'package:uuid/uuid.dart';

class Vehicle implements Identifiable {
  String _id;
  String registrationNo;
  CarBrand type;
  Owner? owner;

  Vehicle(
      {required this.registrationNo,
      required this.type,
      required this.owner,
      String? id})
      : _id = id ?? Uuid().v4();

  @override
  String get id => _id;

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    var typeIndex = json['type'];

    Vehicle vehicle = Vehicle(
      id: json['id'],
      registrationNo: json['registrationNo'],
      type: CarBrand.values[typeIndex],
      owner: json['owner'] != null ? Owner.fromJson(json['owner']) : null,
    );
    return vehicle;
  }

  Map<String, dynamic> toJson() => {
        'id': _id,
        'registrationNo': registrationNo,
        'type': type.index,
        'owner': owner?.toJson()
      };

  @override
  String toString() {
    return 'RegistrationNo: $registrationNo, type: $type, owner: (${owner.toString()})';
  }
}
