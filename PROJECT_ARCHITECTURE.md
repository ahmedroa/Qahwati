# UI Guide — How to Write UI Code in This Project

> **Purpose:** This document explains exactly how to write UI screens and widgets in this project.  
> Every AI assistant must follow these rules when building any screen or widget.  
> Do NOT use raw colors, raw font sizes, or raw spacing — always use the project's design system.

---

## 1. Design System — The 4 Rules

### Rule 1 — Colors → always use `ColorsManager`

```dart
import 'package:erp/core/theme/colors.dart';

// ✅ Correct
ColorsManager.kPrimaryColor      // main teal color #38B2AC
ColorsManager.dark               // dark text color #2F2F2F
ColorsManager.gray               // secondary text #A2A2A2
ColorsManager.backgroundColor    // screen background #F7F7F7
ColorsManager.containerColor     // card background #F5F5F5
ColorsManager.grayBorder         // border color #D9D9D9
ColorsManager.white              // white #F5F5F5
ColorsManager.red                // error red #C71919
ColorsManager.green              // success green #8ABD80
ColorsManager.yellow             // warning yellow #E3C153

// ❌ Never write raw colors
Color(0xFF38B2AC)
Colors.grey
Colors.black
```

---

### Rule 2 — Text Styles → always use `TextStyles(context).fontXXColorWeight`

```dart
import 'package:erp/core/theme/text_style.dart';

// Pattern: font{size}{color}{weight}
TextStyles(context).font16BlackRegular   // 16sp, dark color, regular
TextStyles(context).font14GrayRegular    // 14sp, gray color, regular
TextStyles(context).font14BlackRegular   // 14sp, dark color, regular
TextStyles(context).font16DarkBold       // 16sp, dark color, bold
TextStyles(context).font14PrimaryRegular // 14sp, primary teal, regular
TextStyles(context).font14WhiteRegular   // 14sp, white, regular
TextStyles(context).font12GraykRegular   // 12sp, gray, regular
TextStyles(context).font18BlackMedium    // 18sp, dark, medium
TextStyles(context).font20DarkBold       // 20sp, dark, bold

// To customize one property only → use .copyWith()
TextStyles(context).font14BlackRegular.copyWith(color: Colors.red)
TextStyles(context).font16DarkBold.copyWith(fontSize: 18.sp)
```

---

### Rule 3 — Spacing → always use `verticalSpace()` and `horizontalSpace()`

```dart
import 'package:erp/core/helpers/spacing.dart';

verticalSpace(8)    // SizedBox(height: 8.h)
verticalSpace(16)   // SizedBox(height: 16.h)
verticalSpace(24)   // SizedBox(height: 24.h)

horizontalSpace(8)  // SizedBox(width: 8.w)
horizontalSpace(12) // SizedBox(width: 12.w)

// ❌ Never write
SizedBox(height: 16)
SizedBox(width: 12)
const SizedBox(height: 8)
```

---

### Rule 4 — Responsive sizing → always use `flutter_screenutil`

```dart
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Sizes
16.h          // responsive height
16.w          // responsive width
16.r          // responsive radius (BorderRadius)
16.sp         // responsive font size (only inside TextStyle)

// ❌ Never write raw numbers in sizing
BorderRadius.circular(16)     // wrong
EdgeInsets.all(16)            // wrong (unless truly fixed)
EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h)  // correct
```

---

## 2. Screen Template

Every screen follows this exact structure:

```dart
import 'package:erp/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class [FeatureName]Screen extends StatelessWidget {
  const [FeatureName]Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)![featureName]),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // content widgets here
          ],
        ),
      ),
    );
  }
}
```

**Rules:**
- Always `StatelessWidget` unless state is truly local (like a checkbox toggle)
- AppBar title always uses `S.of(context)!.key` — never hardcoded strings
- Body always has `horizontal: 16` padding
- Split UI into small private methods `_buildXxx()` or separate widget files

---

## 3. Card / List Item Template

The standard card used across all list screens:

