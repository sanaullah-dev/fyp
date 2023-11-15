import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vehicle_management_and_booking_system/app/app.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/request_controller.dart';
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
import 'package:vehicle_management_and_booking_system/models/report_model.dart';
import 'package:vehicle_management_and_booking_system/models/request_machiery_model.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';
import 'package:vehicle_management_and_booking_system/utils/app_colors.dart';
import 'package:flutter/foundation.dart' as TargetPlatform;

import 'package:vehicle_management_and_booking_system/utils/const.dart';

class ReportScreen extends StatefulWidget {
  ReportScreen({this.request, this.machine});

  RequestModelForMachieries? request;
  MachineryModel? machine;
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final TextEditingController descriptionController = TextEditingController();
  final List<File> _images = [];
  final List<Uint8List> _webImages = [];
  late UserModel reportOnUser;
  late MachineryModel machine;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    if (widget.machine == null) {
      reportOnUser = context.read<MachineryRegistrationController>().getUser(
          widget.request!.senderUid ==
                  context.read<AuthController>().appUser!.uid
              ? widget.request!.machineryOwnerUid
              : widget.request!.senderUid);
      machine = context
          .read<MachineryRegistrationController>()
          .allMachineries!
          .firstWhere(
              (element) => element.machineryId == widget.request!.machineId);
    } else {
      machine = widget.machine!;
    }
    super.initState();
  }

  void _getWebImage() async {
    // if (!TargetPlatform.kIsWeb) {
    var fileResult = await FilePicker.platform.pickFiles(type: FileType.image);
    if (fileResult != null) {
      final img = fileResult.files.first.bytes;
      setState(() {
        _webImages.add(img!);
        //log("message");
      });
    }
  }

  void _getImage(ImageSource source) async {
    // if (!TargetPlatform.kIsWeb) {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
        //log("message");
      });
    } else {
      log("No image selected.");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ConstantHelper.darkOrBright(context);
    return Scaffold(
      appBar: AppBar(
        title: Text( widget.machine != null?"Machine Complaint":
          "Complaint",
          style: TextStyle(color: isDark ? null : Colors.black),
        ),
        backgroundColor: isDark ? null : AppColors.accentColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              navigatorKey.currentState!.pop();
            },
            icon: Icon(
              Icons.arrow_back_ios_new_sharp,
              color: isDark ? null : AppColors.blackColor,
            )),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              widget.machine == null
                  ? Card(
                      child: ListTile(
                        leading: reportOnUser.profileUrl != null
                            ? CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                // imageUrl:
                                reportOnUser.profileUrl.toString(),
                               
                              ))
                            : CircleAvatar(child: Text(reportOnUser.name[0])),
                        title: Text(reportOnUser.name),
                        subtitle: Text(reportOnUser.email),
                      ),
                    )
                  : const SizedBox(),
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                    // imageUrl:
                    machine.images!.last.toString(),
                  
                  )),
                  title: Text(machine.title),
                  subtitle: Text(machine.charges.toString()),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                minLines: 1,
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                    color: isDark
                        ? Colors.white
                        : Colors.black, // Adjust this as needed
                    width: 0.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Upload Issue Related Image'),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        !TargetPlatform.kIsWeb
                            ? OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        color: isDark
                                            ? Colors.transparent
                                            : AppColors.accentColor)),
                                onPressed: () => _getImage(ImageSource.camera),
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: isDark ? null : AppColors.accentColor,
                                ),
                                label: Text(
                                  'Camera',
                                  style: TextStyle(
                                    color:
                                        isDark ? null : AppColors.accentColor,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        TextButton.icon(
                          onPressed: () => !TargetPlatform.kIsWeb
                              ? _getImage(
                                  ImageSource.gallery,
                                )
                              : _getWebImage(),
                          icon: Icon(
                            Icons.photo,
                            color: isDark ? null : AppColors.accentColor,
                          ),
                          label: Text(
                            'Gallery',
                            style: TextStyle(
                              color: isDark ? null : AppColors.accentColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (_images.isNotEmpty || _webImages.isNotEmpty)
                      const Text("Selected Images"),
                    if (_images.isNotEmpty || _webImages.isNotEmpty)
                      SizedBox(
                        height: 80.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: !TargetPlatform.kIsWeb
                              ? _images.length
                              : _webImages.length,
                          itemBuilder: (BuildContext context, int index) {
                            //log(_images[index].path);
                            return Padding(
                              padding: index == 0
                                  ? const EdgeInsets.only(
                                      left: 0,
                                      right: 8.0,
                                      top: 8.0,
                                      bottom: 8.0)
                                  : const EdgeInsets.all(8.0),
                              child: (!TargetPlatform.kIsWeb)
                                  ? Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Image.file(
                                          File(_images[index].path),
                                          width: 70.0,
                                          height: 70.0,
                                          fit: BoxFit.cover,
                                        ),
                                        Positioned(
                                          right: -20,
                                          top: -15,
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _images.removeAt(index);
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.cancel_outlined,
                                                color: Colors.red,
                                              )),
                                        )
                                      ],
                                    )
                                  : Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Image.memory(_webImages[index]),
                                        Positioned(
                                          right: -20,
                                          top: -15,
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _webImages.removeAt(index);
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.cancel_outlined,
                                                color: Colors.red,
                                              )),
                                        )
                                      ],
                                    ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
              // ElevatedButton(
              //   onPressed: () async {
              //     final pickedFile =
              //         await ImagePicker().pickImage(source: ImageSource.gallery);

              //     setState(() {
              //       if (pickedFile != null) {
              //         _images.add(File(pickedFile.path));
              //       } else {
              //         print('No image selected.');
              //       }
              //     });
              //   },
              //   child: Text('Upload Issue Related Image'),
              // ),
              // const SizedBox(height: 16),

              const SizedBox(height: 16),
              Consumer<RequestController>(builder: (context, provider, _) {
                return provider.isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.amber,
                          ),
                        ),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () async {
                          // Handle the submission logic here
                          if (_formKey.currentState!.validate() &&
                              widget.request != null) {
                            try {
                              ReportModel report = ReportModel(
                                  reportId: const Uuid().v1(),
                                  reportOn: reportOnUser.uid,
                                  requestId: widget.request!.requestId,
                                  reportFrom: context
                                      .read<AuthController>()
                                      .appUser!
                                      .uid,
                                  machineId: machine.machineryId,
                                  description: descriptionController.text,
                                  status: "Pending",
                                  dateTime: DateTime.now());

                              _images.isNotEmpty || _webImages.isNotEmpty
                                  ? await context
                                      .read<RequestController>()
                                      .reportSubmition(context,
                                          report: report,
                                          images: !TargetPlatform.kIsWeb
                                              ? _images
                                              : _webImages,
                                          collection: "Reports",
                                          fireStoreCollectionForReport:
                                              "Reports")
                                  : throw Exception("Images Required");

                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Reported added"),
                                ),
                              );
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                ),
                              );
                            }
                          } else if (_formKey.currentState!.validate() &&
                              widget.machine != null) {
                            try {
                              ReportModel report = ReportModel(
                                  reportId: const Uuid().v1(),
                                  reportOn: machine.uid,
                                  // requestId: widget.request!.requestId,
                                  reportFrom: context
                                      .read<AuthController>()
                                      .appUser!
                                      .uid,
                                  machineId: machine.machineryId,
                                  description: descriptionController.text,
                                  status: "Pending",
                                  dateTime: DateTime.now());

                              _images.isNotEmpty || _webImages.isNotEmpty
                                  ? await context
                                      .read<RequestController>()
                                      .reportSubmition(context,
                                          report: report,
                                          images: !TargetPlatform.kIsWeb
                                              ? _images
                                              : _webImages,
                                          collection: "MachineriesReports",
                                          fireStoreCollectionForReport:
                                              "MachineriesReports")
                                  : throw Exception("Images Required");

                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Reported added"),
                                ),
                              );
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text('Submit Report'),
                      );
              })
            ],
          ),
        ),
      ),
    );
  }
}
