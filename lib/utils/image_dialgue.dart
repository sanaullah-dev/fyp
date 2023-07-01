import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tuple/tuple.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';

Widget imageDialogue(BuildContext context,
    {required Function(Tuple2<XFile?, Uint8List?> file) onSelect}) {
  return SizedBox(
    width: screenWidth(context),
    height: screenHeight(context) * 0.2,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Select Picker",
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            !kIsWeb
                ? IconButton(
                    onPressed: () async {
                      //final img = await pickImage(imageSource: ImageSource.camera);
                      // if (img != null) {
                      Tuple2<XFile?, Uint8List?> img = await Imagee.pickImage(cmra: "1");
                      onSelect.call(img);
                      //}
                    },
                    icon: const Icon(
                      Icons.camera,
                      color: Colors.blue,
                      size: 50,
                    ))
                : SizedBox(),
            !kIsWeb
                ? SizedBox(
                    width: screenWidth(context) * 0.3,
                  )
                : SizedBox(),
            IconButton(
                onPressed: () async {
                  // final img = await pickImage(imageSource: ImageSource.gallery);
                  // if (img != null) {
                  Tuple2<XFile?, Uint8List?> img = await Imagee.pickImage(cmra: "0");

                  onSelect.call(img);
                  // }
                },
                icon: const Icon(
                  Icons.image,
                  color: Colors.purple,
                  size: 50,
                )),
          ],
        ),
        SizedBox(
          height: 30,
        ),
      ],
    ),
  );
}

Future<XFile?> pickImageCamera({required ImageSource imageSource}) async {
  final ImagePicker _picker = ImagePicker();
  final img = await _picker.pickImage(source: imageSource);
  return img;
}

// Future<Tuple2<XFile?,Uint8List>> pickImage({required ImageSource imageSource}) async {
//   //final ImagePicker _picker = ImagePicker();
//   XFile? selectFile;
//   Uint8List? selectedImageInBytes;
//   var fileResult = await FilePicker.platform.pickFiles();
//   selectFile = fileResult!.files.first.name as XFile?;
//   selectedImageInBytes = fileResult.files.first.bytes;
//   final img = //await _picker.pickImage(source: imageSource);
//    Tuple2(selectFile, selectedImageInBytes);
// }

class Imagee {
  static Future<Tuple2<XFile?, Uint8List?>> pickImage({required String cmra}) async {
    //final ImagePicker _picker = ImagePicker();
    XFile? selectFile;
    Uint8List? selectedImageInBytes;
    if(cmra != "1"){
    var fileResult = await FilePicker.platform.pickFiles(type: FileType.image);
    // log(fileResult!.files.first.name);
    if (fileResult != null && fileResult.files.isNotEmpty) {
      if (!kIsWeb) {
        selectFile = XFile(fileResult.files.single.path!);
        selectedImageInBytes = null;
        //log(selectFile.name);
      } else if (fileResult.files.first.bytes != null && kIsWeb) {
        //selectedImageInBytes = fileResult.
        //log("sana");
        selectFile = null;
        selectedImageInBytes = fileResult.files.first.bytes;
      }
      //selectedImageInBytes = fileResult.files.first.bytes;
    }
    }else{
     selectFile = await pickImageCamera(imageSource: ImageSource.camera);
     selectedImageInBytes = null;
    }
    // var file = fileResult!.files.single;
    // if (file.path != null) {
    //   selectFile = XFile(file.path!);
    // }

    // log("${selectedImageInBytes}saana");
    // final img = //await _picker.pickImage(source: imageSource);
    return Tuple2(selectFile, selectedImageInBytes);
  }
}
