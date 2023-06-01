import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';


Widget imageDialogue(BuildContext context,
    {required Function(XFile file) onSelect}) {
     
  return SizedBox(
    width: screenWidth(context),
    height: screenHeight(context) * 0.2,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Select Picker",style: TextStyle(fontSize: 24),),
        SizedBox(height: 40,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () async {
                  final img = await pickImage(imageSource: ImageSource.camera);
                  if (img != null) {
                    onSelect.call(img);
                  }
                },
                icon: const Icon(
                  Icons.camera,
                  color: Colors.blue,
                  size: 50,
                )),
             SizedBox(
              width: screenWidth(context) * 0.3,
            ),
            IconButton(
                onPressed: () async {
                  final img = await pickImage(imageSource: ImageSource.gallery);
                  if (img != null) {
                    onSelect.call(img);
                  }
                },
                icon: const Icon(
                  Icons.browse_gallery,
                  color: Colors.purple,
                  size: 50,
                )),
          ],
        ),
        SizedBox(height: 30,),
      ],
    ),
  );
}

Future<XFile?> pickImage({required ImageSource imageSource}) async {
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
