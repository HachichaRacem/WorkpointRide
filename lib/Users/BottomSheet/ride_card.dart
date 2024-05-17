import 'package:clay_containers/constants.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:osmflutter/Services/reservation.dart';
import 'package:osmflutter/constant/colorsFile.dart';
import 'package:url_launcher/url_launcher.dart';

class RideCard extends StatelessWidget {
  final Map<String, dynamic>? selectedRouteCardInfo;
  final Function()? updateRides;
  const RideCard({super.key, this.selectedRouteCardInfo, this.updateRides});

  _launchPhone(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _deleteRide() async {
    await Reservation().deleteReservationByID(selectedRouteCardInfo!['id']);
    updateRides!();
    debugPrint("Hi");
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return GlassmorphicContainer(
      height: 200,
      width: 130,
      borderRadius: 15,
      blur: 100,
      alignment: Alignment.center,
      border: 2,
      linearGradient: const LinearGradient(
          colors: [Color(0xFFD8E6EE), Color(0xFFD8E6EE)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter),
      borderGradient: LinearGradient(colors: [
        Colors.white24.withOpacity(0.2),
        Colors.white70.withOpacity(0.2)
      ]),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SizedBox(
                  //   height: 10,
                  // ),
                  Container(
                    height: 70,
                    width: 70,
                    padding: const EdgeInsets.all(5), // Border width
                    decoration: const BoxDecoration(
                        color: colorsFile.borderCircle, shape: BoxShape.circle),
                    child: ClipOval(
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(30), // Image radius
                        child: Image(
                          image: AssetImage(selectedRouteCardInfo!['image'] ??
                              "assets/images/homme1.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        selectedRouteCardInfo!['driverName'] ??
                            "Foulen Ben Falten",
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: colorsFile.titleCard),
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: _deleteRide,
                          icon: const Icon(
                            Icons.delete,
                            color: colorsFile.skyBlue,
                          )),
                    ],
                  ),

                  Row(
                    children: [
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: Stack(
                          children: [
                            ClayContainer(
                              color: Colors.white,
                              height: 30,
                              width: 30,
                              borderRadius: 50,
                              curveType: CurveType.concave,
                              depth: 20,
                              spread: 1,
                            ),
                            GestureDetector(
                              onTap: () {
                                print("heloooo");
                                _launchPhone(
                                    selectedRouteCardInfo!['driverNum']);
                              },
                              child: Center(
                                child: ClayContainer(
                                  color: Colors.white,
                                  height: 20,
                                  width: 20,
                                  borderRadius: 40,
                                  curveType: CurveType.convex,
                                  depth: 30,
                                  spread: 1,
                                  child: const Center(
                                    child: Icon(
                                      Icons.phone,
                                      size: 20,
                                      color: colorsFile.buttonIcons,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        selectedRouteCardInfo!['driverNum'] ?? "55 555 555",
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: colorsFile.titleCard),
                      ),
                    ],
                  ),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            selectedRouteCardInfo!['type'],
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: colorsFile.detailColor),
                          ),
                        ],
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            selectedRouteCardInfo!['scheduleStartTime'] != null
                                ? DateFormat("HH:mm").format(DateTime.parse(
                                    selectedRouteCardInfo![
                                        'scheduleStartTime']))
                                : '00:00',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                            style: GoogleFonts.montserrat(
                                fontSize: 12, color: colorsFile.detailColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
