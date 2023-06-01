// ignore: file_names
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/helper.dart';
import 'package:vehicle_management_and_booking_system/models/operator_model.dart';
import 'package:flutter/foundation.dart' as TargetPlatform;
import 'package:vehicle_management_and_booking_system/utils/image_dialgue.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';

class OperatorFormScreen extends StatefulWidget {
  const OperatorFormScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OperatorFormScreenState createState() => _OperatorFormScreenState();
}

class _OperatorFormScreenState extends State<OperatorFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _emergencyNumberController =
      TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _certificatesController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  var _isGettingLocation = false;
  var   _selectedAddress;
  var location;
  Uint8List? selectedImageInBytes;
  XFile? _pickedImage;

  @override
  void dispose() {
    _nameController.dispose();
    _experienceController.dispose();
    _mobileNumberController.dispose();
    _emergencyNumberController.dispose();
    _genderController.dispose();
    _emailController.dispose();
    _educationController.dispose();
    _skillsController.dispose();
    _certificatesController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Operator'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                const CircleAvatar(
                  radius: 60,

                  // :            NetworkImage(value.appUser!.profileUrl.toString()),
                  // imageUrl !=null || _pickedImage == null
                  //     ? NetworkImage(url)
                  // : FileImage(
                  //     File(
                  //       _pickedImage!.path.toString(),
                  //     ),
                  //   ),
                  //child:  imageUrl!=null?Image.network(imageUrl,fit: BoxFit.contain,):SizedBox()
                ),
                Positioned(
                  //right: 0,
                  bottom: 0,
                  left: screenHeight(context) * 0.1,
                  child: IconButton(
                    icon: Icon(
                      Icons.camera,
                      size: 35,
                      color: Colors.amber.shade900,
                    ),
                    onPressed: () async {
                      showModalBottomSheet(
                          //isDismissible: true,
                          context: context,
                          builder: (context) {
                            return imageDialogue(
                              context,
                              onSelect: (file) {
                                // log(file.path.toString());
                                setState(() {
                                  _pickedImage = file;
                                });
                                //value.changeImage(image: file);
                                Navigator.pop(context);
                              },
                            );
                          });
                      // Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _experienceController,
              decoration: const InputDecoration(labelText: 'Experience Years'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter experience years';
                }
                return null;
              },
            ),
            const SizedBox(height: 10.0),
            TextFormField(
             // initialValue: _selectedAddress.isNotEmpty ? _selectedAddress.toString():null,
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                suffixIcon: IconButton(
                    icon: const Icon(Icons.my_location),
                    onPressed: () async {
                      _isGettingLocation = true;
                      setState(() {});
                      var results = await Helper.getCurrentLocation();
                      _selectedAddress = results.item1;
                      location = results.item2;
                      _isGettingLocation = false;
                      setState(() {});
                    }),
              ),
              readOnly: false,
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
            //
            const SizedBox(height: 16),
            TextFormField(
              controller: _mobileNumberController,
              decoration: const InputDecoration(labelText: 'Mobile Number'),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a mobile number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emergencyNumberController,
              decoration: const InputDecoration(labelText: 'Emergency Number'),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter an emergency number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _genderController,
              // The validator checks if a gender has been selected
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please select a gender';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Gender',
                suffixIcon: PopupMenuButton<String>(
                  onSelected: (value) {
                    setState(() {
                      _genderController.text = value;
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'Male',
                        child: Text('Male'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Female',
                        child: Text('Female'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Other',
                        child: Text('Other'),
                      ),
                    ];
                  },
                ),
              ),
              // onSaved will store the selected gender in the _genderController
            ),
            // TextFormField(
            //   controller: _genderController,
            //   decoration: InputDecoration(labelText: 'Gender',

            //   ),
            //   validator: (value) {
            //     if (value!.isEmpty) {
            //       return 'Please enter a gender';
            //     }
            //     return null;
            //   },

            // ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter an email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _educationController,
              decoration: const InputDecoration(labelText: 'Education'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter education details';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _skillsController,
              decoration:
                  const InputDecoration(labelText: 'Skills (Machinery)'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter skills information';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _certificatesController,
              decoration: const InputDecoration(labelText: 'Certificates'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter certificate details';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _summaryController,
              decoration:
                  const InputDecoration(labelText: 'Summary/Description'),
              maxLines: 5,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a summary/description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                //   if (_formKey.currentState!.validate()) {
                // try{
                //   final _currentUser = context.read<AuthController>().appUser;
                //     final operator_model = OperatorModel(
                //       uid: _currentUser!.uid.toString(),
                //       name: _nameController.text,
                //       years: _experienceController.text,
                //       mobileNumber: _mobileNumberController.text,
                //       emergencyNumber: _emergencyNumberController.text,
                //       gender: _genderController.text,
                //       email: _emailController.text,
                //       education: _educationController.text,
                //       skills: _skillsController.text,
                //       certificates: _certificatesController.text,
                //       summaryOrDescription: _summaryController.text,
                //       location:
                //     );
                // }catch(e){
                //   ScaffoldMessenger.of(context).showSnackBar(
                //                       SnackBar(
                //                         content: Text(
                //                           "There was an issue $e",
                //                         ),
                //                       ),
                //                     );
                //                     Navigator.pop(context);
                // }

                //   }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
