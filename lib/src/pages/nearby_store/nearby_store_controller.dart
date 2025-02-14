import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:workshop/core/config/routes.dart';
import 'package:workshop/core/lifecycle/lifecycle_listener.dart';

class NearbyStoreController extends GetxController with LifecycleListenerEvent {
  Completer<GoogleMapController> controller = Completer();

  final _defaultLocation = const LatLng(18.89481479513443, 99.01092596937058);

  late final CameraPosition _defaultCameraLocation =
      CameraPosition(target: _defaultLocation, zoom: 15);

  final _fabLocation = const LatLng(13.703165480702987, 100.5434610047566);

  late final CameraPosition _fabButtonCameraLocation =
      CameraPosition(target: _fabLocation, zoom: 15);

  LatLng? _currentDeviceLocation;

  CameraPosition get currentDeviceLocation {
    return _currentDeviceLocation != null
        ? CameraPosition(
            target: LatLng(_currentDeviceLocation!.latitude,
                _currentDeviceLocation!.longitude),
            zoom: 14.4726,
          )
        : _defaultCameraLocation;
  }

  Future<void> goToTheLake() async {
    final GoogleMapController c = await controller.future;
    c.animateCamera(CameraUpdate.newCameraPosition(_fabButtonCameraLocation));
  }

  final Set<Marker> markers = {};

  late LifecycleListener _lifecycleListener;

  bool isOpenAppSetting = false;

  @override
  void onInit() {
    super.onInit();

    _moveCameraToCurrentLocation();
    _addMarkers();
    _lifecycleListener = LifecycleListener(providerInstance: this);
  }

  @override
  void onClose() {
    _lifecycleListener.dispose();
    super.onClose();
  }

  void _addMarkers() async {
    final Uint8List? markerIcon =
        await getBytesFromAsset("assets/user.png", 108, 108);

    markers.add(const Marker(
        markerId: MarkerId("1"),
        position: LatLng(13.7021, 100.5415),
        infoWindow: InfoWindow(
          title: 'Nearby store 1',
          snippet: 'First exclusive store',
        ),
        icon: BitmapDescriptor.defaultMarker));

    markers.add(
      Marker(
        markerId: const MarkerId("2"),
        position: const LatLng(13.7012, 100.5429),
        infoWindow: const InfoWindow(
          title: 'Nearby store 2',
          snippet: 'Second exclusive store',
        ),
        icon: BitmapDescriptor.fromBytes(markerIcon!),
      ),
    );

    markers.add(
      Marker(
        markerId: const MarkerId("3"),
        position: const LatLng(13.7024, 100.5447),
        infoWindow: const InfoWindow(
          title: 'Nearby store 3',
          snippet: 'Third exclusive store',
        ),
        icon: BitmapDescriptor.fromBytes(markerIcon),
      ),
    );

    update();
  }

  Future<Uint8List?> getBytesFromAsset(String path, int width, int height) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        ?.buffer
        .asUint8List();
  }

  void _moveCameraToCurrentLocation() async {
    try {
      final position = await _determinePosition();

      _currentDeviceLocation = LatLng(position.latitude, position.longitude);

      final GoogleMapController controller = await this.controller.future;

      controller
          .animateCamera(CameraUpdate.newCameraPosition(currentDeviceLocation));

      update();
    } catch (e) {
      _openAppSetting(e.toString());
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  void _openAppSetting(String message) {
    Get.dialog(
      AlertDialog(
        title: const Text("ไม่สามารถเข้าถึงตำแหน่งได้"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(Get.overlayContext!).pop();
              Get.back();
            },
            child: const Text("ยกเลิก"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(Get.overlayContext!).pop();

              if (Platform.isAndroid) {
                isOpenAppSetting = await Geolocator.openLocationSettings();
                return;
              }

              if (Platform.isIOS) {
                await Geolocator.openAppSettings();
                await Geolocator.openLocationSettings();
              }
            },
            child: const Text("ตั้งค่า"),
          ),
        ],
      ),
      barrierDismissible: false);
  }

  @override
  void onResume(){
  super.onResume();

  if(Get.currentRoute == Routes.nearbyStorePage && isOpenAppSetting){
    isOpenAppSetting = false;
    _moveCameraToCurrentLocation();
  }
  }
}
