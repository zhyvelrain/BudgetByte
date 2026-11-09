import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../theme/bb_colors.dart';
import '../../theme/bb_text.dart';
import '../../widgets/brand_button.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthService>().currentUser;
    _nameController = TextEditingController(text: user?.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    final auth = context.read<AuthService>();
    final error = await auth.updateProfile(name: _nameController.text.trim());
    setState(() => _isSaving = false);
    if (error != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error, style: BBTextResponsive.bodyMedium(context)),
          backgroundColor: BBColors.accentRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated', style: BBTextResponsive.bodyMedium(context)),
          backgroundColor: BBColors.accentGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: BBTextResponsive.headlineMedium(context, weight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(BBColors.padL),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar preview
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: BrandAccents.electricGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_rounded, size: 50, color: Colors.white),
                ),
              ),
              const SizedBox(height: BBColors.padXL),

              Text('Personal Information', style: BBTextResponsive.titleLarge(context, weight: FontWeight.w600)),
              const SizedBox(height: BBColors.padM),

              // Name field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter your name',
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(BBColors.radiusMd)),
                  filled: true,
                  fillColor: isDark ? BBColors.nightSurface : BBColors.daySurface,
                ),
                validator: (v) => AuthService.validateName(v),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: BBColors.padL),

              // Email (read-only)
              TextFormField(
                initialValue: user?.email ?? '',
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(BBColors.radiusMd)),
                  filled: true,
                  fillColor: isDark ? BBColors.nightSurface.withValues(alpha: 0.5) : BBColors.daySurface.withValues(alpha: 0.5),
                  helperText: 'Email cannot be changed',
                  helperStyle: BBTextResponsive.caption(context),
                ),
              ),
              const SizedBox(height: BBColors.padL),

              // Member since (read-only)
              TextFormField(
                initialValue: 'Member since ${user?.createdAt.year ?? DateTime.now().year}',
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Account Created',
                  prefixIcon: const Icon(Icons.calendar_today_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(BBColors.radiusMd)),
                  filled: true,
                  fillColor: isDark ? BBColors.nightSurface.withValues(alpha: 0.5) : BBColors.daySurface.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: BBColors.padXXL),

              // Save button
              BrandButton(
                text: 'Save Changes',
                icon: Icons.save_rounded,
                onPressed: _isSaving ? null : _save,
                fullWidth: true,
                height: 56,
              ),
            ],
          ),
        ),
      ),
    );
  }
}