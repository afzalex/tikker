import 'package:flutter/material.dart';
import 'package:gallery/components/gallery.dart';

class GalleryContainer extends StatefulWidget {
  GalleryContainer({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _GalleryContainerState createState() => _GalleryContainerState();
}

class _GalleryContainerState extends State<GalleryContainer> {
  void _incrementCounter() {
    setState(() {
      print("I am pressed");
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Gallery(),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
