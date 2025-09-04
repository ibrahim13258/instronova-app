// widgets/loading_button.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

/// Different states the button can be in
enum ButtonState { idle, loading, success, error }

/// Different types of button styles
enum ButtonType { elevated, outlined, text }

/// Different button sizes
enum ButtonSize { small, medium, large, fullWidth }

/// A highly customizable Instagram-style button with loading, success, and error states
class LoadingButton extends StatefulWidget {
  // Basic properties
  final Widget child;
  final VoidCallback? onPressed;
  final VoidCallback? onLoading;
  final VoidCallback? onSuccess;
  final VoidCallback? onError;
  final bool disabled;
  final ButtonType type;
  final ButtonSize size;
  final double borderRadius;
  final bool isPillShape;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;

  // Colors and styling
  final Color? backgroundColor;
  final Color? disabledColor;
  final Color? textColor;
  final Color? disabledTextColor;
  final Color? borderColor;
  final Color? successColor;
  final Color? errorColor;
  final Gradient? gradient;
  final BoxShadow? shadow;
  final TextStyle? textStyle;
  final double borderWidth;

  // Icon properties
  final Widget? icon;
  final IconPosition iconPosition;
  final double iconSpacing;
  final Widget? successIcon;
  final Widget? errorIcon;

  // Loading properties
  final Widget? loader;
  final double loaderSize;
  final Color? loaderColor;
  final bool showLoaderText;
  final double progressValue;
  final bool showProgress;

  // Animation properties
  final bool enableScaleAnimation;
  final bool enableShimmerAnimation;
  final Duration animationDuration;
  final Duration stateResetDuration;
  final bool enableHapticFeedback;
  final bool debounceEnabled;
  final Duration debounceDuration;

  const LoadingButton({
    super.key,
    required this.child,
    this.onPressed,
    this.onLoading,
    this.onSuccess,
    this.onError,
    this.disabled = false,
    this.type = ButtonType.elevated,
    this.size = ButtonSize.medium,
    this.borderRadius = 8.0,
    this.isPillShape = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    this.width,
    this.height,
    this.backgroundColor,
    this.disabledColor,
    this.textColor,
    this.disabledTextColor,
    this.borderColor,
    this.successColor,
    this.errorColor,
    this.gradient,
    this.shadow,
    this.textStyle,
    this.borderWidth = 1.0,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.iconSpacing = 8.0,
    this.successIcon,
    this.errorIcon,
    this.loader,
    this.loaderSize = 20.0,
    this.loaderColor,
    this.showLoaderText = true,
    this.progressValue = 0.0,
    this.showProgress = false,
    this.enableScaleAnimation = true,
    this.enableShimmerAnimation = false,
    this.animationDuration = const Duration(milliseconds: 200),
    this.stateResetDuration = const Duration(seconds: 2),
    this.enableHapticFeedback = true,
    this.debounceEnabled = true,
    this.debounceDuration = const Duration(milliseconds: 500),
  });

