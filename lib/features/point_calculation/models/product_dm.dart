class ProductDm {
  final String iCode;
  final String iName;
  final String shortName;
  final double salesRate;
  final bool dateWise;
  final double? rate;

  ProductDm({
    required this.iCode,
    required this.iName,
    required this.shortName,
    required this.salesRate,
    required this.dateWise,
    this.rate,
  });

  factory ProductDm.fromJson(Map<String, dynamic> json) {
    return ProductDm(
      iCode: json['ICODE'],
      iName: json['INAME'],
      shortName: json['SHORTNAME'],
      salesRate: (json['SalesRate'] is int)
          ? (json['SalesRate'] as int).toDouble()
          : json['SalesRate'] as double,
      dateWise: json['DATEWISE'],
      rate: json['Rate'] != null ? json['Rate'] as double : 0.0,
    );
  }
}
