import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextRecognizer? textRecognizer;
  File? image;
  final picker = ImagePicker();

  Future<void> getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  String textFromPic = '';

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textRecognizer!.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image to text Converter"),
      ),
      body: Center(
        child: image == null
            ? const Text("No Image Selected")
            : Column(
                children: [
                  Image.file(image!,
                      height: MediaQuery.of(context).size.height * 0.6),
                  ElevatedButton(
                    onPressed: () {
                      readTextFromImage();
                    },
                    child: const Text("Get Text"),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getImageFromGallery();
        },
        tooltip: "Select Image",
        child: const Icon(Icons.image),
      ),
    );
  }

  Future<void> readTextFromImage() async {
    final inputImage = InputImage.fromFile(image!);
    textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer!.processImage(inputImage);
      textFromPic = recognizedText.text;
    for (var block in textFromPic.characters) {
     print("This is block: $block");
      // for (TextLine line in block.lines) {
      //
      //   for (TextElement element in line.elements) {
      //
      //     textFromPic = '${element.text}';
      //   }
      // }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Extracted Text"),
          content: Text(textFromPic), // Display extracted text here
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
