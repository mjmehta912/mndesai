class CardInfoDm {
  final String cardType;
  final String member;
  final double balance;
  final int pcSrNo;
  final String mobileNo;
  final String pCode;

  CardInfoDm({
    required this.cardType,
    required this.member,
    required this.balance,
    required this.pcSrNo,
    required this.mobileNo,
    required this.pCode,
  });

  factory CardInfoDm.fromJson(Map<String, dynamic> json) {
    return CardInfoDm(
      cardType: json['CARDTYPE'],
      member: json['MemberName'],
      balance: json['Balance'],
      pcSrNo: json['PCSRNO'],
      mobileNo: json['MOBILE'],
      pCode: json['PCODE'],
    );
  }
}
