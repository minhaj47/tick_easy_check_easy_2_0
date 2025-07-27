import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tick_easy_check_easy_2_0/Constant/global_variable.dart';
import 'package:tick_easy_check_easy_2_0/models/qr_payload.dart';
import 'package:tick_easy_check_easy_2_0/provider/auth_provider.dart';
import 'package:tick_easy_check_easy_2_0/models/ticket_response.dart';

// Enum for ticket states to improve code readability
enum TicketState {
  parsing,
  verifying,
  verified,
  alreadyCheckedIn,
  checkingIn,
  checkedIn,
  error,
}

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({
    super.key,
    required this.qrData,
    required this.closeScreen,
    required this.organizationId,
  });

  final String qrData;
  final Function() closeScreen;
  final String organizationId;

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  // Simplified state management
  TicketState _currentState = TicketState.parsing;
  QrPayload? _qrPayload;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeTicketFlow();
  }

  // Clean initialization flow
  Future<void> _initializeTicketFlow() async {
    _parseQrData();
    if (_qrPayload != null) {
      await _verifyTicket();
    }
  }

  void _parseQrData() {
    try {
      _qrPayload = QrPayload.fromJson(widget.qrData);
    } catch (e) {
      _updateState(TicketState.error, 'Invalid QR code format');
    }
  }

  // Consolidated state update method
  void _updateState(TicketState state, [String? errorMessage]) {
    setState(() {
      _currentState = state;
      _errorMessage = errorMessage;
    });
  }

  // Consolidated API call method
  Future<TicketResponse?> _makeApiCall(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).jwtToken;

      final response = await http.post(
        Uri.parse('$uri/api/tickets/$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      return TicketResponse.fromJson(response.body);
    } catch (e) {
      _updateState(
        TicketState.error,
        'Network error: Please check your connection',
      );
      return null;
    }
  }

  Future<void> _verifyTicket() async {
    if (_qrPayload == null) return;

    _updateState(TicketState.verifying);

    final response = await _makeApiCall('verify', {
      'ticketIdentifier': _qrPayload!.ticketIdentifier,
      'qrCode': _qrPayload!.qrCode,
      'organizationId': widget.organizationId,
    });

    if (response != null) {
      setState(() {
        if (response.success) {
          _currentState = response.checkedIn == true
              ? TicketState.alreadyCheckedIn
              : TicketState.verified;
          _errorMessage = null;
        } else {
          _currentState = TicketState.error;
          _errorMessage = response.error ?? response.message;
        }
      });
    }
  }

  Future<void> _checkInTicket() async {
    if (_qrPayload == null || _currentState != TicketState.verified) return;

    _updateState(TicketState.checkingIn);

    final response = await _makeApiCall('checkin', {
      'ticketIdentifier': _qrPayload!.ticketIdentifier,
      'organizationId': widget.organizationId,
    });

    if (response != null) {
      setState(() {
        if (response.success) {
          _currentState = TicketState.checkedIn;
          _errorMessage = null;
          log(response.message);
        } else {
          _currentState = TicketState.error;
          _errorMessage = response.error ?? response.message;
        }
      });
    }
  }

  // Consolidated status methods
  StatusInfo _getStatusInfo() {
    switch (_currentState) {
      case TicketState.parsing:
        return StatusInfo(
          Colors.grey,
          'Preparing to verify ticket',
          Icons.qr_code_scanner,
        );
      case TicketState.verifying:
        return StatusInfo(
          Colors.blue,
          'Verifying ticket...',
          Icons.sync,
          showProgress: true,
        );
      case TicketState.verified:
        return StatusInfo(
          Colors.blue,
          'Ticket verified - Ready for check-in',
          Icons.verified,
        );
      case TicketState.alreadyCheckedIn:
        return StatusInfo(
          Colors.orange,
          'Ticket already checked in',
          Icons.warning,
        );
      case TicketState.checkingIn:
        return StatusInfo(
          Colors.green,
          'Processing check-in...',
          Icons.sync,
          showProgress: true,
        );
      case TicketState.checkedIn:
        return StatusInfo(
          Colors.green,
          'Check-in completed successfully!',
          Icons.check_circle,
        );
      case TicketState.error:
        return StatusInfo(
          Colors.red,
          _errorMessage ?? 'Unknown error',
          Icons.error,
        );
    }
  }

  void _closeScreen() {
    widget.closeScreen();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getStatusInfo();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildQrCard(),
            const SizedBox(height: 24),
            if (_qrPayload != null) ...[
              _buildTicketInfoCard(),
              const SizedBox(height: 24),
              _buildStatusCard(statusInfo),
              const SizedBox(height: 32),
              _buildActionButtons(),
            ],
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: _closeScreen,
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      title: const Text(
        "Ticket Checker",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildQrCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.purple.shade50],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: QrImageView(
                data: widget.qrData,
                size: 180,
                version: QrVersions.auto,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            if (_qrPayload != null)
              Text(
                _qrPayload!.ticketIdentifier,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ticket Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Name', _qrPayload!.buyerName),
            _buildInfoRow('Email', _qrPayload!.buyerEmail),
            _buildInfoRow('Ticket ID', _qrPayload!.ticketIdentifier),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(StatusInfo statusInfo) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: statusInfo.color.withOpacity(0.1),
          border: Border.all(
            color: statusInfo.color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            statusInfo.showProgress
                ? const CircularProgressIndicator()
                : Icon(statusInfo.icon, color: statusInfo.color, size: 48),
            const SizedBox(height: 12),
            Text(
              statusInfo.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: statusInfo.color,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    switch (_currentState) {
      case TicketState.error:
        return _buildButton(
          'Try Again',
          Icons.refresh,
          Colors.orange,
          _verifyTicket,
        );
      case TicketState.verified:
        return _buildButton(
          'Check In Attendee',
          Icons.how_to_reg,
          Colors.green,
          _checkInTicket,
        );
      case TicketState.checkingIn:
        return _buildButton(
          'Processing...',
          Icons.sync,
          Colors.green,
          null,
          showProgress: true,
        );
      case TicketState.checkedIn:
      case TicketState.alreadyCheckedIn:
        return _buildButton(
          'Complete',
          Icons.done,
          Colors.purple,
          _closeScreen,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback? onPressed, {
    bool showProgress = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showProgress)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            else
              Icon(icon),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper class to encapsulate status information
class StatusInfo {
  final Color color;
  final String message;
  final IconData icon;
  final bool showProgress;

  StatusInfo(this.color, this.message, this.icon, {this.showProgress = false});
}
