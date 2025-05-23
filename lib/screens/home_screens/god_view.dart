import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stepowner/custom_router/route_names.dart';
import 'package:stepowner/provider/provider_model/space_provider.dart';
import 'package:stepowner/utils/AppString/app_strings.dart';
import 'package:stepowner/utils/change_language/app_location.dart';
import 'package:stepowner/utils/const_color/constant_color.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class GodView extends StatefulWidget {
  const GodView({super.key});

  @override
  State<GodView> createState() => _GodViewState();
}

class _GodViewState extends State<GodView> {
  late SpaceProvider spaceProvider = Provider.of(context, listen: false);

  @override
  void initState() {
    super.initState();
    spaceProvider = Provider.of<SpaceProvider>(context, listen: false);
  }

  final MapType _currentMapType = MapType.normal;

  onWillPop(context) {
    Navigator.pushNamedAndRemoveUntil(
        context, RouteName.mainDrawerRoute, (route) => false);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    spaceProvider = Provider.of<SpaceProvider>(context, listen: true);
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) => onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, RouteName.mainDrawerRoute, (route) => false);
              },
              child: const Icon(Icons.arrow_back_outlined)),
          centerTitle: true,
          backgroundColor: AppColors.commonColorSkyBlue,
          foregroundColor: AppColors.white,
          title: Text(
            AppLocalizations.of(context).translate(AppString.godView),
            style: TextStyle(
                fontFamily: AppString.rubik,
                fontSize: 16.sp,
                color: AppColors.white),
          ),
        ),
        backgroundColor: AppColors.white,
        body: spaceProvider.mapViewLoader == true
            ? const Center(child: CircularProgressIndicator())
            : GoogleMap(
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: true,
                mapType: _currentMapType,
                markers: spaceProvider.markers,
                initialCameraPosition: CameraPosition(
                  target: spaceProvider.lastMapPosition != null
                      ? spaceProvider.lastMapPosition!
                      : const LatLng(22.2587, 71.1924),
                  zoom: 14.4746,
                ),
              ),
      ),
    );
  }
}
