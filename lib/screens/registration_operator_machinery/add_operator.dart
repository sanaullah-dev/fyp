// ignore: file_names
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vehicle_management_and_booking_system/app/app.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/operator_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/helper.dart';
import 'package:flutter/foundation.dart' as TargetPlatform;
import 'package:vehicle_management_and_booking_system/models/operator_model.dart';
import 'package:vehicle_management_and_booking_system/utils/app_colors.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';
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
  // final TextEditingController _certificatesController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  var _isGettingLocation = false;
  // ignore: prefer_typing_uninitialized_variables
  var _selectedAddress;
  List<String> addresses = [];
  late Locations location;
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
    // _certificatesController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ConstantHelper.darkOrBright(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Operator",
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
      // appBar: AppBar(
      //   title: const Text('Add Operator'),
      // ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 60,

                  backgroundImage: !TargetPlatform.kIsWeb &&
                          _pickedImage != null
                      ? FileImage(File(_pickedImage!.path))
                      : selectedImageInBytes != null
                          ? MemoryImage(selectedImageInBytes!) as ImageProvider
                          : null,
                  child: selectedImageInBytes == null && _pickedImage == null
                      ? const Text("Profile Image")
                      : null, //_pickedImage!=null? AssetImage(_pickedImage!.path.toString()):MemoryImage(bytes),

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
                  left: screenHeight(context) * 0.09,
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

                                if (TargetPlatform.kIsWeb) {
                                  selectedImageInBytes = file.item2;
                                  //log("message");
                                } else {
                                  // _pickedImage = file.item1;
                                  _pickedImage = file.item1;
                                }
                                setState(() {
                                  // log(selectFile!.name);
                                });
                                // setState(() {
                                //   _pickedImage = file;
                                // });

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
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: "Jhon",
                  border: OutlineInputBorder()),
              validator: (value) {
                String pattern = r'^[0-9]+$';
                RegExp regExp = RegExp(pattern);
                if (value!.isEmpty && regExp.hasMatch(value)) {
                  return 'Please enter name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              maxLines: 1,
              textAlign: TextAlign.justify,
              controller: _experienceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'Work Experience',
                  hintText:
                      "1, 2, 3 years", // floatingLabelBehavior: FloatingLabelBehavior.always,

                  border: OutlineInputBorder()),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter
                    .digitsOnly, // Only allow digits to be entered
              ],
              //keyboardType: TextInputType.number,
              validator: (value) {
                String pattern =
                    r'^03\d{9}$'; // This assumes the number starts with '03' and has 11 digits.
                RegExp regExp = RegExp(pattern);
                if (value!.isEmpty) {
                  return 'Please enter a valid Wrok Experience';
                } else if (!regExp.hasMatch(value)) {
                  return 'Please enter a valid Wrok Experience';
                }
                return null;
              },
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              //initialValue: "Press location and popupMenuButton",

              controller: _locationController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                // prefixText: "Press my location",
                helperText: _selectedAddress == null
                    ? "Press location and popupMenuButton to get accurate location"
                    : null,
                // border: OutlineInputBorder(),
                hintText: "abc,Islamabad,Pakistan",
                labelText: 'Location',
                suffixIcon: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PopupMenuButton<String>(
                        color: isDark ? null : AppColors.accentColor,
                      // color: Colors.orange,
                      onSelected: (value) {
                        setState(() {
                          _selectedAddress = value;
                        });
                      },
                      itemBuilder: (BuildContext context) {
                        // ignore: unnecessary_null_comparison
                        if (addresses.isEmpty) {
                          // No addresses are available. Return a list with a single item.
                          return [
                            const PopupMenuItem<String>(
                              value: 'No addresses available',
                              child: Text('No addresses available'),
                            ),
                          ];
                        } else {
                          // Generate the menu entries dynamically based on the addresses.
                          return addresses.map((String address) {
                            return PopupMenuItem<String>(
                              value: address,
                              child: Text(address),
                            );
                          }).toList();
                        }
                      },
                    ),
                    IconButton(
                        icon: const Icon(
                          Icons.my_location,color: Colors.orange,
                        ),
                        onPressed: () async {
                          _isGettingLocation = true;
                          setState(() {});
                          var results =
                              await Helper.getCurrentLocation(operator: true);
                          addresses = results.item1;
                          location = results.item2;
                          _isGettingLocation = false;
                          setState(() {});
                        }),
                  ],
                ),
              ),
              readOnly: true,
            ),
            // TextFormField(
            //   // initialValue: _selectedAddress.isNotEmpty ? _selectedAddress.toString():null,
            //   controller: _locationController,
            //   decoration: InputDecoration(
            //     labelText: 'Location',
            //     suffixIcon: IconButton(
            //         icon: const Icon(Icons.my_location),
            //         onPressed: () async {
            //           _isGettingLocation = true;
            //           setState(() {});
            //           var results = await Helper.getCurrentLocation();
            //           _selectedAddress = results.item1;
            //           location = results.item2;
            //           _isGettingLocation = false;
            //           setState(() {});
            //         }),
            //   ),
            //   readOnly: false,
            // ),
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
              decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(),
                  hintText: "03XXXXXXXXX"),
                  inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter
                      .digitsOnly, // Only allow digits to be entered
                ],
              keyboardType: TextInputType.phone,
              validator: (value) {
                Pattern pattern = r'^(03[0-9]{2})([0-9]{7})$';
                RegExp regex = RegExp(pattern.toString());
                if (!regex.hasMatch(value!) || value.isEmpty) {
                  return 'Invalid mobile number';
                } else
                  return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emergencyNumberController,
              decoration: const InputDecoration(
                  helperText: "guardian or Family Member",
                  labelText: 'Emergency Number',
                  border: OutlineInputBorder(),
                  hintText: "03XXXXXXXXX"),
              keyboardType: TextInputType.phone,
              validator: (value) {
                Pattern pattern = r'^(03[0-9]{2})([0-9]{7})$';
                RegExp regex = RegExp(pattern.toString());
                if (!regex.hasMatch(value!) || value.isEmpty)
                  return 'Invalid mobile number';
                else
                  return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              readOnly: true,
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
                hintText: "Male,Female,Other",
                border: const OutlineInputBorder(),
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
                  border: OutlineInputBorder(),
                  hintText: "xyz@gmail.com"),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                String pattern = r'^[^@]+@[^@]+\.[^@]+$';
                RegExp regExp = RegExp(pattern);
                if (value!.isEmpty) {
                  return 'Please enter a valid email address';
                } else if (!regExp.hasMatch(value)) {
                  return 'Enter Valid Email Address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _educationController,
              decoration: const InputDecoration(
                  labelText: 'Education',
                  border: OutlineInputBorder(),
                  hintText: "Bachelor of Scence in Construction Management"),
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
              decoration: const InputDecoration(
                  labelText: 'Skills (Machinery)',
                  hintText:
                      "Front-end loader eperation Tractor-trailer operation",
                  border: OutlineInputBorder()),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter skills information';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // TextFormField(
            //   controller: _certificatesController,
            //   decoration:
            //       const InputDecoration(labelText: 'Certificates (Optional)'),
            //   validator: (value) {
            //     if (value!.isEmpty) {
            //       return 'Please enter certificate details';
            //     }
            //     return null;
            //   },
            // ),
            const SizedBox(height: 16),
            TextFormField(
              textAlign: TextAlign.justify,
              controller: _summaryController,
              decoration: const InputDecoration(
                  labelText: 'Summary/Description',
                  hintText:
                      "Dependable and safety-onerced heavy equipment operator with -i years of experience. At' ThrasherStorese, operated and maintained good working condition of 7 different vehicles, including front-end loaders, tractor trailers and forklifts. Handled ovilcedine ot up to 15 shigments dails. L.oolane to provide Paned.Co with my reliable slallace in operains machery.",
                  border: OutlineInputBorder()),
              maxLines: 10,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a summary/description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            Consumer<OperatorRegistrationController>(
                builder: (context, value, _) {
              return value.isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.amber,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 14.0),
                      child: Container(
                        width: 100,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: OutlinedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              double ratingValue = 0.0;
                              try {
                                final _currentUser =
                                    context.read<AuthController>().appUser;
                                await context.read<OperatorRegistrationController>().isOperatorExists(
                                        uid: _currentUser!.uid)
                                    ?null: throw Exception("You are already registered One Operator");

                                final operator_model = OperatorModel(
                                    uid: _currentUser!.uid.toString(),
                                    name: _nameController.text,
                                    years: _experienceController.text,
                                    fullAddress: _selectedAddress.toString(),
                                    mobileNumber: _mobileNumberController.text,
                                    emergencyNumber:
                                        _emergencyNumberController.text,
                                    gender: _genderController.text,
                                    email: _emailController.text,
                                    education: _educationController.text,
                                    skills: _skillsController.text,
                                    summaryOrDescription:
                                        _summaryController.text,
                                    location: location,
                                    //  operatorImage: null,
                                    dateAdded: Timestamp.now(),
                                    operatorId: const Uuid().v1(),
                                    rating: ratingValue,
                                    isAvailable: true);

                                _pickedImage != null ||
                                        selectedImageInBytes != null
                                    ? await context
                                        .read<OperatorRegistrationController>()
                                        .uploadOperator(
                                          context,
                                          details: operator_model,
                                          image: !TargetPlatform.kIsWeb
                                              ? File(_pickedImage!.path)
                                              : selectedImageInBytes,
                                        )
                                    : throw Exception("Images Required");

                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Operator added"),
                                  ),
                                );
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                                // log('UID: ${operator_model.uid}');
                                // log('Name: ${operator_model.name}');
                                // log('Years of Experience: ${operator_model.years}');
                                // log('Mobile Number: ${operator_model.mobileNumber}');
                                // log('Emergency Number: ${operator_model.emergencyNumber}');
                                // log('Gender: ${operator_model.gender}');
                                // log('Email: ${operator_model.email}');
                                // log('Education: ${operator_model.education}');
                                // log('Skills: ${operator_model.skills}');
                                // log('Summary or Description: ${operator_model.summaryOrDescription}');
                                // log('Location: ${operator_model.location.title}');
                                // log('Date Added: ${operator_model.dateAdded}');
                                // log('Operator ID: ${operator_model.operatorId}');
                                // log('Rating: ${operator_model.rating}');
                                // log('Rating: ${operator_model.fullAddress}');
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "There was an issue $e",
                                    ),
                                  ),
                                );
                                // Navigator.pop(context);
                              }
                            }
                          },
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
            }),
          ],
        ),
      ),
    );
  }
}
