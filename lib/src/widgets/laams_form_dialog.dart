import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChannels;
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'laams_floating_button.dart';

class LaamsFormDialog extends StatelessWidget {
  final bool isPrimary;
  final bool resizeToAvoidBottomInset;
  final bool isFullScreen;
  final bool centerTitle;
  final bool isFormScrollable;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final void Function(BuildContext context) onClose;
  final String titleText;
  final void Function(BuildContext context)? onAction;
  final IconData? actionIcon;
  final String? actionText;
  final EdgeInsetsGeometry formPadding;
  final Widget form;
  final Widget? navBar;

  const LaamsFormDialog._({
    required this.isPrimary,
    required this.resizeToAvoidBottomInset,
    required this.isFullScreen,
    required this.centerTitle,
    required this.isFormScrollable,
    required this.height,
    required this.width,
    required this.margin,
    required this.backgroundColor,
    required this.borderRadius,
    required this.onClose,
    required this.titleText,
    required this.onAction,
    required this.actionIcon,
    required this.actionText,
    required this.formPadding,
    required this.form,
    required this.navBar,
  });

  static Future<T?> display<T>(
    BuildContext context, {
    bool barrierDismissible = false,
    bool useSafeARea = true,
    bool useRootNavigator = true,
    bool isInnerScaffoldPrimary = false,
    bool resizeToAvoidBottomInset = true,
    bool centerTitle = true,
    bool isFormScrollable = true,
    double? height,
    double? width = 550,
    EdgeInsetsGeometry? margin = const EdgeInsets.fromLTRB(10, 35, 10, 35),
    Color? barrierColor,
    Color? backgroundColor,
    BorderRadiusGeometry? borderRadius =
        const BorderRadius.all(Radius.circular(20)),
    required void Function(BuildContext context) onClose,
    required String titleText,
    void Function(BuildContext context)? onAction,
    IconData? actionIcon,
    String? actionText,
    required Widget form,
    EdgeInsetsGeometry formPadding = const EdgeInsets.fromLTRB(10, 0, 10, 250),
    Widget? navBar,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      useSafeArea: useSafeARea,
      useRootNavigator: useRootNavigator,
      barrierColor: barrierColor ?? Colors.grey.withOpacity(0.3),
      builder: (context) => switch (MediaQuery.sizeOf(context).width < 600) {
        true => Dialog.fullscreen(
            backgroundColor: backgroundColor,
            child: LaamsFormDialog._(
              isPrimary: isInnerScaffoldPrimary,
              resizeToAvoidBottomInset: resizeToAvoidBottomInset,
              isFullScreen: true,
              centerTitle: centerTitle,
              isFormScrollable: isFormScrollable,
              height: null,
              width: null,
              margin: null,
              backgroundColor: backgroundColor,
              borderRadius: null,
              onClose: onClose,
              titleText: titleText,
              onAction: onAction,
              actionIcon: actionIcon,
              actionText: actionText,
              formPadding: formPadding,
              form: form,
              navBar: navBar,
            ),
          ),
        false => LaamsFormDialog._(
            isPrimary: isInnerScaffoldPrimary,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            isFullScreen: false,
            centerTitle: centerTitle,
            isFormScrollable: isFormScrollable,
            height: height,
            width: width,
            margin: margin,
            backgroundColor: backgroundColor,
            borderRadius: borderRadius,
            onClose: onClose,
            titleText: titleText,
            onAction: onAction,
            actionIcon: actionIcon,
            actionText: actionText,
            formPadding: formPadding,
            form: form,
            navBar: navBar,
          ),
      },
    );
  }

  void _handleClose(BuildContext context, bool isVisible) {
    if (isVisible) SystemChannels.textInput.invokeMethod('TextInput.hide');
    onClose(context);
  }

  void _handleOnSave(BuildContext context, bool isVisible) {
    if (isVisible) SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (onAction != null) onAction!(context);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: _build);
  }

  Widget _build(BuildContext context, bool isVisible) {
    final theme = Theme.of(context);
    final hasAction = (actionText ?? '').trim().isNotEmpty;
    final actionStyle = switch (isFullScreen) {
      true => theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.primaryColor,
        ),
      false => theme.textTheme.displayLarge?.copyWith(fontSize: 18),
    };

    final closeBtn = InkWell(
      onTap: () => _handleClose(context, isVisible),
      child: Icon(
        isFullScreen ? Icons.arrow_back_ios : Icons.close,
        size: 25,
        color: theme.textTheme.bodyLarge?.color,
      ),
    );

    final title = Text(
      titleText,
      style: theme.textTheme.displaySmall,
    );

    final actionBtn = GestureDetector(
      onTap: () => _handleOnSave(context, isVisible),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Text(
          actionText ?? '',
          style: actionStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );

    final actions = switch (isFullScreen) {
      true => hasAction ? [actionBtn, const SizedBox(width: 5)] : <Widget>[],
      false => [isVisible ? actionBtn : closeBtn, const SizedBox(width: 15)],
    };

    const bottomSize = Size.fromHeight(50);
    final appBar = AppBar(
      automaticallyImplyLeading: false,
      primary: isPrimary,
      toolbarHeight: 50,
      surfaceTintColor: theme.scaffoldBackgroundColor,
      leading: ((isVisible && hasAction) || isFullScreen) ? closeBtn : null,
      title: title,
      centerTitle: true,
      actions: actions,
      bottom: switch (navBar != null && isVisible) {
        true => PreferredSize(preferredSize: bottomSize, child: navBar!),
        false => null,
      },
    );

    Widget body = switch (isFormScrollable) {
      true => SingleChildScrollView(
          child: Padding(padding: formPadding, child: form),
        ),
      false => Padding(padding: formPadding, child: form),
    };

    final floatingBtn = switch (hasAction && !isVisible) {
      true => LaamsFloatingButton(
          onPressed: () {},
          icon: actionIcon ?? Icons.save_outlined,
          titleText: actionText ?? '',
          margin: const EdgeInsets.only(bottom: 10),
        ),
      false => null,
    };

    final scaffold = Scaffold(
      primary: isPrimary,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor,
      appBar: appBar,
      body: body,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      floatingActionButton: floatingBtn,
      bottomNavigationBar: (!isVisible) ? navBar : null,
    );

    if (isFullScreen) return scaffold;

    final decoration = BoxDecoration(
      borderRadius: borderRadius,
    );
    final container = Container(
      height: height,
      width: width,
      margin: margin,
      decoration: decoration,
      clipBehavior: Clip.antiAlias,
      child: scaffold,
    );

    return Center(child: container);
  }
}
