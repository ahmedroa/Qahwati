import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qahwati/core/colors.dart';
import 'package:qahwati/core/helpers/spacing.dart';
import 'package:qahwati/core/theme/text_style.dart';
import 'package:qahwati/registr.dart';
import 'package:qahwati/screens/location_screen.dart';
import 'package:qahwati/screens/privacy_policy_screen.dart';
import 'package:qahwati/widget/app_text_form_field.dart';
import 'package:qahwati/widget/main_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.screenBackground,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      verticalSpace(28),
                      Center(
                        child: SvgPicture.asset('img/logo.svg', height: 72.h),
                      ),
                      verticalSpace(32),
                      _buildLabeledField(
                        'البريد الإلكتروني أو الهاتف',
                        hintText: 'أدخل البريد أو رقم الهاتف',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: ColorsManager.gray,
                          size: 18.sp,
                        ),
                      ),
                      verticalSpace(14),
                      _buildLabeledField(
                        'كلمة المرور',
                        hintText: 'أدخل كلمة المرور',
                        controller: _passwordController,
                        isObscure: _obscurePassword,
                        prefixIcon: Icon(
                          Icons.lock_outline_rounded,
                          color: ColorsManager.gray,
                          size: 18.sp,
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          child: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: ColorsManager.gray,
                            size: 18.sp,
                          ),
                        ),
                      ),
                      verticalSpace(10),

                      // Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: GestureDetector(
                      //     onTap: () {},
                      //     child: Text(
                      //       'نسيت كلمة المرور؟',
                      //       style:
                      //           TextStyles(context).font12GraykRegular.copyWith(
                      //                 color: ColorsManager.coffeeButton,
                      //               ),
                      //     ),
                      //   ),
                      // ),
                      verticalSpace(32),
                      MainButton(
                        text: _isLoading ? '' : 'تسجيل الدخول',
                        onTap: _isLoading ? null : _login,
                        color: ColorsManager.coffeeButton,
                        child: _isLoading
                            ? SizedBox(
                                height: 22.h,
                                width: 22.h,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : null,
                      ),
                      verticalSpace(20),
                      _buildDividerSection(),
                      verticalSpace(16),
                    ],
                  ),
                ),
              ),
              _buildTermsText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledField(
    String label, {
    required String hintText,
    TextEditingController? controller,
    bool isObscure = false,
    Widget? suffixIcon,
    Widget? prefixIcon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyles(
            context,
          ).font12GraykRegular.copyWith(color: const Color(0xff8C503A)),
        ),
        verticalSpace(6),
        AppTextFormField(
          hintText: hintText,
          controller: controller,
          isObscureText: isObscure,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          keyboardType: keyboardType,
          validator: (_) => null,
        ),
      ],
    );
  }

  Widget _buildDividerSection() {
    return Column(
      children: [
        Center(
          child: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const Registr()),
              );
            },
            child: Text(
              'إنشاء حساب جديد',
              style: TextStyles(
                context,
              ).font14GrayRegular.copyWith(color: ColorsManager.coffeeButton),
            ),
          ),
        ),
        verticalSpace(16),
        Row(
          children: [
            Expanded(
              child: Divider(color: ColorsManager.coffeeButton, thickness: 0.2),
            ),
          ],
        ),
        verticalSpace(16),
        MainButton(
          text: 'الدخول كزائر',
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LocationScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTermsText() {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h, top: 8.h),
      child: RichText(
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        text: TextSpan(
          style: TextStyles(
            context,
          ).font12GraykRegular.copyWith(color: ColorsManager.gray),
          children: [
            const TextSpan(text: 'باستخدامك التطبيق، أنت توافق على '),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PrivacyPolicyScreen(),
                  ),
                ),
                child: Text(
                  'سياسة الخصوصية',
                  style: TextStyles(context).font12GraykRegular.copyWith(
                    color: ColorsManager.coffeeButton,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    decorationColor: ColorsManager.coffeeButton,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialIconButton(
          onTap: () {},
          bgColor: Colors.white,
          borderColor: ColorsManager.grayBorder,
          child: SvgPicture.asset('img/google.svg', height: 26.h),
        ),
        horizontalSpace(16),
        _SocialIconButton(
          onTap: () {},
          bgColor: Colors.black,
          borderColor: Colors.black,
          child: Icon(Icons.apple, size: 26.sp, color: Colors.white),
        ),
      ],
    );
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError('يرجى تعبئة جميع الحقول');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LocationScreen()),
      );
    } on FirebaseAuthException catch (e) {
      _showError(_authErrorMessage(e.code));
    } catch (_) {
      _showError('حدث خطأ، حاول مجدداً');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _authErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
      case 'invalid-credential':
        return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صحيح';
      case 'user-disabled':
        return 'هذا الحساب موقوف';
      case 'too-many-requests':
        return 'محاولات كثيرة، حاول لاحقاً';
      default:
        return 'حدث خطأ، حاول مجدداً';
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        backgroundColor: ColorsManager.coffeeButton,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      ),
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color bgColor;
  final Color borderColor;

  const _SocialIconButton({
    required this.child,
    required this.onTap,
    required this.bgColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52.w,
        height: 52.h,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: 1),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
