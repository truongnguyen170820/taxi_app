
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:taxi_app/model/place_item_res.dart';
import 'package:taxi_app/model/steps_res.dart';
import 'package:taxi_app/model/trip_info_res.dart';
import 'package:taxi_app/respository/place_service.dart';
import 'package:taxi_app/utils/color_utils.dart';
import 'package:taxi_app/utils/font_utils.dart';
import 'package:taxi_app/view/car_pickup.dart';
import 'package:taxi_app/view/login_page.dart';
import 'package:taxi_app/view/ride_picker.dart';
import 'package:taxi_app/widget/circle_avatar.dart';
import 'package:taxi_app/widget/common_appbar.dart';
import 'package:taxi_app/widget/custombutton.dart';
import 'package:taxi_app/widget/global.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _tripDistance = 0;
  final Map<String, Marker> _markers = <String, Marker>{};

  GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.gray8,
      key: _scaffoldKey,
      drawer: mainDrawer(),
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: Stack(
          children: [
            GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(37.42796133580664, -122.085749655962),
                  zoom: 14.4746,
                )),
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    title: Text(
                      "Taxi App",
                      style: TextStyle(color: Colors.black),
                    ),
                    leading: FlatButton(
                        onPressed: () {
                          // Scaffold.of(context).openDrawer();
                          print("click menu");
                          _scaffoldKey.currentState.openDrawer();
                        },
                        child: Image.asset(getAssetsImage("ic_menu.png"))),
                    actions: <Widget>[
                      Image.asset(getAssetsImage("ic_notify.png"))
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: RidePicker(onPlaceSelected),
                  ),
                ],
              ),
            ),
            Positioned(left: 20,
              right: 20,
              bottom: 40,
              height: 248,
              child: CarPickup(_tripDistance),
            )
          ],
        ),
      ),
    );
  }

  void onPlaceSelected(PlaceItemRes place, bool fromAddress) {
    var mkId = fromAddress ? "from_address" : "to_address";
    _addMarker(mkId, place);
    _moveCamera();
    _checkDrawPolyline();
  }

  void _addMarker(String mkId, PlaceItemRes place) async {
    // remove old
    _markers.remove(mkId);

    // _mapController.clearMarkers();

    _markers[mkId] = Marker(markerId: MarkerId(mkId),
        position: LatLng(place.lat, place.lng),
        infoWindow: InfoWindow(title: place.name, snippet: place.address)
    );

    // _markers[mkId] = Marker(
    //     mkId,
    //     MarkerOptions(
    //         position: LatLng(place.lat, place.lng),
    //         infoWindowText: InfoWindowText(place.name, place.address)));

    for (var m in _markers.values) {
      // await mapController.(m.o);
    }
  }

//
  void _moveCamera() {
    print("move camera: ");
    print(_markers);

    if (_markers.values.length > 1) {
      var fromLatLng = _markers["from_address"].position;
      var toLatLng = _markers["to_address"].position;

      var sLat, sLng, nLat, nLng;
      if (fromLatLng.latitude <= toLatLng.latitude) {
        sLat = fromLatLng.latitude;
        nLat = toLatLng.latitude;
      } else {
        sLat = toLatLng.latitude;
        nLat = fromLatLng.latitude;
      }

      if (fromLatLng.longitude <= toLatLng.longitude) {
        sLng = fromLatLng.longitude;
        nLng = toLatLng.longitude;
      } else {
        sLng = toLatLng.longitude;
        nLng = fromLatLng.longitude;
      }

      LatLngBounds bounds = LatLngBounds(
          northeast: LatLng(nLat, nLng), southwest: LatLng(sLat, sLng));
      mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    } else {
      mapController.animateCamera(CameraUpdate.newLatLng(
          _markers.values
              .elementAt(0)
              .position));
    }
  }

//
  void _checkDrawPolyline() {
//  remove old polyline
//     mapController.clearPolylines();

    if (_markers.length > 1) {
      var from = _markers["from_address"].position;
      var to = _markers["to_address"].position;
      PlaceService.getStep(
          from.latitude, from.longitude, to.latitude, to.longitude)
          .then((vl) {
        TripInfoRes infoRes = vl;

        _tripDistance = infoRes.distance;
        setState(() {});
        List<StepsRes> rs = infoRes.steps;
        List<LatLng> paths = new List();
        for (var t in rs) {
          paths
              .add(LatLng(t.startLocation.latitude, t.startLocation.longitude));
          paths.add(LatLng(t.endLocation.latitude, t.endLocation.longitude));
        }

// //        print(paths);
//         mapController.addPolyline(PolylineOptions(
//             points: paths, color: Color(0xFF3ADF00).value, width: 10));
      });
    }
  }
    Widget mainDrawer() {
      return Drawer(
        child: Column(
          children: [
            SizedBox(height: setHeight(50)),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: ColorUtils.gray6
                      )
                  )
              ),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: setWidth(16),
                          top: setHeight(32),
                          right: setWidth(16),
                          bottom: setHeight(16)),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorUtils.RED_BACKGROUND
                      ),
                      child: Text("bbb"),
                    ),
                    Text("Nguyễn Văn A",)
                  ]),
            ),

            _buildItem("Ride History", "ic_menu_history.png"),
            _buildItem("Offers", "ic_menu_percent.png"),
            _buildItem("Help & Support", "ic_menu_help.png"),
            _buildItem("Logout", "ic_menu_logout.png", ontap: () {
              showConfirmDialog();
            })
          ],
        ),
      );
    }

    Widget _buildItem(String name, String imageUrl, {Function ontap}) {
      return GestureDetector(
        onTap: ontap,
        child: Container(
          margin: EdgeInsets.only(left: setWidth(16), top: setHeight(40)),
          child: Row(
            children: [
              Image.asset(getAssetsImage(imageUrl)),
              SizedBox(width: setWidth(16)),
              Text(name, style: FontUtils.MEDIUM.copyWith(
                  color: ColorUtils.TEXT_BLACK, fontSize: setSp(16)))
            ],
          ),
        ),
      );
    }

    showConfirmDialog() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              child: Container(
                width: setWidth(310),
                padding: EdgeInsets.all(
                  setHeight(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.logout,
                          size: 30,
                        ),
                        SizedBox(
                          width: setWidth(10),
                        ),
                        Text(
                          "Đăng xuất",
                          style: FontUtils.MEDIUM.copyWith(fontSize: setSp(16)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: setHeight(20),
                    ),
                    Text(
                      "Bạn có muốn đăng xuất khỏi tài khoản đang sử dụng?",
                      style: FontUtils.NORMAL,
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(
                      height: setHeight(20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ButtonCustom(
                          title: "Không",
                          width: setWidth(100),
                          height: setHeight(40),
                          bgColor: Colors.grey,
                          onTap: () {
                            pop(context);
                          },
                        ),
                        ButtonCustom(
                          title: "Có",
                          width: setWidth(100),
                          height: setHeight(40),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => LoginPage()));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
    }
  }



