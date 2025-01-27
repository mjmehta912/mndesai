class CardNoDm {
  final int cardNo;

  CardNoDm({
    required this.cardNo,
  });

  factory CardNoDm.fromJson(Map<String, dynamic> json) {
    return CardNoDm(
      cardNo: json['CARDNO'],
    );
  }
}
