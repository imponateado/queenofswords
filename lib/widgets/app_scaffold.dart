import 'package:flutter/material.dart';

import 'ad_banner_placeholder.dart';

/// Every screen should be wrapped in this instead of a bare [Scaffold], so
/// there is exactly one ad slot, always fixed at the bottom, regardless of
/// route.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.drawer,
  });

  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? drawer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title == null
          ? null
          : AppBar(title: Text(title!), actions: actions),
      drawer: drawer,
      body: SafeArea(bottom: false, child: body),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: const AdBannerPlaceholder(),
    );
  }
}
