import 'package:flutter/material.dart';
import '../ozow_result.dart';

class OzowResultScreen extends StatefulWidget {
  final OzowResult result;
  final VoidCallback onDone;
  final VoidCallback? onRetry;

  const OzowResultScreen({
    super.key,
    required this.result,
    required this.onDone,
    this.onRetry,
  });

  @override
  State<OzowResultScreen> createState() => _OzowResultScreenState();
}

class _OzowResultScreenState extends State<OzowResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _primaryColor {
    switch (widget.result.status) {
      case OzowPaymentStatus.success:
        return const Color(0xFF1ABFA1);
      case OzowPaymentStatus.cancelled:
        return const Color(0xFFF59E0B);
      case OzowPaymentStatus.error:
        return const Color(0xFFEF4444);
      case OzowPaymentStatus.pending:
        return const Color(0xFF3B82F6);
    }
  }

  IconData get _icon {
    switch (widget.result.status) {
      case OzowPaymentStatus.success:
        return Icons.check_circle_outline;
      case OzowPaymentStatus.cancelled:
        return Icons.cancel_outlined;
      case OzowPaymentStatus.error:
        return Icons.error_outline;
      case OzowPaymentStatus.pending:
        return Icons.hourglass_empty;
    }
  }

  String get _title {
    switch (widget.result.status) {
      case OzowPaymentStatus.success:
        return 'Payment Successful';
      case OzowPaymentStatus.cancelled:
        return 'Payment Cancelled';
      case OzowPaymentStatus.error:
        return 'Payment Failed';
      case OzowPaymentStatus.pending:
        return 'Payment Pending';
    }
  }

  String get _subtitle {
    switch (widget.result.status) {
      case OzowPaymentStatus.success:
        return 'Your payment has been successfully completed.';
      case OzowPaymentStatus.cancelled:
        return 'You cancelled the payment. No money was deducted.';
      case OzowPaymentStatus.error:
        return widget.result.errorMessage ??
            'Something went wrong. Please try again.';
      case OzowPaymentStatus.pending:
        return 'Your payment is being processed. We will notify you shortly.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated icon
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _primaryColor.withValues(alpha: 0.12),
                    ),
                    child: Icon(_icon, size: 56, color: _primaryColor),
                  ),
                ),

                const SizedBox(height: 28),

                // Title
                Text(
                  _title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                // Subtitle
                Text(
                  _subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white60 : const Color(0xFF666666),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                // Transaction ID
                if (widget.result.transactionId != null) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E1E1E)
                          : const Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF333333)
                            : const Color(0xFFE5E5E5),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.receipt_outlined,
                          size: 16,
                          color: isDark ? Colors.white38 : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Ref: ${widget.result.transactionId}',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'monospace',
                            color: isDark ? Colors.white60 : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 40),

                // Primary button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: widget.onDone,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      widget.result.isSuccess ? 'Return to merchant' : 'Done',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // Retry button (only on error)
                if (widget.result.isError && widget.onRetry != null) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: widget.onRetry,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _primaryColor,
                        side: BorderSide(color: _primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Try again',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // Ozow branding footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.blur_circular,
                      color: const Color(0xFF1ABFA1),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Powered by OZOW',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.white38 : Colors.grey,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
