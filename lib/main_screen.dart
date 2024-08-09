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
  XFile? image;
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
                  image = picture;
                  setState(() {});
                }
              },
              child: image == null
                  ? const Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 100,
                        child: Icon(
                          Icons.camera_alt,
                          size: 50,
                        ),
                      ),
                    )
                  : ClipOval(
                      child: Image.file(
                      File(image!.path),
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    )),
            ),
            const SizedBox(
              height: 30,
            ),
            uploadTask != null
                ? buildProgress() as Widget
                : ElevatedButton(
                    onPressed: () async {
                      final ref = FirebaseStorage.instance
                          .ref()
                          .child("images/${image!.name}");
                      //upload
                      uploadTask = ref.putFile(File(image!.path));
                      setState(() {});
                      final snapshot =
                          await uploadTask!.whenComplete(() => null);
                      setState(() {
                        uploadTask = null;
                      });
                      final downloadUrl = await snapshot.ref.getDownloadURL();
                      print("URL : $downloadUrl");
                    },
                    child: const Text(
                      "upload",
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget? buildProgress() {
    return StreamBuilder(
        stream: uploadTask?.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            double progress = data!.bytesTransferred / data.totalBytes;
            return Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    strokeWidth: 8,
                    value: progress,
                    color: Colors.green,
                    backgroundColor: Colors.grey,
                  ),
                ),
                Text(
                  "${(progress * 100).roundToDouble()}%",
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        });
  }
}
