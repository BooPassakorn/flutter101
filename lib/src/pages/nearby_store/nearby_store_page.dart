import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:workshop/src/pages/nearby_store/nearby_store_controller.dart';
import 'package:get/get.dart';

class NearbyStorePage extends StatelessWidget {
  NearbyStorePage({Key? key}) : super(key: key);

  final _nearbyStoreController = Get.put(NearbyStoreController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<NearbyStoreController>(
        builder: (NearbyStoreController nearbyStoreController){
          return GoogleMap(
            mapType: MapType.normal,
            trafficEnabled: false,
            markers: nearbyStoreController.markers,
            initialCameraPosition: nearbyStoreController.currentDeviceLocation, //อยากให้แสดงที่ไหน ใส่ initialCameraPosition
            onMapCreated: (GoogleMapController controller) {
              nearbyStoreController.controller.complete(controller);
            },
            myLocationEnabled: true, //จะโชว์ตำแหน่งของเราบน map
            myLocationButtonEnabled: false, //ตำแหน่วที่กดแล้วมาหาฉัน
            zoomControlsEnabled: true, //ปุุ่ม + - ขยายแผนที่
            compassEnabled: false, //เข็มทิศ
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _nearbyStoreController.goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }
}
