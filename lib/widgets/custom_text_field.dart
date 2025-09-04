import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A highly customizable Instagram-style text field with advanced features
/// including validation, animations, and custom UI enhancements.
class CustomTextField extends StatefulWidget {
  // Basic Properties
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;

  // Validation & Input Formatting
  final FormFieldValidator<String>? validator;
  final bool isRequired;
  final int? maxLength;
  final int? minLength;
  final RegExp? regexPattern;
  final String? regexError;
  final bool autoValidate;
  final List<TextInputFormatter>? inputFormatters;
  final bool autocorrect;
  final bool enableSuggestions;

  // UI Customization
  final Widget? prefixIcon;
  final String? prefixText;
  final Widget? suffixIcon;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? fillColor;
  final bool filled;
  final double borderRadius;
  final EdgeInsetsGeometry contentPadding;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;
  final TextStyle? labelStyle;
  final bool showCharCounter;
  final BoxShadow? shadow;
  final Gradient? borderGradient;

  // Advanced Features
  final bool isPassword;
  final bool isMultiline;
  final int? maxLines;
  final int? minLines;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final bool autoFocus;
  final bool readOnly;
  final bool showLoadingIndicator;
  final bool showClearButton;

  // Callbacks
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onTap;

  // Instagram-style Specific
  final bool floatingLabel;
  final bool showLoadingAnimation;
  final Duration animationDuration;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.validator,
    this.isRequired = false,
    this.maxLength,
    this.minLength,
    this.regexPattern,
    this.regexError,
    this.autoValidate = false,
    this.inputFormatters,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.prefixIcon,
    this.prefixText,
    this.suffixIcon,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.fillColor,
    this.filled = false,
    this.borderRadius = 12.0,
    this.contentPadding = const EdgeInsets.all(16.0),
    this.textStyle,
    this.hintStyle,
    this.errorStyle,
    this.labelStyle,
    this.showCharCounter = false,
    this.shadow,
    this.borderGradient,
    this.isPassword = false,
    this.isMultiline = false,
    this.maxLines = 1,
    this.minLines,
    this.focusNode,
    this.nextFocusNode,
    this.autoFocus = false,
    this.readOnly = false,
    this.showLoadingIndicator = false,
    this.showClearButton = false,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.onTap,
    this.floatingLabel = true,
    this.showLoadingAnimation = false,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _obscureText = true;
  bool _isValid = true;
  String? _errorText;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _borderAnimation;
  late Animation<double> _labelAnimation;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _obscureText = widget.isPassword;

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    // Border focus animation
    _borderAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Floating label animation
    _labelAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Listen to focus changes
    _focusNode.addListener(_handleFocusChange);
    _controller.addListener(_handleTextChange);
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
      _validateField();
    }
  }

  void _handleTextChange() {
    if (widget.onChanged != null) {
      widget.onChanged!(_controller.text);
    }

    if (widget.autoValidate) {
      _validateField();
    }

    setState(() {}); // Update UI for clear button and char counter
  }

  void _validateField() {
    if (widget.validator != null) {
      final error = widget.validator!(_controller.text);
      setState(() {
        _errorText = error;
        _isValid = error == null;
      });
    } else {
      _validateDefault();
    }
  }

  void _validateDefault() {
    String? error;
    final text = _controller.text;

    if (widget.isRequired && text.isEmpty) {
      error = 'This field is required';
    } else if (widget.minLength != null && text.length < widget.minLength!) {
      error = 'Minimum ${widget.minLength} characters required';
    } else if (widget.maxLength != null && text.length > widget.maxLength!) {
      error = 'Maximum ${widget.maxLength} characters allowed';
    } else if (widget.regexPattern != null &&
        text.isNotEmpty &&
        !widget.regexPattern!.hasMatch(text)) {
      error = widget.regexError ?? 'Invalid format';
    } else if (widget.keyboardType == TextInputType.emailAddress &&
        text.isNotEmpty &&
        !_isValidEmail(text)) {
      error = 'Please enter a valid email address';
    }

    setState(() {
      _errorText = error;
      _isValid = error == null;
    });
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _clearText() {
    setState(() {
      _controller.clear();
      _errorText = null;
      _isValid = true;
    });
    if (widget.onChanged != null) {
      widget.onChanged!('');
    }
  }

  void _handleSubmitted(String value) {
    if (widget.onSubmitted != null) {
      widget.onSubmitted!(value);
    }

    if (widget.nextFocusNode != null) {
      widget.nextFocusNode!.requestFocus();
    } else {
      _focusNode.unfocus();
    }
  }

  Widget _buildPrefix() {
    if (widget.prefixIcon != null || widget.prefixText != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.prefixIcon != null) widget.prefixIcon!,
          if (widget.prefixText != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                widget.prefixText!,
                style: widget.textStyle?.copyWith(
                      color: widget.textStyle?.color?.withOpacity(0.7),
                    ) ??
                    const TextStyle(color: Colors.grey),
              ),
            ),
          const SizedBox(width: 8.0),
        ],
      );
    }
    return const SizedBox();
  }

  Widget _buildSuffix() {
    final List<Widget> suffixChildren = [];

    // Loading indicator
    if (widget.showLoadingIndicator && _isLoading) {
      suffixChildren.add(
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    // Clear button
    if (widget.showClearButton &&
        _controller.text.isNotEmpty &&
        !widget.isPassword) {
      suffixChildren.add(
        GestureDetector(
          onTap: _clearText,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.clear, size: 20, color: Colors.grey),
          ),
        ),
      );
    }

    // Password visibility toggle
    if (widget.isPassword) {
      suffixChildren.add(
        GestureDetector(
          onTap: _togglePasswordVisibility,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              size: 20,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    // Custom suffix icon
    if (widget.suffixIcon != null) {
      suffixChildren.add(widget.suffixIcon!);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: suffixChildren,
    );
  }

  Widget _buildLabel() {
    if (widget.labelText == null) return const SizedBox();

    return AnimatedBuilder(
      animation: _labelAnimation,
      builder: (context, child) {
        final scale = 0.8 + (_labelAnimation.value * 0.2);
        final offset = -20.0 * _labelAnimation.value;

        return Transform.translate(
          offset: Offset(0, offset),
          child: Transform.scale(
            scale: scale,
            child: Text(
              widget.labelText!,
              style: (widget.labelStyle ?? const TextStyle()).copyWith(
                color: _focusNode.hasFocus
                    ? (widget.focusedBorderColor ?? Theme.of(context).primaryColor)
                    : Colors.grey,
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
    final isDark = theme.brightness == Brightness.dark;

    // Default colors
    final defaultBorderColor = isDark ? Colors.grey[600]! : Colors.grey[400]!;
    final defaultFocusedBorderColor = theme.primaryColor;
    final defaultErrorBorderColor = Colors.red;
    final defaultFillColor = isDark ? Colors.grey[800]! : Colors.grey[100]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Floating label
        if (widget.floatingLabel && widget.labelText != null) _buildLabel(),

        // Text field container
        AnimatedBuilder(
          animation: _borderAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                color: widget.filled
                    ? widget.fillColor ?? defaultFillColor
                    : Colors.transparent,
                boxShadow: widget.shadow != null ? [widget.shadow!] : [
                  if (!_focusNode.hasFocus)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                ],
                gradient: widget.borderGradient,
                border: widget.borderGradient == null
                    ? null
                    : Border.all(
                        width: _focusNode.hasFocus
                            ? _borderAnimation.value
                            : 1.0,
                        color: _isValid
                            ? (_focusNode.hasFocus
                                ? widget.focusedBorderColor ??
                                    defaultFocusedBorderColor
                                : widget.borderColor ?? defaultBorderColor)
                            : widget.errorBorderColor ?? defaultErrorBorderColor,
                      ),
              ),
              child: Padding(
                padding: widget.borderGradient != null
                    ? const EdgeInsets.all(2.0)
                    : EdgeInsets.zero,
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  keyboardType: widget.isMultiline
                      ? TextInputType.multiline
                      : widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  obscureText: _obscureText,
                  maxLength: widget.maxLength,
                  maxLines: widget.isMultiline
                      ? widget.maxLines ?? 5
                      : widget.maxLines,
                  minLines: widget.isMultiline
                      ? widget.minLines ?? 1
                      : widget.minLines,
                  autocorrect: widget.autocorrect,
                  enableSuggestions: widget.enableSuggestions,
                  readOnly: widget.readOnly,
                  autofocus: widget.autoFocus,
                  inputFormatters: widget.inputFormatters,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: widget.hintStyle ??
                        TextStyle(color: Colors.grey[500]),
                    border: InputBorder.none,
                    contentPadding: widget.contentPadding,
                    prefixIcon: _buildPrefix(),
                    suffixIcon: _buildSuffix(),
                    counterText: widget.showCharCounter ? null : '',
                    errorBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                  ),
                  style: widget.textStyle ?? theme.textTheme.bodyMedium,
                  onChanged: (value) {
                    if (widget.onChanged != null) {
                      widget.onChanged!(value);
                    }
                    if (widget.autoValidate) {
                      _validateField();
                    }
                  },
                  onSubmitted: _handleSubmitted,
                  onEditingComplete: widget.onEditingComplete,
                  onTap: widget.onTap,
                ),
              ),
            );
          },
        ),

        // Error text and character counter
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Error text
              if (_errorText != null)
                Expanded(
                  child: Text(
                    _errorText!,
                    style: widget.errorStyle ??
                        TextStyle(
                          color: widget.errorBorderColor ?? Colors.red,
                          fontSize: 12,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

              // Character counter
              if (widget.showCharCounter && widget.maxLength != null)
                Text(
                  '${_controller.text.length}/${widget.maxLength}',
                  style: TextStyle(
                    color: _controller.text.length > widget.maxLength!
                        ? Colors.red
                        : Colors.grey,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.removeListener(_handleFocusChange);
    _controller.removeListener(_handleTextChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }
}

// Example usage and validation functions
class CustomTextFieldExample extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  CustomTextFieldExample({super.key});

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Text Field Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Email field with floating label
            CustomTextField(
              controller: emailController,
              labelText: 'Email Address',
              hintText: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              focusNode: emailFocusNode,
              nextFocusNode: passwordFocusNode,
              validator: _validateEmail,
              autoValidate: true,
              isRequired: true,
              prefixIcon: const Icon(Icons.email, size: 20),
              floatingLabel: true,
            ),

            const SizedBox(height: 20),

            // Password field with visibility toggle
            CustomTextField(
              controller: passwordController,
              labelText: 'Password',
              hintText: 'Enter your password',
              isPassword: true,
              focusNode: passwordFocusNode,
              validator: _validatePassword,
              autoValidate: true,
              isRequired: true,
              prefixIcon: const Icon(Icons.lock, size: 20),
              floatingLabel: true,
            ),

            const SizedBox(height: 20),

            // Bio field with character counter
            CustomTextField(
              controller: bioController,
              labelText: 'Bio',
              hintText: 'Tell us about yourself...',
              isMultiline: true,
              maxLength: 150,
              showCharCounter: true,
              maxLines: 4,
              floatingLabel: true,
            ),
          ],
        ),
      ),
    );
  }
}
