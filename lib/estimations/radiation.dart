import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart' show ModelViewer;

class RadiationPage extends StatelessWidget {
  const RadiationPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // the widget will draw infinite pixels when sharing body without expanded
    // <https://stackoverflow.com/questions/56354923/flutter-bottom-overflowed-by-infinity-pixels>

    return Expanded(
      child: Center(
        child: ModelViewer(
          src: 'assets/models/house_colorized_2.glb',
          alt: "A 3D model of a house",
          ar: false,
          autoRotate: false,
          cameraControls: true,
          maxCameraOrbit: "auto 90deg auto",
          backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
          exposure: 0.35,
          shadowIntensity: 0.5,
          shadowSoftness: 0,
          key: UniqueKey(), // key ensures the widget is updated
        ),
      ),
    );
    // maxOrbit ensures user cannot look under the model
  }
}
