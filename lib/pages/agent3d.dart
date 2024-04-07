import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

class AgentPage extends StatefulWidget {
  const AgentPage({Key? key}) : super(key: key);

  @override
  State<AgentPage> createState() => _AgentPageState();
}

class _AgentPageState extends State<AgentPage> {
  Flutter3DController controller = Flutter3DController();
  String? chosenAnimation;
  String? chosenTexture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Column(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     FloatingActionButton.small(
      //       onPressed: () {
      //         controller.playAnimation();
      //       },
      //       child: const Icon(Icons.play_arrow),
      //     ),
      //     const SizedBox(
      //       height: 4,
      //     ),
      //     // FloatingActionButton.small(
      //     //   onPressed: () {
      //     //     controller.pauseAnimation();
      //     //   },
      //     //   child: const Icon(Icons.pause),
      //     // ),
      //     // const SizedBox(
      //     //   height: 4,
      //     // ),
      //     // FloatingActionButton.small(
      //     //   onPressed: () {
      //     //     controller.resetAnimation();
      //     //   },
      //     //   child: const Icon(Icons.replay_circle_filled),
      //     // ),
      //     // const SizedBox(
      //     //   height: 4,
      //     // ),
      //     // FloatingActionButton.small(
      //     //   onPressed: () async {
      //     //     List<String> availableAnimations =
      //     //         await controller.getAvailableAnimations();
      //     //     print(
      //     //         'Animations : $availableAnimations -- Length : ${availableAnimations.length}');
      //     //     // chosenAnimation =
      //     //     //     await showPickerDialog(availableAnimations, chosenAnimation);
      //     //     controller.playAnimation(animationName: chosenAnimation);
      //     //   },
      //     //   child: const Icon(Icons.format_list_bulleted_outlined),
      //     // ),
      //     // const SizedBox(
      //     //   height: 4,
      //     // ),
      //     //   FloatingActionButton.small(
      //     //     onPressed: () async {
      //     //       List<String> availableTextures =
      //     //           await controller.getAvailableTextures();
      //     //       print(
      //     //           'Textures : $availableTextures -- Length : ${availableTextures.length}');
      //     //       // chosenTexture =
      //     //       //     await showPickerDialog(availableTextures, chosenTexture);
      //     //       controller.setTexture(textureName: chosenTexture ?? '');
      //     //     },
      //     //     child: const Icon(Icons.list_alt_rounded),
      //     //   ),
      //     //   const SizedBox(
      //     //     height: 4,
      //     //   ),
      //     //   FloatingActionButton.small(
      //     //     onPressed: () {
      //     //       controller.setCameraOrbit(20, 20, 5);
      //     //       //controller.setCameraTarget(0.3, 0.2, 0.4);
      //     //     },
      //     //     child: const Icon(Icons.camera_alt),
      //     //   ),
      //     //   const SizedBox(
      //     //     height: 4,
      //     //   ),
      //     //   FloatingActionButton.small(
      //     //     onPressed: () {
      //     //       controller.resetCameraOrbit();
      //     //       //controller.resetCameraTarget();
      //     //     },
      //     //     child: const Icon(Icons.cameraswitch_outlined),
      //     //   )
      //   ],
      // ),
      body: Container(
        color: Colors.grey,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Flutter3DViewer(
          controller: controller,
          src: 'assets/3d model/colorized2.gltf',
        ),
      ),
    );
  }
}
