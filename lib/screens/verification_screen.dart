import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qahwati/core/colors.dart';
import 'package:qahwati/core/helpers/spacing.dart';
import 'package:qahwati/core/theme/text_style.dart';
import 'package:qahwati/screens/map_screen.dart';
import 'package:qahwati/widget/main_button.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late final AnimationController _animCtrl;
  late final Animation<double> _sizeFactor;
  late final Animation<double> _fadeAnim;

  final List<_Criterion> _criteria = [
    _Criterion(
      label: 'السعر',
      hint: 'حدد نطاق السعر',
      options: [
        'حتى ٣٠,٠٠٠ ريال',
        '٣٠,٠٠٠ - ٤٥,٠٠٠ ريال',
        '٤٥,٠٠٠ - ٦٠,٠٠٠ ريال',
        '٦٠,٠٠٠ - ٨٠,٠٠٠ ريال',
        'أكثر من ٨٠,٠٠٠ ريال',
      ],
    ),
    _Criterion(
      label: 'الطرق',
      hint: 'اختر نوع الطريق',
      options: ['تجاري', 'رئيسي', 'خدمات', 'داخلي', 'سريع'],
    ),
    _Criterion(
      label: 'المباني',
      hint: 'اختر نوع المبنى',
      options: ['سكني', 'تجاري', 'صحي', 'منشأة عمل', 'ترفيهي'],
    ),
  ];

  late final List<Set<String>> _selections;

  @override
  void initState() {
    super.initState();
    _selections = List.generate(_criteria.length, (_) => {});
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _sizeFactor = CurvedAnimation(
      parent: _animCtrl,
      curve: Curves.easeInOutCubic,
    );
    _fadeAnim = CurvedAnimation(
      parent: _animCtrl,
      curve: const Interval(0.2, 1.0, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() => _isExpanded = !_isExpanded);
    if (_isExpanded) {
      _animCtrl.forward();
    } else {
      _animCtrl.reverse();
    }
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text('المعايير', style: TextStyles(context).font16DarkBold),
              ),
              verticalSpace(12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: _buildAccordion(),
              ),
              const Spacer(),
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

  Widget _buildAccordion() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: ColorsManager.coffeeButton.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          children: [
            _buildAccordionHeader(),
            SizeTransition(
              sizeFactor: _sizeFactor,
              axisAlignment: -1,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    Divider(
                      height: 1,
                      thickness: 0.8,
                      color: ColorsManager.coffeeButton.withValues(alpha: 0.2),
                    ),
                    ...List.generate(_criteria.length, (i) => _buildCriterionRow(i)),
                    verticalSpace(4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccordionHeader() {
    return GestureDetector(
      onTap: _toggleExpanded,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.tune_rounded, color: ColorsManager.coffeeButton, size: 18.sp),
                horizontalSpace(8),
                Text(
                  'حدد طلبك',
                  style: TextStyles(context).font14BlackRegular.copyWith(
                        color: ColorsManager.coffeeButton,
                      ),
                ),
              ],
            ),
            RotationTransition(
              turns: Tween(begin: 0.0, end: 0.5).animate(_sizeFactor),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: ColorsManager.coffeeButton,
                size: 22.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCriterionRow(int index) {
    final criterion = _criteria[index];
    final selected = _selections[index];
    final displayText = selected.isEmpty ? criterion.hint : selected.join('، ');

    return GestureDetector(
      onTap: () => _showOptionsSheet(index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 90.w,
              child: Text(
                criterion.label,
                style: TextStyles(context).font14GrayRegular.copyWith(
                      color: ColorsManager.coffeeButton,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.right,
              ),
            ),
            horizontalSpace(12),
            Expanded(
              child: Container(
                height: 38.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: ColorsManager.coffeeButton.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                alignment: Alignment.centerRight,
                child: Text(
                  displayText,
                  style: TextStyles(context).font12GraykRegular.copyWith(
                        color: selected.isEmpty
                            ? ColorsManager.gray
                            : ColorsManager.dark,
                      ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionsSheet(int index) {
    final criterion = _criteria[index];
    // نسخة مؤقتة للاختيارات داخل الـ sheet
    final tempSelected = Set<String>.from(_selections[index]);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              verticalSpace(12),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: ColorsManager.grayBorder,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              verticalSpace(4),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Row(
                  children: [
                    Text(criterion.label, style: TextStyles(context).font16DarkBold),
                    const Spacer(),
                    if (tempSelected.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          setSheetState(() => tempSelected.clear());
                        },
                        child: Text(
                          'مسح الكل',
                          style: TextStyles(context).font12GraykRegular.copyWith(
                                color: ColorsManager.coffeeButton,
                              ),
                        ),
                      ),
                  ],
                ),
              ),
              Divider(height: 1, color: ColorsManager.grayBorder),
              ...criterion.options.map(
                (option) => CheckboxListTile(
                  value: tempSelected.contains(option),
                  onChanged: (val) {
                    setSheetState(() {
                      if (val == true) {
                        tempSelected.add(option);
                      } else {
                        tempSelected.remove(option);
                      }
                    });
                  },
                  title: Text(option, style: TextStyles(context).font14BlackRegular),
                  activeColor: ColorsManager.coffeeButton,
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
                child: MainButton(
                  text: 'تأكيد',
                  height: 48,
                  onTap: () {
                    setState(() => _selections[index] = tempSelected);
                    Navigator.pop(ctx);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
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
                MaterialPageRoute(builder: (_) => const MapScreen()),
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

class _Criterion {
  final String label;
  final String hint;
  final List<String> options;

  const _Criterion({
    required this.label,
    required this.hint,
    required this.options,
  });
}
