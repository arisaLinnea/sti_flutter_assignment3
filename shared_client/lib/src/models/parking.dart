import 'package:shared_client/src/extensions/date_extension.dart';
import 'package:shared_client/src/models/identifiable.dart';
import 'package:shared_client/src/models/parkinglot.dart';
import 'package:shared_client/src/models/vehicle.dart';
import 'package:uuid/uuid.dart';

class Parking implements Identifiable {
  String _id;
  Vehicle? vehicle;
  ParkingLot? parkinglot;
  DateTime startTime;
  DateTime? endTime;

  Parking(
      {required this.vehicle,
      required this.parkinglot,
      required this.startTime,
      this.endTime,
      String? id})
      : _id = id ?? Uuid().v4();

  @override
  String get id => _id;

  bool get isActive => endTime == null || endTime!.isAfter(DateTime.now());

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
        id: json['id'],
        vehicle:
            json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null,
        parkinglot: json['parkinglot'] != null
            ? ParkingLot.fromJson(json['parkinglot'])
            : null,
        startTime: DateTime.parse(json['startTime']),
        endTime:
            json['endTime'] != null ? DateTime.parse(json['endTime']) : null);
  }

  Map<String, dynamic> toJson() => {
        'id': _id,
        'vehicle': vehicle?.toJson(),
        'parkinglot': parkinglot?.toJson(),
        'startTime':
            startTime.toIso8601String(), // Convert DateTime to ISO 8601 string,
        'endTime': endTime?.toIso8601String()
      };

  @override
  String toString() {
    String formattedStartDate = startTime.parkingFormat();
    String? formattedEndDate = endTime?.parkingFormat();
    return 'Vehicle: ${vehicle.toString()}, Parking lot: ${parkinglot.toString()}, Starttime: $formattedStartDate, Endtime: ${formattedEndDate ?? '-'}';
  }
}
