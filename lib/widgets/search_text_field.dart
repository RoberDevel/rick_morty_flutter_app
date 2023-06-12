import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rick_morty_flutter_app/widgets/asset_button.dart';

class ExpandedWidget extends StatefulWidget {
  const ExpandedWidget({
    Key? key,
    required this.closeIcon,
    required this.openIcon,
    this.isOpen = false,
    this.child,
    this.onChanged,
  }) : super(key: key);

  final String closeIcon;
  final String openIcon;
  final bool isOpen;
  final Widget? child;
  final ValueChanged<bool>? onChanged;

  @override
  State<ExpandedWidget> createState() => _ExpandedWidgetState();
}

class _ExpandedWidgetState extends State<ExpandedWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ExpandedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isOpen != widget.isOpen) {
      if (widget.isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => Stack(
        children: <Widget>[
          Positioned(
            height: 46,
            width: lerpDouble(46, constraints.maxWidth, _controller.value),
            top: constraints.maxHeight / 2 - 23,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(50)),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(7, 7, 0, 7),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 150),
                      child: widget.isOpen
                          ? AssetButton(
                              widget.openIcon,
                              onTap: _toggleIsOpen,
                              color: Theme.of(context).colorScheme.onPrimary,
                            )
                          : AssetButton(
                              widget.closeIcon,
                              onTap: _toggleIsOpen,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                    ),
                  ),
                  if (_controller.isCompleted && widget.child != null)
                    Expanded(child: widget.child!)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _toggleIsOpen() {
    widget.onChanged?.call(!widget.isOpen);
  }
}
