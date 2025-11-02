import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  static OverlayEntry? _activeEntry;

  static void show({
    required String title,
    required String message,
    Color backgroundColor = const Color(0xFF323232),
    Color textColor = Colors.white,
    IconData? icon,
    int durationSeconds = 3,
    Alignment alignment = Alignment.bottomCenter, // posisi default bawah
  }) {
    _removeActiveSnackbar();

    final overlay = Overlay.of(Get.overlayContext!);
    final currentRoute = Get.currentRoute;
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => _AnimatedSnackbar(
        title: title,
        message: message,
        backgroundColor: backgroundColor,
        textColor: textColor,
        icon: icon,
        durationSeconds: durationSeconds,
        onDismissed: () {
          entry.remove();
          _activeEntry = null;
        },
        initialRoute: currentRoute,
        alignment: alignment,
      ),
    );

    overlay.insert(entry);
    _activeEntry = entry;
  }

  static void _removeActiveSnackbar() {
    if (_activeEntry != null) {
      _activeEntry!.remove();
      _activeEntry = null;
    }
  }
}

class _AnimatedSnackbar extends StatefulWidget {
  final String title;
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final int durationSeconds;
  final VoidCallback onDismissed;
  final String initialRoute;
  final Alignment alignment;

  const _AnimatedSnackbar({
    required this.title,
    required this.message,
    required this.backgroundColor,
    required this.textColor,
    required this.durationSeconds,
    this.icon,
    required this.onDismissed,
    required this.initialRoute,
    required this.alignment,
  });

  @override
  State<_AnimatedSnackbar> createState() => _AnimatedSnackbarState();
}

class _AnimatedSnackbarState extends State<_AnimatedSnackbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slide;
  late Animation<double> _fade;
  double dragOffset = 0;
  bool _isDismissing = false;
  bool get isTop => widget.alignment == Alignment.topCenter;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 450),
    );

    // Animasi masuk dari atas atau bawah
    _slide =
        Tween(
          begin: isTop ? const Offset(0, -0.25) : const Offset(0, 0.25),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          ),
        );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeIn,
    );

    _controller.forward();

    Future.delayed(Duration(seconds: widget.durationSeconds), () {
      if (mounted) _dismiss();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _checkRouteChanges());
  }

  void _checkRouteChanges() {
    if (!mounted || _isDismissing) return;
    if (Get.currentRoute != widget.initialRoute) {
      _dismiss();
      return;
    }
    Future.delayed(const Duration(milliseconds: 100), _checkRouteChanges);
  }

  void _dismiss() {
    if (_isDismissing) return;
    _isDismissing = true;
    _controller.reverse().then((_) {
      if (mounted) widget.onDismissed();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      dragOffset += details.delta.dy;
      // Batasi arah gerakan
      if (isTop) {
        dragOffset = dragOffset.clamp(-120, 0); // geser ke atas untuk hilang
      } else {
        dragOffset = dragOffset.clamp(0, 120); // geser ke bawah untuk hilang
      }
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;

    // logika berbeda tergantung posisi snackbar
    if (isTop) {
      if (dragOffset < -50 || velocity < -300) {
        _dismiss();
      } else {
        setState(() => dragOffset = 0);
      }
    } else {
      if (dragOffset > 50 || velocity > 300) {
        _dismiss();
      } else {
        setState(() => dragOffset = 0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final safeArea = mediaQuery.padding;

    EdgeInsets padding;
    if (isTop) {
      padding = EdgeInsets.only(
        top: safeArea.top + 10,
        left: mediaQuery.size.width * 0.07,
        right: mediaQuery.size.width * 0.07,
      );
    } else {
      padding = EdgeInsets.only(
        bottom: keyboardHeight > 0 ? keyboardHeight + 6 : safeArea.bottom + 6,
        left: mediaQuery.size.width * 0.07,
        right: mediaQuery.size.width * 0.07,
      );
    }

    return AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      padding: padding,
      child: Align(
        alignment: widget.alignment,
        child: GestureDetector(
          onVerticalDragUpdate: _onVerticalDragUpdate,
          onVerticalDragEnd: _onVerticalDragEnd,
          child: SlideTransition(
            position: _slide,
            child: FadeTransition(
              opacity: _fade,
              child: Transform.translate(
                offset: Offset(0, dragOffset),
                child: Material(
                  color: Colors.transparent,
                  elevation: 4,
                  borderRadius: BorderRadius.circular(14),
                  shadowColor: Colors.black.withValues(alpha: 0.2),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: 1.0 - (dragOffset.abs() / 100).clamp(0, 0.8),
                    curve: Curves.easeOutCubic,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: widget.backgroundColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (widget.icon != null)
                            Icon(
                              widget.icon,
                              color: widget.textColor,
                              size: 20,
                            ),
                          if (widget.icon != null) const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: widget.textColor,
                                  ),
                                ),
                                Text(
                                  widget.message,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: widget.textColor.withValues(
                                      alpha: 0.85,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
