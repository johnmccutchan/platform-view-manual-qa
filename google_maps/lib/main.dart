import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';
import 'dart:ui';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  AndroidMapRenderer mapRenderer = AndroidMapRenderer.latest;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    // Don't use hybrid composition.
    mapsImplementation.useAndroidViewSurface = false;
    // Use latest renderer.
    mapRenderer = await mapsImplementation
        .initializeWithRenderer(AndroidMapRenderer.latest);
    print(mapRenderer);
  }
  print('main done');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: TestScreen(),
    );
  }
}

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _setRedMarkers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: const CameraPosition(
                target: LatLng(37.3861, -122.0839),
                zoom: 14,
              ),
              markers: _markers,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _button('RED', Colors.red, _setRedMarkers),
                _button('GREEN', Colors.green, _setGreenMarkers),
                _button('BLUE', Colors.blue, _setBlueMarkers),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _button(String text, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: color,
        padding: const EdgeInsets.all(16),
        child: Text(text),
      ),
    );
  }

  void _setRedMarkers() async {
    _setMarkers('images/red.png');
  }

  void _setGreenMarkers() async {
    _setMarkers('images/green.png');
  }

  void _setBlueMarkers() async {
    _setMarkers('images/blue.png');
  }

  void _setMarkers(String assetPath) async {
    Uint8List? byteData = await _getBytesFromAsset(assetPath, 30);
    if (byteData == null) return;

    BitmapDescriptor icon = BitmapDescriptor.fromBytes(byteData);

    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('1'),
          position: const LatLng(37.3861, -122.0839),
          icon: icon,
        ),
        Marker(
          markerId: const MarkerId('2'),
          position: const LatLng(37.3761, -122.0839),
          icon: icon,
        ),
        Marker(
          markerId: const MarkerId('3'),
          position: const LatLng(37.3961, -122.0839),
          icon: icon,
        ),
      };
    });
  }

  Future<Uint8List?> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))
        ?.buffer
        .asUint8List();
  }
}
