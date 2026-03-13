import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';


class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final double? width;
  final double? height;
  final Color? color;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final Color mainColor = color ?? AppColors.primary;

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18),
          const SizedBox(width: 8),
        ],
        Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );

    Widget body = Stack(
      alignment: Alignment.center,
      children: [
        Opacity(opacity: isLoading ? 0 : 1, child: content),
        if (isLoading)
          const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.white,
            ),
          ),
      ],
    );

    return isOutlined
        ? OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(width ?? double.infinity, height ?? 48),
        side: BorderSide(color: mainColor),
        foregroundColor: mainColor,
      ),
      child: body,
    )
        : ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width ?? double.infinity, height ?? 48),
        backgroundColor: mainColor,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      child: body,
    );
  }
}