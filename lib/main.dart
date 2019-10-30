import 'package:ifuel/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'places_search_map.dart';
import 'search_filter.dart';


void main() async{
  runApp(MaterialApp(
    home: GoogleMapsSampleApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class GoogleMapsSampleApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GoogleMapSampleApp();
  }
}

class _GoogleMapSampleApp extends State<GoogleMapsSampleApp>{
  static String keyword = "gasStation";

  void updateKeyWord(String newKeyword) {
    print(newKeyword);
    setState(() {
      keyword = newKeyword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iFuel',
      home: Scaffold(
        appBar: AppBar(
          title: Text('iFuel - Encontre um Posto'),
          actions: <Widget>[
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                    icon: Icon(Icons.filter_list),
                    tooltip: 'Filter Search',
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    });
              },
            ),
          ],
        ),
        body: PlacesSearchMapSample(keyword),
        endDrawer: SearchFilter(updateKeyWord),
      ),
    );
  }
}
