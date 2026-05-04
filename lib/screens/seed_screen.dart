import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qahwati/core/colors.dart';
import 'package:qahwati/core/helpers/spacing.dart';
import 'package:qahwati/core/theme/text_style.dart';
import 'package:qahwati/widget/main_button.dart';

class SeedScreen extends StatefulWidget {
  const SeedScreen({super.key});

  @override
  State<SeedScreen> createState() => _SeedScreenState();
}

class _SeedScreenState extends State<SeedScreen> {
  bool _isLoading = false;
  String? _statusMessage;
  bool _isSuccess = false;

  static const List<Map<String, dynamic>> _seedPlaces = [
    // ───── حتى ٣٠,٠٠٠ ريال (10 أماكن) ─────
    {
      'name': 'قهوتي مكسبي - حي النزهة',
      'address': 'شارع التحلية، حي النزهة',
      'lat': 21.4692, 'lng': 39.1938,
      'rating': 4.9, 'openNow': false,
      'workingHours': '٨ص - ١٢م', 'seatingCapacity': '٣٠',
      'features': ['واي فاي مجاني', 'موقف سيارات', 'جلسات خارجية', 'نقاط مضاعفة'],
      'priceRange': 'حتى ٣٠,٠٠٠ ريال', 'roadType': 'داخلي', 'buildingType': 'سكني',
    },
    {
      'name': 'قهوتي مكسبي - حي المروة',
      'address': 'شارع الستين، حي المروة',
      'lat': 21.4567, 'lng': 39.1823,
      'rating': 4.3, 'openNow': true,
      'workingHours': '٧ص - ١٠م', 'seatingCapacity': '٢٠',
      'features': ['واي فاي مجاني', 'خالٍ من التدخين'],
      'priceRange': 'حتى ٣٠,٠٠٠ ريال', 'roadType': 'داخلي', 'buildingType': 'سكني',
    },
    {
      'name': 'قهوتي مكسبي - حي النعيم',
      'address': 'شارع الوادي، حي النعيم',
      'lat': 21.4456, 'lng': 39.2287,
      'rating': 4.1, 'openNow': true,
      'workingHours': '٦ص - ١١م', 'seatingCapacity': '٢٥',
      'features': ['واي فاي مجاني', 'توصيل'],
      'priceRange': 'حتى ٣٠,٠٠٠ ريال', 'roadType': 'خدمات', 'buildingType': 'سكني',
    },
    {
      'name': 'قهوتي مكسبي - حي التيسير',
      'address': 'شارع المدينة المنورة، حي التيسير',
      'lat': 21.4389, 'lng': 39.2198,
      'rating': 4.2, 'openNow': false,
      'workingHours': '٨ص - ١١م', 'seatingCapacity': '٢٢',
      'features': ['خالٍ من التدخين', 'خدمة ذاتية'],
      'priceRange': 'حتى ٣٠,٠٠٠ ريال', 'roadType': 'داخلي', 'buildingType': 'سكني',
    },
    {
      'name': 'قهوتي مكسبي - حي الرحمانية',
      'address': 'شارع العروبة، حي الرحمانية',
      'lat': 21.5034, 'lng': 39.1512,
      'rating': 4.4, 'openNow': true,
      'workingHours': '٧ص - ١٢م', 'seatingCapacity': '٢٨',
      'features': ['واي فاي مجاني', 'توصيل', 'خالٍ من التدخين'],
      'priceRange': 'حتى ٣٠,٠٠٠ ريال', 'roadType': 'داخلي', 'buildingType': 'تجاري',
    },
    {
      'name': 'قهوتي مكسبي - حي قويزة',
      'address': 'شارع الأمير نايف، حي قويزة',
      'lat': 21.4623, 'lng': 39.2105,
      'rating': 4.0, 'openNow': true,
      'workingHours': '٨ص - ١٠م', 'seatingCapacity': '١٨',
      'features': ['واي فاي مجاني'],
      'priceRange': 'حتى ٣٠,٠٠٠ ريال', 'roadType': 'داخلي', 'buildingType': 'سكني',
    },
    {
      'name': 'قهوتي مكسبي - حي الوزيرية',
      'address': 'شارع المظالم، حي الوزيرية',
      'lat': 21.4712, 'lng': 39.2134,
      'rating': 4.2, 'openNow': false,
      'workingHours': '٩ص - ١٢م', 'seatingCapacity': '٢٠',
      'features': ['مكيف', 'خالٍ من التدخين'],
      'priceRange': 'حتى ٣٠,٠٠٠ ريال', 'roadType': 'خدمات', 'buildingType': 'سكني',
    },
    {
      'name': 'قهوتي مكسبي - حي البوادي',
      'address': 'شارع الأمين، حي البوادي',
      'lat': 21.4834, 'lng': 39.1956,
      'rating': 4.3, 'openNow': true,
      'workingHours': '٧ص - ١١م', 'seatingCapacity': '٢٤',
      'features': ['واي فاي مجاني', 'توصيل'],
      'priceRange': 'حتى ٣٠,٠٠٠ ريال', 'roadType': 'داخلي', 'buildingType': 'سكني',
    },
    {
      'name': 'قهوتي مكسبي - حي الجامعة',
      'address': 'طريق الجامعة، حي الجامعة',
      'lat': 21.4512, 'lng': 39.2311,
      'rating': 4.5, 'openNow': true,
      'workingHours': '٦ص - ١٢م', 'seatingCapacity': '٣٥',
      'features': ['واي فاي مجاني', 'نقاط مضاعفة', 'خدمة ذاتية'],
      'priceRange': 'حتى ٣٠,٠٠٠ ريال', 'roadType': 'خدمات', 'buildingType': 'منشأة عمل',
    },
    {
      'name': 'قهوتي مكسبي - حي أم السلم',
      'address': 'شارع الإمام الشافعي، حي أم السلم',
      'lat': 21.4378, 'lng': 39.2089,
      'rating': 4.1, 'openNow': false,
      'workingHours': '٨ص - ١٠م', 'seatingCapacity': '٢٠',
      'features': ['مكيف', 'خالٍ من التدخين'],
      'priceRange': 'حتى ٣٠,٠٠٠ ريال', 'roadType': 'داخلي', 'buildingType': 'سكني',
    },

    // ───── ٣٠,٠٠٠ - ٤٥,٠٠٠ ريال (10 أماكن) ─────
    {
      'name': 'قهوتي مكسبي - حي الروضة',
      'address': 'شارع الأمير محمد بن عبدالعزيز، حي الروضة',
      'lat': 21.5433, 'lng': 39.1728,
      'rating': 4.8, 'openNow': true,
      'workingHours': '٧ص - ١٢م', 'seatingCapacity': '٤٠',
      'features': ['واي فاي مجاني', 'موقف سيارات', 'خالٍ من التدخين', 'توصيل'],
      'priceRange': '٣٠,٠٠٠ - ٤٥,٠٠٠ ريال', 'roadType': 'رئيسي', 'buildingType': 'تجاري',
    },
    {
      'name': 'قهوتي مكسبي - حي الكندرة',
      'address': 'شارع الكندرة، حي الكندرة',
      'lat': 21.5018, 'lng': 39.1765,
      'rating': 4.6, 'openNow': true,
      'workingHours': '٧ص - ١١م', 'seatingCapacity': '٣٨',
      'features': ['واي فاي مجاني', 'موقف سيارات', 'توصيل'],
      'priceRange': '٣٠,٠٠٠ - ٤٥,٠٠٠ ريال', 'roadType': 'رئيسي', 'buildingType': 'تجاري',
    },
    {
      'name': 'قهوتي مكسبي - حي الفيصلية',
      'address': 'شارع الأمير سلطان، حي الفيصلية',
      'lat': 21.4783, 'lng': 39.2016,
      'rating': 4.5, 'openNow': false,
      'workingHours': '٨ص - ١٢م', 'seatingCapacity': '٤٥',
      'features': ['واي فاي مجاني', 'قسم عائلي', 'خالٍ من التدخين'],
      'priceRange': '٣٠,٠٠٠ - ٤٥,٠٠٠ ريال', 'roadType': 'رئيسي', 'buildingType': 'تجاري',
    },
    {
      'name': 'قهوتي مكسبي - حي الخالدية',
      'address': 'شارع خالد بن الوليد، حي الخالدية',
      'lat': 21.5234, 'lng': 39.1876,
      'rating': 4.7, 'openNow': true,
      'workingHours': '٦ص - ١٢م', 'seatingCapacity': '٤٢',
      'features': ['واي فاي مجاني', 'موقف سيارات', 'نقاط مضاعفة'],
      'priceRange': '٣٠,٠٠٠ - ٤٥,٠٠٠ ريال', 'roadType': 'تجاري', 'buildingType': 'تجاري',
    },
    {
      'name': 'قهوتي مكسبي - حي السامر',
      'address': 'طريق الأمير متعب، حي السامر',
      'lat': 21.5893, 'lng': 39.1748,
      'rating': 4.4, 'openNow': true,
      'workingHours': '٧ص - ١٢م', 'seatingCapacity': '٣٦',
      'features': ['واي فاي مجاني', 'مكيف', 'توصيل'],
      'priceRange': '٣٠,٠٠٠ - ٤٥,٠٠٠ ريال', 'roadType': 'رئيسي', 'buildingType': 'تجاري',
    },
    {
      'name': 'قهوتي مكسبي - حي الربوة',
      'address': 'شارع الربوة، حي الربوة',
      'lat': 21.5347, 'lng': 39.1842,
      'rating': 4.6, 'openNow': true,
      'workingHours': '٧ص - ١١م', 'seatingCapacity': '٤٠',
      'features': ['واي فاي مجاني', 'قسم عائلي', 'موقف سيارات'],
      'priceRange': '٣٠,٠٠٠ - ٤٥,٠٠٠ ريال', 'roadType': 'تجاري', 'buildingType': 'تجاري',
    },
    {
      'name': 'قهوتي مكسبي - حي الشاطئ',
      'address': 'شارع الشاطئ، حي الشاطئ',
      'lat': 21.4932, 'lng': 39.1643,
      'rating': 4.5, 'openNow': false,
      'workingHours': '٨ص - ١٢م', 'seatingCapacity': '٣٢',
      'features': ['واي فاي مجاني', 'إطلالة بحرية', 'خالٍ من التدخين'],
      'priceRange': '٣٠,٠٠٠ - ٤٥,٠٠٠ ريال', 'roadType': 'رئيسي', 'buildingType': 'ترفيهي',
    },
    {
      'name': 'قهوتي مكسبي - حي الحزام الذهبي',
      'address': 'طريق الحزام الذهبي، غرب جدة',
      'lat': 21.5156, 'lng': 39.1623,
      'rating': 4.3, 'openNow': true,
      'workingHours': '٦ص - ١٢م', 'seatingCapacity': '٣٨',
      'features': ['واي فاي مجاني', 'موقف سيارات', 'توصيل'],
      'priceRange': '٣٠,٠٠٠ - ٤٥,٠٠٠ ريال', 'roadType': 'سريع', 'buildingType': 'تجاري',
    },
    {
      'name': 'قهوتي مكسبي - حي مدائن الفهد',
      'address': 'شارع مدائن الفهد، شمال جدة',
      'lat': 21.6012, 'lng': 39.1867,
      'rating': 4.4, 'openNow': true,
      'workingHours': '٧ص - ١١م', 'seatingCapacity': '٣٥',
      'features': ['واي فاي مجاني', 'جلسات خارجية', 'مكيف'],
      'priceRange': '٣٠,٠٠٠ - ٤٥,٠٠٠ ريال', 'roadType': 'رئيسي', 'buildingType': 'تجاري',
    },
    {
      'name': 'قهوتي مكسبي - حي الرويس',
      'address': 'شارع الرويس القديم، حي الرويس',
      'lat': 21.5034, 'lng': 39.1512,
      'rating': 4.2, 'openNow': false,
      'workingHours': '٨ص - ١١م', 'seatingCapacity': '٢٨',
      'features': ['واي فاي مجاني', 'خدمة ذاتية'],
      'priceRange': '٣٠,٠٠٠ - ٤٥,٠٠٠ ريال', 'roadType': 'تجاري', 'buildingType': 'تجاري',
    },

    // ───── ٤٥,٠٠٠ - ٦٠,٠٠٠ ريال (10 أماكن) ─────
    {
      'name': 'قهوتي مكسبي - حي الزهراء',
      'address': 'طريق الكورنيش، حي الزهراء',
      'lat': 21.5128, 'lng': 39.1804,
      'rating': 4.6, 'openNow': true,
      'workingHours': '٦ص - ١١م', 'seatingCapacity': '٦٠',
      'features': ['واي فاي مجاني', 'إطلالة بحرية', 'قسم عائلي', 'توصيل'],
      'priceRange': '٤٥,٠٠٠ - ٦٠,٠٠٠ ريال', 'roadType': 'سريع', 'buildingType': 'ترفيهي',
    },
    {
      'name': 'قهوتي مكسبي - حي الأندلس',
      'address': 'شارع الأندلس، حي الأندلس',
      'lat': 21.5624, 'lng': 39.1894,
      'rating': 4.7, 'openNow': true,
      'workingHours': '٧ص - ١٢م', 'seatingCapacity': '٥٥',
      'features': ['واي فاي مجاني', 'موقف سيارات', 'قسم عائلي', 'نقاط مضاعفة'],
      'priceRange': '٤٥,٠٠٠ - ٦٠,٠٠٠ ريال', 'roadType': 'رئيسي', 'buildingType': 'تجاري',
    },
    {
      'name': 'قهوتي مكسبي - حي السلامة',
      'address': 'شارع السلامة، حي السلامة',
      'lat': 21.5712, 'lng': 39.1962,
      'rating': 4.8, 'openNow': true,
      'workingHours': '٦ص - ١٢م', 'seatingCapacity': '٦٥',
      'features': ['واي فاي مجاني', 'موقف سيارات', 'جلسات خارجية', 'مكيف'],
      'priceRange': '٤٥,٠٠٠ - ٦٠,٠٠٠ ريال', 'roadType': 'رئيسي', 'buildingType': 'تجاري',
    },
    {
      'name': 'قهوتي مكسبي - حي البغدادية',
      'address': 'شارع البغدادية، حي البغدادية',
      'lat': 21.5127, 'lng': 39.1698,
      'rating': 4.5, 'openNow': false,
      'workingHours': '٨ص - ١١م', 'seatingCapacity': '٤٨',
      'features': ['واي فاي مجاني', 'خالٍ من التدخين', 'توصيل'],
      'priceRange': '٤٥,٠٠٠ - ٦٠,٠٠٠ ريال', 'roadType': 'تجاري', 'buildingType': 'منشأة عمل',
    },
    {
      'name': 'قهوتي مكسبي - حي العليا',
      'address': 'شارع التحلية، حي العليا',
      'lat': 21.5389, 'lng': 39.1934,
      'rating': 4.9, 'openNow': true,
      'workingHours': '٦ص - ١٢م', 'seatingCapacity': '٧٠',
      'features': ['واي فاي مجاني', 'موقف سيارات', 'قسم عائلي', 'نقاط مضاعفة', 'توصيل'],
      'priceRange': '٤٥,٠٠٠ - ٦٠,٠٠٠ ريال', 'roadType': 'رئيسي', 'buildingType': 'تجاري',
    },
    {
      'name': 'قهوتي مكسبي - حي الواجهة البحرية',
      'address': 'كورنيش جدة، الواجهة البحرية',
      'lat': 21.4967, 'lng': 39.1578,
      'rating': 4.8, 'openNow': true,
      'workingHours': '٧ص - ١٢م', 'seatingCapacity': '٨٠',
      'features': ['واي فاي مجاني', 'إطلالة بحرية', 'جلسات خارجية', 'قسم عائلي'],
      'priceRange': '٤٥,٠٠٠ - ٦٠,٠٠٠ ريال', 'roadType': 'سريع', 'buildingType': 'ترفيهي',
    },
    {
      'name': 'قهوتي مكسبي - حي الحمراء (٢)',
      'address': 'شارع المنصور، حي الحمراء',
      'lat': 21.5298, 'lng': 39.1712,
      'rating': 4.6, 'openNow': true,
      'workingHours': '٧ص - ١٢م', 'seatingCapacity': '٥٠',
      'features': ['واي فاي مجاني', 'مكيف', 'موقف سيارات', 'توصيل'],
      'priceRange': '٤٥,٠٠٠ - ٦٠,٠٠٠ ريال', 'roadType': 'تجاري', 'buildingType': 'تجاري',
    },
    {
      'name': 'قهوتي مكسبي - حي الجوهرة',
      'address': 'شارع الجوهرة، حي الجوهرة',
      'lat': 21.4712, 'lng': 39.2134,
      'rating': 4.4, 'openNow': false,
      'workingHours': '٨ص - ١١م', 'seatingCapacity': '٤٥',
      'features': ['واي فاي مجاني', 'خالٍ من التدخين', 'مكيف'],
      'priceRange': '٤٥,٠٠٠ - ٦٠,٠٠٠ ريال', 'roadType': 'تجاري', 'buildingType': 'منشأة عمل',
    },
    {
      'name': 'قهوتي مكسبي - حي الروضة (٢)',
      'address': 'شارع الستين، حي الروضة',
      'lat': 21.5451, 'lng': 39.1756,
      'rating': 4.7, 'openNow': true,
      'workingHours': '٦ص - ١٢م', 'seatingCapacity': '٥٢',
      'features': ['واي فاي مجاني', 'موقف سيارات', 'جلسات خارجية', 'نقاط مضاعفة'],
      'priceRange': '٤٥,٠٠٠ - ٦٠,٠٠٠ ريال', 'roadType': 'رئيسي', 'buildingType': 'تجاري',
    },
    {
      'name': 'قهوتي مكسبي - حي العزيزية',
      'address': 'شارع الأمير فيصل، حي العزيزية',
      'lat': 21.4641, 'lng': 39.2233,
      'rating': 4.5, 'openNow': true,
      'workingHours': '٧ص - ١١م', 'seatingCapacity': '٤٨',
      'features': ['واي فاي مجاني', 'قسم عائلي', 'خالٍ من التدخين'],
      'priceRange': '٤٥,٠٠٠ - ٦٠,٠٠٠ ريال', 'roadType': 'رئيسي', 'buildingType': 'تجاري',
    },

    // ───── ٦٠,٠٠٠ - ٨٠,٠٠٠ ريال (10 أماكن) ─────
    {
      'name': 'قهوتي مكسبي - حي الصفا',
      'address': 'شارع الأمير ماجد، حي الصفا',
      'lat': 21.4894, 'lng': 39.2096,
      'rating': 4.5, 'openNow': true,
      'workingHours': '٧ص - ١١م', 'seatingCapacity': '٥٠',
      'features': ['واي فاي مجاني', 'قسم عائلي', 'توصيل', 'خدمة ذاتية'],
      'priceRange': '٦٠,٠٠٠ - ٨٠,٠٠٠ ريال', 'roadType': 'تجاري', 'buildingType': 'تجاري',
    },
    {
      'name': 'قهوتي مكسبي - حي الحمراء',
      'address': 'شارع حراء، حي الحمراء',
      'lat': 21.5286, 'lng': 39.1697,
      'rating': 4.7, 'openNow': true,
      'workingHours': '٦ص - ١٢م', 'seatingCapacity': '٣٥',
      'features': ['واي فاي مجاني', 'مكيف', 'خالٍ من التدخين', 'موقف سيارات'],
      'priceRange': '٦٠,٠٠٠ - ٨٠,٠٠٠ ريال', 'roadType': 'خدمات', 'buildingType': 'منشأة عمل',
    },
    {
      'name': 'قهوتي مكسبي - حي الكورنيش الشمالي',
      'address': 'كورنيش جدة الشمالي، الشاطئ',
      'lat': 21.5823, 'lng': 39.1523,
      'rating': 4.9, 'openNow': true,
      'workingHours': '٦ص - ١٢م', 'seatingCapacity': '٧٥',
      'features': ['واي فاي مجاني', 'إطلالة بحرية', 'جلسات خارجية', 'قسم عائلي', 'موقف سيارات'],
      'priceRange': '٦٠,٠٠٠ - ٨٠,٠٠٠ ريال', 'roadType': 'سريع', 'buildingType': 'ترفيهي',
    },
    {
      'name': 'قهوتي مكسبي - حي النزهة (٢)',
      'address': 'شارع خريص، حي النزهة',
      'lat': 21.4712, 'lng': 39.1967,
      'rating': 4.8, 'openNow': true,
      'workingHours': '٧ص - ١٢م', 'seatingCapacity': '٦٠',
      'features': ['واي فاي مجاني', 'موقف سيارات', 'نقاط مضاعفة', 'توصيل'],
      'priceRange': '٦٠,٠٠٠ - ٨٠,٠٠٠ ريال', 'roadType': 'رئيسي', 'buildingType': 'تجاري',
    },
    {
      'name': 'قهوتي مكسبي - حي الزهراء (٢)',
      'address': 'شارع الأمير عبدالله، حي الزهراء',
      'lat': 21.5145, 'lng': 39.1834,
      'rating': 4.7, 'openNow': false,
      'workingHours': '٨ص - ١٢م', 'seatingCapacity': '٥٥',
      'features': ['واي فاي مجاني', 'قسم عائلي', 'مكيف', 'خالٍ من التدخين'],
      'priceRange': '٦٠,٠٠٠ - ٨٠,٠٠٠ ريال', 'roadType': 'رئيسي', 'buildingType': 'تجاري',
    },
    {
      'name': 'قهوتي مكسبي - حي السلامة (٢)',
      'address': 'شارع عثمان بن عفان، حي السلامة',
      'lat': 21.5734, 'lng': 39.1978,
      'rating': 4.8, 'openNow': true,
      'workingHours': '٦ص - ١٢م', 'seatingCapacity': '٧٠',
      'features': ['واي فاي مجاني', 'موقف سيارات', 'جلسات خارجية', 'قسم عائلي'],
      'priceRange': '٦٠,٠٠٠ - ٨٠,٠٠٠ ريال', 'roadType': 'رئيسي', 'buildingType': 'تجاري',
    },
    {
      'name': 'قهوتي مكسبي - حي العليا (٢)',
      'address': 'شارع الأمير محمد بن فهد، حي العليا',
      'lat': 21.5412, 'lng': 39.1956,
      'rating': 4.9, 'openNow': true,
      'workingHours': '٧ص - ١٢م', 'seatingCapacity': '٨٠',
      'features': ['واي فاي مجاني', 'موقف سيارات', 'مكيف', 'نقاط مضاعفة', 'توصيل'],
      'priceRange': '٦٠,٠٠٠ - ٨٠,٠٠٠ ريال', 'roadType': 'سريع', 'buildingType': 'تجاري',
    },
    {
      'name': 'قهوتي مكسبي - حي الأندلس (٢)',
      'address': 'شارع حافظ إبراهيم، حي الأندلس',
      'lat': 21.5645, 'lng': 39.1912,
      'rating': 4.6, 'openNow': true,
      'workingHours': '٧ص - ١١م', 'seatingCapacity': '٥٨',
      'features': ['واي فاي مجاني', 'قسم عائلي', 'خالٍ من التدخين', 'موقف سيارات'],
      'priceRange': '٦٠,٠٠٠ - ٨٠,٠٠٠ ريال', 'roadType': 'تجاري', 'buildingType': 'ترفيهي',
    },
    {
      'name': 'قهوتي مكسبي - حي الروضة (٣)',
      'address': 'طريق الملك عبدالله، حي الروضة',
      'lat': 21.5467, 'lng': 39.1745,
      'rating': 4.7, 'openNow': false,
      'workingHours': '٩ص - ١٢م', 'seatingCapacity': '٦٢',
      'features': ['واي فاي مجاني', 'موقف سيارات', 'توصيل', 'مكيف'],
      'priceRange': '٦٠,٠٠٠ - ٨٠,٠٠٠ ريال', 'roadType': 'رئيسي', 'buildingType': 'تجاري',
    },
    {
      'name': 'قهوتي مكسبي - حي الخالدية (٢)',
      'address': 'شارع الأمير سعد، حي الخالدية',
      'lat': 21.5256, 'lng': 39.1893,
      'rating': 4.6, 'openNow': true,
      'workingHours': '٦ص - ١٢م', 'seatingCapacity': '٦٥',
      'features': ['واي فاي مجاني', 'جلسات خارجية', 'قسم عائلي', 'نقاط مضاعفة'],
      'priceRange': '٦٠,٠٠٠ - ٨٠,٠٠٠ ريال', 'roadType': 'رئيسي', 'buildingType': 'تجاري',
    },

    // ───── أكثر من ٨٠,٠٠٠ ريال (10 أماكن) ─────
    {
      'name': 'قهوتي مكسبي - حي الحمراء (فلاجشيب)',
      'address': 'شارع التحلية، حي الحمراء',
      'lat': 21.5312, 'lng': 39.1678,
      'rating': 5.0, 'openNow': true,
      'workingHours': '٦ص - ١٢م', 'seatingCapacity': '١٠٠',
      'features': ['واي فاي مجاني', 'مكيف', 'موقف سيارات', 'قسم عائلي', 'جلسات خارجية', 'نقاط مضاعفة'],
      'priceRange': 'أكثر من ٨٠,٠٠٠ ريال', 'roadType': 'رئيسي', 'buildingType': 'منشأة عمل',
    },
    {
      'name': 'قهوتي مكسبي - حي الواجهة (فلاجشيب)',
      'address': 'شارع الكورنيش المركزي، الواجهة',
      'lat': 21.4989, 'lng': 39.1556,
      'rating': 5.0, 'openNow': true,
      'workingHours': '٥ص - ١٢م', 'seatingCapacity': '١٢٠',
      'features': ['واي فاي مجاني', 'إطلالة بحرية', 'جلسات خارجية', 'قسم عائلي', 'موقف سيارات', 'توصيل'],
      'priceRange': 'أكثر من ٨٠,٠٠٠ ريال', 'roadType': 'سريع', 'buildingType': 'ترفيهي',
    },
    {
      'name': 'قهوتي مكسبي - حي الأندلس (فلاجشيب)',
      'address': 'طريق الأمير نايف، حي الأندلس',
      'lat': 21.5667, 'lng': 39.1923,
      'rating': 4.9, 'openNow': true,
      'workingHours': '٦ص - ١٢م', 'seatingCapacity': '٩٠',
      'features': ['واي فاي مجاني', 'موقف سيارات', 'مكيف', 'قسم عائلي', 'نقاط مضاعفة'],
      'priceRange': 'أكثر من ٨٠,٠٠٠ ريال', 'roadType': 'رئيسي', 'buildingType': 'تجاري',
    },
    {
      'name': 'قهوتي مكسبي - حي السلامة (فلاجشيب)',
      'address': 'شارع الحرمين، حي السلامة',
      'lat': 21.5756, 'lng': 39.1989,
      'rating': 4.9, 'openNow': true,
      'workingHours': '٦ص - ١٢م', 'seatingCapacity': '١١٠',
      'features': ['واي فاي مجاني', 'موقف سيارات', 'جلسات خارجية', 'قسم عائلي', 'توصيل'],
      'priceRange': 'أكثر من ٨٠,٠٠٠ ريال', 'roadType': 'سريع', 'buildingType': 'تجاري',
    },
    {
      'name': 'قهوتي مكسبي - حي الزهراء (فلاجشيب)',
      'address': 'شارع الأمير عبدالمجيد، حي الزهراء',
      'lat': 21.5167, 'lng': 39.1823,
      'rating': 4.8, 'openNow': true,
      'workingHours': '٦ص - ١٢م', 'seatingCapacity': '٩٥',
      'features': ['واي فاي مجاني', 'إطلالة بحرية', 'مكيف', 'قسم عائلي', 'موقف سيارات', 'توصيل'],
      'priceRange': 'أكثر من ٨٠,٠٠٠ ريال', 'roadType': 'سريع', 'buildingType': 'ترفيهي',
    },
    {
      'name': 'قهوتي مكسبي - حي العليا (فلاجشيب)',
      'address': 'برج التوأم، شارع التحلية، حي العليا',
      'lat': 21.5434, 'lng': 39.1967,
      'rating': 5.0, 'openNow': true,
      'workingHours': '٦ص - ١٢م', 'seatingCapacity': '١٣٠',
      'features': ['واي فاي مجاني', 'موقف سيارات', 'مكيف', 'قسم عائلي', 'نقاط مضاعفة', 'توصيل'],
      'priceRange': 'أكثر من ٨٠,٠٠٠ ريال', 'roadType': 'رئيسي', 'buildingType': 'منشأة عمل',
    },
    {
      'name': 'قهوتي مكسبي - حي الربوة (فلاجشيب)',
      'address': 'طريق الملك فهد، حي الربوة',
      'lat': 21.5367, 'lng': 39.1856,
      'rating': 4.9, 'openNow': true,
      'workingHours': '٦ص - ١٢م', 'seatingCapacity': '١٠٠',
      'features': ['واي فاي مجاني', 'موقف سيارات', 'جلسات خارجية', 'مكيف', 'قسم عائلي'],
      'priceRange': 'أكثر من ٨٠,٠٠٠ ريال', 'roadType': 'سريع', 'buildingType': 'تجاري',
    },
    {
      'name': 'قهوتي مكسبي - حي الروضة (فلاجشيب)',
      'address': 'طريق الملك عبدالعزيز، حي الروضة',
      'lat': 21.5489, 'lng': 39.1768,
      'rating': 4.8, 'openNow': false,
      'workingHours': '٧ص - ١٢م', 'seatingCapacity': '٨٥',
      'features': ['واي فاي مجاني', 'موقف سيارات', 'مكيف', 'توصيل', 'نقاط مضاعفة'],
      'priceRange': 'أكثر من ٨٠,٠٠٠ ريال', 'roadType': 'رئيسي', 'buildingType': 'تجاري',
    },
    {
      'name': 'قهوتي مكسبي - حي الخالدية (فلاجشيب)',
      'address': 'شارع الأمير خالد، حي الخالدية',
      'lat': 21.5278, 'lng': 39.1912,
      'rating': 4.9, 'openNow': true,
      'workingHours': '٥ص - ١٢م', 'seatingCapacity': '١١٠',
      'features': ['واي فاي مجاني', 'موقف سيارات', 'جلسات خارجية', 'قسم عائلي', 'توصيل', 'نقاط مضاعفة'],
      'priceRange': 'أكثر من ٨٠,٠٠٠ ريال', 'roadType': 'رئيسي', 'buildingType': 'تجاري',
    },
    {
      'name': 'قهوتي مكسبي - حي الكندرة (فلاجشيب)',
      'address': 'شارع قريش، حي الكندرة',
      'lat': 21.5045, 'lng': 39.1789,
      'rating': 4.8, 'openNow': true,
      'workingHours': '٦ص - ١٢م', 'seatingCapacity': '٩٠',
      'features': ['واي فاي مجاني', 'موقف سيارات', 'مكيف', 'قسم عائلي', 'خالٍ من التدخين'],
      'priceRange': 'أكثر من ٨٠,٠٠٠ ريال', 'roadType': 'تجاري', 'buildingType': 'منشأة عمل',
    },
  ];

