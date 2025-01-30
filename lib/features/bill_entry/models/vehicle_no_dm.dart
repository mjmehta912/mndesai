class VehicleNoDm {
  final String vehicleNo;

  VehicleNoDm({
    required this.vehicleNo,
  });

  factory VehicleNoDm.fromJson(Map<String, dynamic> json) {
    return VehicleNoDm(
      vehicleNo: json['VEHICLENO'],
    );
  }
}
