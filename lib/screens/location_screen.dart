import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qahwati/core/colors.dart';
import 'package:qahwati/core/helpers/spacing.dart';
import 'package:qahwati/core/theme/text_style.dart';
import 'package:qahwati/screens/verification_screen.dart';
import 'package:qahwati/widget/app_text_form_field.dart';
import 'package:qahwati/widget/main_button.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  List<String> _filtered = [];

  static const List<String> _allNeighborhoods = [
    'حي الروضة',
    'حي الزهراء',
    'حي النزهة',
    'حي الصفا',
    'حي الحمراء',
    'حي العزيزية',
    'حي الكندرة',
    'حي البغدادية',
    'حي الفيصلية',
    'حي الربوة',
    'حي مدائن الفهد',
    'حي الأندلس',
    'حي السلامة',
    'حي الشاطئ',
    'حي الواجهة البحرية',
    'حي التيسير',
    'حي الرحمانية',
    'حي السامر',
    'حي قويزة',
    'حي المروة',
    'حي الجوهرة',
    'حي البوادي',
    'حي الخالدية',
    'حي الوزيرية',
    'حي النعيم',
    'حي الرويس',
    'حي الجامعة',
    'حي العليا',
    'حي الحزام الذهبي',
    'حي أم السلم',
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(() => setState(() {}));
  }

  void _onTextChanged() {
    final query = _controller.text.trim();
    setState(() {
      _filtered = query.isEmpty
          ? []
          : _allNeighborhoods
              .where((n) => n.contains(query))
              .toList();
    });
  }

  void _selectNeighborhood(String name) {
    setState(() {
      _filtered = [];
      _controller.text = name;
    });
    _focusNode.unfocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLogoHeader(),
              _buildTitle(),
              verticalSpace(20),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      AppTextFormField(
                        hintText: 'ابحث عن الحي',
                        controller: _controller,
                        focusNode: _focusNode,
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(12.r),
                          child: Icon(Icons.location_on_outlined, color: ColorsManager.gray, size: 20.sp),
                        ),
                        suffixIcon: _controller.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.close_rounded, color: ColorsManager.gray, size: 18.sp),
                                onPressed: () {
                                  _controller.clear();
                                  setState(() => _filtered = []);
                                },
                              )
                            : null,
                        validator: (_) => null,
                      ),
                      // قائمة الاقتراحات
                      if (_filtered.isNotEmpty) ...[
                        verticalSpace(4),
                        Container(
                          constraints: BoxConstraints(maxHeight: 240.h),
                          decoration: BoxDecoration(
                            color: ColorsManager.textFormField,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: ColorsManager.coffeeButton.withValues(alpha: 0.15),
                              width: 0.8,
                            ),
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(vertical: 6.h),
                            itemCount: _filtered.length,
                            separatorBuilder: (context, index) => Divider(
                              height: 1,
                              indent: 16.w,
                              endIndent: 16.w,
                              color: ColorsManager.coffeeButton.withValues(alpha: 0.12),
                            ),
                            itemBuilder: (_, i) {
                              final name = _filtered[i];
                              return ListTile(
                                dense: true,
                                leading: Icon(Icons.location_on_rounded, color: ColorsManager.coffeeButton, size: 18.sp),
                                title: Text(name, style: TextStyles(context).font14BlackRegular),
                                onTap: () => _selectNeighborhood(name),
                              );
                            },
                          ),
                        ),
                      ],
                      // عرض كل الأحياء إذا الحقل فاضي وفي focus
                      if (_controller.text.isEmpty && _focusNode.hasFocus) ...[
                        verticalSpace(4),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: ColorsManager.textFormField,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: ColorsManager.coffeeButton.withValues(alpha: 0.15),
                                width: 0.8,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                                  child: Text(
                                    'أحياء جدة',
                                    style: TextStyles(context).font12GraykRegular.copyWith(
                                          color: ColorsManager.coffeeButton,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                                Divider(height: 1, color: ColorsManager.coffeeButton.withValues(alpha: 0.12)),
                                Expanded(
                                  child: ListView.separated(
                                    padding: EdgeInsets.symmetric(vertical: 4.h),
                                    itemCount: _allNeighborhoods.length,
                                    separatorBuilder: (context, index) => Divider(
                                      height: 1,
                                      indent: 16.w,
                                      endIndent: 16.w,
                                      color: ColorsManager.coffeeButton.withValues(alpha: 0.12),
                                    ),
                                    itemBuilder: (_, i) {
                                      final name = _allNeighborhoods[i];
                                      return ListTile(
                                        dense: true,
                                        leading: Icon(Icons.location_on_rounded, color: ColorsManager.coffeeButton, size: 18.sp),
                                        title: Text(name, style: TextStyles(context).font14BlackRegular),
                                        onTap: () => _selectNeighborhood(name),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              _buildBottomButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoHeader() {
    return Padding(
      padding: EdgeInsets.only(top: 24.h, bottom: 16.h),
      child: Center(child: SvgPicture.asset('img/logo.svg', height: 64.h)),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Text('الحي', style: TextStyles(context).font16DarkBold),
    );
  }

  Widget _buildBottomButtons() {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 28.h),
      child: Row(
        children: [
          Expanded(
            child: MainButton(
              text: 'التالي',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const VerificationScreen()),
              ),
            ),
          ),
          horizontalSpace(12),
          Expanded(
            child: MainButton(
              text: 'السابق',
              outlined: true,
              onTap: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
