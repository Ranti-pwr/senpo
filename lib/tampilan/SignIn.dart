import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:gocrane_v3_new/Widget/Alert.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gocrane_v3_new/tampilan/home.dart';

String? login_id;
String? login_username;
String? login_password;
String? login_status;
String? pegawaiid;
String? pegawainama;
String? pegawai_alamat;
String? pegawai_no_hp;
String? pegawai_foto;
String? pegawai_tanggal_lahir;
String? pegawai_email;

String? username;
String? dep_nama;
String? usr_foto;

String? usr_when_create;
String? usr_id;
String? usr_loginname;
String? usr_email;

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _showClearButton = false;

  void initState() {
    super.initState();

    emailController.addListener(() {
      setState(() {
        _showClearButton = emailController.text.length > 0;
      });
    });
  }

  Widget _getClearButton() {
    if (!_showClearButton) {
      return Text("");
    }
    return InkWell(
      onTap: () {
        emailController.clear();
      },
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "assets/icons/ic_clear.png",
            scale: 4.3,
          )),
    );
  }

  //
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  //Form Validation
//   var _formKey = GlobalKey<FormState>();
//   String _email;
//   String _password;

//   void _submit() async {
//     final isValid = _formKey.currentState.validate();
//     if (!isValid) {
//       return;
//     }
//     _formKey.currentState.save();
//     Navigator.push(context, SlidePageRoute(page: HomePage()));
//   }

//   bool isEmail(String input) => EmailValidator.validate(input);
//   bool isPhone(String input) =>
//       RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
//           .hasMatch(input);

//   String validateMobile(String value) {
//     String patttern = r'(^[0-9]*$)';
//     RegExp regExp = new RegExp(patttern);
//     if (value.length == 0) {
//       return "Invalid phone no";
//     }
//     return null;
//   }