  /// Creates a button that automatically handles async operations
  /// When pressed, it will show loading state until the future completes
  /// Then shows success or error state based on the result
  factory LoadingButton.future({
    Key? key,
    required Widget child,
    required Future<void> Function()? asyncAction,
    VoidCallback? onPressed,
    VoidCallback? onLoading,
    VoidCallback? onSuccess,
    VoidCallback? onError,
    bool disabled = false,
    ButtonType type = ButtonType.elevated,
    ButtonSize size = ButtonSize.medium,
    double borderRadius = 8.0,
    bool isPillShape = false,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    double? width,
    double? height,
    Color? backgroundColor,
    Color? disabledColor,
    Color? textColor,
    Color? disabledTextColor,
    Color? borderColor,
    Color? successColor,
    Color? errorColor,
    Gradient? gradient,
    BoxShadow? shadow,
    TextStyle? textStyle,
    double borderWidth = 1.0,
    Widget? icon,
    IconPosition iconPosition = IconPosition.left,
    double iconSpacing = 8.0,
    Widget? successIcon,
    Widget? errorIcon,
    Widget? loader,
    double loaderSize = 20.0,
    Color? loaderColor,
    bool showLoaderText = true,
    bool enableScaleAnimation = true,
    bool enableShimmerAnimation = false,
    Duration animationDuration = const Duration(milliseconds: 200),
    Duration stateResetDuration = const Duration(seconds: 2),
    bool enableHapticFeedback = true,
    bool debounceEnabled = true,
    Duration debounceDuration = const Duration(milliseconds: 500),
  }) {
    return _AsyncLoadingButton(
      key: key,
      child: child,
      asyncAction: asyncAction,
      onPressed: onPressed,
      onLoading: onLoading,
      onSuccess: onSuccess,
      onError: onError,
      disabled: disabled,
      type: type,
      size: size,
      borderRadius: borderRadius,
      isPillShape: isPillShape,
      padding: padding,
      width: width,
      height: height,
      backgroundColor: backgroundColor,
      disabledColor: disabledColor,
      textColor: textColor,
      disabledTextColor: disabledTextColor,
      borderColor: borderColor,
      successColor: successColor,
      errorColor: errorColor,
      gradient: gradient,
      shadow: shadow,
      textStyle: textStyle,
      borderWidth: borderWidth,
      icon: icon,
      iconPosition: iconPosition,
      iconSpacing: iconSpacing,
      successIcon: successIcon,
      errorIcon: errorIcon,
      loader: loader,
      loaderSize: loaderSize,
      loaderColor: loaderColor,
      showLoaderText: showLoaderText,
      enableScaleAnimation: enableScaleAnimation,
      enableShimmerAnimation: enableShimmerAnimation,
      animationDuration: animationDuration,
      stateResetDuration: stateResetDuration,
      enableHapticFeedback: enableHapticFeedback,
      debounceEnabled: debounceEnabled,
      debounceDuration: debounceDuration,
    );
  }

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

/// Icon position relative to text
enum IconPosition { left, right }

class _LoadingButtonState extends State<LoadingButton>
    with SingleTickerProviderStateMixin {
  late ButtonState _buttonState = ButtonState.idle;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late AnimationController _shimmerController;
  Timer? _resetTimer;
  DateTime? _lastPressedTime;

  @override
  void initState() {
    super.initState();

    // Scale animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      lowerBound: 0.0,
      upperBound: 1.0,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Shimmer animation controller
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _shimmerController.dispose();
    _resetTimer?.cancel();
    super.dispose();
  }

  bool get _isDisabled => widget.disabled || _buttonState == ButtonState.loading;

  Color _getBackgroundColor(ThemeData theme) {
    if (_isDisabled) {
      return widget.disabledColor ?? theme.disabledColor;
    }

    switch (_buttonState) {
      case ButtonState.success:
        return widget.successColor ?? Colors.green;
      case ButtonState.error:
        return widget.errorColor ?? Colors.red;
      case ButtonState.loading:
      case ButtonState.idle:
      default:
        if (widget.gradient != null) return Colors.transparent;
        return widget.backgroundColor ?? theme.primaryColor;
    }
  }

  Color _getTextColor(ThemeData theme) {
    if (_isDisabled) {
      return widget.disabledTextColor ?? theme.disabledColor;
    }

    if (widget.textColor != null) return widget.textColor!;

    // Determine text color based on button type and state
    switch (widget.type) {
      case ButtonType.elevated:
        return theme.colorScheme.onPrimary;
      case ButtonType.outlined:
      case ButtonType.text:
        return theme.colorScheme.primary;
    }
  }

  Color _getBorderColor(ThemeData theme) {
    if (_isDisabled) {
      return widget.disabledColor ?? theme.disabledColor;
    }

    if (widget.borderColor != null) return widget.borderColor!;

    switch (_buttonState) {
      case ButtonState.success:
        return widget.successColor ?? Colors.green;
      case ButtonState.error:
        return widget.errorColor ?? Colors.red;
      case ButtonState.loading:
      case ButtonState.idle:
      default:
        return theme.primaryColor;
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (widget.size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0);
      case ButtonSize.fullWidth:
        return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0);
    }
  }