```dart
Widget _build[FeatureName]Item(BuildContext context, [FeatureName]Data item) {
  return Container(
    width: double.infinity,
    margin: EdgeInsets.only(bottom: 12.h),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: InkWell(
      onTap: () {
        // navigate to details if needed
        // Navigator.pushNamed(context, Routes.details[FeatureName], arguments: item);
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: icon or image
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: ColorsManager.kPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Icons.label, color: ColorsManager.kPrimaryColor, size: 24.sp),
            ),
            horizontalSpace(12),

            // Center: main info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name ?? S.of(context)!.notAvailable,
                    style: TextStyles(context).font16DarkBold,
                  ),
                  verticalSpace(4),
                  Text(
                    item.subtitle ?? S.of(context)!.notAvailable,
                    style: TextStyles(context).font14GrayRegular,
                  ),
                ],
              ),
            ),

            // Right: status badge or date
            Container(
              decoration: BoxDecoration(
                color: ColorsManager.kPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: ColorsManager.kPrimaryColor, width: 0.99),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              child: Text(
                item.status ?? S.of(context)!.undefined,
                style: TextStyles(context).font12GraykRegular,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
```

---

## 4. Details Screen Template

Used when showing full details of a single item:

```dart
import 'package:erp/core/helpers/spacing.dart';
import 'package:erp/core/widgets/BuildLine_and_title.dart';
import 'package:erp/features/setting/ui/widgets/profile/title_and_subtitle.dart';
import 'package:erp/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class Details[FeatureName]Screen extends StatelessWidget {
  final [FeatureName]Data item;
  const Details[FeatureName]Screen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.name ?? '')),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Column(
          children: [
            // Section header with line
            BuildlineAndTitle(title: S.of(context)!.sectionTitle),
            verticalSpace(16),

            // Row: label on left, value on right
            TitleAndSubTitle(title: S.of(context)!.fieldLabel, subTitle: item.fieldValue ?? ''),
            TitleAndSubTitle(title: S.of(context)!.anotherLabel, subTitle: item.anotherValue ?? ''),

            verticalSpace(16),
            BuildlineAndTitle(title: S.of(context)!.anotherSection),
            verticalSpace(16),
            TitleAndSubTitle(title: S.of(context)!.moreLabel, subTitle: item.moreValue ?? ''),
          ],
        ),
      ),
    );
  }
}
```

**Shared widgets used in details screens:**

| Widget | Purpose | Usage |
|---|---|---|
| `BuildlineAndTitle(title: '...')` | Section header with gradient line | Group related fields |
| `TitleAndSubTitle(title: '...', subTitle: '...')` | Label + value row | Every data field |

---

## 5. Shared Core Widgets — Use, Never Recreate

These widgets already exist in `core/widgets/`. Always use them:

### `AppTextFormField` — for all text inputs

```dart
import 'package:erp/core/widgets/app_text_form_field.dart';

AppTextFormField(
  hintText: S.of(context)!.email,
  title: S.of(context)!.email,        // optional label above input
  controller: cubit.emailController,
  keyboardType: TextInputType.emailAddress,
  prefixIcon: Icon(Icons.email, color: ColorsManager.gray),
  suffixIcon: ...,                     // optional
  validator: (value) {
    if (value == null || value.isEmpty) return S.of(context)!.pleaseEnterEmail;
    return null;
  },
)
```

### `MainButton` — for primary action buttons

```dart
import 'package:erp/core/widgets/main_button.dart';

MainButton(
  text: S.of(context)!.signIn,
  onTap: () => cubit.validateThenLogin(),
  // optional overrides:
  // width: 150.w,
  // height: 48,
  // color: ColorsManager.kPrimaryColor,
)
```

### `ErrorGetData` — for error state with retry

```dart
import 'package:erp/core/widgets/error_get_gata.dart';

ErrorGetData(
  errorMessage: message,
  onRetry: () => context.read<[FeatureName]Cubit>().get[FeatureName](),
)
```

### `NoDataWidget` — for empty list state

```dart
import 'package:erp/core/widgets/no_data.dart';

NoDataWidget()
```

### `BuildlineAndTitle` — section separator with title

```dart
import 'package:erp/core/widgets/BuildLine_and_title.dart';

BuildlineAndTitle(title: S.of(context)!.sectionTitle)
```

### `TitleAndSubTitle` — label + value row

```dart
import 'package:erp/features/setting/ui/widgets/profile/title_and_subtitle.dart';

TitleAndSubTitle(
  title: S.of(context)!.fieldLabel,
  subTitle: item.value ?? '',
)
```

---

## 6. BlocBuilder Pattern — The 4 States

Every screen that loads data must handle all 4 states:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erp/features/rewards/ui/widgets/rewards_shimmer_list.dart'; // reuse shimmer

