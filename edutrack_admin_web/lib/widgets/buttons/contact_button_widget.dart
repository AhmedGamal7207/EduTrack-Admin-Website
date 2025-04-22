import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:edutrack_admin_web/constants/constants.dart';

class ContactButtonWidget extends StatelessWidget {
  final IconData icon;
  final String value;
  final ContactType type;

  const ContactButtonWidget({
    super.key,
    required this.icon,
    required this.value,
    required this.type,
  });

  void _handleTap() async {
    final Uri uri =
        type == ContactType.phone
            ? Uri.parse('tel:$value')
            : Uri.parse('mailto:$value');

    try {
      await launchUrl(uri);
    } catch (e) {
      debugPrint("Launch failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: value,
      decoration: BoxDecoration(
        color: Constants.primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: Constants.interFont(Constants.weightRegular, 12, Colors.white),
      child: GestureDetector(
        onTap: _handleTap,
        child: Container(
          height: 40,
          width: 40,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFE0F3F6),
          ),
          child: Icon(icon, color: Constants.primaryColor, size: 20),
        ),
      ),
    );
  }
}

enum ContactType { phone, email }
