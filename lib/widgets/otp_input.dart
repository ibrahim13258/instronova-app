// widgets/otp_input.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A highly customizable OTP input widget with Instagram-style design
/// and advanced features like animations, validation, and auto-submit.
class OTPInput extends StatefulWidget {
  // Basic Configuration
  final int length;
  final bool autoFocus;
  final bool obscureText;
  final bool autoClear;
  final bool disablePaste;
  final bool isRTL;

  // Validation
  final int? minLength;
  final int? maxLength;
  final FormFieldValidator<String>? validator;

  // UI Customization
  final double boxSize;
  final double boxSpacing;
  final double borderRadius;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color errorBorderColor;
  final Color fillColor;
  final bool filled;
  final TextStyle textStyle;
  final TextStyle errorStyle;
  final BoxShape boxShape;
  final bool showCursor;
  final Duration cursorBlinkInterval;

  // Animations
  final bool enableAnimation;
  final Duration animationDuration;
  final Curve animationCurve;

  // Callbacks
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onError;

  // Advanced Features
  final bool showLoadingIndicator;
  final bool enableHapticFeedback;
  final Duration resendCooldown;

  const OTPInput({
    super.key,
    this.length = 6,
    this.autoFocus = true,
    this.obscureText = false,
    this.autoClear = false,
    this.disablePaste = false,
    this.isRTL = false,
    this.minLength,
    this.maxLength,
    this.validator,
    this.boxSize = 50.0,
    this.boxSpacing = 8.0,
    this.borderRadius = 8.0,
    this.borderColor = Colors.grey,
    this.focusedBorderColor = Colors.blue,
    this.errorBorderColor = Colors.red,
    this.fillColor = Colors.transparent,
    this.filled = false,
    this.textStyle = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    this.errorStyle = const TextStyle(
      fontSize: 12,
      color: Colors.red,
    ),
    this.boxShape = BoxShape.rectangle,
    this.showCursor = true,
    this.cursorBlinkInterval = const Duration(milliseconds: 500),
    this.enableAnimation = true,
    this.animationDuration = const Duration(milliseconds: 150),
    this.animationCurve = Curves.easeInOut,
    required this.onChanged,
    required this.onCompleted,
    this.onError,
    this.showLoadingIndicator = false,
    this.enableHapticFeedback = true,
    this.resendCooldown = const Duration(seconds: 60),
  })  : assert(length > 0, 'Length must be greater than 0'),
        assert(boxSize > 0, 'Box size must be greater than 0');

  @override
  State<OTPInput> createState() => _OTPInputState();
}

class _OTPInputState extends State<OTPInput> with SingleTickerProviderStateMixin {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late List<bool> _hasError;
  late String _currentText;
  late AnimationController _cursorController;
  late AnimationController _errorAnimationController;
  bool _isLoading = false;
  bool _showCursor = true;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _currentText = '';

    // Initialize cursor animation
    _cursorController = AnimationController(
      vsync: this,
      duration: widget.cursorBlinkInterval,
    )..repeat(reverse: true);

