import 'package:flutter/material.dart';
import 'package:mapfeature_project/Test/SenseOfPunishment.dart';
import 'package:mapfeature_project/Test/loss%20of%20pleasure.dart';
import 'package:mapfeature_project/main.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:typewritertext/typewritertext.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import 'package:mapfeature_project/Test/DifficultyOfConcentration.dart';
import 'package:mapfeature_project/Test/Indecision.dart';

class Guilt extends StatefulWidget {
  @override
  _Guilt createState() => _Guilt();
}

class _Guilt extends State<Guilt> {
  String selectedOption = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0),
            child: TextAnimator(
              'One More...',
              atRestEffect: WidgetRestingEffects.pulse(effectStrength: 0.6),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
              incomingEffect: WidgetTransitionEffects.incomingSlideInFromTop(
                  blur: const Offset(0, 20), scale: 2),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: const StepProgressIndicator(
              totalSteps: 21,
              currentStep: 5,
              size: 13,
              padding: 0,
              unselectedColor: Colors.white,
              roundedEdges: Radius.circular(10),
              selectedGradientColor: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF8ABAC5), Colors.white],
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
              '5. Guilt',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          RadioListTile<String>(
            title: const Text('I  don\'t feel particularly guilty.'),
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
            title: const Text('I feel a good part of the time.'),
            groupValue: selectedOption,
            value: 'b',
            onChanged: (value) {
              setState(() {
                selectedOption = value!;
                userScore += 1;
                cognitiveScore += 1;
              });
            },
            activeColor: const Color(0xFF8ABAC5),
          ),
          RadioListTile<String>(
            title: const Text('I feel quite guilty most of the time.'),
            groupValue: selectedOption,
            value: 'c',
            onChanged: (value) {
              setState(() {
                selectedOption = value!;
                userScore += 2;
                cognitiveScore += 2;
              });
            },
            activeColor: const Color(0xFF8ABAC5),
          ),
          RadioListTile<String>(
            title: const Text('I feel guilty all of the time.'),
            groupValue: selectedOption,
            value: 'd',
            onChanged: (value) {
              setState(() {
                selectedOption = value!;
                userScore += 3;
                cognitiveScore += 3;
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
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LossOfPleasure()));
              },
              child: const Icon(Icons.navigate_before),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                // تحويل للشاشة التي تأتي بعد الشاشة الحالية
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SenseOfPunishment()));
              },
              child: const Icon(Icons.navigate_next),
            ),
            label: '',
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.0),
              Text(
                '@“Let’s Start…”',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16.0),
              // Add more Drawer items if needed
            ],
          ),
        ),
      ),
    );
  }
}