// //
//   String validatePassword(String value) {
//     final RegExp _passwordRegExp = RegExp(
//       r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
//     );
//     Pattern pattern = "^(?=(.*\d){1})(.*\S)(?=.*[a-zA-Z\S])[0-9a-zA-Z\S]{8,}";
//     RegExp regex = new RegExp(pattern);
//     print(value);
//     if (value.isEmpty) {
//       return 'Invalid password';
//     } else if (value.length < 8) {
//       return "Password should be between 8-20 characters";
//     } else {
//       if (!_passwordRegExp.hasMatch(value))
//         return 'Use 8-20 characters from at least 2 categories:\nletters, numbers, special characters';
//       else
//         return null;
//     }
//   }

  bool checkBoxValue = false;
  _onChange(bool val) {
    setState(() {
      checkBoxValue = val;
    });
  }

  //============================================================================

  Future _login() async {
    if (emailController.text.isEmpty || emailController.text.isEmpty) {
      return showDialog<void>(
          context: context,
          builder: (BuildContext dialogContext) {
            return Alert(
              title: "Pembritahuan !!!",
              subTile: "Akun tidak benar!",
            );
          });
    }

    final Response = await http.post(
      Uri.parse("http://103.27.206.23/api_gocrane_v3/login.php"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "username": emailController.text,
        "password": passwordController.text
      },
    );

    var datauser = jsonDecode(Response.body);

    if (datauser == false) {
      return showDialog<void>(
          context: context,
          builder: (BuildContext dialogContext) {
            return Alert(
              title: datauser.toString(),
              subTile: datauser.toString(),
            );
          });
      //========================================================================
    } else if (datauser?[0]['id_rol'] != "1" && datauser?[0]['id_rol'] != "2") {
      showDialog<void>(
          context: context,
          builder: (BuildContext dialogContext) {
            return Alert(
              title: "Pembritahuan !!!",
              subTile: "Anda Bukan User",
            );
          });
    } else {
      setState(() {
        // login_id = datauser[0]['usr_id'];
        // login_username = datauser[0]['usr_name'];
        // login_status = datauser[0]['setatus_pegawai'];
        // pegawaiid = datauser[0]['nip'];
        // pegawainama = datauser[0]['nama'];
        // pegawai_alamat = datauser[0]['alamat'];
        // pegawai_no_hp = datauser[0]['no_wa'];
        // pegawai_foto = datauser[0]['pegawai_foto'];
        // pegawai_tanggal_lahir = datauser[0]['pegawai_no_str'];
        // pegawai_email = datauser[0]['telemedicine_id'];

        usr_id = datauser?[0]['usr_id'];
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false);
        datauser = jsonDecode(Response.body);
      });
      print(pegawaiid);

      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString("usr_id", datauser?[0]['usr_id']);
      // prefs.setString("usr_name", datauser[0]['usr_name']);

      // prefs.setBool("isUser", true);
      // prefs.setString("login_id", datauser[0]['login_id']);
      // prefs.setString("username", datauser[0]['usr_name']);
      // prefs.setString("usr_when_create", datauser[0]['usr_when_create']);
      // prefs.setString("usr_loginname", datauser[0]['usr_loginname']);
      // prefs.setString("usr_email", datauser[0]['usr_email']);

      print(datauser);
      return datauser;
    }
  }

  //============================================================================
  // checkVal(BuildContext context) {
  //   if (emailController.text.isEmpty) {
  // return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext dialogContext) {
  //       return Alert(
  //         title: "Alert !!!",
  //         subTile: "Email is required !",
  //       );
  //     });
  //   } else if (passwordController.text.isEmpty ||
  //       passwordController.text.length < 3) {
  //     if (passwordController.text.length >= 1 &&
  //         passwordController.text.length < 3) {
  //       showDialog<void>(
  //           context: context,
  //           builder: (BuildContext dialogContext) {
  //             return Alert(
  //               title: "Alert !!!",
  //               subTile: "Password must be 3 digit !",
  //             );
  //           });
  //     } else {
  //       showDialog<void>(
  //           context: context,
  //           builder: (BuildContext dialogContext) {
  //             return Alert(
  //               title: "Alert !!!",
  //               subTile: "Password can't empty !",
  //             );
  //           });
  //     }
  //   } else {
  //     _login();
  //   }
  // }

  //============================================================================
  MediaQueryData? queryData;
  FocusNode usernameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return MediaQuery(
      data: queryData!.copyWith(textScaleFactor: 1.0),
      child: SafeArea(
        child: Scaffold(
          body: Form(
            // key: _formKey,
            child: Container(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      top: 52,
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Login",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   height: 35,
                  // ),

                  //Appbar
                  // Container(
                  //   height: 50,
                  //   child: Stack(
                  //     fit: StackFit.expand,
                  //     children: [
                  //       //back btn
                  //       Positioned.directional(
                  //         textDirection: Directionality.of(context),
                  //         start: -4,
                  //         top: 0,
                  //         bottom: 0,
                  //         child: InkWell(
                  //           onTap: () {
                  //             Navigator.pop(context);
                  //           },
                  //           child: Padding(
                  //             padding: const EdgeInsets.all(10.0),
                  //             child: Image.asset(
                  //               "assets/icons/ic_back.png",
                  //               scale: 30,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  //
                  Expanded(
                    child: Container(
                      child: ListView(
                        children: [
                          //Space
                          const SizedBox(
                            height: 35,
                          ),
                          //Sign In

                          //Space
                          Container(
                            width: 300,
                            // height: 300,

                            height: 150,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image: AssetImage(
                                      "assets/icons/gocranelog.png",
                                    ))),
                          ),
                          const SizedBox(
                            height: 35,
                          ),

                          //Space

                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Username",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xff141414),
                                    fontSize: 14,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.06,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //Email or Phone Number
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Stack(
                              children: [
                                TextFormField(
                                  cursorColor: Color.fromARGB(255, 48, 47, 47),
                                  controller: emailController,
                                  textInputAction: TextInputAction.next,
                                  focusNode: usernameFocusNode,
                                  onFieldSubmitted: (value) {
                                    // Fokus ke TextField selanjutnya
                                    FocusScope.of(context)
                                        .requestFocus(passwordFocusNode);
                                  },
                                  decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(255, 48, 47,
                                              47)), // Ubah warna border saat terfokus
                                    ),
                                    contentPadding:
                                        EdgeInsets.only(top: 5, left: 14),
                                    labelText: "Input Username",
                                    border: OutlineInputBorder(
                                      // Tambahkan border di sini
                                      // Atur radius sesuai keinginan
                                      borderSide: BorderSide(
                                        // Tentukan warna dan ketebalan garis
                                        color: Colors.grey, // Warna garis
                                        width: 1.0, // Ketebalan garis
                                      ),
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                  ),
                                )
                              ],
                            ),
                          ),
                          //Space
                          // SizedBox(
                          //   height: 17,
                          // ),
                          //Password Text Field
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Password",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xff141414),
                                    fontSize: 14,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.06,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Stack(
                              children: [
                                TextFormField(
                                  cursorColor: Color.fromARGB(255, 48, 47, 47),
                                  obscureText: _obscureText,
                                  controller: passwordController,
                                  keyboardType: TextInputType.visiblePassword,
                                  focusNode: passwordFocusNode,
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: () {
                                    // Navigator.push(context,
                                    //     SlidePageRoute(page: HomePage()));
                                  },
                                  decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(255, 48, 47,
                                              47)), // Ubah warna border saat terfokus
                                    ),
                                    contentPadding: EdgeInsets.only(left: 14),
                                    labelText: "Input Password",
                                    labelStyle: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "medium",
                                        color: Color.fromARGB(255, 48, 47, 47)),
                                    border: OutlineInputBorder(
                                      // Tambahkan border di sini
                                      // Atur radius sesuai keinginan
                                      borderSide: BorderSide(
                                        // Tentukan warna dan ketebalan garis
                                        color: Colors.grey, // Warna garis
                                        width: 1.0, // Ketebalan garis
                                      ),
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                  ),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: "medium",
                                      color: Color.fromARGB(255, 48, 47, 47)),
                                ),
                                Positioned.directional(
                                  textDirection: Directionality.of(context),
                                  end: 8,
                                  top: 4,
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _toggle();
                                        });
                                      },
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: _obscureText
                                              ? const Icon(
                                                  Icons.visibility_off,
                                                  color: Colors.grey,
                                                )
                                              : const Icon(
                                                  Icons.visibility_outlined,
                                                  color: Colors.grey,
                                                ))),
                                )
                              ],
                            ),
                          ),

                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Forget Password?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xff6e5de7),
                                    fontSize: 12,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.06,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Container(
                          //   margin: const EdgeInsets.all(15.0),
                          //   padding: const EdgeInsets.all(3.0),
                          //   decoration: BoxDecoration(
                          //       border: Border.all(
                          //           color: Theme.of(context)
                          //               .accentTextTheme
                          //               .headline4
                          //               .color)),
                          //   // padding: EdgeInsets.symmetric(horizontal: 16),
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(1.0),
                          //     child: DropdownButton(
                          //       isExpanded: true,

                          //       hint: Text(
                          //         "   Jabatan",
                          //         style: TextStyle(
                          //             fontSize: 14,
                          //             fontFamily: "medium",
                          //             color: Theme.of(context)
                          //                 .accentTextTheme
                          //                 .headline4
                          //                 .color),
                          //         semanticsLabel: "Jabatan",
                          //       ),
                          //       // borderRadius: BorderRadius.circular(4),
                          //       value: jabatan,
                          //       items: pilihjabatan.map((item) {
                          //         return DropdownMenuItem(
                          //           child: Text(
                          //             item['jabatan_nama'],
                          //             style: TextStyle(
                          //                 fontSize: 14,
                          //                 fontFamily: "medium",
                          //                 color: Theme.of(context)
                          //                     .accentTextTheme
                          //                     .headline2
                          //                     .color),
                          //           ),
                          //           value: item['nilai'],
                          //         );
                          //       }).toList(),
                          //       onChanged: (value) {
                          //         setState(() {
                          //           jabatan = value;
                          //           print(jabatan);
                          //         });
                          //       },
                          //     ),
                          //   ),
                          // ),

                          //SIGN IN button

                          //OR
                          // Container(
                          //   padding: EdgeInsets.symmetric(vertical: 15),
                          //   alignment: Alignment.center,
                          //   child: Text(
                          //     "OR",
                          //     style: TextStyle(
                          //       color:
                          //           Theme.of(context).textTheme.headline2.color,
                          //       fontSize: 18,
                          //       fontFamily: 'medium',
                          //     ),
                          //   ),
                          // ),
                          //CONTINUE WITH FACEBOOK
                          // Container(
                          //   padding: EdgeInsets.symmetric(horizontal: 16),
                          //   child: Row(
                          //     children: [
                          //       Expanded(
                          //         child: MaterialButton(
                          //           height: 44,
                          //           onPressed: () {
                          //             FocusScope.of(context)
                          //                 .requestFocus(FocusNode());
                          //             Navigator.push(context,
                          //                 SlidePageRoute(page: HomePage()));
                          //           },
                          //           shape: RoundedRectangleBorder(
                          //               borderRadius: BorderRadius.circular(4)),
                          //           color: Theme.of(context)
                          //               .accentTextTheme
                          //               .subtitle1
                          //               .color,
                          //           elevation: 0,
                          //           highlightElevation: 0,
                          //           child: Container(
                          //             height: 44,
                          //             child: Stack(
                          //               clipBehavior: Clip.none,
                          //               fit: StackFit.expand,
                          //               children: [
                          //                 Positioned.directional(
                          //                     textDirection:
                          //                         Directionality.of(context),
                          //                     start: -19,
                          //                     top: 0,
                          //                     bottom: 0,
                          //                     child: Image.asset(
                          //                       "assets/icons/ic_fb.png",
                          //                       scale: 3.2,
                          //                     )),
                          //                 Positioned.directional(
                          //                   textDirection:
                          //                       Directionality.of(context),
                          //                   start: 0,
                          //                   end: 0,
                          //                   top: 0,
                          //                   bottom: 0,
                          //                   child: Container(
                          //                     alignment: Alignment.center,
                          //                     child: Text(
                          //                       "Continue with Facebook",
                          //                       style: TextStyle(
                          //                         fontFamily: 'medium',
                          //                         fontSize: 15,
                          //                         color: Theme.of(context)
                          //                             .textTheme
                          //                             .subtitle2
                          //                             .color,
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          //Space

                          //CONTINUE WITH GOOGLE
                          // Container(
                          //   padding: EdgeInsets.symmetric(horizontal: 16),
                          //   child: Row(
                          //     children: [
                          //       Expanded(
                          //         child: MaterialButton(
                          //           height: 44,
                          //           onPressed: () {
                          //             FocusScope.of(context)
                          //                 .requestFocus(FocusNode());
                          //             Navigator.push(context,
                          //                 SlidePageRoute(page: HomePage()));
                          //           },
                          //           shape: RoundedRectangleBorder(
                          //               borderRadius: BorderRadius.circular(4)),
                          //           color: Theme.of(context)
                          //               .accentTextTheme
                          //               .headline5
                          //               .color,
                          //           elevation: 0,
                          //           highlightElevation: 0,
                          //           child: Container(
                          //             height: 44,
                          //             child: Stack(
                          //               clipBehavior: Clip.none,
                          //               fit: StackFit.expand,
                          //               children: [
                          //                 Positioned.directional(
                          //                     textDirection:
                          //                         Directionality.of(context),
                          //                     start: -19,
                          //                     top: 0,
                          //                     bottom: 0,
                          //                     child: Image.asset(
                          //                       "assets/icons/ic_google.png",
                          //                       scale: 3.2,
                          //                     )),
                          //                 Positioned.directional(
                          //                   textDirection:
                          //                       Directionality.of(context),
                          //                   start: 0,
                          //                   end: 0,
                          //                   top: 0,
                          //                   bottom: 0,
                          //                   child: Container(
                          //                     alignment: Alignment.center,
                          //                     child: Text(
                          //                       "Masuk akun Google",
                          //                       style: TextStyle(
                          //                         fontFamily: 'medium',
                          //                         fontSize: 15,
                          //                         color: Theme.of(context)
                          //                             .textTheme
                          //                             .subtitle2
                          //                             .color,
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  ),
                  MaterialButton(
                      onPressed: () async {
                        _login();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 340,
                              height: 55,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0xff2ab2a2),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Login",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.08,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),

                  SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
