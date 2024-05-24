// ignore_for_file: use_build_context_synchronously, avoid_print, use_key_in_widget_constructors, file_names, depend_on_referenced_packages, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mapfeature_project/Test/Health.dart';
import 'package:mapfeature_project/Test/result.dart';
import 'package:mapfeature_project/helper/show_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:http/http.dart' as http;

class LossOFInterest extends StatefulWidget {
  @override
  _LossOFInterest createState() => _LossOFInterest();
}

class _LossOFInterest extends State<LossOFInterest> {
  String selectedOption = '';
  int userScore = 0;
  int cognitiveScore = 0;
  int somaticScore = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0),
            child: Text(
              'And We are done ...',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: const StepProgressIndicator(
              totalSteps: 21,
              currentStep: 21,
              size: 13,
              padding: 0,
              unselectedColor: Colors.white,
              roundedEdges: Radius.circular(10),
              selectedGradientColor: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF8ABAC5), Color(0xFF8ABAC5)],
              ),
            ),
          ),
          const SizedBox(height: 16.0), // المسافة بين الـ Slider والنص الجديد

          const Padding(
            padding: EdgeInsets.all(16.0),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF8ABAC5),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: const Text(
              '21. Loss of interest in sex',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          RadioListTile<String>(
            title: const Text('I have not noticed any recent change in my interest in sex.'),
            groupValue: selectedOption,
            value: 'a',
            onChanged: (value) {
              setState(() {
                selectedOption = value!;
              });
            },
            activeColor: const Color(0xFF8ABAC5),
          ),
          RadioListTile<String>(
            title: const Text('I am less interested in sex than I used to be.'),
            groupValue: selectedOption,
            value: 'b',
            onChanged: (value) {
              setState(() {
                selectedOption = value!;
                userScore += 1;
                somaticScore += 1;
              });
            },
            activeColor: const Color(0xFF8ABAC5),
          ),
          RadioListTile<String>(
            title: const Text('I have almost no interest in sex.'),
            groupValue: selectedOption,
            value: 'c',
            onChanged: (value) {
              setState(() {
                selectedOption = value!;
                userScore += 2;
                somaticScore += 2;
              });
            },
            activeColor: const Color(0xFF8ABAC5),
          ),
          RadioListTile<String>(
            title: const Text('I have lost interest in sex completely.'),
            groupValue: selectedOption,
            value: 'd',
            onChanged: (value) {
              setState(() {
                selectedOption = value!;
                userScore += 3;
                somaticScore += 3;
              });
            },
            activeColor: const Color(0xFF8ABAC5),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Health()),
                );
              },
              child: const Icon(Icons.navigate_before),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                postDataToApi();
                print(userScore);
                print(cognitiveScore);
                print(somaticScore);
                print(DateFormat('yyyy/MM/dd').format(DateTime.now()).replaceAll('/', '-'));
                // تحويل للشاشة التي تأتي بعد الشاشة الحالية
              },
              child: const Icon(Icons.navigate_next),
            ),
            label: 'Show result',
          ),
        ],
      ),
    );
  }
  postDataToApi() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String? token = prefs.getString('token');
    String? id = prefs.getString('id');
    // print(id);
    print(token);  //Abdo1 the token exists but the id isn't
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await http.post(
      Uri.parse('https://mental-health-ef371ab8b1fd.herokuapp.com/api/testscore'),
      body: {
        "totalscores": userScore.toString(),
        "mentalscores": cognitiveScore.toString(),
        "phyicalscores": somaticScore.toString(),
        "user_id": id,
        "date": DateFormat('yyyy/MM/dd').format(DateTime.now()).replaceAll('/', '-')
      },
      headers: headers,
    );

    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> data = jsonDecode(response.body);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MtResult(
            userScore: userScore,
            cognitiveScore: cognitiveScore,
            somaticScore: somaticScore,
          ),
        ),
      );
      showSnackBar(context, data['message']);
    } else {
      print("eerrrrorrr");
      print(response.reasonPhrase);
      showSnackBar(context, 'Failed to submit data: ${response.reasonPhrase}');
    }
  }
}