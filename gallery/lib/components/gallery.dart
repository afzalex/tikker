import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Gallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ContentPager>(
        create: (context) => ContentPager(), child: GalleryBox());
  }

  // @override
  // State<StatefulWidget> createState() => _GalleryState();
}

class ContentPager extends ChangeNotifier {
  bool _isDisposed = false;
  var count = 10;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}

class GalleryBox extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GalleryBoxState();
}

class _GalleryBoxState extends State<GalleryBox> {
  final Future<String> _calculation = Future<String>.delayed(
    const Duration(seconds: 2),
    () => 'Data Loaded',
  );

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),

        // Try 03
        // child: CustomScrollView(
        //   slivers: <Widget>[
        //     SliverPadding(
        //         padding: const EdgeInsets.all(10),
        //         sliver: SliverGrid(
        //           gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        //             maxCrossAxisExtent: 200.0,
        //             mainAxisSpacing: 10.0,
        //             crossAxisSpacing: 10.0,
        //             childAspectRatio: 4.0,
        //           ),
        //           delegate: SliverChildBuilderDelegate(
        //             (BuildContext context, int index) {
        //               var contentCache = Provider.of<ContentPager>(context);
        //               return Container(
        //                 alignment: Alignment.center,
        //                 color: Colors.teal[100 * (index % 9)],
        //                 child: Text('grid item $index'),
        //               );
        //             },
        //             childCount: 10,
        //           ),
        //         ))
        //   ],
        // )

        // Try 01
        child: FutureBuilder<String>(
          future: _calculation,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey
              ),
              child: Center(
                child: Text("Hello")
              ),
            );
          },
        ),

        // Try 02
        // child: CustomScrollView(
        //   primary: false,
        //   slivers: <Widget>[
        //     SliverPadding(
        //       padding: const EdgeInsets.all(5),
        //       sliver: SliverGrid.count(
        //         crossAxisSpacing: 5,
        //         mainAxisSpacing: 5,
        //         crossAxisCount: 5,
        //         children: <Widget>[
        //           Container(
        //             padding: const EdgeInsets.all(8),
        //             child: const Text("He'd have you all unravel at the"),
        //             color: Colors.green[100],
        //           ),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
        );
  }
}