  double? _getWidth() {
    if (widget.width != null) return widget.width;
    if (widget.size == ButtonSize.fullWidth) return double.infinity;
    return null;
  }

  double _getLoaderSize() {
    switch (widget.size) {
      case ButtonSize.small:
        return 16.0;
      case ButtonSize.medium:
        return 20.0;
      case ButtonSize.large:
        return 24.0;
      case ButtonSize.fullWidth:
        return 20.0;
    }
  }

  TextStyle _getTextStyle(ThemeData theme) {
    final baseStyle = widget.textStyle ?? theme.textTheme.labelLarge!;
    final color = _getTextColor(theme);

    switch (widget.size) {
      case ButtonSize.small:
        return baseStyle.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: color,
        );
      case ButtonSize.medium:
        return baseStyle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: color,
        );
      case ButtonSize.large:
        return baseStyle.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: color,
        );
      case ButtonSize.fullWidth:
        return baseStyle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: color,
        );
    }
  }

  void _handlePressed() async {
    // Debounce logic
    if (widget.debounceEnabled) {
      final now = DateTime.now();
      if (_lastPressedTime != null &&
          now.difference(_lastPressedTime!) < widget.debounceDuration) {
        return;
      }
      _lastPressedTime = now;
    }

    // Haptic feedback
    if (widget.enableHapticFeedback) {
      // import 'package:flutter/services.dart'; if needed
      // HapticFeedback.lightImpact();
    }

    // Call onPressed callback
    if (widget.onPressed != null) {
      widget.onPressed!();
    }

    // If button is already in loading state, don't do anything
    if (_buttonState == ButtonState.loading) return;

    // Set loading state
    setState(() {
      _buttonState = ButtonState.loading;
    });

    // Call onLoading callback
    if (widget.onLoading != null) {
      widget.onLoading!();
    }
  }

  void setLoading() {
    setState(() {
      _buttonState = ButtonState.loading;
    });
  }

  void setSuccess({bool autoReset = true}) {
    setState(() {
      _buttonState = ButtonState.success;
    });

    if (widget.onSuccess != null) {
      widget.onSuccess!();
    }

    if (autoReset) {
      _resetTimer = Timer(widget.stateResetDuration, () {
        if (mounted) {
          setState(() {
            _buttonState = ButtonState.idle;
          });
        }
      });
    }
  }

  void setError({bool autoReset = true}) {
    setState(() {
      _buttonState = ButtonState.error;
    });

    if (widget.onError != null) {
      widget.onError!();
    }

    if (autoReset) {
      _resetTimer = Timer(widget.stateResetDuration, () {
        if (mounted) {
          setState(() {
            _buttonState = ButtonState.idle;
          });
        }
      });
    }
  }

  void reset() {
    setState(() {
      _buttonState = ButtonState.idle;
    });
    _resetTimer?.cancel();
  }

  Widget _buildChild(ThemeData theme) {
    final textStyle = _getTextStyle(theme);
    final showText = _buttonState != ButtonState.loading || widget.showLoaderText;

    // Build icon based on state
    Widget? iconWidget;
    switch (_buttonState) {
      case ButtonState.success:
        iconWidget = widget.successIcon ?? const Icon(Icons.check, size: 20);
        break;
      case ButtonState.error:
        iconWidget = widget.errorIcon ?? const Icon(Icons.error, size: 20);
        break;
      case ButtonState.loading:
        iconWidget = widget.loader ??
            SizedBox(
              width: _getLoaderSize(),
              height: _getLoaderSize(),
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.loaderColor ?? _getTextColor(theme),
                ),
              ),
            );
        break;
      case ButtonState.idle:
        iconWidget = widget.icon;
        break;
    }

    // Build content row
    final children = <Widget>[];

    if (iconWidget != null && widget.iconPosition == IconPosition.left) {
      children.add(iconWidget);
      if (showText) children.add(SizedBox(width: widget.iconSpacing));
    }

    if (showText) {
      children.add(
        AnimatedOpacity(
          opacity: _buttonState == ButtonState.loading && !widget.showLoaderText ? 0.0 : 1.0,
          duration: widget.animationDuration,
          child: widget.child is Text
              ? DefaultTextStyle.merge(
                  style: textStyle,
                  child: widget.child,
                )
              : widget.child,
        ),
      );
    }

    if (iconWidget != null && widget.iconPosition == IconPosition.right) {
      if (showText) children.add(SizedBox(width: widget.iconSpacing));
      children.add(iconWidget);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  Widget _buildProgressBar(ThemeData theme) {
    if (!widget.showProgress || _buttonState != ButtonState.loading) {
      return const SizedBox();
    }

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: LinearProgressIndicator(
        value: widget.progressValue,
        backgroundColor: Colors.transparent,
        valueColor: AlwaysStoppedAnimation<Color>(
          widget.loaderColor ?? _getTextColor(theme),
        ),
        minHeight: 2,
      ),
    );
  }

  Widget _buildShimmerEffect(ThemeData theme) {
    if (!widget.enableShimmerAnimation || _isDisabled) {
      return const SizedBox();
    }

    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        final gradient = LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.3),
            Colors.white.withOpacity(0.1),
          ],
          stops: const [0.1, 0.5, 0.9],
          begin: const Alignment(-1.0, -0.3),
          end: const Alignment(1.0, 0.3),
          transform: _SlidingGradientTransform(
            slidePercent: _shimmerController.value,
          ),
        );

        return Positioned.fill(
          child: ShaderMask(
            shaderCallback: (bounds) => gradient.createShader(bounds),
            blendMode: BlendMode.srcOver,
            child: Container(
              decoration: BoxDecoration(
                color: _buttonState == ButtonState.success
                    ? widget.successColor ?? Colors.green
                    : _buttonState == ButtonState.error
                        ? widget.errorColor ?? Colors.red
                        : widget.backgroundColor ?? theme.primaryColor,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Determine button style based on type
    final buttonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (states) => _getBackgroundColor(theme),
      ),
      foregroundColor: MaterialStateProperty.resolveWith<Color>(
        (states) => _getTextColor(theme),
      ),
      side: widget.type == ButtonType.outlined
          ? MaterialStateProperty.resolveWith<BorderSide>(
              (states) => BorderSide(
                color: _getBorderColor(theme),
                width: widget.borderWidth,
              ),
            )
          : null,
      elevation: widget.type == ButtonType.elevated
          ? MaterialStateProperty.all(2.0)
          : MaterialStateProperty.all(0.0),
      padding: MaterialStateProperty.all(widget.padding),
      shape: MaterialStateProperty.all(
        widget.isPillShape
            ? StadiumBorder()
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
      ),
      overlayColor: MaterialStateProperty.resolveWith<Color>(
        (states) {
          if (states.contains(MaterialState.pressed)) {
            return theme.colorScheme.onPrimary.withOpacity(0.1);
          }
          return Colors.transparent;
        },
      ),
    );

    // Build the button widget
    Widget buttonWidget;
    switch (widget.type) {
      case ButtonType.elevated:
        buttonWidget = ElevatedButton(
          onPressed: _isDisabled ? null : _handlePressed,
          style: buttonStyle,
          child: _buildChild(theme),
        );
        break;
      case ButtonType.outlined:
        buttonWidget = OutlinedButton(
          onPressed: _isDisabled ? null : _handlePressed,
          style: buttonStyle,
          child: _buildChild(theme),
        );
        break;
      case ButtonType.text:
        buttonWidget = TextButton(
          onPressed: _isDisabled ? null : _handlePressed,
          style: buttonStyle,
          child: _buildChild(theme),
        );
        break;
    }

    // Apply scale animation
    if (widget.enableScaleAnimation) {
      buttonWidget = Listener(
        onPointerDown: (_) => _animationController.forward(),
        onPointerUp: (_) => _animationController.reverse(),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: buttonWidget,
        ),
      );
    }

    // Apply shimmer effect and progress bar
    return Stack(
      children: [
        Container(
          width: _getWidth(),
          height: widget.height,
          constraints: BoxConstraints(
            minWidth: widget.size == ButtonSize.fullWidth ? double.infinity : 0,
          ),
          child: buttonWidget,
        ),
        _buildShimmerEffect(theme),
        _buildProgressBar(theme),
      ],
    );
  }
}

