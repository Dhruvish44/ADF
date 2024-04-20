import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ListView with ListTile Example',
      home: Scaffold(
        appBar: AppBar(
          title: Text('ListView with ListTile'),
        ),
        body: ListView.builder(
          itemCount: 20, // Number of items in the list
          itemBuilder: (BuildContext context, int index) {
            // Return a ListTile for each item in the list
            return ListTile(
              leading: CircleAvatar(
                child: Text((index + 1).toString()), // Display item index
              ),
              title: Text('Item ${index + 1}'), // Display item number
              subtitle: Text('Subtitle for Item ${index + 1}'),
              onTap: () {
                // Action to perform when the item is tapped
                print('Tapped on Item ${index + 1}');
              },
            );
          },
        ),
      ),
    );
  }
}
