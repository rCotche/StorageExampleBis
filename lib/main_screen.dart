import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  File? image;
  UploadTask? uploadTask;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Firebase Storage",
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            InkWell(
              onTap: () async {
                final picture =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (picture != null) {
                  image = File(picture.path);
                  setState(() {});
                }
              },
              child: const Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 100,
                  child: Icon(
                    Icons.camera_alt,
                    size: 50,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text(
                "upload",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
