import 'package:flutter/material.dart';

enum OzowButtonStyle { standard, absaPay, capitecPay, nedbankEFT }

class OzowButton extends StatelessWidget {
  final VoidCallback onPressed;
  final OzowButtonStyle style;
  final bool isLoading;

  const OzowButton({
    super.key,
    required this.onPressed,
    this.style = OzowButtonStyle.standard,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF1ABFA1),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLeftContent(),
                  const SizedBox(width: 10),
                  _buildOzowLogo(),
                ],
              ),
      ),
    );
  }

  Widget _buildLeftContent() {
    switch (style) {
      case OzowButtonStyle.absaPay:
        return Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFDC1E2A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'absa',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              'Pay',
              style: TextStyle(
                color: Color(0xFFDC1E2A),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        );

      case OzowButtonStyle.capitecPay:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF003087), width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Icon(Icons.circle, color: Color(0xFFCC0000), size: 12),
              SizedBox(width: 4),
              Text(
                'Pay',
                style: TextStyle(
                  color: Color(0xFF003087),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );

      case OzowButtonStyle.nedbankEFT:
        return Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF007A4D),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'N',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              'Nedbank Direct EFT',
              style: TextStyle(
                color: Color(0xFF007A4D),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        );

      case OzowButtonStyle.standard:
        return const Text(
          'Pay With',
          style: TextStyle(
            color: Color(0xFF555555),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        );
    }
  }

  Widget _buildOzowLogo() {
    if (style == OzowButtonStyle.standard) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomPaint(size: const Size(28, 28), painter: _OzowIconPainter()),
          const SizedBox(width: 6),
          const Text(
            'OZOW',
            style: TextStyle(
              color: Color(0xFF2D3748),
              fontWeight: FontWeight.w800,
              fontSize: 18,
              letterSpacing: 0.5,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Powered by',
          style: TextStyle(color: Color(0xFF888888), fontSize: 9),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomPaint(size: const Size(16, 16), painter: _OzowIconPainter()),
            const SizedBox(width: 3),
            const Text(
              'OZOW',
              style: TextStyle(
                color: Color(0xFF2D3748),
                fontWeight: FontWeight.w800,
                fontSize: 11,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Ozow spiral icon painter ─────────────────────────
class _OzowIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width * 0.48, size.height * 0.5);

    const color1 = Color(0xFF1ABFA1);
    const color2 = Color(0xFF0D9E87);

    // Inner circle
    paint
      ..color = color1
      ..strokeWidth = size.width * 0.1;
    canvas.drawCircle(center, size.width * 0.12, paint);

    // Middle arc
    paint
      ..color = color1
      ..strokeWidth = size.width * 0.09;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width * 0.26),
      -2.4,
      4.8,
      false,
      paint,
    );

    // Outer arc
    paint
      ..color = color2
      ..strokeWidth = size.width * 0.09;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width * 0.42),
      -2.0,
      4.2,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_OzowIconPainter oldDelegate) => false;
}
