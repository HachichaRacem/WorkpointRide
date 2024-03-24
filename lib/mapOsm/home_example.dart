import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:osmflutter/shared_preferences/shared_preferences.dart';
import 'package:osmflutter/GoogleMaps/googlemaps.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:osmflutter/mapOsm/search_example.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:osmflutter/constant/colorsFile.dart';

void main() {
  runApp(MaterialApp(
    home: MapsGoogleExample(),
  ));
}

class OldMainExample extends StatefulWidget {
  OldMainExample({Key? key}) : super(key: key);

  @override
  _MainExampleState createState() => _MainExampleState();
}

class _MainExampleState extends State<OldMainExample>
    with OSMMixinObserver, TickerProviderStateMixin {
  late MapController controller;

  late GlobalKey<ScaffoldState> scaffoldKey;
  Key mapGlobalkey = UniqueKey();
  ValueNotifier<bool> zoomNotifierActivation = ValueNotifier(false);
  ValueNotifier<bool> visibilityZoomNotifierActivation = ValueNotifier(false);
  ValueNotifier<bool> advPickerNotifierActivation = ValueNotifier(false);
  ValueNotifier<bool> visibilityOSMLayers = ValueNotifier(false);
  ValueNotifier<double> positionOSMLayers = ValueNotifier(-200);
  ValueNotifier<GeoPoint?> centerMap = ValueNotifier(null);
  ValueNotifier<bool> trackingNotifier = ValueNotifier(false);
  ValueNotifier<bool> showFab = ValueNotifier(true);
  ValueNotifier<GeoPoint?> lastGeoPoint = ValueNotifier(null);
  ValueNotifier<bool> beginDrawRoad = ValueNotifier(false);
  List<GeoPoint> pointsRoad = [];
  Timer? timer;
  int x = 0;
  late AnimationController animationController;
  late Animation<double> animation =
      Tween<double>(begin: 0, end: 2 * pi).animate(animationController);
  final ValueNotifier<int> mapRotate = ValueNotifier(0);
  RoadInfo? _roadInfo;

  //Google Maps Api

  //Completer<GoogleMapController> _controller = Completer();

  // Markers

  List<Marker> myMarker = [];

  List<Marker> markers = [];

  dynamic current_lat, current_lng;
  bool check = false;

  Future<void> getCurrentLocation() async {
    print("--------Inside the get location method --------");

    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {});

    Position position = await Geolocator.getCurrentPosition();

    setState(() {
      current_lat = position.latitude;
      current_lng = position.longitude;

      check = true;

      print("Current Lat & Lng is: ");
      print(current_lat);
      print(current_lng);

      myMarker.add(Marker(
        markerId: const MarkerId("First"),
        position: LatLng(current_lng, current_lng),
        infoWindow: const InfoWindow(title: "Current Location"),
      ));
    });

    //storing values in shared preferences

    print("Current lat & lng is ${current_lng} : ${current_lat}" );
    //setting
    sharedpreferences.setlat(current_lat);
    sharedpreferences.setlng(current_lng);



  }

  @override
  void initState() {
    super.initState();

    //Getting user location


    getCurrentLocation();

    controller = MapController.withPosition(
      initPosition: GeoPoint(
        latitude: 36.8065,
        longitude: 10.1815,
      ),
    );

    controller.addObserver(this);
    scaffoldKey = GlobalKey<ScaffoldState>();
    controller.listenerMapLongTapping.addListener(() async {
      if (controller.listenerMapLongTapping.value != null) {
        print(controller.listenerMapLongTapping.value);
        final randNum = Random.secure().nextInt(100).toString();
        print(randNum);
        await controller
            .changeLocation(controller.listenerMapLongTapping.value!);
      }
    });
    controller.listenerMapSingleTapping.addListener(() async {
      if (controller.listenerMapSingleTapping.value != null) {
        print(controller.listenerMapSingleTapping.value);
        if (beginDrawRoad.value) {
          pointsRoad.add(controller.listenerMapSingleTapping.value!);
          await controller.addMarker(
            controller.listenerMapSingleTapping.value!,
            markerIcon: MarkerIcon(
              icon: Icon(
                Icons.person_pin_circle,
                color: Colors.amber,
                size: 48,
              ),
            ),
          );
          if (pointsRoad.length >= 2 && showFab.value) {
            roadActionBt(context);
          }
        } else if (lastGeoPoint.value != null) {
          await controller.changeLocationMarker(
            oldLocation: lastGeoPoint.value!,
            newLocation: controller.listenerMapSingleTapping.value!,
          );
          lastGeoPoint.value = controller.listenerMapSingleTapping.value;
        } else {
          await controller.addMarker(
            controller.listenerMapSingleTapping.value!,
            markerIcon: MarkerIcon(
              icon: Icon(
                Icons.person_pin,
                color: Colors.red,
                size: 48,
              ),
            ),
            iconAnchor: IconAnchor(
              anchor: Anchor.top,
            ),
          );
          lastGeoPoint.value = controller.listenerMapSingleTapping.value;
        }
      }
    });
    controller.listenerRegionIsChanging.addListener(() async {
      if (controller.listenerRegionIsChanging.value != null) {
        print(controller.listenerRegionIsChanging.value);
        centerMap.value = controller.listenerRegionIsChanging.value!.center;
      }
    });
    animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
    );
  }

  Future<void> mapIsInitialized() async {
    await controller.setZoom(zoomLevel: 12);

    final bounds = await controller.bounds;
    print(bounds.toString());
  }

  @override
  Future<void> mapIsReady(bool isReady) async {
    if (isReady) {
      await mapIsInitialized();
    }
  }

  @override
  void onRoadTap(RoadInfo road) {
    super.onRoadTap(road);
    debugPrint("road:" + road.toString());
    Future.microtask(() async {
      await controller.removeMarkers(road.route);
      await controller.removeRoad(roadKey: road.key);
    });
  }

  @override
  void dispose() {
    if (timer != null && timer!.isActive) {
      timer?.cancel();
    }

    animationController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: <Widget>[
          Builder(builder: (ctx) {
            return GestureDetector(
              onLongPress: () => drawMultiRoads(),
              onDoubleTap: () async {
                await controller.clearAllRoads();
                await controller.removeLastRoad();
                await controller.removeMarkers(await controller.geopoints);
              },
              child: ClayContainer(
                color: Colors.white,
                height: 50,
                width: 50,
                borderRadius: 40,
                curveType: CurveType.concave,
                depth: 30,
                spread: 2,
                child: Center(
                  child: IconButton(
                    onPressed: () {
                      beginDrawRoad.value = true;
                    },
                    icon: Icon(
                      Icons.route,
                      color: colorsFile.icons,
                    ),
                  ),
                ),
              ),
            );
          }),
          SizedBox(
            width: 5,
          ),
          ClayContainer(
            color: Colors.white,
            height: 50,
            width: 50,
            borderRadius: 40,
            curveType: CurveType.concave,
            depth: 30,
            spread: 2,
            child: Center(
              child: IconButton(
                onPressed: () async {
                  visibilityZoomNotifierActivation.value =
                      !visibilityZoomNotifierActivation.value;
                  zoomNotifierActivation.value = !zoomNotifierActivation.value;
                },
                icon: Icon(
                  Icons.zoom_out_map,
                  color: colorsFile.icons,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          ClayContainer(
            color: Colors.white,
            height: 50,
            width: 50,
            borderRadius: 40,
            curveType: CurveType.concave,
            depth: 30,
            spread: 2,
            child: Center(
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchPage(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.search,
                  color: colorsFile.icons,
                ),
              ),
            ),
          ),
        ],
      ),
      // appBar: AppBar(
      //   actions: <Widget>[
      //     Builder(builder: (ctx) {
      //       return GestureDetector(
      //         onLongPress: () => drawMultiRoads(),
      //         onDoubleTap: () async {
      //           await controller.clearAllRoads();
      //             await controller.removeLastRoad();
      //             await controller.removeMarkers(await controller.geopoints);
      //         },
      //         child: 
      //         ClayContainer(
      //               color: Colors.white,
      //               height: 50,
      //               width: 50,
      //               borderRadius: 40,
      //               curveType: CurveType.concave,
      //               depth: 30,
      //               spread: 2,
      //               child: Center(
      //                 child: 
      //                 IconButton(
      //           onPressed: () {
      //             beginDrawRoad.value = true;
      //           },
      //           icon: Icon(Icons.route,color: colorsFile.icons,),
      //         ),
      //               ),
      //             ),

      //       );
      //     }),
      //     SizedBox(width: 5,),
      //       ClayContainer(
      //               color: Colors.white,
      //               height: 50,
      //               width: 50,
      //               borderRadius: 40,
      //               curveType: CurveType.concave,
      //               depth: 30,
      //               spread: 2,
      //               child: Center(
      //                 child:IconButton(
      //       onPressed: () async {
      //         visibilityZoomNotifierActivation.value =
      //             !visibilityZoomNotifierActivation.value;
      //         zoomNotifierActivation.value = !zoomNotifierActivation.value;
      //       },
      //       icon: Icon(Icons.zoom_out_map ,color: colorsFile.icons,),
      //               ),
      //             ),
            
      //     ),
      //     SizedBox(width: 5,),

      //     ClayContainer(
      //               color: Colors.white,
      //               height: 50,
      //               width: 50,
      //               borderRadius: 40,
      //               curveType: CurveType.concave,
      //               depth: 30,
      //               spread: 2,
      //               child: Center(
      //                 child:IconButton(
      //       onPressed: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => SearchPage(),
      //           ),
      //         );
      //       },
      //       icon: Icon(Icons.search,color: colorsFile.icons,),
      //     ),
      //               ),
      //             ),
      //   ],
      // ),
      body: Container(
        child: Stack(
          children: [
            //Osm Code
            // OSMFlutter(
            //   controller: controller,
            //   osmOption: OSMOption(
            //     enableRotationByGesture: true,
            //     zoomOption: ZoomOption(
            //       initZoom: 13,
            //       minZoomLevel: 3,
            //       maxZoomLevel: 19,
            //       stepZoom: 1.0,
            //     ),
            //     userLocationMarker: UserLocationMaker(
            //         personMarker: MarkerIcon(
            //           iconWidget: SizedBox(
            //             width: 32,
            //             height: 64,
            //             child: Image.asset(
            //               "assets/images/directionIcon.png",
            //               scale: .3,
            //             ),
            //           ),
            //         ),
            //         directionArrowMarker: MarkerIcon(
            //           iconWidget: SizedBox(
            //             width: 32,
            //             height: 64,
            //             child: Image.asset(
            //               "assets/images/directionIcon.png",
            //               scale: .3,
            //             ),
            //           ),
            //         )),
            //     roadConfiguration: RoadOption(
            //       roadColor: Colors.blueAccent,
            //     ),
            //     markerOption: MarkerOption(
            //       defaultMarker: MarkerIcon(
            //         icon: Icon(
            //           Icons.home,
            //           color: Colors.orange,
            //           size: 32,
            //         ),
            //       ),
            //       advancedPickerMarker: MarkerIcon(
            //         icon: Icon(
            //           Icons.location_searching,
            //           color: Colors.green,
            //           size: 56,
            //         ),
            //       ),
            //     ),
            //     showContributorBadgeForOSM: false,
            //     showDefaultInfoWindow: false,
            //   ),
            //   mapIsLoading: Center(
            //     child: Column(
            //       mainAxisSize: MainAxisSize.min,
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         CircularProgressIndicator(),
            //         Text("Map is Loading.."),
            //       ],
            //     ),
            //   ),
            //   onMapIsReady: (isReady) {
            //     if (isReady) {
            //       print("map is ready");
            //     }
            //   },
            //   onLocationChanged: (myLocation) {
            //     print('user location :$myLocation');
            //   },
            //   onGeoPointClicked: (geoPoint) async {
            //     if (geoPoint ==
            //         GeoPoint(
            //           latitude: 47.442475,
            //           longitude: 8.4680389,
            //         )) {
            //       final newGeoPoint = GeoPoint(
            //         latitude: 47.4517782,
            //         longitude: 8.4716146,
            //       );
            //     }
            //   },
            // ),
            //Google Maps Api code
            check == true
                ? GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: LatLng(current_lat, current_lng), zoom: 14.5))
                : Center(
                    child: Text(
                    "Map is Loading",
                    style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  )),
            Positioned(
              bottom: 10,
              left: 10,
              child: ValueListenableBuilder<bool>(
                valueListenable: advPickerNotifierActivation,
                builder: (ctx, visible, child) {
                  return Visibility(
                    visible: visible,
                    child: AnimatedOpacity(
                      opacity: visible ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 500),
                      child: child,
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: ValueListenableBuilder<bool>(
                valueListenable: visibilityZoomNotifierActivation,
                builder: (ctx, visibility, child) {
                  return Visibility(
                    visible: visibility,
                    child: child!,
                  );
                },
                child: ValueListenableBuilder<bool>(
                  valueListenable: zoomNotifierActivation,
                  builder: (ctx, isVisible, child) {
                    return AnimatedOpacity(
                      opacity: isVisible ? 1.0 : 0.0,
                      onEnd: () {
                        visibilityZoomNotifierActivation.value = isVisible;
                      },
                      duration: Duration(milliseconds: 500),
                      child: child,
                    );
                  },
                  child: Column(
                    children: [
                      ClayContainer(
                        color: Colors.white,
                        height: 50,
                        width: 50,
                        borderRadius: 40,
                        curveType: CurveType.concave,
                        depth: 30,
                        spread: 2,
                        child: Center(
                          child: ElevatedButton(
                            child: Icon(
                              Icons.add,
                              color: colorsFile.icons,
                            ),
                            onPressed: () async {
                              controller.zoomIn();
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      ClayContainer(
                        color: Colors.white,
                        height: 50,
                        width: 50,
                        borderRadius: 40,
                        curveType: CurveType.concave,
                        depth: 30,
                        spread: 2,
                        child: Center(
                            child: ElevatedButton(
                          child: Icon(
                            Icons.remove,
                            color: colorsFile.icons,
                          ),
                          onPressed: () async {
                            controller.zoomOut();
                          },
                        )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: visibilityOSMLayers,
              builder: (ctx, isVisible, child) {
                if (!isVisible) {
                  return SizedBox.shrink();
                }
                return child!;
              },
            ),
            if (_roadInfo != null)
              Positioned(
                top: 10,
                left: 10,
                child: RoadInformationWidget(
                  duration:
                      "${Duration(seconds: _roadInfo!.duration!.toInt()).inMinutes} minutes",
                  distance: "${_roadInfo!.distance} Km",
                  roadInfo: _roadInfo!.route.toString(),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: showFab,
        builder: (ctx, isShow, child) {
          if (!isShow) {
            return SizedBox.shrink();
          }
          return child!;
        },
        child: PointerInterceptor(
          child: FloatingActionButton(
            key: UniqueKey(),
            heroTag: "locationUser",
            onPressed: () async {
              if (!trackingNotifier.value) {
                await controller.currentLocation();
                await controller.enableTracking(
                  enableStopFollow: true,
                  disableUserMarkerRotation: false,
                  anchor: Anchor.left,
                );
              } else {
                await controller.disabledTracking();
              }
              trackingNotifier.value = !trackingNotifier.value;
            },
            child: Column(
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: trackingNotifier,
                  builder: (ctx, isTracking, _) {
                    if (isTracking) {
                      return Container(
                          child: Center(
                        child: ClayContainer(
                          color: Colors.white,
                          height: 50,
                          width: 50,
                          borderRadius: 40,
                          curveType: CurveType.concave,
                          depth: 30,
                          spread: 2,
                          child: Center(
                            child: Icon(
                              Icons.send,
                              color: colorsFile.icons,
                            ),
                          ),
                        ),
                      ));
                    }
                    return Container(
                        child: Center(
                      child: ClayContainer(
                        color: Colors.white,
                        height: 50,
                        width: 50,
                        borderRadius: 40,
                        curveType: CurveType.concave,
                        depth: 30,
                        spread: 2,
                        child: Center(
                          child: Icon(
                            Icons.my_location,
                            color: colorsFile.icons,
                          ),
                        ),
                      ),
                    ));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void roadActionBt(BuildContext ctx) async {
    try {
      showFab.value = false;
      ValueNotifier<RoadType> notifierRoadType = ValueNotifier(RoadType.car);

      final bottomPersistant = scaffoldKey.currentState!.showBottomSheet(
        (ctx) {
          return PointerInterceptor(
            child: RoadTypeChoiceWidget(
              setValueCallback: (roadType) {
                notifierRoadType.value = roadType;
              },
            ),
          );
        },
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      );
      await bottomPersistant.closed.then((roadType) async {
        showFab.value = true;
        beginDrawRoad.value = false;
        RoadInfo roadInformation = await controller.drawRoad(
          pointsRoad.first,
          pointsRoad.last,
          roadType: notifierRoadType.value,
          intersectPoint:
              pointsRoad.getRange(1, pointsRoad.length - 1).toList(),
          roadOption: RoadOption(
            roadWidth: 10,
            roadColor: Colors.blue,
            zoomInto: true,
          ),
        );
        pointsRoad.clear();

        // Update _roadInfo with the newly drawn road information
        setState(() {
          _roadInfo = roadInformation;
        });
      });
    } on RoadException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${e.errorMessage()}",
          ),
        ),
      );
    }
  }

  @override
  Future<void> mapRestored() async {
    super.mapRestored();
    print("log map restored");
  }

  void drawMultiRoads() async {
    final configs = [
      MultiRoadConfiguration(
        startPoint: GeoPoint(
          latitude: 47.4834379430,
          longitude: 8.4638911095,
        ),
        destinationPoint: GeoPoint(
          latitude: 47.4046149269,
          longitude: 8.5046595453,
        ),
      ),
      MultiRoadConfiguration(
          startPoint: GeoPoint(
            latitude: 47.4814981476,
            longitude: 8.5244329867,
          ),
          destinationPoint: GeoPoint(
            latitude: 47.3982152237,
            longitude: 8.4129691189,
          ),
          roadOptionConfiguration: MultiRoadOption(
            roadColor: Colors.orange,
          )),
      MultiRoadConfiguration(
        startPoint: GeoPoint(
          latitude: 47.4519015578,
          longitude: 8.4371175094,
        ),
        destinationPoint: GeoPoint(
          latitude: 47.4321999727,
          longitude: 8.5147623089,
        ),
      ),
    ];
    final listRoadInfo = await controller.drawMultipleRoad(
      configs,
      commonRoadOption: MultiRoadOption(
        roadColor: Colors.red,
      ),
    );
    print(listRoadInfo);
  }

  Future<void> drawRoadManually() async {
    final encoded =
        "mfp_I__vpAqJ`@wUrCa\\dCgGig@{DwWq@cf@lG{m@bDiQrCkGqImHu@cY`CcP@sDb@e@hD_LjKkRt@InHpCD`F";
    final list = await encoded.toListGeo();
    await controller.drawRoadManually(
      list,
      RoadOption(
        zoomInto: true,
        roadColor: Colors.blueAccent,
      ),
    );
  }
}

class RoadTypeChoiceWidget extends StatelessWidget {
  final Function(RoadType road) setValueCallback;

  RoadTypeChoiceWidget({
    required this.setValueCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      child: PopScope(
        canPop: false,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: TextButton(
            onLongPress: () {},
            onPressed: () {
              setValueCallback(RoadType.car);
              Navigator.pop(context, RoadType.car);
            },
            child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white60,
                ),
                child: Center(
                  child: ClayContainer(
                    color: Colors.white,
                    height: 50,
                    width: 50,
                    borderRadius: 40,
                    curveType: CurveType.concave,
                    depth: 30,
                    spread: 2,
                    child: Center(
                      child: Icon(
                        Icons.route_sharp,
                        color: colorsFile.icons,
                      ),
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }
}

class RoadInformationWidget extends StatelessWidget {
  final String duration;
  final String distance;
  final String roadInfo;

  const RoadInformationWidget({
    required this.duration,
    required this.distance,
    required this.roadInfo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      height: 150,
      width: 250,
      borderRadius: 15,
      blur: 2,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(
        colors: [
          Color(0xFF003A5A).withOpacity(0.37),
          Color(0xFF003A5A).withOpacity(1),
          Color(0xFF003A5A).withOpacity(0.36),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      borderGradient: LinearGradient(
        colors: [
          Color(0xFF003A5A).withOpacity(0.37),
          Color(0xFF003A5A).withOpacity(1),
          Color(0xFF003A5A).withOpacity(0.36),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 10, 10, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'roadInfo: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          for (int i = 0; i < roadInfo.length; i += 1000) {
                            int end = (i + 1000 < roadInfo.length)
                                ? i + 1000
                                : roadInfo.length;
                            print(roadInfo.substring(i, end));
                          }
                          // Add the function to close the card here
                        },
                      ),
                    ],
                  ),
                  Text(
                    'Distance: $distance',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // Other road information widgets...
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
