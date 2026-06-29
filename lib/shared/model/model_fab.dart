import 'package:flutter/material.dart';

class CustomFabItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const CustomFabItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
