import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Landing extends StatelessWidget {
  const Landing({super.key});

  static const _ink = Color(0xFF18243B);
  static const _orange = Color(0xFFFF5A1F);
  static const _background = Color(0xFFFFF8F3);

  void _openLogin(BuildContext context) {
    context.push('/login');
  }

  void _openSignup(BuildContext context) {
    context.push('/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 760;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 48 : 24,
                vertical: 24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1160),
                  child: Column(
                    children: [
                      _buildHeader(context, isWide),
                      SizedBox(height: isWide ? 72 : 44),
                      if (isWide)
                        Row(
                          children: [
                            Expanded(child: _buildMessage(context, true)),
                            const SizedBox(width: 56),
                            const Expanded(child: _FoodIllustration()),
                          ],
                        )
                      else
                        Column(
                          children: [
                            _buildMessage(context, false),
                            const SizedBox(height: 32),
                            const _FoodIllustration(),
                          ],
                        ),
                      const SizedBox(height: 48),
                      const Text(
                        'Good food, good mood.',
                        style: TextStyle(
                          color: Color(0xFF8993A3),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isWide) {
    return Row(
      children: [
        const Icon(Icons.restaurant, color: _orange, size: 30),
        const SizedBox(width: 9),
        const Text(
          'FoodMood',
          style: TextStyle(
            color: _ink,
            fontSize: 21,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () => _openLogin(context),
          child: const Text(
            'Log in',
            style: TextStyle(color: _ink, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 8),
        FilledButton(
          onPressed: () => _openSignup(context),
          style: FilledButton.styleFrom(
            backgroundColor: _orange,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 22 : 16,
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Sign up'),
        ),
      ],
    );
  }

  Widget _buildMessage(BuildContext context, bool isWide) {
    return Column(
      crossAxisAlignment: isWide
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE7DA),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Text(
            'FIND YOUR NEXT FAVORITE MEAL',
            style: TextStyle(
              color: _orange,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: 22),
        Text(
          'Find food that\nfits your mood.',
          textAlign: isWide ? TextAlign.left : TextAlign.center,
          style: TextStyle(
            color: _ink,
            fontSize: isWide ? 58 : 42,
            height: 1.08,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.5,
          ),
        ),
        const SizedBox(height: 18),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 470),
          child: Text(
            'Explore delicious meals and local favorites, '
            'all in one place. Your next craving is just a few taps away.',
            textAlign: isWide ? TextAlign.left : TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF667085),
              fontSize: 16,
              height: 1.7,
            ),
          ),
        ),
        const SizedBox(height: 30),
        Wrap(
          alignment: isWide ? WrapAlignment.start : WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: () => _openSignup(context),
                icon: const Icon(Icons.arrow_forward_rounded, size: 19),
                label: const Text('Get started'),
                style: FilledButton.styleFrom(
                  backgroundColor: _orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 52,
              child: OutlinedButton(
                onPressed: () => _openLogin(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _ink,
                  side: const BorderSide(color: Color(0xFFE8D9D0)),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('I already have an account'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Color(0xFF4F9B72), size: 18),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                'Create an account to get started',
                style: TextStyle(color: Color(0xFF667085), fontSize: 13),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FoodIllustration extends StatelessWidget {
  const _FoodIllustration();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.08,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 330,
            height: 330,
            decoration: const BoxDecoration(
              color: Color(0xFFFFE7DA),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.65),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 194,
            height: 194,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF18243B).withValues(alpha: 0.12),
                  blurRadius: 38,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: const Icon(
              Icons.ramen_dining_rounded,
              color: Color(0xFFFF5A1F),
              size: 112,
            ),
          ),
          const Positioned(
            top: 36,
            right: 12,
            child: _FloatingLabel(
              icon: Icons.star_rounded,
              iconColor: Color(0xFFFFB547),
              title: 'Made for you',
              subtitle: 'Find a new favorite',
            ),
          ),
          const Positioned(
            bottom: 40,
            left: 0,
            child: _FloatingLabel(
              icon: Icons.favorite_rounded,
              iconColor: Color(0xFFFF5A1F),
              title: 'Good food',
              subtitle: 'Better moods',
            ),
          ),
          const Positioned(
            top: 72,
            left: 34,
            child: Icon(Icons.eco_rounded, color: Color(0xFF4F9B72), size: 32),
          ),
          const Positioned(
            bottom: 74,
            right: 34,
            child: Icon(
              Icons.local_fire_department_rounded,
              color: Color(0xFFFF8A47),
              size: 31,
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingLabel extends StatelessWidget {
  const _FloatingLabel({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF18243B).withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 9),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF18243B),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(color: Color(0xFF8993A3), fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
