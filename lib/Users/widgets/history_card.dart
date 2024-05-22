import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:osmflutter/constant/colorsFile.dart';

class HistoryCard extends StatelessWidget {
  final double height;
  final double width;
  final String title;
  final Color color;
  final String direction;
  final String date;
  final String? time;
  final String createdAt;
  const HistoryCard(
      {super.key,
      required this.title,
      required this.color,
      required this.direction,
      required this.date,
      required this.time,
      required this.height,
      required this.width,
      required this.createdAt});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0, top: 16.0),
      child: GlassmorphicContainer(
        height: height,
        width: width,
        borderRadius: 15,
        blur: 100,
        alignment: Alignment.center,
        border: 2,
        linearGradient: const LinearGradient(
          colors: [Color(0xFFD8E6EE), Color(0xFFD8E6EE)],
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
          child: Row(
            children: [
              const SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                          height: 10), // Increased height for more top padding
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                          height: 15), // Increased height for more spacing
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.route_sharp,
                            color: colorsFile.historyIcon,
                            size: 18,
                          ),
                          const SizedBox(
                              width: 3), // Added space between icon and text
                          Text(
                            direction,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: colorsFile.titleCard,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                          height: 10), // Increased height for more spacing
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                color: colorsFile.historyIcon,
                                size: 18,
                              ),
                              const SizedBox(
                                  width:
                                      3), // Added space between icon and text
                              Text(
                                time != null
                                    ? "$date at ${TimeOfDay.fromDateTime(DateTime.parse(time!)).format(context)}"
                                    : date,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: colorsFile.titleCard,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              TimeOfDay.fromDateTime(DateTime.parse(createdAt))
                                  .format(context),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                                color: colorsFile.titleCard,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(height: 15),  // Added more space at the bottom
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