  Future<void> _seedData() async {
    setState(() {
      _isLoading = true;
      _statusMessage = null;
    });

    try {
      final collection = FirebaseFirestore.instance.collection('places');

      // رفع على دفعات لتفادي حد الـ 500 عملية
      const batchSize = 25;
      for (int i = 0; i < _seedPlaces.length; i += batchSize) {
        final batch = FirebaseFirestore.instance.batch();
        final end = (i + batchSize).clamp(0, _seedPlaces.length);
        for (final place in _seedPlaces.sublist(i, end)) {
          final docRef = collection.doc();
          batch.set(docRef, {
            ...place,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
        await batch.commit();
      }

      if (!mounted) return;
      setState(() {
        _isSuccess = true;
        _statusMessage = 'تم رفع ${_seedPlaces.length} مكاناً بنجاح ✓';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSuccess = false;
        _statusMessage = 'حدث خطأ: $e';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final p in _seedPlaces) {
      final range = p['priceRange'] as String;
      grouped.putIfAbsent(range, () => []).add(p);
    }

    return Scaffold(
      backgroundColor: ColorsManager.screenBackground,
      appBar: AppBar(
        backgroundColor: ColorsManager.screenBackground,
        title: Text('رفع البيانات الافتراضية', style: TextStyles(context).font16DarkBold),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp, color: ColorsManager.dark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 12.h),
              child: Row(
                children: [
                  Text(
                    '${_seedPlaces.length} مكاناً جاهزاً للرفع',
                    style: TextStyles(context).font14BlackRegular.copyWith(
                          fontWeight: FontWeight.w700,
                          color: ColorsManager.coffeeButton,
                        ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: ColorsManager.coffeeButton.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      '${grouped.length} فئات سعر',
                      style: TextStyles(context).font12GraykRegular.copyWith(
                            color: ColorsManager.coffeeButton,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                children: grouped.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.h, top: 4.h),
                        child: Row(
                          children: [
                            Icon(Icons.attach_money_rounded,
                                color: ColorsManager.coffeeButton, size: 14.sp),
                            horizontalSpace(4),
                            Text(
                              entry.key,
                              style: TextStyles(context).font12GraykRegular.copyWith(
                                    color: ColorsManager.coffeeButton,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            horizontalSpace(8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: ColorsManager.coffeeButton,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                '${entry.value.length}',
                                style: TextStyles(context)
                                    .font12GraykRegular
                                    .copyWith(color: Colors.white, fontSize: 10.sp),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...entry.value.map((place) => Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: _PlaceCard(place: place),
                          )),
                      verticalSpace(6),
                    ],
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 0),
              child: _statusMessage != null
                  ? Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: _isSuccess
                            ? ColorsManager.green.withValues(alpha: 0.15)
                            : ColorsManager.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        _statusMessage!,
                        style: TextStyles(context).font14BlackRegular.copyWith(
                              color:
                                  _isSuccess ? ColorsManager.green : ColorsManager.red,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 28.h),
              child: MainButton(
                text: _isLoading ? '' : 'رفع ${_seedPlaces.length} مكاناً إلى Firestore',
                onTap: _isLoading ? null : _seedData,
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
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  final Map<String, dynamic> place;

  const _PlaceCard({required this.place});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: ColorsManager.coffeeButton.withValues(alpha: 0.15),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: ColorsManager.coffeeButton.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.coffee, color: ColorsManager.coffeeButton, size: 16.sp),
          ),
          horizontalSpace(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place['name'] as String,
                  style: TextStyles(context).font14BlackRegular.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 12.sp,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                verticalSpace(3),
                Text(
                  place['address'] as String,
                  style: TextStyles(context)
                      .font12GraykRegular
                      .copyWith(fontSize: 10.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                verticalSpace(3),
                Row(
                  children: [
                    Icon(Icons.directions_rounded,
                        color: ColorsManager.gray, size: 11.sp),
                    horizontalSpace(3),
                    Text(place['roadType'] as String,
                        style: TextStyles(context)
                            .font12GraykRegular
                            .copyWith(fontSize: 10.sp)),
                    horizontalSpace(8),
                    Icon(Icons.apartment_rounded,
                        color: ColorsManager.gray, size: 11.sp),
                    horizontalSpace(3),
                    Text(place['buildingType'] as String,
                        style: TextStyles(context)
                            .font12GraykRegular
                            .copyWith(fontSize: 10.sp)),
                  ],
                ),
              ],
            ),
          ),
          horizontalSpace(8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(Icons.star_rounded, color: const Color(0xFFFFB800), size: 12.sp),
                  horizontalSpace(2),
                  Text('${place['rating']}',
                      style: TextStyles(context)
                          .font12GraykRegular
                          .copyWith(color: ColorsManager.dark, fontSize: 11.sp)),
                ],
              ),
              verticalSpace(4),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: (place['openNow'] as bool)
                      ? ColorsManager.green.withValues(alpha: 0.15)
                      : ColorsManager.red.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  (place['openNow'] as bool) ? 'مفتوح' : 'مغلق',
                  style: TextStyles(context).font12GraykRegular.copyWith(
                        color: (place['openNow'] as bool)
                            ? ColorsManager.green
                            : ColorsManager.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 9.sp,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
