import 'package:flutter/material.dart';

class MyStepperWidget extends StatefulWidget {
  @override
  _MyStepperWidgetState createState() => _MyStepperWidgetState();
}

class _MyStepperWidgetState extends State<MyStepperWidget> {
  // ignore: unused_field
  int? _currentStep = 0;

  // ignore: unused_field
  List<Step> _steps = [
    Step(
      title: Text('Waktu'),
      subtitle: Text('Unit'),
      content: Text('Step 1 Content'),
      isActive: true,
    ),
    Step(
      title: Text('Pekerjaan'),
      subtitle: Text('Unit'),
      content: Text('Step 2 Content'),
      isActive: true,
    ),
    Step(
      title: Text('Cetak'),
      subtitle: Text('Unit'),
      content: Text('Step 3 Content'),
      isActive: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 299,
      height: 49,
      child: Stack(
        children: [
          Positioned(
            left: 9,
            top: 0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff2ab2a2),
              ),
            ),
          ),
          Positioned(
            left: 95,
            top: 0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffeae6e6),
              ),
            ),
          ),
          Positioned(
            left: 181,
            top: 0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffeae6e6),
              ),
            ),
          ),
          Positioned(
            left: 267,
            top: 0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffeae6e6),
              ),
            ),
          ),
          Positioned(
            left: 32,
            top: 10,
            child: Container(
              width: 65,
              height: 4,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 63.33,
                        height: 4,
                        color: Color(0xffeae6e6),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 36.67,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(2),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(2),
                          ),
                          color: Color(0xff2ab2a2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 117,
            top: 10,
            child: Container(
              width: 65,
              height: 4,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 63.33,
                        height: 4,
                        color: Color(0xffeae6e6),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 36.67,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(2),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(2),
                          ),
                          color: Color(0xffeae6e6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 202,
            top: 10,
            child: Container(
              width: 65,
              height: 4,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 63.33,
                        height: 4,
                        color: Color(0xffeae6e6),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 36.67,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(2),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(2),
                          ),
                          color: Color(0xffeae6e6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Waktu",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xff141414),
                  fontSize: 14,
                  letterSpacing: 0.07,
                ),
              ),
            ),
          ),
          Positioned(
            left: 93,
            top: 32,
            child: Text(
              "Unit",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff141414),
                fontSize: 14,
                letterSpacing: 0.07,
              ),
            ),
          ),
          Positioned(
            left: 159,
            top: 32,
            child: Text(
              "Pekerjaan",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff141414),
                fontSize: 14,
                letterSpacing: 0.07,
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "Cetak",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xff141414),
                  fontSize: 14,
                  letterSpacing: 0.07,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyStepperWidget_2 extends StatefulWidget {
  @override
  _MyStepperWidget_2State createState() => _MyStepperWidget_2State();
}

class _MyStepperWidget_2State extends State<MyStepperWidget_2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 299,
      height: 49,
      child: Stack(
        children: [
          Positioned(
            left: 32,
            top: 10,
            child: Container(
              width: 65,
              height: 4,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 63.33,
                        height: 4,
                        color: Color(0xff2ab2a2),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 36.67,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(2),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(2),
                          ),
                          color: Color(0xff2ab2a2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 9,
            top: 0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff2ab2a2),
              ),
            ),
          ),
          Positioned(
            left: 95,
            top: 0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff2ab2a2),
              ),
            ),
          ),
          Positioned(
            left: 181,
            top: 0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffeae6e6),
              ),
            ),
          ),
          Positioned(
            left: 267,
            top: 0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffeae6e6),
              ),
            ),
          ),
          Positioned(
            left: 117,
            top: 10,
            child: Container(
              width: 65,
              height: 4,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 63.33,
                        height: 4,
                        color: Color(0xffeae6e6),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 36.67,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(2),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(2),
                          ),
                          color: Color(0xff2ab2a2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 202,
            top: 10,
            child: Container(
              width: 65,
              height: 4,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 63.33,
                        height: 4,
                        color: Color(0xffeae6e6),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 36.67,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(2),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(2),
                          ),
                          color: Color(0xffeae6e6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Waktu",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xff141414),
                  fontSize: 14,
                  letterSpacing: 0.07,
                ),
              ),
            ),
          ),
          Positioned(
            left: 93,
            top: 32,
            child: Text(
              "Unit",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff141414),
                fontSize: 14,
                letterSpacing: 0.07,
              ),
            ),
          ),
          Positioned(
            left: 159,
            top: 32,
            child: Text(
              "Pekerjaan",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff141414),
                fontSize: 14,
                letterSpacing: 0.07,
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "Cetak",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xff141414),
                  fontSize: 14,
                  letterSpacing: 0.07,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyStepperWidget_3 extends StatefulWidget {
  @override
  _MyStepperWidget_3State createState() => _MyStepperWidget_3State();
}

