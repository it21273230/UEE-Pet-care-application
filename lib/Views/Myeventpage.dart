import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../widgets/events_feed_widget.dart';
import 'map_page.dart';

// ... Your MapPage and EventsFeed widgets ...

class Myeventpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1, // Use flex to make MapPage take half of the screen
            child: MapPage(),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(10.0), // Add padding here
              child: SingleChildScrollView(
                child: EventsFeed(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