/// Specialized widget for handling async operations
class _AsyncLoadingButton extends StatefulWidget {
  final Future<void> Function()? asyncAction;
  final Widget child;
  final VoidCallback? onPressed;
  final VoidCallback? onLoading;
  final VoidCallback? onSuccess;
  final VoidCallback? onError;
  final bool disabled;
  final ButtonType type;
  final ButtonSize size;
  final double borderRadius;
  final bool isPillShape;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? disabledColor;
  final Color? textColor;
  final Color? disabledTextColor;
  final Color? borderColor;
  final Color? successColor;
  final Color? errorColor;
  final Gradient? gradient;
  final BoxShadow? shadow;
  final TextStyle? textStyle;
  final double borderWidth;
  final Widget? icon;
  final IconPosition iconPosition;
  final double iconSpacing;
  final Widget? successIcon;
  final Widget? errorIcon;
  final Widget? loader;
  final double loaderSize;
  final Color? loaderColor;
  final bool showLoaderText;
  final bool enableScaleAnimation;
  final bool enableShimmerAnimation;
  final Duration animationDuration;
  final Duration stateResetDuration;
  final bool enableHapticFeedback;
  final bool debounceEnabled;
  final Duration debounceDuration;

  const _AsyncLoadingButton({
    super.key,
    required this.asyncAction,
    required this.child,
    this.onPressed,
    this.onLoading,
    this.onSuccess,
    this.onError,
    this.disabled = false,
    this.type = ButtonType.elevated,
    this.size = ButtonSize.medium,
    this.borderRadius = 8.0,
    this.isPillShape = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    this.width,
    this.height,
    this.backgroundColor,
    this.disabledColor,
    this.textColor,
    this.disabledTextColor,
    this.borderColor,
    this.successColor,
    this.errorColor,
    this.gradient,
    this.shadow,
    this.textStyle,
    this.borderWidth = 1.0,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.iconSpacing = 8.0,
    this.successIcon,
    this.errorIcon,
    this.loader,
    this.loaderSize = 20.0,
    this.loaderColor,
    this.showLoaderText = true,
    this.enableScaleAnimation = true,
    this.enableShimmerAnimation = false,
    this.animationDuration = const Duration(milliseconds: 200),
    this.stateResetDuration = const Duration(seconds: 2),
    this.enableHapticFeedback = true,
    this.debounceEnabled = true,
    this.debounceDuration = const Duration(milliseconds: 500),
  });

