import 'package:flutter/material.dart';
import '../../theme/bb_colors.dart';
import '../../theme/bb_text.dart';
import '../../widgets/brand_button.dart';

/// Terms and Conditions screen - shown before onboarding
class TermsScreen extends StatefulWidget {
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const TermsScreen({
    super.key,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen>
    with TickerProviderStateMixin {
  bool _acceptedTerms = false;
  bool _acceptedPrivacy = false;
  bool _acceptedLimitations = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool get _canProceed =>
      _acceptedTerms && _acceptedPrivacy && _acceptedLimitations;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? BBColors.nightBg : BBColors.dayBg,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(BBColors.padXL),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(BBColors.padM),
                        decoration: BoxDecoration(
                          gradient: BrandAccents.electricGradient,
                          borderRadius: BorderRadius.circular(
                            BBColors.radiusLg,
                          ),
                        ),
                        child: const Icon(
                          Icons.memory_rounded,
                          size: 28,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: BBColors.padM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ByteBudget',
                              style: BBTextResponsive.titleLarge(
                                context,
                                weight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Terms & Conditions',
                              style: BBTextResponsive.bodyMedium(
                                context,
                                color: BBColors.textMuted(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Progress indicator
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: BBColors.padXL,
                  ),
                  height: 4,
                  child: LinearProgressIndicator(
                    value: 0.5,
                    backgroundColor: isDark
                        ? BBColors.nightDivider
                        : BBColors.dayDivider,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      BBColors.accentBlue,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: BBColors.padXL),
                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: BBColors.padXL,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Terms of Service
                        _AgreementSection(
                          title: 'Terms of Service',
                          icon: Icons.description_rounded,
                          color: BBColors.accentBlue,
                          initiallyExpanded: true,
                          required: true,
                          value: _acceptedTerms,
                          onChanged: (v) => setState(() => _acceptedTerms = v),
                          content: _termsOfServiceContent,
                        ),
                        const SizedBox(height: BBColors.padL),
                        // Privacy Policy
                        _AgreementSection(
                          title: 'Privacy Policy',
                          icon: Icons.privacy_tip_rounded,
                          color: BBColors.accentGreen,
                          required: true,
                          value: _acceptedPrivacy,
                          onChanged: (v) =>
                              setState(() => _acceptedPrivacy = v),
                          content: _privacyPolicyContent,
                        ),
                        const SizedBox(height: BBColors.padL),
                        // App Limitations
                        _AgreementSection(
                          title: 'App Limitations & Disclaimers',
                          icon: Icons.warning_amber_rounded,
                          color: BBColors.accentOrange,
                          required: true,
                          value: _acceptedLimitations,
                          onChanged: (v) =>
                              setState(() => _acceptedLimitations = v),
                          content: _limitationsContent,
                        ),
                      ],
                    ),
                  ),
                ),
                // Bottom buttons
                Padding(
                  padding: const EdgeInsets.all(BBColors.padXL),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: BrandButton(
                          text: 'Accept & Continue',
                          onPressed: _canProceed ? widget.onAccept : null,
                          gradient: BrandAccents.electricGradient,
                          icon: Icons.arrow_forward_rounded,
                          iconPosition: IconPosition.trailing,
                        ),
                      ),
                      const SizedBox(height: BBColors.padM),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: widget.onDecline,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: BBColors.padM,
                            ),
                            side: BorderSide(
                              color: isDark
                                  ? BBColors.nightDivider
                                  : BBColors.dayDivider,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                BBColors.radiusLg,
                              ),
                            ),
                          ),
                          child: Text(
                            'Decline & Exit',
                            style: BBTextResponsive.labelLarge(
                              context,
                              color: BBColors.textMuted(context),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static const String _termsOfServiceContent = '''
By using ByteBudget ("the App"), you agree to these Terms of Service. Please read them carefully.

1. ACCEPTANCE OF TERMS
By accessing or using the App, you agree to be bound by these Terms. If you disagree with any part, you may not use the App.

2. DESCRIPTION OF SERVICE
ByteBudget is a PC peripheral shopping and build planning application. We provide product information, pricing, and build compatibility tools for informational purposes only.

3. USER ACCOUNTS
You may create an account to save builds, track orders, and manage preferences. You are responsible for maintaining account confidentiality.

4. PRICING & AVAILABILITY
All prices are in Philippine Peso (₱) and are subject to change without notice. We strive for accuracy but cannot guarantee prices are current. Product availability varies.

5. THIRD-PARTY LINKS
The App may contain links to third-party retailers. We are not responsible for their content, policies, or transactions.

6. INTELLECTUAL PROPERTY
All content, trademarks, and data in the App are owned by or licensed to ByteBudget. Unauthorized use is prohibited.

7. DISCLAIMER OF WARRANTIES
The App is provided "as is" without warranties of any kind. We do not guarantee uninterrupted or error-free operation.

8. LIMITATION OF LIABILITY
To the maximum extent permitted by law, ByteBudget shall not be liable for any indirect, incidental, or consequential damages.

9. GOVERNING LAW
These Terms are governed by the laws of the Republic of the Philippines.

10. CHANGES TO TERMS
We may update these Terms at any time. Continued use constitutes acceptance of changes.

Last updated: 2024
''';

  static const String _privacyPolicyContent = '''
Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your information.

1. INFORMATION WE COLLECT
• Account data: name, email, preferences
• Usage data: app interactions, build configurations, search queries
• Device data: device model, OS version, app version
• Location data: coarse location for regional pricing (optional)

2. HOW WE USE YOUR DATA
• Provide and improve the App
• Personalize your experience
• Sync data across devices
• Send relevant notifications (with consent)
• Analytics and performance monitoring

3. DATA STORAGE & SECURITY
• Data stored locally on device via SharedPreferences
• Optional cloud sync uses encrypted transmission
• We implement reasonable security measures
• No sensitive payment data stored in the App

4. DATA SHARING
We do not sell your personal data. We may share:
• With service providers (analytics, crash reporting)
• When required by law
• With your explicit consent

5. YOUR RIGHTS
• Access, correct, or delete your data
• Opt-out of analytics
• Disable data sync
• Request data export
Contact: privacy@bytebudget.app

6. CHILDREN'S PRIVACY
The App is not intended for users under 13. We do not knowingly collect data from children.

7. CHANGES
We may update this policy. Continued use constitutes acceptance.

Last updated: 2024
''';

  static const String _limitationsContent = '''
Please understand the following limitations of ByteBudget before proceeding.

1. PRICE ACCURACY
• Prices are sourced from partner retailers and may not reflect real-time pricing
• Promotional prices may expire or have limited stock
• Always verify final price at retailer before purchase

2. PRODUCT AVAILABILITY
• Stock levels are indicative only
• Regional availability varies across the Philippines
• Some products may be discontinued or backordered

3. COMPATIBILITY CHECKING
• Build compatibility is based on standard specifications
• Edge cases (clearance, power, BIOS) may not be detected
• Always verify compatibility with manufacturer specs

4. IMAGE SOURCES
• Product images are sourced from manufacturer/retailer websites
• Images may not match exact variant (color, version)
• Used under fair use for identification purposes

5. NO PURCHASE GUARANTEE
• ByteBudget is a planning tool, not a retailer
• We cannot guarantee order fulfillment
• Transactions occur on third-party sites

6. OFFLINE FUNCTIONALITY
• Limited features available offline
• Cart/builds sync when connectivity restored
• Price updates require internet connection

7. REGIONAL RESTRICTIONS
• Pricing in Philippine Peso (₱) only
• Shipping/tax estimates for Philippines only
• Some products may not ship to all regions

8. APP UPDATES
• Features may change between versions
• Data migration not guaranteed across major updates
• Backup your builds periodically

9. SUPPORT LIMITATIONS
• Community-based support via GitHub/issues
• No guaranteed response time
• No phone/live chat support

10. USE AT YOUR OWN RISK
ByteBudget assists with research and planning. Final purchasing decisions and compatibility verification are your responsibility.

By accepting, you acknowledge these limitations.
''';
}

class _AgreementSection extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final bool required;
  final bool initiallyExpanded;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String content;

  const _AgreementSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.required,
    required this.value,
    required this.onChanged,
    required this.content,
    this.initiallyExpanded = false,
  });

  @override
  State<_AgreementSection> createState() => _AgreementSectionState();
}

