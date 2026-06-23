import 'package:flutter/material.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/core/routes/routes_enum.dart';
import 'package:task_manager/core/routes/routes_navigator.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/common_widget/button/custom_button_icon.dart';
import 'package:task_manager/shared/common_widget/snackbar/custom_snackbar.dart';

class NavigationGesture extends StatefulWidget {
  final List<Map<String, dynamic>> attContent;
  final ValueNotifier<bool> isOpen;
  final VoidCallback close;
  final RoutesEnum currentPage;
  final Map<String, dynamic>? arguments;
  const NavigationGesture({
    super.key,
    required this.attContent,
    required this.isOpen,
    required this.close,
    required this.currentPage,
    required this.arguments,
  });

  @override
  State<NavigationGesture> createState() => _NavigationGestureState();
}

class _NavigationGestureState extends State<NavigationGesture> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.isOpen,
      builder: (context, value, child) {
        return AnimatedPositioned(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          left: value ? 0 : -240,
          top: 0,
          bottom: 0,
          child: Container(
            margin: EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              color: AppPropertyColor.white,
              boxShadow: [
                BoxShadow(
                  color: AppPropertyColor.black.withValues(alpha: 0.4),
                  blurRadius: 10,
                  blurStyle: BlurStyle.outer,
                ),
              ],
            ),
            width: 200,
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButtonIcon(
                    left: true,
                    icon: const Icon(
                      Icons.keyboard_backspace_rounded,
                      color: AppPropertyColor.white,
                    ),
                    label: Text("Close", style: lv1TextStyleWhiteBold),
                    backgroundColor: AppPropertyColor.primary,
                    onPressed: widget.close,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(),
                    children: [
                      Text("Menu", style: lv2TextStyle),
                      const SizedBox(height: 10),
                      for (var menu in widget.attContent)
                        _navContent(
                          menu['toContext'],
                          menu['text_menu'],
                          widget.arguments,
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButtonIcon(
                    left: true,
                    icon: const Icon(
                      Icons.keyboard_backspace_rounded,
                      color: AppPropertyColor.white,
                    ),
                    label: Text("Keluar", style: lv1TextStyleWhiteBold),
                    backgroundColor: AppPropertyColor.red,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _navContent(
    RoutesEnum toRoute,
    String text,
    Map<String, dynamic>? arguments,
  ) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      color: AppPropertyColor.white,
      child: Material(
        color: AppPropertyColor.primary,
        elevation: 2,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () {
            if (widget.currentPage == toRoute) {
              customSnackBar(context, "Already in $text menu!");
            } else {
              Navigator.pop(context);
              RoutesNavigator(
                context: context,
                replace: false,
                routeName: toRoute,
                arguments: arguments,
              ).navigate();
            }
          },
          borderRadius: BorderRadius.circular(10),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(text, style: lv1TextStyleWhite),
              ),
              const Spacer(),
              if (widget.currentPage == toRoute)
                Container(
                  margin: EdgeInsets.only(right: 10),
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppPropertyColor.white,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
