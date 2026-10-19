import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:futureme/core/auth/auth_service.dart';
import 'package:futureme/core/data/user_repository.dart';
import 'package:futureme/core/di/injectable_init.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/feature/authentication/reset_password_screen.dart';
import 'package:futureme/feature/chat/chat_flow.dart';
import 'package:futureme/feature/dashboard/dashboard_navigation.dart';
import 'package:futureme/feature/dashboard/module_progress.dart';
import 'package:futureme/feature/paywall/pricing_package.dart';
import 'package:futureme/feature/profile/delete_account_screen.dart';
import 'package:futureme/feature/report/report_screen.dart';
import 'package:futureme/feature/resources/resources_screen.dart';
import 'package:futureme/feature/splash/splash_screen.dart';
import 'package:futureme/shared/widgets/app_bottom_nav_bar.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/page_title.dart';

/// How each stored age bracket reads on screen. Signup records a bracket
/// rather than a date of birth, so this is as precise as the profile gets —
/// deliberately, since the app is used by minors.
const Map<String, String> _ageBracketLabels = {
  'under14': "Sub 14 ani",
  '14_15': "14-15 ani",
  '16_17': "16-17 ani",
  '18_plus': "18 ani sau peste",
};

const Map<String, String> _authProviderLabels = {
  'password': "Email și parolă",
  'google.com': "Google",
  'apple.com': "Apple",
};

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _profile;
  bool _loading = true;
  bool _signingOut = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final uid = getIt<AuthService>().currentUser?.uid;
    await ModuleProgress.hydrate();
    Map<String, dynamic>? profile;
    if (uid != null) {
      try {
        profile = await getIt<UserRepository>().fetchProfile(uid);
      } catch (_) {
        profile = null;
      }
    }
    if (!mounted) return;
    setState(() {
      _profile = profile;
      _loading = false;
    });
  }

  Future<void> _signOut() async {
    if (_signingOut) return;
    setState(() => _signingOut = true);
    try {
      await getIt<AuthService>().signOut();
      if (!mounted) return;
      // Clearing the stack on its own left the user staring at nothing:
      // the app shell doesn't build a new route when auth state changes.
      // Push the splash in place of everything instead — it routes to
      // onboarding now that there's no session.
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const SplashScreen()),
        (route) => false,
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nu am putut ieși din cont. Încearcă din nou.')),
      );
      setState(() => _signingOut = false);
    }
  }

  bool get _hasAccess {
    final status = (_profile?['subscription'] as Map<String, dynamic>?)?['status'] as String?;
    return status != null && status.startsWith('active');
  }

  String get _authProvider {
    final raw = _profile?['authProvider'] as String?;
    return _authProviderLabels[raw] ?? "Email și parolă";
  }

  /// Only email/password accounts have a password to change.
  bool get _canChangePassword => (_profile?['authProvider'] as String? ?? 'password') == 'password';

  String? get _ageBracket => _ageBracketLabels[_profile?['ageBracket'] as String?];

  String? get _memberSince {
    final createdAt = _profile?['createdAt'];
    if (createdAt is! Timestamp) return null;
    final date = createdAt.toDate();
    const months = [
      "ianuarie", "februarie", "martie", "aprilie", "mai", "iunie",
      "iulie", "august", "septembrie", "octombrie", "noiembrie", "decembrie",
    ];
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final user = getIt<AuthService>().currentUser;
    final name = (user?.displayName?.trim().isNotEmpty ?? false)
        ? user!.displayName!.trim()
        : ((_profile?['displayName'] as String?)?.trim().isNotEmpty ?? false)
            ? (_profile!['displayName'] as String).trim()
            : "Contul tău";
    final email = user?.email ?? (_profile?['email'] as String?) ?? "—";
    final completed = ModuleProgress.completedModules.clamp(0, 5);
    final ageBracket = _ageBracket;
    final memberSince = _memberSince;

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: AppBottomNavBar(
        activeIndex: 4,
        onHomeTap: () => goToDashboard(context),
        onChatTap: () => openChat(context),
        onReportTap: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ReportScreen()),
        ),
        onResourcesTap: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ResourcesScreen()),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            CustomAppBar(context),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          const PageTitle(content: "Profilul tău", textAlign: TextAlign.left),
                          const SizedBox(height: 24),
                          _IdentityCard(name: name, email: email),
                          const SizedBox(height: 24),
                          const _SectionLabel(text: "Datele contului"),
                          const SizedBox(height: 8),
                          _DetailsCard(
                            rows: [
                              _DetailRow(icon: Icons.person_outline, label: "Nume", value: name),
                              _DetailRow(icon: Icons.mail_outline, label: "Email", value: email),
                              if (ageBracket != null)
                                _DetailRow(icon: Icons.cake_outlined, label: "Vârstă", value: ageBracket),
                              _DetailRow(icon: Icons.key_outlined, label: "Autentificare", value: _authProvider),
                              if (memberSince != null)
                                _DetailRow(icon: Icons.calendar_today_outlined, label: "Cont creat", value: memberSince),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const _SectionLabel(text: "Parcursul tău"),
                          const SizedBox(height: 8),
                          _InfoCard(
                            title: "Module finalizate",
                            body: "$completed din 5",
                            progress: completed / 5,
                          ),
                          const SizedBox(height: 16),
                          _AccessCard(
                            hasAccess: _hasAccess,
                            onBuy: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PricingPackage()),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const _SectionLabel(text: "Setări"),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: AppColors.border),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                if (_canChangePassword) ...[
                                  _ActionRow(
                                    icon: Icons.lock_outline,
                                    label: "Schimbă parola",
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
                                    ),
                                  ),
                                  const Divider(color: AppColors.border, height: 1, indent: 16, endIndent: 16),
                                ],
                                _ActionRow(
                                  icon: Icons.logout,
                                  label: _signingOut ? "Se deconectează..." : "Deconectează-te",
                                  onTap: _signingOut ? null : _signOut,
                                ),
                                const Divider(color: AppColors.border, height: 1, indent: 16, endIndent: 16),
                                _ActionRow(
                                  icon: Icons.delete_outline,
                                  label: "Șterge contul",
                                  color: AppColors.errorFg,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const DeleteAccountScreen()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.uiHeading,
        fontSize: 18,
        fontFamily: AppFonts.heading,
        fontWeight: FontWeight.w500,
        height: 1.2,
      ),
    );
  }
}

