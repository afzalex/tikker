import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'components/gallery_container.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Gallery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GalleryContainer(title: 'My Gallery'),
    );
  }
}


// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       builder: (context, widget) => ResponsiveWrapper.builder(
//           child,
//           maxWidth: 1200,
//           minWidth: 480,
//           defaultScale: true,
//           breakpoints: [
//             ResponsiveBreakpoint.resize(480, name: MOBILE),
//             ResponsiveBreakpoint.autoScale(800, name: TABLET),
//             ResponsiveBreakpoint.resize(1000, name: DESKTOP),
//           ],
//           background: Container(color: Color(0xFFF5F5F5))),
//       initialRoute: "/",
//     );
//   }
// }