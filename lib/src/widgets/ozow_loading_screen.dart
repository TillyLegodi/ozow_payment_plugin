import 'package:flutter/material.dart';

class OzowLoadingScreen extends StatefulWidget {
  final String message;
  const OzowLoadingScreen({
    super.key,
    this.message = 'Loading secure payment...',
  });

  @override
  State<OzowLoadingScreen> createState() => _OzowLoadingScreenState();
}

class _OzowLoadingScreenState extends State<OzowLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.85,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _fadeAnimation = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? const Color(0xFF121212) : Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated Ozow logo rings
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer ring
                    Transform.scale(
                      scale: _pulseAnimation.value * 1.3,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF1ABFA1).withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    // Middle ring
                    Transform.scale(
                      scale: _pulseAnimation.value * 1.1,
                      child: Container(
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF1ABFA1).withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                    // Inner circle with icon
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF1ABFA1),
                        ),
                        child: const Icon(
                          Icons.lock_outline,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 32),

            // OZOW text
            const Text(
              'OZOW',
              style: TextStyle(
                color: Color(0xFF1ABFA1),
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 4,
              ),
            ),

            const SizedBox(height: 8),

            // Message
            Text(
              widget.message,
              style: TextStyle(
                color: isDark ? Colors.white60 : const Color(0xFF666666),
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 24),

            // Progress indicator
            SizedBox(
              width: 120,
              child: LinearProgressIndicator(
                backgroundColor: const Color(0xFF1ABFA1).withValues(alpha: 0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF1ABFA1),
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            const SizedBox(height: 24),

            // Security badge
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.shield_outlined,
                  size: 14,
                  color: isDark ? Colors.white38 : Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  'Secure TLS Encryption',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white38 : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
