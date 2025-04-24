import 'package:flutter/material.dart';
import 'package:edutrack_admin_web/constants/constants.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final bool hasIcon;
  final VoidCallback? onTap;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.hasIcon = true,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    Widget content =
        widget.hasIcon
            ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/icons/Add Icon.png',
                  height: 20,
                  width: 20,
                  color: Constants.whiteColor,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.text,
                  style: TextStyle(
                    color: Constants.whiteColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            )
            : Text(
              widget.text,
              style: TextStyle(
                color: Constants.whiteColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            );
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(widget.hasIcon ? 25 : 15),
        child: InkWell(
          borderRadius: BorderRadius.circular(widget.hasIcon ? 25 : 15),
          onTap: widget.onTap,
          hoverColor: Colors.transparent, // prevent InkWell from overriding
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color:
                  _isHovering ? Constants.hoverColor : Constants.primaryColor,
              borderRadius: BorderRadius.circular(widget.hasIcon ? 25 : 15),
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}
