class CardHelpDm {
  final int cardNo;
  final String name;
  final String mobileNo;

  CardHelpDm({
    required this.cardNo,
    required this.name,
    required this.mobileNo,
  });

  factory CardHelpDm.fromJson(Map<String, dynamic> json) {
    return CardHelpDm(
      cardNo: json['CARDNO'],
      name: json['PNAME'],
      mobileNo: json['MOBILE'],
    );
  }
}
