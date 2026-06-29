import 'package:flutter/material.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/shared/model/model_fab.dart';
import 'package:task_manager/shared/style/text_size.dart';

class CustomMultiFab extends StatefulWidget {
  final List<CustomFabItem> items;

  const CustomMultiFab({super.key, required this.items});

  @override
  State<CustomMultiFab> createState() => _CustomMultiFabState();
}

class _CustomMultiFabState extends State<CustomMultiFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool _isOpen = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggle() {
    if (_isOpen) {
      _controller.reverse();
    } else {
      _controller.forward();
    }

    setState(() {
      _isOpen = !_isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 320,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomRight,
        children: [
          ...List.generate(widget.items.length, (index) {
            final item = widget.items[index];
            final animation = CurvedAnimation(
              parent: _controller,
              curve: Interval(
                index / widget.items.length,
                1,
                curve: Curves.easeOut,
              ),
            );

            return AnimatedBuilder(
              animation: animation,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Text(item.title, style: lv1TextStyle),
                    ),
                  ),
                  FloatingActionButton.small(
                    backgroundColor: AppPropertyColor.primary,
                    heroTag: item.title,
                    onPressed: () {
                      toggle();
                      item.onTap();
                    },
                    child: Icon(item.icon, color: AppPropertyColor.white),
                  ),
                ],
              ),
              builder: (_, child) {
                return Positioned(
                  right: 0,
                  bottom: 65 + (index * 50 * animation.value),
                  child: IgnorePointer(
                    ignoring: !_isOpen,
                    child: Opacity(
                      opacity: animation.value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - animation.value)),
                        child: Transform.scale(
                          scale: animation.value,
                          child: child,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),

          FloatingActionButton(
            backgroundColor: AppPropertyColor.primary,
            heroTag: "main_fab",
            onPressed: toggle,
            child: AnimatedRotation(
              turns: _isOpen ? .25 : 0,
              duration: const Duration(milliseconds: 250),
              child: Icon(
                _isOpen ? Icons.close : Icons.add,
                color: AppPropertyColor.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
