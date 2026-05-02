import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qahwati/core/colors.dart';
import 'package:qahwati/core/helpers/spacing.dart';
import 'package:qahwati/core/theme/text_style.dart';
import 'package:qahwati/login.dart';
import 'package:qahwati/screens/location_screen.dart';
import 'package:qahwati/widget/app_text_form_field.dart';
import 'package:qahwati/widget/main_button.dart';

class Registr extends StatefulWidget {
  const Registr({super.key});

  @override
  State<Registr> createState() => _RegistrState();
}

class _RegistrState extends State<Registr> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
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
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpace(28),
                Center(child: SvgPicture.asset('img/logo.svg', height: 72.h)),
                verticalSpace(32),
                _buildLabeledField(
                  'اسم المستخدم',
                  hintText: 'أدخل اسم المستخدم',
                  controller: _nameController,
                  prefixIcon: Icon(
                    Icons.person_outline_rounded,
                    color: ColorsManager.gray,
                    size: 18.sp,
                  ),
                ),
                verticalSpace(14),
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
                  isObscure: true,
                  prefixIcon: Icon(
                    Icons.lock_outline_rounded,
                    color: ColorsManager.gray,
                    size: 18.sp,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    child: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: ColorsManager.gray,
                      size: 18.sp,
                    ),
                  ),
                ),
                verticalSpace(32),
                MainButton(
                  text: _isLoading ? '' : 'إضافة الحساب',
                  onTap: _isLoading ? null : _register,
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
                verticalSpace(20),
                _buildSocialButtons(),
                verticalSpace(32),
              ],
            ),
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
          ).font12GraykRegular.copyWith(color: Color(0xff8C503A)),
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

          // helperText: ,
          // prefixText: '05',
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
                MaterialPageRoute(builder: (_) => const Login()),
              );
            },
            child: Text(
              'تسجيل الدخول',
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
        Center(
          child: Text(
            'يمكنك إستخدام',
            style: TextStyles(
              context,
            ).font14GrayRegular.copyWith(color: ColorsManager.coffeeButton),
          ),
        ),
      ],
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

  Future<void> _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showError('يرجى تعبئة جميع الحقول');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set({
        'uid': credential.user!.uid,
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await credential.user!.updateDisplayName(name);

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
      case 'email-already-in-use':
        return 'البريد الإلكتروني مستخدم بالفعل';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صحيح';
      case 'weak-password':
        return 'كلمة المرور ضعيفة، استخدم 6 أحرف أو أكثر';
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
