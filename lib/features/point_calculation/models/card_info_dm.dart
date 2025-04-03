class CardInfoDm {
  final String cardType;
  final String member;
  final double? balance;
  final String pcSrNo;
  final String mobileNo;
  final String pCode;
  final int cardNo;
  final String typeCode;

  CardInfoDm({
    required this.cardType,
    required this.member,
    this.balance,
    required this.pcSrNo,
    required this.mobileNo,
    required this.pCode,
    required this.cardNo,
    required this.typeCode,
  });

  factory CardInfoDm.fromJson(Map<String, dynamic> json) {
    return CardInfoDm(
      cardType: json['CARDTYPE'],
      member: json['MemberName'],
      balance: json['Balance'],
      pcSrNo: json['PCSRNO'],
      mobileNo: json['MOBILE'],
      pCode: json['PCODE'],
      cardNo: json['CardNo'],
      typeCode: json['TYPECODE'],
    );
  }
}
