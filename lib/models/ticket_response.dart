import 'dart:convert';

class TicketResponse {
  bool success;
  String message;
  bool? checkedIn;
  String? error;

  TicketResponse({
    required this.success,
    required this.message,
    this.checkedIn,
    this.error,
  });

  factory TicketResponse.fromMap(Map<String, dynamic> map) {
    return TicketResponse(
      success: map['success'] ?? false,
      message: map['message'] ?? '',
      checkedIn: map['checkedIn'],
      error: map['error'],
    );
  }

  factory TicketResponse.fromJson(String string) {
    return TicketResponse.fromMap(jsonDecode(string) as Map<String, dynamic>);
  }
}
