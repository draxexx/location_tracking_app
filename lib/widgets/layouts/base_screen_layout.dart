import 'package:flutter/material.dart';

class BaseScreenLayout extends StatelessWidget {
  const BaseScreenLayout({
    super.key,
    required this.title,
    required this.child,
    this.padding = 36,
  });

  final String title;
  final Widget child;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(padding: EdgeInsets.all(padding), child: child),
    );
  }
}
