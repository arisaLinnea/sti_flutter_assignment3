import 'package:firebase_repositories/src/repositories/repository.dart';
import 'package:shared_client/shared_client.dart';

class ParkingLotRepository extends Repository<ParkingLot> {
  static final ParkingLotRepository _instance =
      ParkingLotRepository._internal(path: 'parkinglot');

  ParkingLotRepository._internal({required super.path});

  factory ParkingLotRepository() => _instance;

  @override
  ParkingLot deserialize(Map<String, dynamic> json) =>
      ParkingLot.fromJson(json);

  @override
  Map<String, dynamic> serialize(ParkingLot item) => item.toJson();
}
