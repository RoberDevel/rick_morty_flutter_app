import 'package:flutter/material.dart';

class AssetButton extends StatelessWidget {
  const AssetButton(
    this.source, {
    Key? key,
    this.onTap,
    this.size = 32,
    this.color,
  }) : super(key: key);

  final String source;
  final GestureTapCallback? onTap;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Image.asset(
        source,
        height: size,
        width: size,
        fit: BoxFit.contain,
        color: color ?? Theme.of(context).colorScheme.secondary,
        colorBlendMode: BlendMode.srcIn,
      ),
    );
  }
}
