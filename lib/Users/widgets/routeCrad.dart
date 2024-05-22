import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:osmflutter/constant/colorsFile.dart';

class RouteCard extends StatefulWidget {
  List<dynamic>? schedules;
  Map? driverData;
  bool? isCardSelected;
  int? selectedIndexRoute;
  int? index;

  RouteCard(this.schedules, this.driverData, this.isCardSelected,
      this.selectedIndexRoute, this.index,
      {Key? key})
      : super(key: key);

  @override
  State<RouteCard> createState() => _RouteCardState();
}

class _RouteCardState extends State<RouteCard> {
  final Color _selectedColor = colorsFile.icons;
  final Color _unselectedColor = colorsFile.cardColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(
          right: 16.0,
        ),
        child: GlassmorphicContainer(
          height: 185,
          width: MediaQuery.of(context).size.width * 0.3,
          borderRadius: 15,
          blur: 100,
          alignment: Alignment.center,
          border: 2,
          linearGradient: LinearGradient(
            colors: [
              (widget.isCardSelected! &&
                      widget.selectedIndexRoute == widget.index)
                  ? _selectedColor
                  : _unselectedColor,
              (widget.isCardSelected! &&
                      widget.selectedIndexRoute == widget.index)
                  ? _selectedColor
                  : _unselectedColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderGradient: LinearGradient(
            colors: [
              Colors.white24.withOpacity(0.2),
              Colors.white70.withOpacity(0.2),
            ],
          ),
          child: Container(
              child: Row(children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Center(
                      child: Container(
                        height: 60,
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: colorsFile.borderCircle,
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                            child: SizedBox.fromSize(
                                size: const Size.fromRadius(28),
                                child: Image(
                                  image: AssetImage(
                                    widget.driverData?["image"] ??
                                        "assets/images/homme1.png",
                                  ),
                                  fit: BoxFit.cover,
                                ))),
                      ),
                    ),
                    const SizedBox(height: 13),
                    Center(
                      child: Text(
                        widget.driverData?["firstName"] != null
                            ? (widget.driverData?["firstName"] +
                                " " +
                                widget.driverData?["lastName"])
                            : "Foulen Ben Falten",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          color: (widget.isCardSelected! &&
                                  widget.selectedIndexRoute == widget.index)
                              ? Colors.white
                              : colorsFile.titleCard,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          color: (widget.isCardSelected! &&
                                  widget.selectedIndexRoute == widget.index)
                              ? Colors.white
                              : colorsFile.icons,
                          size: 12,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.driverData?["phoneNumber"] ?? "55 555 555",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            color: (widget.isCardSelected! &&
                                    widget.selectedIndexRoute == widget.index)
                                ? Colors.white
                                : colorsFile.titleCard,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 55,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                (widget.driverData?["availablePlaces"] ?? 0)
                                    .toInt(),
                                (index) => const Icon(
                                  Icons.airline_seat_recline_normal_sharp,
                                  color: colorsFile.buttonIcons,
                                  size: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            (widget.schedules?[widget.index!]['startTime']
                                        as String) !=
                                    null
                                ? (widget.schedules?[widget.index!]['startTime']
                                        as String)
                                    .substring(11, 17)
                                : '00:00',
                            textAlign: TextAlign.end,
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              color: (widget.isCardSelected! &&
                                      widget.selectedIndexRoute == widget.index)
                                  ? Colors.white
                                  : colorsFile.detailColor,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ])),
        ),
      ),
    );
  }
}