class _AgreementSectionState extends State<_AgreementSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightAnimation;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _heightAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    if (_expanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
      _expanded ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? BBColors.nightSurface : BBColors.daySurface,
        borderRadius: BorderRadius.circular(BBColors.radiusXL),
        border: Border.all(
          color: widget.value
              ? widget.color.withValues(alpha: 0.5)
              : (isDark ? BBColors.nightDivider : BBColors.dayDivider),
          width: widget.value ? 2 : 1,
        ),
        boxShadow: widget.value
            ? [
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.1),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: _toggle,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(BBColors.radiusXL),
            ),
            child: Padding(
              padding: const EdgeInsets.all(BBColors.padM),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(BBColors.padS),
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(BBColors.radiusMd),
                    ),
                    child: Icon(
                      widget.icon,
                      size: 20,
                      color: BBColors.readable(context, widget.color),
                    ),
                  ),
                  const SizedBox(width: BBColors.padM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                widget.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: BBTextResponsive.titleMedium(
                                  context,
                                  weight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (widget.required) ...[
                              const SizedBox(width: BBColors.padS),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: widget.color.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(
                                    BBColors.radiusFull,
                                  ),
                                ),
                                child: Text(
                                  'Required',
                                  style: BBTextResponsive.labelSmall(
                                    context,
                                    color: widget.color,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        Text(
                          _expanded ? 'Tap to collapse' : 'Tap to expand',
                          style: BBTextResponsive.bodySmall(
                            context,
                            color: BBColors.textMuted(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: BBColors.textMuted(context),
                    ),
                  ),
                  const SizedBox(width: BBColors.padS),
                  Checkbox(
                    value: widget.value,
                    onChanged: (v) => widget.onChanged(v ?? false),
                    activeColor: widget.color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(BBColors.radiusSm),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content
          SizeTransition(
            sizeFactor: _heightAnimation,
            alignment: Alignment.topCenter,
            child: ClipRect(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  BBColors.padM,
                  0,
                  BBColors.padM,
                  BBColors.padM,
                ),
                child: SelectableText(
                  widget.content,
                  style: BBTextResponsive.bodyMedium(context).copyWith(
                    height: 1.6,
                    color: BBColors.textSecondary(context),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
