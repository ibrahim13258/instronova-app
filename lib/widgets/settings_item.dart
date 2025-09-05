import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? textColor;

  const SettingsItem({
    Key? key,
    required this.title,
    this.subtitle,
    this.leadingIcon,
    this.trailingIcon = Icons.arrow_forward_ios,
    this.onTap,
    this.iconColor = Colors.black87,
    this.textColor = Colors.black87,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            if (leadingIcon != null)
              Icon(
                leadingIcon,
                color: iconColor,
              ),
            if (leadingIcon != null) const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
            if (trailingIcon != null)
              Icon(
                trailingIcon,
                size: 18,
                color: Colors.grey[400],
              ),
          ],
        ),
      ),
    );
  }
}
