import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
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

  static IconData _featureIcon(String label) {
    switch (label) {
      case 'واي فاي مجاني':
        return Icons.wifi_rounded;
      case 'موقف سيارات':
        return Icons.local_parking_rounded;
      case 'خالٍ من التدخين':
        return Icons.smoke_free_rounded;
      case 'توصيل':
        return Icons.delivery_dining_rounded;
      case 'إطلالة بحرية':
        return Icons.water_rounded;
      case 'قسم عائلي':
        return Icons.family_restroom_rounded;
      case 'جلسات خارجية':
        return Icons.outdoor_grill_rounded;
      case 'نقاط مضاعفة':
        return Icons.card_giftcard_rounded;
      case 'خدمة ذاتية':
        return Icons.self_improvement_rounded;
      case 'مكيف':
        return Icons.ac_unit_rounded;
      default:
        return Icons.star_rounded;
    }
  }

  static _CoffeeShop _fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final featureLabels = List<String>.from(data['features'] as List? ?? []);
    return _CoffeeShop(
      id: doc.id,
      name: data['name'] as String? ?? '',
      address: data['address'] as String? ?? '',
      lat: (data['lat'] as num).toDouble(),
      lng: (data['lng'] as num).toDouble(),
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      openNow: data['openNow'] as bool? ?? false,
      workingHours: data['workingHours'] as String? ?? '',
      seatingCapacity: '${data['seatingCapacity']} مقعد',
      priceRange: data['priceRange'] as String? ?? '',
      roadType: data['roadType'] as String? ?? '',
      buildingType: data['buildingType'] as String? ?? '',
      features: featureLabels
          .map((label) => _Feature(icon: _featureIcon(label), label: label))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.screenBackground,
      appBar: _buildAppBar(context),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('places')
            .orderBy('createdAt')
            .snapshots(),
        builder: (context, snapshot) {
          final shops = snapshot.hasData
              ? snapshot.data!.docs.map(_fromFirestore).toList()
              : <_CoffeeShop>[];

          return Stack(
            children: [
              _buildMap(shops),
              if (snapshot.connectionState == ConnectionState.waiting && shops.isEmpty)
                const Center(child: CircularProgressIndicator()),
              if (_selectedLocation != null) _buildSelectedCard(context, shops),
            ],
          );
        },
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

  Widget _buildMap(List<_CoffeeShop> shops) {
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
          markers: shops.map((shop) {
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

  Widget _buildSelectedCard(BuildContext context, List<_CoffeeShop> shops) {
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
                ],
              ),
              if (shop != null) ...[
                verticalSpace(10),
                Row(
                  children: [
                    Icon(Icons.attach_money_rounded, color: ColorsManager.gray, size: 14.sp),
                    horizontalSpace(3),
                    Expanded(
                      child: Text(shop.priceRange,
                          style: TextStyles(context).font12GraykRegular,
                          overflow: TextOverflow.ellipsis),
                    ),
                    horizontalSpace(10),
                    Icon(Icons.directions_rounded, color: ColorsManager.gray, size: 14.sp),
                    horizontalSpace(3),
                    Text(shop.roadType, style: TextStyles(context).font12GraykRegular),
                    horizontalSpace(10),
                    Icon(Icons.apartment_rounded, color: ColorsManager.gray, size: 14.sp),
                    horizontalSpace(3),
                    Text(shop.buildingType, style: TextStyles(context).font12GraykRegular),
                  ],
                ),
              ],
              verticalSpace(14),
              MainButton(
                text: 'فتح على الخريطة',
                height: 48,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class _CoffeeShop {
  final String id;
  final String name;
  final String address;
  final double lat;
  final double lng;
  final double rating;
  final bool openNow;
  final String workingHours;
  final String seatingCapacity;
  final String priceRange;
  final String roadType;
  final String buildingType;
  final List<_Feature> features;

  const _CoffeeShop({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.rating,
    required this.openNow,
    required this.workingHours,
    required this.seatingCapacity,
    required this.priceRange,
    required this.roadType,
    required this.buildingType,
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