    // Initialize error animation
    _errorAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    // Auto-focus first field
    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_focusNodes[0]);
      });
    }

    // Listen to cursor animation
    _cursorController.addListener(() {
      setState(() {
        _showCursor = _cursorController.value > 0.5;
      });
    });
  }

  void _initializeControllers() {
    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );

    _focusNodes = List.generate(
      widget.length,
      (index) => FocusNode(),
    );

    _hasError = List.generate(widget.length, (index) => false);

    // Add listeners to each controller
    for (int i = 0; i < widget.length; i++) {
      _controllers[i].addListener(() {
        _onTextChanged(i);
      });

      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          _onFocus(i);
        }
      });
    }
  }

  void _onTextChanged(int index) {
    final text = _controllers[index].text;

    if (text.isNotEmpty) {
      // Move to next field when text is entered
      if (index < widget.length - 1) {
        _focusNodes[index].unfocus();
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      }

      // Provide haptic feedback
      if (widget.enableHapticFeedback) {
        HapticFeedback.lightImpact();
      }
    }

    // Update current text
    _currentText = _getCurrentText();
    widget.onChanged(_currentText);

    // Check if OTP is complete
    if (_currentText.length == widget.length) {
      _validateAndComplete();
    }
  }

  void _onFocus(int index) {
    // Select all text when focused
    if (_controllers[index].text.isNotEmpty) {
      _controllers[index].selection = TextSelection(
        baseOffset: 0,
        extentOffset: _controllers[index].text.length,
      );
    }

    // Animate the focused box
    if (widget.enableAnimation) {
      setState(() {});
    }
  }

  String _getCurrentText() {
    return _controllers.map((controller) => controller.text).join();
  }

  void _validateAndComplete() {
    final text = _getCurrentText();
    String? error;

    // Validate min length
    if (widget.minLength != null && text.length < widget.minLength!) {
      error = 'OTP must be at least ${widget.minLength} digits';
    }

    // Validate max length
    if (widget.maxLength != null && text.length > widget.maxLength!) {
      error = 'OTP cannot exceed ${widget.maxLength} digits';
    }

    // Custom validator
    if (widget.validator != null) {
      error = widget.validator!(text);
    }

    if (error != null) {
      // Show error state
      _showError(error);
      if (widget.onError != null) {
        widget.onError!(error);
      }
    } else {
      // Complete OTP entry
      widget.onCompleted(text);
    }
  }

  void _showError(String error) {
    // Animate error state
    _errorAnimationController.forward(from: 0).then((_) {
      _errorAnimationController.reverse();
    });

    setState(() {
      for (int i = 0; i < widget.length; i++) {
        _hasError[i] = true;
      }
    });

    // Reset error state after animation
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          for (int i = 0; i < widget.length; i++) {
            _hasError[i] = false;
          }
        });
      }
    });
  }

  void _handlePaste(String text) {
    if (widget.disablePaste) return;

    // Clear existing text if autoClear is enabled
    if (widget.autoClear) {
      _clearAll();
    }

    // Fill boxes with pasted text
    for (int i = 0; i < min(text.length, widget.length); i++) {
      _controllers[i].text = text[i];
    }

    // Move focus to the next empty field or last field
    final nextEmptyIndex = _getNextEmptyIndex();
    if (nextEmptyIndex < widget.length) {
      FocusScope.of(context).requestFocus(_focusNodes[nextEmptyIndex]);
    } else {
      FocusScope.of(context).requestFocus(_focusNodes[widget.length - 1]);
    }
  }

  void _clearAll() {
    for (final controller in _controllers) {
      controller.clear();
    }
    _currentText = '';
    widget.onChanged(_currentText);
    FocusScope.of(context).requestFocus(_focusNodes[0]);
  }

  int _getNextEmptyIndex() {
    for (int i = 0; i < widget.length; i++) {
      if (_controllers[i].text.isEmpty) {
        return i;
      }
    }
    return widget.length;
  }

  void _handleBackspace(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      // Move to previous field if current is empty
      _focusNodes[index].unfocus();
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    } else if (_controllers[index].text.isNotEmpty) {
      // Clear current field
      _controllers[index].clear();
    }
  }

  Widget _buildSingleBox(int index) {
    final hasFocus = _focusNodes[index].hasFocus;
    final hasText = _controllers[index].text.isNotEmpty;
    final hasError = _hasError[index];

    // Determine border color based on state
    Color borderColor = widget.borderColor;
    if (hasError) {
      borderColor = widget.errorBorderColor;
    } else if (hasFocus) {
      borderColor = widget.focusedBorderColor;
    }

    // Animation for focused box
    double scale = 1.0;
    if (widget.enableAnimation && hasFocus) {
      scale = 1.05;
    }

    return AnimatedContainer(
      duration: widget.animationDuration,
      curve: widget.animationCurve,
      width: widget.boxSize,
      height: widget.boxSize,
      transform: Matrix4.identity()..scale(scale, scale),
      decoration: BoxDecoration(
        color: widget.filled ? widget.fillColor : Colors.transparent,
        borderRadius: widget.boxShape == BoxShape.rectangle
            ? BorderRadius.circular(widget.borderRadius)
            : null,
        shape: widget.boxShape,
        border: Border.all(
          color: borderColor,
          width: hasFocus ? 2.0 : 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Text or obscured text
          Text(
            hasText
                ? widget.obscureText
                    ? '•'
                    : _controllers[index].text
                : '',
            style: widget.textStyle,
          ),

          // Cursor
          if (hasFocus && widget.showCursor && !hasText)
            AnimatedOpacity(
              opacity: _showCursor ? 1.0 : 0.0,
              duration: widget.cursorBlinkInterval,
              child: Container(
                width: 2,
                height: widget.textStyle.fontSize! * 1.5,
                color: widget.focusedBorderColor,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // OTP input boxes
        Directionality(
          textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.length, (index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: widget.boxSpacing / 2),
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(_focusNodes[index]);
                  },
                  child: _buildSingleBox(index),
                ),
              );
            }),
          ),
        ),

        // Loading indicator
        if (widget.showLoadingIndicator && _isLoading)
          const Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _cursorController.dispose();
    _errorAnimationController.dispose();
    super.dispose();
  }
}

// Example usage
class OTPInputExample extends StatefulWidget {
  const OTPInputExample({super.key});

  @override
  State<OTPInputExample> createState() => _OTPInputExampleState();
}

class _OTPInputExampleState extends State<OTPInputExample> {
  final String _correctOTP = "123456";
  String _enteredOTP = "";
  bool _isLoading = false;
  String? _errorMessage;

  void _verifyOTP(String otp) {
    setState(() {
      _isLoading = true;
      _enteredOTP = otp;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        if (otp != _correctOTP) {
          _errorMessage = "Invalid OTP. Please try again.";
        } else {
          _errorMessage = null;
          // Navigate to next screen or show success
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OTP Verification"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter the 6-digit code sent to your phone",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            OTPInput(
              length: 6,
              onChanged: (value) {
                setState(() {
                  _enteredOTP = value;
                  if (_errorMessage != null && value.isEmpty) {
                    _errorMessage = null;
                  }
                });
              },
              onCompleted: _verifyOTP,
              onError: (error) {
                setState(() {
                  _errorMessage = error;
                });
              },
              autoFocus: true,
              enableHapticFeedback: true,
              showLoadingIndicator: _isLoading,
              textStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              focusedBorderColor: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Resend OTP logic
              },
              child: const Text("Resend Code"),
            ),
          ],
        ),
      ),
    );
  }
}
