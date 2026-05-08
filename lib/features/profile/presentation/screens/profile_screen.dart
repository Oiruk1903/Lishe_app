import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lishe_app/features/profile/domain/entities/user_profile.dart';
import 'package:lishe_app/features/profile/presentation/widgets/settings_title.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/router/routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/provides.dart';
import '../provider/profile_provider.dart';
import '../widgets/profile_header.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _heightController = TextEditingController();
  final _targetWeightController = TextEditingController();

  bool _isEditing = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _heightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  void _initializeControllers(UserProfile profile) {
    _fullNameController.text = profile.fullName;
    _emailController.text = profile.email;
    _phoneController.text = profile.phoneNumber ?? '';
    _heightController.text = profile.height?.toString() ?? '';
    _targetWeightController.text = profile.targetWeight?.toString() ?? '';
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context);
    final profileAsync = ref.watch(profileProvider);
    final authState = ref.watch(authNotifierProvider.select((state) => state));
    final locale = ref.watch(localeProvider.select((locale) => locale));
    final themeMode = ref.watch(themeModeProvider.select((mode) => mode));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isEditing = false;
                });
              },
            ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Profile not found'));
          }

          if (_fullNameController.text.isEmpty) {
            _initializeControllers(profile);
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(AppDimensions.paddingMedium),
            child: Column(
              children: [
                // Profile Header
                ProfileHeader(
                  name: profile.fullName,
                  email: profile.email,
                  cohort: profile.cohort,
                  imageUrl: profile.profileImage,
                  onImageTap: () {
                    // TODO: Implement image picker
                  },
                ),

                SizedBox(height: 24.h),

                // Profile Form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Taarifa Binafsi',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 16.h),
                      AppTextField(
                        label: l10n.fullName,
                        controller: _fullNameController,
                        enabled: _isEditing,
                        prefixIcon: const Icon(Icons.person_outline),
                        validator: (value) {
                          if (_isEditing && (value == null || value.isEmpty)) {
                            return 'This field is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      AppTextField(
                        label: l10n.email,
                        controller: _emailController,
                        enabled: _isEditing,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email_outlined),
                        validator: (value) {
                          if (_isEditing && (value == null || value.isEmpty)) {
                            return 'This field is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      AppTextField(
                        label: l10n.phoneNumber,
                        controller: _phoneController,
                        enabled: _isEditing,
                        keyboardType: TextInputType.phone,
                        prefixIcon: const Icon(Icons.phone_outlined),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        'Vipimo vya Mwili',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              label: '${l10n.height} (cm)',
                              controller: _heightController,
                              enabled: _isEditing,
                              keyboardType: TextInputType.number,
                              prefixIcon: const Icon(Icons.height),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: AppTextField(
                              label: '${l10n.targetWeight} (kg)',
                              controller: _targetWeightController,
                              enabled: _isEditing,
                              keyboardType: TextInputType.number,
                              prefixIcon:
                                  const Icon(Icons.monitor_weight_outlined),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                if (_isEditing) ...[
                  SizedBox(height: 32.h),
                  Consumer(
                    builder: (context, ref, child) {
                      final formState = ref.watch(profileFormNotifierProvider);
                      final formNotifier =
                          ref.read(profileFormNotifierProvider.notifier);

                      return Column(
                        children: [
                          AppButton(
                            text: l10n.save,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                formNotifier
                                    .updateFullName(_fullNameController.text);
                                formNotifier.updateEmail(_emailController.text);
                                formNotifier
                                    .updatePhoneNumber(_phoneController.text);
                                formNotifier
                                    .updateHeight(_heightController.text);
                                formNotifier.updateTargetWeight(
                                    _targetWeightController.text);

                                final success = await formNotifier.submit();
                                if (success && mounted) {
                                  setState(() {
                                    _isEditing = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.success),
                                      backgroundColor: AppColors.success,
                                    ),
                                  );
                                } else if (formState.errorMessage != null &&
                                    mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(formState.errorMessage!),
                                      backgroundColor: AppColors.error,
                                    ),
                                  );
                                }
                              }
                            },
                            isLoading: formState.isLoading,
                          ),
                          SizedBox(height: 12.h),
                          AppButton(
                            text: l10n.cancel,
                            onPressed: () {
                              setState(() {
                                _isEditing = false;
                              });
                              _initializeControllers(profile);
                            },
                            isOutlined: true,
                          ),
                        ],
                      );
                    },
                  ),
                ],

                SizedBox(height: 32.h),

                // Settings Section
                Text(
                  l10n.settings,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 16.h),

                Card(
                  child: Column(
                    children: [
                      SettingsTile(
                        icon: Icons.language,
                        title: l10n.language,
                        subtitle: locale.languageCode == 'sw'
                            ? l10n.swahili
                            : l10n.english,
                        onTap: () {
                          _showLanguageDialog(context);
                        },
                      ),
                      const Divider(height: 1),
                      SettingsTile(
                        icon: Icons.dark_mode_outlined,
                        title: l10n.darkMode,
                        trailing: Switch(
                          value: themeMode == ThemeMode.dark,
                          onChanged: (value) {
                            ref.read(themeModeProvider.notifier).setThemeMode(
                                  value ? ThemeMode.dark : ThemeMode.light,
                                );
                          },
                        ),
                      ),
                      const Divider(height: 1),
                      SettingsTile(
                        icon: Icons.notifications_outlined,
                        title: l10n.notifications,
                        onTap: () {
                          context.push(Routes.reminders);
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // Account Actions
                Card(
                  child: Column(
                    children: [
                      SettingsTile(
                        icon: Icons.privacy_tip_outlined,
                        title: l10n.privacyPolicy,
                        onTap: () {},
                      ),
                      const Divider(height: 1),
                      SettingsTile(
                        icon: Icons.description_outlined,
                        title: l10n.termsOfService,
                        onTap: () {},
                      ),
                      const Divider(height: 1),
                      SettingsTile(
                        icon: Icons.info_outline,
                        title: l10n.about,
                        subtitle: '${l10n.version} 1.0.0',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // Logout Button
                AppButton(
                  text: l10n.logout,
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(l10n.logout),
                        content: const Text('Una uhakika unataka kutoka?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(l10n.cancel),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text(l10n.logout),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true && mounted) {
                      await ref.read(authNotifierProvider.notifier).logout();
                      if (mounted) {
                        context.go(Routes.login);
                      }
                    }
                  },
                  backgroundColor: AppColors.error,
                  isOutlined: false,
                ),

                SizedBox(height: 32.h),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text(l10n.swahili),
              value: 'sw',
              groupValue: ref.read(localeProvider).languageCode,
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(localeProvider.notifier)
                      .setLocale(const Locale('sw', 'TZ'));
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: Text(l10n.english),
              value: 'en',
              groupValue: ref.read(localeProvider).languageCode,
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(localeProvider.notifier)
                      .setLocale(const Locale('en'));
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