  @override
  State<_AsyncLoadingButton> createState() => _AsyncLoadingButtonState();
}

class _AsyncLoadingButtonState extends State<_AsyncLoadingButton> {
  final GlobalKey<_LoadingButtonState> _buttonKey = GlobalKey();

  Future<void> _handleAsyncAction() async {
    if (widget.asyncAction == null) return;

    // Set loading state
    _buttonKey.currentState?.setLoading();

    try {
      // Execute the async action
      await widget.asyncAction!();
      
      // Set success state
      _buttonKey.currentState?.setSuccess();
    } catch (e) {
      // Set error state
      _buttonKey.currentState?.setError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingButton(
      key: _buttonKey,
      child: widget.child,
      onPressed: _handleAsyncAction,
      onLoading: widget.onLoading,
      onSuccess: widget.onSuccess,
      onError: widget.onError,
      disabled: widget.disabled,
      type: widget.type,
      size: widget.size,
      borderRadius: widget.borderRadius,
      isPillShape: widget.isPillShape,
      padding: widget.padding,
      width: widget.width,
      height: widget.height,
      backgroundColor: widget.backgroundColor,
      disabledColor: widget.disabledColor,
      textColor: widget.textColor,
      disabledTextColor: widget.disabledTextColor,
      borderColor: widget.borderColor,
      successColor: widget.successColor,
      errorColor: widget.errorColor,
      gradient: widget.gradient,
      shadow: widget.shadow,
      textStyle: widget.textStyle,
      borderWidth: widget.borderWidth,
      icon: widget.icon,
      iconPosition: widget.iconPosition,
      iconSpacing: widget.iconSpacing,
      successIcon: widget.successIcon,
      errorIcon: widget.errorIcon,
      loader: widget.loader,
      loaderSize: widget.loaderSize,
      loaderColor: widget.loaderColor,
      showLoaderText: widget.showLoaderText,
      enableScaleAnimation: widget.enableScaleAnimation,
      enableShimmerAnimation: widget.enableShimmerAnimation,
      animationDuration: widget.animationDuration,
      stateResetDuration: widget.stateResetDuration,
      enableHapticFeedback: widget.enableHapticFeedback,
      debounceEnabled: widget.debounceEnabled,
      debounceDuration: widget.debounceDuration,
    );
  }
}

/// Helper class for shimmer animation
class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform({required this.slidePercent});

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

// Example usage
class LoadingButtonExample extends StatefulWidget {
  const LoadingButtonExample({super.key});

