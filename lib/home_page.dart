import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? originalImage;
  File? compressedImage;
  String compressedImagePath = "/storage/emulated/0/Download";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Compression App"),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 20),
                if (originalImage != null)
                  Image.file(
                    originalImage!,
                    height: 200,
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: openImagePicker,
                  child: const Text("Pick image from gallery"),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () => compressImage(),
                  child: const Text("Compress Image"),
                ),
                const SizedBox(height: 10),
                if (compressedImage != null)
                  Image.file(
                    compressedImage!,
                    height: 200,
                    width: 300,
                    fit: BoxFit.cover,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void compressImage() async {
    if (originalImage == null) return;

    try {
      final filePath = originalImage!.absolute.path;
      final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
      final splitted = filePath.substring(0, (lastIndex));
      final outPath = "${splitted}_out${filePath.substring(lastIndex)}";

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        originalImage!.path,
        outPath,
      );

      if (compressedFile == null) print("compressedFile = null");

      if (compressedFile != null) {
        // print("compressImage");
        final temp = File(compressedFile.path);

        setState(() {
          compressedImage = temp;
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  void openImagePicker() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() {
        originalImage = imageTemp;
        print("image");
      });
    } on PlatformException {
      print("failed to print image");
    }
  }
}