BlocBuilder<[FeatureName]Cubit, [FeatureName]State>(
  builder: (context, state) {
    return state.when(
      initial: () => const RewardsShimmerList(),   // show skeleton while waiting
      loading: () => const RewardsShimmerList(),   // show skeleton while loading
      success: (model) {
        final items = model.data;
        if (items == null || items.isEmpty) {
          return const NoDataWidget();             // empty list
        }
        return [FeatureName]List(items: items);    // show list
      },
      error: (message) => ErrorGetData(
        errorMessage: message,
        onRetry: () => context.read<[FeatureName]Cubit>().get[FeatureName](),
      ),
    );
  },
)
```

**Rules:**
- `initial` and `loading` → show `RewardsShimmerList()` (skeleton loading)
- `success` with empty data → show `NoDataWidget()`
- `success` with data → show the list widget
- `error` → show `ErrorGetData` with a retry callback
- Always wrap the `BlocBuilder` in `Expanded` when inside a `Column`

---

## 7. ListView Pattern

```dart
class [FeatureName]List extends StatelessWidget {
  final List<[FeatureName]Data> items;
  const [FeatureName]List({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _build[FeatureName]Item(context, items[index]);
      },
    );
  }

  Widget _build[FeatureName]Item(BuildContext context, [FeatureName]Data item) {
    // use card template from Section 3
  }
}
```

---

## 8. Text — Rules

```dart
// ✅ Always use localization
Text(S.of(context)!.someKey, style: TextStyles(context).font16BlackRegular)

// ✅ Fallback for nullable API values
Text(item.name ?? S.of(context)!.notAvailable, style: TextStyles(context).font14GrayRegular)

// ✅ Fallback with empty string for non-critical fields
Text(item.code ?? '', style: TextStyles(context).font12GraykRegular)

// ❌ Never hardcode user-facing strings
Text('No data found', ...)
Text('Loading...', ...)
```

---

## 9. Padding — Standard Values

```dart
// Screen body padding (horizontal only)
Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: ...)

// Screen body padding (with top)
Padding(padding: const EdgeInsets.only(left: 16, right: 16, top: 16), child: ...)

// Card inner padding
Padding(padding: const EdgeInsets.all(12.0), child: ...)

// Between list items (use margin on the card container)
margin: EdgeInsets.only(bottom: 12.h)
```

---

## 10. Navigation

```dart
import 'package:erp/core/extensions/navigation.dart';
import 'package:erp/core/routing/routes.dart';

// Push new screen
context.pushNamed(Routes.[featureName])

// Push with arguments (for details screen)
context.pushNamed(Routes.details[FeatureName], arguments: item)

// Replace current screen
context.pushReplacementNamed(Routes.[featureName])

// Go back
context.pop()
```

---

## 11. Localization in UI

```dart
// Always import
import 'package:erp/generated/l10n/app_localizations.dart';

// Usage
S.of(context)!.signIn
S.of(context)!.noData
S.of(context)!.retry
S.of(context)!.notAvailable
S.of(context)!.undefined
S.of(context)!.goBack
```

Add every new string to both:
- `lib/l10n/intl_en.arb` — English
- `lib/l10n/intl_ar.arb` — Arabic

---

## 12. UI Rules Summary for AI

1. **Colors** → `ColorsManager.xxx` — never raw hex or `Colors.grey`
2. **Text styles** → `TextStyles(context).fontXXColorWeight` — never raw `TextStyle(...)`
3. **Spacing** → `verticalSpace(n)` / `horizontalSpace(n)` — never `SizedBox(height: n)`
4. **Sizes** → always `.h`, `.w`, `.r`, `.sp` from `flutter_screenutil`
5. **Strings** → always `S.of(context)!.key` — never hardcoded text
6. **Nullable API fields** → always provide a fallback with `?? S.of(context)!.notAvailable`
7. **BlocBuilder** → always handle all 4 states: initial, loading, success, error
8. **Existing widgets** → use `AppTextFormField`, `MainButton`, `ErrorGetData`, `NoDataWidget`, `BuildlineAndTitle`, `TitleAndSubTitle` — never recreate them
9. **Widget decomposition** → break large `build()` methods into `_buildXxx()` private methods or separate widget files
10. **StatelessWidget** → use by default; only use `StatefulWidget` when local UI state is truly needed (e.g., tab index, checkbox)
