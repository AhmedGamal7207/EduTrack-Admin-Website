import 'package:flutter/material.dart';

class HoverableMenuItem extends StatefulWidget {
  final Function(int) onItemTap;
  final Widget childWidget;
  final int index;
  const HoverableMenuItem({
    super.key,
    required this.onItemTap,
    required this.index,
    required this.childWidget,
  });

  @override
  _HoverableMenuItemState createState() => _HoverableMenuItemState();
}

class _HoverableMenuItemState extends State<HoverableMenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () => widget.onItemTap(widget.index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform:
              _isHovered ? Matrix4.identity().scaled(1.02) : Matrix4.identity(),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_isHovered ? 6 : 0),
            color:
                _isHovered
                    ? Colors.white.withOpacity(0.05)
                    : Colors.transparent,
          ),
          child: widget.childWidget,
        ),
      ),
    );
  }
}
