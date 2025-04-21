import 'package:flutter/material.dart';
import 'package:edutrack_admin_web/constants/constants.dart';

class RemoveButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const RemoveButton({super.key, required this.text, required this.onTap});

  @override
  State<RemoveButton> createState() => _RemoveButtonState();
}

class _RemoveButtonState extends State<RemoveButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: widget.onTap,
          hoverColor: Colors.transparent, // prevent InkWell from overriding
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color:
                  _isHovering
                      ? Constants.redColor
                      : Constants.removeButtonRedBg,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              widget.text,
              style: TextStyle(
                color:
                    _isHovering
                        ? Constants.whiteColor
                        : Constants.removeButtonRedText,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