class _IdentityCard extends StatelessWidget {
  const _IdentityCard({required this.name, required this.email});

  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.faint,
        border: Border.all(color: AppColors.borderStrong),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppColors.specialGradient),
            child: Text(
              name.isNotEmpty ? name.substring(0, 1).toUpperCase() : "?",
              style: const TextStyle(color: Colors.white, fontSize: 20, fontFamily: AppFonts.heading, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(color: AppColors.uiHeading, fontSize: 18, fontFamily: AppFonts.heading, fontWeight: FontWeight.w600, height: 1.25),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: const TextStyle(color: AppColors.uiHeadingSmall, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow {
  const _DetailRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.rows});

  final List<_DetailRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            if (i > 0) const Divider(color: AppColors.border, height: 1, indent: 16, endIndent: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(rows[i].icon, size: 20, color: AppColors.uiHeadingSmall),
                  const SizedBox(width: 12),
                  Text(
                    rows[i].label,
                    style: const TextStyle(color: AppColors.uiHeadingSmall, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      rows[i].value,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.dashboard, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w500, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Replaces the old "Abonament" card: there's no recurring plan to report
/// on, only whether this account has paid for a run.
class _AccessCard extends StatelessWidget {
  const _AccessCard({required this.hasAccess, required this.onBuy});

  final bool hasAccess;
  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: hasAccess ? AppColors.border : AppColors.grad1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                hasAccess ? Icons.check_circle_outline : Icons.lock_outline,
                size: 20,
                color: hasAccess ? AppColors.statusInfoFg : AppColors.grad1,
              ),
              const SizedBox(width: 8),
              Text(
                hasAccess ? "Acces activ" : "Acces neactivat",
                style: const TextStyle(color: AppColors.uiHeading, fontSize: 16, fontFamily: AppFonts.body, fontWeight: FontWeight.w500, height: 1.375),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            hasAccess
                ? "Ai plătit pentru acest parcurs. Nu există abonament sau reînnoire automată."
                : "Activează experiența FutureMe printr-o singură plată, fără abonament.",
            style: const TextStyle(color: AppColors.uiHeadingSmall, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
          ),
          if (!hasAccess) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: onBuy,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.faint,
                  border: Border.all(color: AppColors.grad1),
                  borderRadius: BorderRadius.circular(100),
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Vezi detalii",
                  style: TextStyle(color: AppColors.grad1, fontSize: 16, fontFamily: AppFonts.body, fontWeight: FontWeight.w500, height: 1.25),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.body, this.progress});

  final String title;
  final String body;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: AppColors.uiHeadingSmall, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w500, height: 1.375),
          ),
          const SizedBox(height: 4),
          Text(
            body,
            style: const TextStyle(color: AppColors.dashboard, fontSize: 16, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
          ),
          if (progress != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(9999),
              child: LinearProgressIndicator(
                value: progress!.clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: AppColors.border,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.statusInfoFg),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.icon, required this.label, this.onTap, this.color = AppColors.dashboard});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 16, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, size: 20, color: AppColors.uiHeadingSmall),
          ],
        ),
      ),
    );
  }
}