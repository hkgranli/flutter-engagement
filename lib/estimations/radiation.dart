import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart' show ModelViewer;

class RadiationHousePage extends StatelessWidget {
  const RadiationHousePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // the widget will draw infinite pixels when sharing body without expanded
    // <https://stackoverflow.com/questions/56354923/flutter-bottom-overflowed-by-infinity-pixels>

    return Expanded(
      child: Center(
        child: ModelViewer(
          src: 'assets/models/house_colorized_5.glb',
          alt: "A 3D model of a house",
          ar: false,
          autoRotate: false,
          cameraControls: true,
          maxCameraOrbit: "auto 90deg auto",
          backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
          exposure: 0.5,
          shadowIntensity: 1,
          shadowSoftness: 0,
          key: UniqueKey(), // key ensures the widget is updated
        ),
      ),
    );
    // maxOrbit ensures user cannot look under the model
  }
}

class RadiationContextPage extends StatelessWidget {
  const RadiationContextPage({
    super.key,
    required this.colorAll,
  });

  final bool colorAll;

  @override
  Widget build(BuildContext context) {
    // the widget will draw infinite pixels when sharing body without expanded
    // <https://stackoverflow.com/questions/56354923/flutter-bottom-overflowed-by-infinity-pixels>

    return Expanded(
      child: Center(
        child: ModelViewer(
          //src: 'assets/models/big_rad_color.glb',
          src: colorAll
              ? 'assets/models/colorized_model.glb'
              : 'assets/models/colorized_model_kg_only.glb',
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
