// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'dart:developer';

//import 'dart:html' as html;
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
// ignore: library_prefixes
import 'package:flutter/foundation.dart' as TargetPlatform;
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/helper.dart';
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';

class MachineryFormScreen extends StatefulWidget {
  const MachineryFormScreen({super.key});

  @override
  _MachineryFormScreenState createState() => _MachineryFormScreenState();
}

class _MachineryFormScreenState extends State<MachineryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _sizeController = TextEditingController();
  final _hourlyChargeController = TextEditingController();
  final _descriptionCOntroller = TextEditingController();
  final _emergencyNumberController = TextEditingController();
  final _modelController = TextEditingController();

  var _isGettingLocation = false;
  String? _selectedAddress;
  final List<File> _images = [];
  // ignore: prefer_typing_uninitialized_variables
  late Location location;

  void _getImage(ImageSource source) async {
    // if (!TargetPlatform.kIsWeb) {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
        //log("message");
      });
    }
    // } else {
    //   final input = html.FileUploadInputElement();
    //   input.accept = 'image/*'; // allow only image files
    //   input.click();

    //   input.onChange.listen((event) {
    //     final file = input.files!.first;
    //     setState(() {
    //       _images.add(File(file.name));
    //     });
    //     // Do something with the selected file, such as display it on the screen
    //   });
    // }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _sizeController.dispose();
    _hourlyChargeController.dispose();
    _emergencyNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Machinery'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _modelController,
                decoration: const InputDecoration(
                    labelText: 'Model', hintText: "2001, 2010"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'write something about machinery model ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  suffixIcon: IconButton(
                      icon: const Icon(Icons.my_location),
                      onPressed: () async {
                        _isGettingLocation = true;
                        setState(() {
                          
                        });
                        var results = await Helper.getCurrentLocation();
                        _selectedAddress = results.item1;
                        location = results.item2;
                        _isGettingLocation = false;
                        setState(() {
                          
                        });
                      }),
                ),
                readOnly: true,
              ),
              if (_isGettingLocation)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              if (_selectedAddress != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_selectedAddress!),
                ),
              const SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _sizeController,
                decoration:
                    const InputDecoration(labelText: 'Size of Machinery'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter size of machinery';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _hourlyChargeController,
                decoration:
                    const InputDecoration(labelText: 'Per Hour Charges'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter hourly charges';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                maxLines: 5,
                textAlign: TextAlign.justify,
                controller: _descriptionCOntroller,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'write something about machinery';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _emergencyNumberController,
                keyboardType: TextInputType.phone,
                decoration:
                    const InputDecoration(labelText: 'Emergency Number'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter emergency number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              const Text('Images'),
              if (_images.isNotEmpty && !TargetPlatform.kIsWeb)
                SizedBox(
                  height: 80.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _images.length,
                    itemBuilder: (BuildContext context, int index) {
                      log(_images[index].path);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: (!TargetPlatform.kIsWeb)
                            ? Image.file(
                                File(_images[index].path),
                                width: 70.0,
                                height: 70.0,
                                fit: BoxFit.cover,
                              )
                            : Image.memory(
                                Uint8List.fromList(_images.last as Uint8List)),
                      );
                    },
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _getImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _getImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo),
                    label: const Text('Gallery'),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Consumer<MachineryRegistrationController>(
                builder: (context, provider, _) {
                  return provider.isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.amber,
                            ),
                          ),
                        )
                      : Container(
                          width: 100,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            // gradient: LinearGradient(
                            //   colors: [
                            //     Color.fromARGB(255, 228, 211, 62),
                            //     Colors.deepOrange,
                            //   ],
                            //   begin: Alignment.centerLeft,
                            //   end: Alignment.centerRight,
                            // ),
                          ),
                          child: OutlinedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  var curruntUser =
                                      context.read<AuthController>().appUser!;
                                  var machine = MachineryModel(
                                    machineryId: const Uuid().v1(),
                                    uid: curruntUser.uid,
                                    name: curruntUser.name,
                                    profilePicture: curruntUser.profileUrl,
                                    title: _titleController.text,
                                    model: _modelController.text,
                                    address: _selectedAddress.toString(),
                                    description: _descriptionCOntroller.text,
                                    size: int.parse(_sizeController.text),
                                    charges:
                                        int.parse(_hourlyChargeController.text),
                                    emergencyNumber:
                                        _emergencyNumberController.text,
                                    dateAdded: Timestamp.now(),
                                    rating: 0.0,
                                    location: location,
                                  );

                                  _images.isNotEmpty
                                      ? await context
                                          .read<
                                              MachineryRegistrationController>()
                                          .uploadMachinery(context,
                                              details: machine,
                                              images: _images,
                                              collection: "machineries")
                                      : throw Exception("Images Required");
                                  log("SANA");
                                  _descriptionCOntroller.clear();
                                  _emergencyNumberController.clear();
                                  _titleController.clear();
                                  _sizeController.clear();
                                  _locationController.clear();
                                  _modelController.clear();
                                  _images.clear();
                                  _hourlyChargeController.clear();
                                  _selectedAddress = null;

                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Machinery added"),
                                    ),
                                  );
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);
                                  // ignore: use_build_context_synchronously
                                  //   Navigator.of(context).pushNamed(AppRouter.bottomNavigationBar);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "There was an issue $e",
                                      ),
                                    ),
                                  );
                                  Navigator.pop(context);
                                }
                              }
                            },
                            child: const Text(
                              "Submit",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
