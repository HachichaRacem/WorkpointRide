import 'package:osmflutter/Users/BottomSheet/MyRides.dart';
import 'package:osmflutter/Users/BottomSheet/want_to_book.dart';
import 'package:osmflutter/Users/widgets/chooseRide.dart';
import 'package:osmflutter/constant/colorsFile.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:intl/intl.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:osmflutter/map/home_example.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  int selectedIndex = 0;
  DateTime now = DateTime.now();
  late DateTime lastDayOfMonth;
  bool isSearchPoPupVisible = false;
  bool listSearchBottomSheet = false;
  bool bottomSheetVisible = true;
  bool myRidesbottomSheetVisible = false;
  bool ridesIsVisible = false;
  late double _height;
  late double _width;
  @override
  void initState() {
    super.initState();
    lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
  }
  _showSearchRides() {
    setState(() {
      isSearchPoPupVisible=true;
      bottomSheetVisible=false;
    });
  }
  _showMyRides() {
    print("tttttttttttttt");
    setState(() {
      myRidesbottomSheetVisible=true;
      listSearchBottomSheet=false;
    });
  }
  showRide() {
    print("tttttttttttttt");
    setState(() {
      ridesIsVisible=!ridesIsVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment(0.8, 1),
              colors: <Color>[
                Color.fromRGBO(94, 149, 180, 1),
                Color.fromRGBO(77, 140, 175, 1),
              ],
              tileMode: TileMode.mirror,
            ),
          ),
        ),
        toolbarHeight: 120.0,
        title: Column(
          children: [
            const SizedBox(height: 16.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: Row(
                children: List.generate(
                  lastDayOfMonth.day,
                  (index) {
                    final currentDate =
                        lastDayOfMonth.add(Duration(days: index + 1));
                    final dayName = DateFormat('EEE').format(currentDate);
                    return Padding(
                      padding: EdgeInsets.only(
                          left: index == 0 ? 16.0 : 0.0, right: 16.0),
                      child: GestureDetector(
                        onTap: () => setState(() {
                          selectedIndex = index;
                        }),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 42.0,
                              width: 42.0,
                              alignment: Alignment.center,
                            
                              child: Text(
                                "${index + 1}",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: selectedIndex == index
                                      ? Colors.white
                                      : colorsFile.titleCard,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),

                            Text(
                              dayName.substring(0, 3),
                              style: TextStyle(
                                fontSize: 16.0,
                                color: selectedIndex == index
                                    ? Colors.white
                                    : Colors.white30,
                                fontWeight: selectedIndex == index
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: (){
          setState(() {
             isSearchPoPupVisible = false;
             listSearchBottomSheet = false;
             bottomSheetVisible = true;
             myRidesbottomSheetVisible = false;
          });
        },
        child: Stack(
          children: [
            // Background Photo
            Positioned(

              child: OldMainExample(),

            ),

            // Content on top of the background
            Visibility(
              visible: bottomSheetVisible,
              child: Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: colorsFile.cardColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(50.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                   // controller: scrollController,
                    child: WantToBook("", "Want to Book a ride ? press + botton!",_showSearchRides),
                  ),
                )
              ),
            ),
            Visibility(
              visible: isSearchPoPupVisible,
              child: Positioned(
                top: 20,
                right: _width / 2 * 0.15,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isSearchPoPupVisible = false;
                      bottomSheetVisible=true;
                    });
                  },
                  child: GlassmorphicContainer(
                    height: 200,
                    width: _width * 0.85,
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
                      padding: const EdgeInsets.fromLTRB(25, 10, 25, 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSearchPoPupVisible = false;
                                    bottomSheetVisible=true;

                                  });
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Color(0xFFFFFFFF), // White color
                                  size: 25.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            decoration: InputDecoration(
                                              labelText: 'Home',
                                              prefixIcon: Container(
                                                width: 37.0,
                                                height: 37.0,
                                                margin: EdgeInsets.only(left:5,right: 10),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(color: Colors.white, width: 2.0,),
                                                  color: Colors.white,
                                                ),
                                                child: Icon(
                                                  Icons.place,
                                                  color: colorsFile.icons,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30.0),
                                                borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 2.0,

                                                ),

                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30.0),
                                                borderSide: BorderSide(
                                                  color: Colors.blue,
                                                  width: 2.0,
                                                ),
                                              ),
                                            ),
                                          )
                                        ),
                                        SizedBox(width: 5),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                            onTap: () {
                            },
                            child:  Center(
                              child: Icon(
                                Icons.swap_vert,
                                color:Colors.white,
                                size: 35,


                              ),
                            )),
                      ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
height: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child:  TextField(
                                            decoration: InputDecoration(
                                              labelText: 'EY Tower',
                                              prefixIcon: Container(
                                                width: 37.0,
                                                height: 37.0,
                                                margin: EdgeInsets.only(left:5,right: 10),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(color: Colors.white, width: 2.0,),
                                                  color: Colors.white,
                                                ),
                                                child: Icon(
                                                  Icons.place,
                                                  color: colorsFile.icons,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30.0),
                                                borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 2.0,

                                                ),

                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30.0),
                                                borderSide: BorderSide(
                                                  color: Colors.blue,
                                                  width: 2.0,
                                                ),
                                              ),
                                            ),
                                          )
                                        ),
                                        SizedBox(width: 10), // Adjust the space between the two icons
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  listSearchBottomSheet=true;
                                                  isSearchPoPupVisible=false;
                                                });
                                              },
                                              child: Container(
                                                height: 45,
                                                width: 45,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white60,

                                                  ),
                                                child:   Center(
                                                  child: ClayContainer(
                                                    color: Colors.white,
                                                    height: 35,
                                                    width: 35,
                                                    borderRadius: 40,
                                                    curveType: CurveType.concave,
                                                    depth: 30,
                                                    spread: 2,
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.send,
                                                        color: colorsFile.buttonIcons,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              )),
                                        ),// Adjust the space between the two icons

                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: listSearchBottomSheet,
              child: Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: colorsFile.cardColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50.0),
                        topRight: Radius.circular(50.0),
                      ),
                    ),
                    child: SingleChildScrollView(
                      //controller: scrollController,
                      child:ChooseRide(_showMyRides,showRide)
                    ),
                  )
              ),
            ),
            Visibility(
              visible: myRidesbottomSheetVisible,
              child: Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: colorsFile.cardColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50.0),
                        topRight: Radius.circular(50.0),
                      ),
                    ),
                    child: SingleChildScrollView(
                      //controller: scrollController,
                        child:MyRides(),
                    ),
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
