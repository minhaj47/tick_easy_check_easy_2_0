import 'dart:convert';

class QrPayload {
  String ticketIdentifier;
  String qrCode;
  String buyerEmail;
  String buyerName;

  QrPayload({
    required this.ticketIdentifier,
    required this.qrCode,
    required this.buyerEmail,
    required this.buyerName,
  });

  factory QrPayload.fromMap(Map<String, dynamic> map) {
    return QrPayload(
      ticketIdentifier: map['ticketIdentifier'] as String,
      qrCode: map['qrCode'] as String,
      buyerEmail: map['buyerEmail'] as String,
      buyerName: map['buyerName'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ticketIdentifier': ticketIdentifier,
      'qrCode': qrCode,
      'buyerEmail': buyerEmail,
      'buyerName': buyerName,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory QrPayload.fromJson(String json) {
    final Map<String, dynamic> jsonMap = jsonDecode(json);
    return QrPayload.fromMap(jsonMap);
  }
}
