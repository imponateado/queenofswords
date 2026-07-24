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
      // Scaffold gives its body a loose width constraint, so a top-level
      // Column (e.g. inside a SingleChildScrollView) shrink-wraps to its
      // content instead of filling the screen — and since Scaffold anchors
      // the body at the top-left, that shrunk content reads as left-aligned
      // instead of centered. Force it to take the full width here once,
      // rather than in every screen that happens to use a shrink-wrapping
      // layout.
      body: SafeArea(
        bottom: false,
        child: SizedBox(width: double.infinity, child: body),
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: const AdBannerPlaceholder(),
    );
  }
}
