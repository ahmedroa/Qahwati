import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:qahwati/core/colors.dart';
import 'package:qahwati/core/helpers/spacing.dart';
import 'package:qahwati/core/theme/text_style.dart';
import 'package:qahwati/widget/main_button.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LatLng? _selectedLocation;
  _CoffeeShop? _selectedShop;

  static const LatLng _jeddahCenter = LatLng(21.4858, 39.1925);

  final List<_CoffeeShop> _coffeeShops = [
    _CoffeeShop(
      name: 'قهوتي مكسبي - حي الروضة',
      address: 'شارع الأمير محمد بن عبدالعزيز، حي الروضة',
      lat: 21.5433,
      lng: 39.1728,
      rating: 4.8,
      openNow: true,
      workingHours: '٧ص - ١٢م',
      seatingCapacity: '٤٠ مقعد',
      features: [
        _Feature(icon: Icons.wifi_rounded, label: 'واي فاي مجاني'),
        _Feature(icon: Icons.local_parking_rounded, label: 'موقف سيارات'),
        _Feature(icon: Icons.smoke_free_rounded, label: 'خالٍ من التدخين'),
        _Feature(icon: Icons.delivery_dining_rounded, label: 'توصيل'),
      ],
    ),
    _CoffeeShop(
      name: 'قهوتي مكسبي - حي الزهراء',
      address: 'طريق الكورنيش، حي الزهراء',
      lat: 21.5128,
      lng: 39.1804,
      rating: 4.6,
      openNow: true,
      workingHours: '٦ص - ١١م',
      seatingCapacity: '٦٠ مقعد',
      features: [
        _Feature(icon: Icons.wifi_rounded, label: 'واي فاي مجاني'),
        _Feature(icon: Icons.water_rounded, label: 'إطلالة بحرية'),
        _Feature(icon: Icons.family_restroom_rounded, label: 'قسم عائلي'),
        _Feature(icon: Icons.delivery_dining_rounded, label: 'توصيل'),
      ],
    ),
    _CoffeeShop(
      name: 'قهوتي مكسبي - حي النزهة',
      address: 'شارع التحلية، حي النزهة',
      lat: 21.4692,
      lng: 39.1938,
      rating: 4.9,
      openNow: false,
      workingHours: '٨ص - ١٢م',
      seatingCapacity: '٣٠ مقعد',
      features: [
        _Feature(icon: Icons.wifi_rounded, label: 'واي فاي مجاني'),
        _Feature(icon: Icons.local_parking_rounded, label: 'موقف سيارات'),
        _Feature(icon: Icons.outdoor_grill_rounded, label: 'جلسات خارجية'),
        _Feature(icon: Icons.card_giftcard_rounded, label: 'نقاط مضاعفة'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.screenBackground,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          _buildMap(),
          if (_selectedLocation != null) _buildSelectedCard(context),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: ColorsManager.screenBackground,
      elevation: 0,
      title: Text('اختر الموقع', style: TextStyles(context).font18BlackMedium),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp, color: ColorsManager.dark),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _jeddahCenter,
        initialZoom: 12.0,
        onTap: (_, point) => setState(() {
          _selectedLocation = point;
          _selectedShop = null;
        }),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.qahwati.app',
        ),
        MarkerLayer(
          markers: _coffeeShops.map((shop) {
            final pos = LatLng(shop.lat, shop.lng);
            return Marker(
              point: pos,
              width: 44.w,
              height: 44.h,
              child: GestureDetector(
                onTap: () => setState(() {
                  _selectedLocation = pos;
                  _selectedShop = shop;
                }),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        color: ColorsManager.coffeeButton,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(Icons.coffee, color: Colors.white, size: 16.sp),
                    ),
                    CustomPaint(
                      size: Size(10.w, 6.h),
                      painter: _TrianglePainter(color: ColorsManager.coffeeButton),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        if (_selectedLocation != null)
          MarkerLayer(
            markers: [
              Marker(
                point: _selectedLocation!,
                width: 36.w,
                height: 36.h,
                child: Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 36.sp,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildSelectedCard(BuildContext context) {
    final shop = _selectedShop;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          margin: EdgeInsets.all(16.r),
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shop?.name ?? 'موقع مخصص',
                          style: TextStyles(context).font16DarkBold,
                        ),
                        if (shop != null) ...[
                          verticalSpace(2),
                          Text(shop.address, style: TextStyles(context).font12GraykRegular),
                        ],
                      ],
                    ),
                  ),
                  if (shop != null)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: shop.openNow
                            ? ColorsManager.green.withValues(alpha: 0.15)
                            : ColorsManager.red.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        shop.openNow ? 'مفتوح الآن' : 'مغلق',
                        style: TextStyles(context).font12GraykRegular.copyWith(
                              color: shop.openNow ? ColorsManager.green : ColorsManager.red,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                ],
              ),
              if (shop != null) ...[
                verticalSpace(10),
                Row(
                  children: [
                    Icon(Icons.star_rounded, color: const Color(0xFFFFB800), size: 15.sp),
                    horizontalSpace(3),
                    Text(shop.rating.toString(), style: TextStyles(context).font12GraykRegular.copyWith(color: ColorsManager.dark)),
                    horizontalSpace(14),
                    Icon(Icons.access_time_rounded, color: ColorsManager.gray, size: 14.sp),
                    horizontalSpace(3),
                    Text(shop.workingHours, style: TextStyles(context).font12GraykRegular),
                    horizontalSpace(14),
                    Icon(Icons.chair_rounded, color: ColorsManager.gray, size: 14.sp),
                    horizontalSpace(3),
                    Text(shop.seatingCapacity, style: TextStyles(context).font12GraykRegular),
                  ],
                ),
                verticalSpace(12),
                Divider(height: 1, color: ColorsManager.grayBorder.withValues(alpha: 0.5)),
                verticalSpace(10),
                Text('مميزات المكان', style: TextStyles(context).font14BlackRegular.copyWith(fontWeight: FontWeight.w700)),
                verticalSpace(8),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: shop.features.map((f) => _buildFeatureChip(context, f)).toList(),
                ),
              ],
              verticalSpace(14),
              MainButton(
                text: 'تأكيد الموقع',
                height: 48,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureChip(BuildContext context, _Feature feature) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: ColorsManager.coffeeButton.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(feature.icon, size: 14.sp, color: ColorsManager.coffeeButton),
          horizontalSpace(5),
          Text(feature.label, style: TextStyles(context).font12GraykRegular.copyWith(color: ColorsManager.dark)),
        ],
      ),
    );
  }
}

class _CoffeeShop {
  final String name;
  final String address;
  final double lat;
  final double lng;
  final double rating;
  final bool openNow;
  final String workingHours;
  final String seatingCapacity;
  final List<_Feature> features;

  const _CoffeeShop({
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.rating,
    required this.openNow,
    required this.workingHours,
    required this.seatingCapacity,
    required this.features,
  });
}

class _Feature {
  final IconData icon;
  final String label;
  const _Feature({required this.icon, required this.label});
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = ui.Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TrianglePainter old) => old.color != color;
}
