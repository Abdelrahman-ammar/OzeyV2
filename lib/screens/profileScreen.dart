// ignore_for_file: file_names, depend_on_referenced_packages, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, use_build_context_synchronously, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, unused_element, deprecated_member_use

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mapfeature_project/screens/resetpassScreen.dart';
import 'dart:io';
import 'package:mapfeature_project/screens/settings.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../helper/show_snack_bar.dart';

class EditProfilePage extends StatefulWidget {
  final String? email;
  final String? username;
  final String userId;
  final String token;
  final String? name;

  EditProfilePage({
    this.email,
    this.username,
    required this.userId,
    required this.token,
    this.name,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _selectedImage;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  String? selectedGender;
  bool showPassword = false;
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();

    // Initialize the controllers with default values
    // fullNameController.text = widget.name ?? "";
    // phoneNumberController.text = '01033886818';
    // dobController.text = "22/2/2002";
    _fetchProfileData();
    selectedGender = null;
  }

  Future<void> _fetchProfileData() async {
    // Prepare the headers
    Map<String, String> headers = {
      "Authorization": "Bearer ${widget.token}",
      "Accept": "application/json",
    };

    String apiUrl =
        'https://mental-health-ef371ab8b1fd.herokuapp.com/api/users/${widget.userId}';

    // Make the HTTP GET request to fetch the profile data
    http.Response response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);

      setState(() {
        fullNameController.text = responseData['name'] ?? '';
        phoneNumberController.text = responseData['phone'] ?? '';
        selectedGender = responseData['gender'].toLowerCase(); //Abdo5 there was a mismatch between what was returned from the API and the dropdownlistMenuItems
        dobController.text = responseData['DOB'] ?? '';
        _selectedImage = File(responseData['image']);
        // Update other fields if needed
      });
      print(_selectedImage);
    } else {
      print("Error: ${response.body}");
    }
  }

  Future<void> _postData() async {
    print(MultipartFile.fromFile(_selectedImage!.path,
            filename: _selectedImage!.path.split('/').last)
        .toString());
    Map<String, String> headers = {
      'Accept': 'application/json',
      // 'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.token}'
    };
    String url =
        'https://mental-health-ef371ab8b1fd.herokuapp.com/api/user/update_profile';

    http.Response response =
        await http.post(Uri.parse(url), headers: headers, body: {
      'files': [
        await MultipartFile.fromFile(_selectedImage!.path,
            filename: _selectedImage!.path.split('/').last)
      ].toString(),
      'id': widget.userId,
      'name': fullNameController.text,
      'phone': '0${phoneNumberController.text}',
      'gender': selectedGender,
      'DOB': dobController.text.replaceAll('-', '/'),
      '_method': 'PUT'
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      showSnackBar(context, responseData['message']);
      print('sddsad');
      setState(() {
        isEditMode = false;
        _fetchProfileData(); // Exit edit mode
      });
    } else {
      print(response.reasonPhrase);
      Map<String, dynamic> responseData = json.decode(response.body);
      print('object');
      print(responseData['message']);
      setState(() {
        isEditMode = true; // Exit edit mode
      });
      showSnackBar(context, responseData['message']);
    }
  }


  @override
  void dispose() {
    fullNameController.dispose();
    phoneNumberController.dispose();
    dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('       Personal Info'),
        actions: [
          if (isEditMode) // Show save button only in edit mode

            ElevatedButton(
              onPressed: () async {
                // print(fullNameController.text);      //Abdo2 These prints the data when pressing save
                // print(phoneNumberController.text);
                // print(selectedGender);
                // print(dobController.text);

                // Map gender string to an integer
                // String? gender;
                // if (selectedGender == "Male") {
                //   gender = 'male';
                // } else if (selectedGender == "Female") { //Abdo3 Made changes here 3
                //   gender = 'female';
                // }

                if (selectedGender != null) {
                  await _saveProfile(
                    name: fullNameController.text,
                    gender: selectedGender!.toLowerCase(),
                    phone: phoneNumberController.text,
                    dob: dobController.text,
                  );
                } else {
                  showSnackBar(context, "Please select a gender.");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB7C3C5),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "SAVE",
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 2.2,
                  color: Colors.white,
                ),
              ),
            ),
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.black,
            ),
            onPressed: () {
              if (isEditMode==false){  //Abdo4 the edit icon works as a switch on/off for save to appear 
              setState(() {
                isEditMode = !isEditMode; // Toggle edit mode
              });
              }
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
        child: ListView(
          children: [
            Center(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (isEditMode) {
                        _pickImage(); // Open gallery only in edit mode
                      }
                    },
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 4,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(0, 10),
                          )
                        ],
                        shape: BoxShape.circle,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (isEditMode) {
                            _pickImage(); // Open gallery only in edit mode
                          }
                        },
                        child: CircleAvatar(
                            backgroundImage: _selectedImage == null
                                ? const AssetImage(
                                    "images/photo_2024-01-17_04-23-53-removebg-preview.png")
                                : NetworkImage(_selectedImage!.path)
                                    as ImageProvider<Object>),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Visibility(
                      visible: isEditMode,
                      child: GestureDetector(
                        onTap: () {
                          _pickImage(); // Open gallery when edit icon is tapped
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            color: const Color(0xFFB7C3C5),
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            const Text(
              'Full Name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            buildTextField('.', fullNameController),
            const Text(
              'Phone Number',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            buildTextField('..', phoneNumberController),
            const Text(
              'Gender',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            buildGenderDropdown(),
            const Text(
              'Date of Birth',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            buildTextField('...', dobController,
                onTap: () => _selectDate(context)),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ResetPasswordScreen(email: widget.email ?? ""),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Reset your password',
                      style:
                          TextStyle(fontSize: 16.0, color: Color(0xFF355A5C)),
                    ),
                    Icon(
                      Icons.check,
                      color: Colors.grey[700],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SettingsPage()), // تستبدل SecondScreen بشاشة الوجهة الثانية الخاصة بك
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      Text('  Log Out',
                          style: TextStyle(fontSize: 16, color: Colors.red)),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller,
      {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: labelText == "."
          ? TextFormField(
              controller: controller,
              readOnly: !isEditMode, // Set readOnly based on edit mode
              onTap: onTap,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.grey[500],
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              style: const TextStyle(
                fontWeight: FontWeight.bold, // تجعل النص داخل الحقل bold
              ),
            )
          : labelText == ".."
              ? IntlPhoneField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, // تجعل النص داخل الحقل bold
                  ),
                  controller: controller,
                  enabled: isEditMode,
                  initialCountryCode: 'EG', // تعيين رمز البلد لمصر
                  onChanged: (phone) {
                    // يمكنك إضافة العمليات التي تريدها هنا على أساس التغييرات في الحقل
                  },
                )
              : TextFormField(
                  controller: controller,
                  readOnly: !isEditMode, // Set readOnly based on edit mode
                  onTap: onTap,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                    suffixIcon: labelText == "..."
                        ? Icon(
                            Icons.calendar_today,
                            color: Colors.grey[500],
                          )
                        : null,
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, // تجعل النص داخل الحقل bold
                  ),
                ),
    );
  }

  Widget buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: DropdownButtonFormField<String>(
        onChanged: isEditMode
            ? (value) {
                setState(() {
                  selectedGender = value!;
                });
              }
            : null,
        value: selectedGender,
// Disable onChanged outside edit mode
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          labelText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(35),
          ),
        ),
        items: <String>["male", 'female'].map((String gender) {
          return DropdownMenuItem<String>(
            value: gender,
            child: Text(gender),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _saveProfile({
    required String name,
    required String gender,
    required String phone,
    required String dob,
  }) async {
    // Prepare the request body
    Map<String, dynamic> requestBody = {
      'id' : widget.userId,    //Abdo 1 , the id was not sent
      'name': name,
      'phone': phone,
      'gender': gender,
      'DOB': dob,
      '_method': 'PUT'
    };

    // Prepare the headers
    Map<String, String> headers = {
      'Authorization': 'Bearer ${widget.token}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    // Make the HTTP PUT request to update the profile
    http.Response response = await http.put(
      Uri.parse(
          'https://mental-health-ef371ab8b1fd.herokuapp.com/api/user/update_profile'),
      headers: headers,
      body: json.encode(requestBody),
    );

    // Parse the response
    if (response.statusCode == 200) {
      print('Profile updated successfully');
      // Optionally, fetch the profile data again
      // await _fetchProfileData();
    } else {
      print('Error: ${response.body}');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        dobController.text = DateFormat('yyyy/MM/dd').format(pickedDate);
      });
    }
  }

  final picker = ImagePicker();

  //Image Picker function to get image from gallery

  Future _pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
      }
    });
  }
}
