import 'package:flutter/material.dart';

enum OzowPaymentMethod { card, payshap }

class OzowPaymentMethodSelector extends StatefulWidget {
  final Function(OzowPaymentMethod) onMethodSelected;
  final String merchantName;
  final double amount;
  final String currency;

  const OzowPaymentMethodSelector({
    super.key,
    required this.onMethodSelected,
    required this.merchantName,
    required this.amount,
    this.currency = 'ZAR',
  });

  @override
  State<OzowPaymentMethodSelector> createState() =>
      _OzowPaymentMethodSelectorState();
}

class _OzowPaymentMethodSelectorState extends State<OzowPaymentMethodSelector> {
  OzowPaymentMethod? _selected;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1ABFA1),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'OZOW',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 20,
            letterSpacing: 3,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Amount header
          _buildAmountHeader(isDark),

          // Payment method label + step indicator
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              children: [
                Text(
                  'Payment Method',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                  ),
                ),
                const Spacer(),
                _buildStepIndicator(),
              ],
            ),
          ),

          // Only 2 payment methods
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                // ── Card ──────────────────────────────────
                _buildMethodTile(
                  method: OzowPaymentMethod.card,
                  icon: Icons.credit_card,
                  title: 'Card',
                  subtitle: 'Pay with Visa or Mastercard',
                  trailing: _buildCardLogos(),
                  isDark: isDark,
                ),

                const SizedBox(height: 4),

                // ── PayShap ───────────────────────────────
                _buildMethodTile(
                  method: OzowPaymentMethod.payshap,
                  icon: Icons.bolt,
                  title: 'PayShap',
                  subtitle: 'Instant payment via mobile or account number',
                  trailing: _buildPayShapBadge(),
                  isDark: isDark,
                ),

                const SizedBox(height: 24),

                // ── Info box ──────────────────────────────
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1ABFA1).withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFF1ABFA1).withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Color(0xFF1ABFA1),
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'PayShap lets you pay instantly using just '
                          'your mobile number — no card or banking '
                          'credentials needed.',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? Colors.white60
                                : const Color(0xFF555555),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Footer
          _buildFooter(isDark),
        ],
      ),
    );
  }

  Widget _buildAmountHeader(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF8F8F8),
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF333333) : const Color(0xFFEEEEEE),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pay ${widget.merchantName}',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white60 : const Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${widget.currency} ${widget.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF1ABFA1).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'SECURE',
              style: TextStyle(
                color: Color(0xFF1ABFA1),
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      children: List.generate(3, (index) {
        final isActive = index == 0;
        return Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? const Color(0xFF1ABFA1) : Colors.transparent,
                border: Border.all(
                  color: isActive
                      ? const Color(0xFF1ABFA1)
                      : Colors.grey.shade400,
                ),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isActive ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            ),
            if (index < 2)
              Container(width: 16, height: 1, color: Colors.grey.shade300),
          ],
        );
      }),
    );
  }

  Widget _buildMethodTile({
    required OzowPaymentMethod method,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    Widget? trailing,
  }) {
    final isSelected = _selected == method;

    return GestureDetector(
      onTap: () {
        setState(() => _selected = method);
        Future.delayed(const Duration(milliseconds: 200), () {
          widget.onMethodSelected(method);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1ABFA1).withValues(alpha: 0.08)
              : isDark
              ? const Color(0xFF1E1E1E)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1ABFA1)
                : isDark
                ? const Color(0xFF333333)
                : const Color(0xFFE5E5E5),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF1ABFA1).withValues(alpha: 0.12)
                    : isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? const Color(0xFF1ABFA1)
                    : isDark
                    ? Colors.white60
                    : const Color(0xFF666666),
                size: 22,
              ),
            ),
            const SizedBox(width: 14),

            // Title + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.white38 : const Color(0xFF888888),
                    ),
                  ),
                ],
              ),
            ),

            if (trailing != null) ...[trailing, const SizedBox(width: 8)],

            Icon(
              Icons.chevron_right,
              color: isDark ? Colors.white38 : Colors.grey.shade400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardLogos() {
    return Row(
      children: [
        // Mastercard
        SizedBox(
          width: 28,
          height: 18,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFEB001B),
                  ),
                ),
              ),
              Positioned(
                left: 10,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFF79E1B).withValues(alpha: 0.9),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        // Visa
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1F71),
            borderRadius: BorderRadius.circular(3),
          ),
          child: const Text(
            'VISA',
            style: TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPayShapBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1ABFA1), Color(0xFF0D9E87)],
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bolt, color: Colors.white, size: 11),
          SizedBox(width: 2),
          Text(
            'INSTANT',
            style: TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "By continuing you agree to Ozow's ",
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.white38 : Colors.grey,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'T&Cs',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF1ABFA1),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shield_outlined,
                size: 12,
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
    );
  }
}
