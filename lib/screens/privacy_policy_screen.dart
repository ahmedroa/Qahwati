import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qahwati/core/colors.dart';
import 'package:qahwati/core/helpers/spacing.dart';
import 'package:qahwati/core/theme/text_style.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.screenBackground,
      appBar: AppBar(
        backgroundColor: ColorsManager.screenBackground,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'سياسة الخصوصية',
          style: TextStyles(context).font16DarkBold,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ColorsManager.coffeeButton,
            size: 20.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLastUpdated(context),
              verticalSpace(20),
              _buildIntro(context),
              verticalSpace(24),
              _buildSection(
                context,
                icon: Icons.info_outline_rounded,
                title: 'عن تطبيق قهوتي',
                body:
                    'قهوتي هو تطبيق مخصص لمحبي القهوة في جدة، يساعدك على اكتشاف أقرب المقاهي إليك، عرض قوائمها، وتقييم تجربتك. نحرص على تقديم تجربة شخصية وآمنة لكل مستخدم.',
              ),
              verticalSpace(20),
              _buildSection(
                context,
                icon: Icons.person_outline_rounded,
                title: 'البيانات التي نجمعها',
                body:
                    '• الاسم والبريد الإلكتروني عند إنشاء الحساب.\n• موقعك الجغرافي لعرض المقاهي القريبة منك.\n• تفضيلاتك وتقييماتك داخل التطبيق.\n• بيانات الجهاز مثل نوع النظام والإصدار لأغراض تقنية.',
              ),
              verticalSpace(20),
              _buildSection(
                context,
                icon: Icons.location_on_outlined,
                title: 'استخدام الموقع الجغرافي',
                body:
                    'نستخدم موقعك لعرض المقاهي القريبة منك فقط. لا نشارك موقعك مع أي جهة خارجية ولا نحتفظ بسجل مواقعك التاريخية. يمكنك إلغاء الإذن في أي وقت من إعدادات جهازك.',
              ),
              verticalSpace(20),
              _buildSection(
                context,
                icon: Icons.lock_outline_rounded,
                title: 'كيف نحمي بياناتك',
                body:
                    'نستخدم Firebase من Google لتخزين بياناتك بشكل آمن ومشفر. لا يمكن لأي طرف ثالث الوصول إلى حسابك أو بياناتك الشخصية بدون إذنك.',
              ),
              verticalSpace(20),
              _buildSection(
                context,
                icon: Icons.share_outlined,
                title: 'مشاركة البيانات',
                body:
                    'لا نبيع بياناتك ولا نشاركها مع أي جهة إعلانية. قد نشارك بيانات مجهولة الهوية وغير قابلة للتعريف لأغراض إحصائية فقط لتحسين التطبيق.',
              ),
              verticalSpace(20),
              _buildSection(
                context,
                icon: Icons.manage_accounts_outlined,
                title: 'حقوقك',
                body:
                    '• يمكنك طلب حذف حسابك وجميع بياناتك في أي وقت.\n• يمكنك تعديل معلوماتك الشخصية من داخل التطبيق.\n• يمكنك إلغاء إذن الموقع من إعدادات جهازك دون التأثير على باقي خدمات التطبيق.',
              ),
              verticalSpace(20),
              _buildSection(
                context,
                icon: Icons.child_care_outlined,
                title: 'الفئة العمرية',
                body:
                    'تطبيق قهوتي مخصص للمستخدمين الذين تبلغ أعمارهم 13 عاماً أو أكثر. إذا علمنا أن مستخدماً دون هذا العمر قد أنشأ حساباً، سنحذف بياناته فوراً.',
              ),
              verticalSpace(20),
              _buildSection(
                context,
                icon: Icons.update_rounded,
                title: 'تحديثات السياسة',
                body:
                    'قد نحدث هذه السياسة من وقت لآخر. سنُعلمك بأي تغييرات جوهرية عبر إشعار داخل التطبيق. استمرارك في استخدام التطبيق بعد التحديث يعني موافقتك على السياسة الجديدة.',
              ),
              verticalSpace(20),
              _buildSection(
                context,
                icon: Icons.mail_outline_rounded,
                title: 'تواصل معنا',
                body:
                    'إذا كانت لديك أي أسئلة أو استفسارات بخصوص سياسة الخصوصية، يمكنك التواصل معنا عبر:\nالبريد الإلكتروني: support@qahwati.com',
              ),
              verticalSpace(40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLastUpdated(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: ColorsManager.coffeeButton.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          'آخر تحديث: مايو 2026',
          style: TextStyles(context).font12GraykRegular.copyWith(
                color: ColorsManager.coffeeButton,
              ),
        ),
      ),
    );
  }

  Widget _buildIntro(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: ColorsManager.coffeeButton.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: ColorsManager.coffeeButton.withValues(alpha: 0.15),
          width: 0.8,
        ),
      ),
      child: Text(
        'نحن في قهوتي نحترم خصوصيتك ونلتزم بحماية بياناتك. توضح هذه السياسة كيفية جمع معلوماتك واستخدامها وحمايتها أثناء استخدامك للتطبيق.',
        style: TextStyles(context).font14BlackRegular.copyWith(
              height: 1.7,
              color: ColorsManager.coffeeButton,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String body,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: ColorsManager.coffeeButton.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: ColorsManager.coffeeButton, size: 18.sp),
            ),
            horizontalSpace(10),
            Text(
              title,
              style: TextStyles(context).font14BlackRegular.copyWith(
                    fontWeight: FontWeight.w700,
                    color: ColorsManager.coffeeButton,
                  ),
            ),
          ],
        ),
        verticalSpace(10),
        Text(
          body,
          style: TextStyles(context).font14BlackRegular.copyWith(
                height: 1.8,
                color: const Color(0xff4A4A4A),
              ),
        ),
        verticalSpace(8),
        Divider(
          color: ColorsManager.coffeeButton.withValues(alpha: 0.1),
          thickness: 0.8,
        ),
      ],
    );
  }
}
