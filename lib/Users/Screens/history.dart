import 'package:flutter/material.dart';
import 'package:osmflutter/Services/history.dart';
import 'package:osmflutter/Users/widgets/history_card.dart';
import 'package:osmflutter/constant/colorsFile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late double _height;
  late double _width;

  Future _getHistoryByUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userID = prefs.getString("user");
    return await HistoryService().getHistoryByUser(userID!);
  }

  late final Future _getHistoryByUserFuture = _getHistoryByUser();

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: colorsFile.background,
        body: Column(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                ),
                height: _height * 0.09,
                width: _width,
              ),
            ),
            Expanded(
              child: Container(
                width: _width,
                decoration: const BoxDecoration(
                  color: colorsFile.cardColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
                child: FutureBuilder(
                    future: _getHistoryByUserFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final response = snapshot.data;
                        if (response.data.isNotEmpty) {
                          return SingleChildScrollView(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 16.0, top: 8),
                              child: Column(
                                children: List.generate(
                                  response.data.length,
                                  (index) {
                                    final colorValue = (response.data[index]
                                            ['color'] as String)
                                        .replaceAll("#", "0xFF");
                                    final cardColor =
                                        Color(int.parse(colorValue));
                                    return HistoryCard(
                                      color: cardColor,
                                      createdAt: response.data[index]
                                          ['createdAt'],
                                      date: response.data[index]['date']
                                          .split("T")[0],
                                      time: response.data[index]['time'],
                                      direction: response.data[index]
                                          ['direction'],
                                      height: _height * 0.15,
                                      width: _width * 0.8,
                                      title: response.data[index]['title'],
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        } else {
                          return const Center(
                            child: Text("Nothing to show yet"),
                          );
                        }
                      }
                      return const Center(child: CircularProgressIndicator());
                    }),
              ),
            ),
          ],
        ));
  }
}
