import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GridView Example',
      home: Scaffold(
        appBar: AppBar(
          title: Text('GridView Example'),
        ),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns in the grid
            crossAxisSpacing: 10.0, // Spacing between columns
            mainAxisSpacing: 10.0, // Spacing between rows
          ),
          itemCount: 20, // Number of items in the grid
          itemBuilder: (BuildContext context, int index) {
            // Return a container for each grid item
            return Container(
              color: Colors.green,
              child: Center(
                child: Text(
                  'Item ${index + 1}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