class _MyStepperWidget_3State extends State<MyStepperWidget_3> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 299,
      height: 49,
      child: Stack(
        children: [
          Positioned(
            left: 32,
            top: 10,
            child: Container(
              width: 65,
              height: 4,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 63.33,
                        height: 4,
                        color: Color(0xff2ab2a2),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 36.67,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(2),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(2),
                          ),
                          color: Color(0xff2ab2a2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 9,
            top: 0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff2ab2a2),
              ),
            ),
          ),
          Positioned(
            left: 95,
            top: 0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff2ab2a2),
              ),
            ),
          ),
          Positioned(
            left: 181,
            top: 0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff2ab2a2),
              ),
            ),
          ),
          Positioned(
            left: 267,
            top: 0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffeae6e6),
              ),
            ),
          ),
          Positioned(
            left: 117,
            top: 10,
            child: Container(
              width: 65,
              height: 4,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 63.33,
                        height: 4,
                        color: Color(0xff2ab2a2),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 36.67,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(2),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(2),
                          ),
                          color: Color(0xff2ab2a2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 202,
            top: 10,
            child: Container(
              width: 65,
              height: 4,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 63.33,
                        height: 4,
                        color: Color(0xffeae6e6),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 36.67,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(2),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(2),
                          ),
                          color: Color(0xff2ab2a2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Waktu",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xff141414),
                  fontSize: 14,
                  letterSpacing: 0.07,
                ),
              ),
            ),
          ),
          Positioned(
            left: 93,
            top: 32,
            child: Text(
              "Unit",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff141414),
                fontSize: 14,
                letterSpacing: 0.07,
              ),
            ),
          ),
          Positioned(
            left: 159,
            top: 32,
            child: Text(
              "Pekerjaan",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff141414),
                fontSize: 14,
                letterSpacing: 0.07,
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "Cetak",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xff141414),
                  fontSize: 14,
                  letterSpacing: 0.07,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyStepperWidget_4 extends StatefulWidget {
  @override
  _MyStepperWidget_4State createState() => _MyStepperWidget_4State();
}

class _MyStepperWidget_4State extends State<MyStepperWidget_4> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 299,
      height: 49,
      child: Stack(
        children: [
          Positioned(
            left: 32,
            top: 10,
            child: Container(
              width: 65,
              height: 4,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 63.33,
                        height: 4,
                        color: Color(0xff2ab2a2),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 36.67,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(2),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(2),
                          ),
                          color: Color(0xff2ab2a2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 9,
            top: 0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff2ab2a2),
              ),
            ),
          ),
          Positioned(
            left: 95,
            top: 0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff2ab2a2),
              ),
            ),
          ),
          Positioned(
            left: 181,
            top: 0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff2ab2a2),
              ),
            ),
          ),
          Positioned(
            left: 267,
            top: 0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff2ab2a2),
              ),
            ),
          ),
          Positioned(
            left: 117,
            top: 10,
            child: Container(
              width: 65,
              height: 4,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 63.33,
                        height: 4,
                        color: Color(0xff2ab2a2),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 36.67,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(2),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(2),
                          ),
                          color: Color(0xff2ab2a2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 202,
            top: 10,
            child: Container(
              width: 65,
              height: 4,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 63.33,
                        height: 4,
                        color: Color(0xff2ab2a2),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 36.67,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(2),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(2),
                          ),
                          color: Color(0xff2ab2a2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Waktu",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xff141414),
                  fontSize: 14,
                  letterSpacing: 0.07,
                ),
              ),
            ),
          ),
          Positioned(
            left: 93,
            top: 32,
            child: Text(
              "Unit",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff141414),
                fontSize: 14,
                letterSpacing: 0.07,
              ),
            ),
          ),
          Positioned(
            left: 159,
            top: 32,
            child: Text(
              "Pekerjaan",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff141414),
                fontSize: 14,
                letterSpacing: 0.07,
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "Cetak",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xff141414),
                  fontSize: 14,
                  letterSpacing: 0.07,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