  @override
  State<LoadingButtonExample> createState() => _LoadingButtonExampleState();
}

class _LoadingButtonExampleState extends State<LoadingButtonExample> {
  int _counter = 0;

  Future<void> _simulateAsyncAction() async {
    // Simulate network request
    await Future.delayed(const Duration(seconds: 2));
    
    // Randomly succeed or fail
    final random = Random();
    if (random.nextBool()) {
      setState(() => _counter++);
    } else {
      throw Exception('Action failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loading Button Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Counter: $_counter', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 32),
            
            // Regular loading button
            LoadingButton(
              onPressed: () async {
                await _simulateAsyncAction();
              },
              child: const Text('Regular Button'),
            ),
            const SizedBox(height: 16),
            
            // Async loading button (automatically handles states)
            LoadingButton.future(
              asyncAction: _simulateAsyncAction,
              child: const Text('Async Button'),
            ),
            const SizedBox(height: 16),
            
            // Button with custom styling
            LoadingButton(
              onPressed: () async {
                await Future.delayed(const Duration(seconds: 2));
                setState(() => _counter += 2);
              },
              type: ButtonType.outlined,
              borderRadius: 20,
              enableShimmerAnimation: true,
              child: const Text('Styled Button'),
            ),
            const SizedBox(height: 16),
            
            // Success/error state example
            LoadingButton(
              onPressed: () async {
                await Future.delayed(const Duration(seconds: 1));
                if (_counter % 2 == 0) {
                  // Simulate success
                  setState(() => _counter++);
                } else {
                  // Simulate error
                  throw Exception('Failed on purpose');
                }
              },
              successIcon: const Icon(Icons.check, color: Colors.white),
              errorIcon: const Icon(Icons.error, color: Colors.white),
              child: const Text('Success/Error Example'),
            ),
          ],
        ),
      ),
    );
  }
}
