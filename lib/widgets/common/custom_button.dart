import 'package:flutter/material.dart';

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

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          visible: icon != null,
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(icon, size: 18),
          ),
        ),
        Text(text),
      ],
    );


    Widget body = Stack(
      alignment: Alignment.center,
      children: [
        Visibility(
          visible: !isLoading,
          child: content,
        ),
        Visibility(
          visible: isLoading,
          child: const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );


    return isOutlined
        ? OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(width ?? double.infinity, height ?? 48),
        side: BorderSide(color: color ?? Theme.of(context).primaryColor),
      ),
      child: body,
    )
        : ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(width ?? double.infinity, height ?? 48),
      ),
      child: body,
    );
  }
}
