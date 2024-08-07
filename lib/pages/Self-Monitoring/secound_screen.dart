// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:user_flutter_app/collectionroute/collection.dart';
// import 'package:user_flutter_app/common/preference_manager.dart';
// import 'package:user_flutter_app/repo/login_repo.dart';
// import 'package:user_flutter_app/screen/thired_screen.dart';
// import 'package:http/http.dart' as http;
//
// enum SingingCharacter { male, female }
// FirebaseAuth kFirebaseAuth = FirebaseAuth.instance;
// FirebaseFirestore kFirebaseStore = FirebaseFirestore.instance;
//
// class UserProfileScreen extends StatefulWidget {
//   @override
//   _UserProfileScreenState createState() => _UserProfileScreenState();
// }
//
// class _UserProfileScreenState extends State<UserProfileScreen>
//     with InputValidationMixin {
//   final picker = ImagePicker();
//   String uploadImage;
//   File _image;
//   Future pickImage() async {
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);
//
//     setState(() {
//       _image = File(pickedFile.path);
//       print(_image);
//     });
//   }
//
//   Future uploadImageToFirebase(
//       {BuildContext contex, String fileName, File file}) async {
//     try {
//       var response =
//           FirebaseStorage.instance.ref('uploads/$fileName').putFile(file);
//       return response.storage.ref('uploads/$fileName').getDownloadURL();
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   final formGlobalKey = GlobalKey<FormState>();
//   bool value1 = false;
//   bool value2 = false;
//   bool selected = false;
//   int hobbySelected = 0;
//   String _dropDownValue;
//   bool password;
//   TextEditingController email = TextEditingController();
//   TextEditingController pass = TextEditingController();
//   TextEditingController phn = TextEditingController();
//   TextEditingController fname = TextEditingController();
//   TextEditingController lname = TextEditingController();
//   SingingCharacter _character = SingingCharacter.male;
//   String _userName = '';
//   List hobbies = [];
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: SingleChildScrollView(
//             child: Form(
//               key: formGlobalKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 10),
//                       child: Stack(
//                         children: [
//                           Container(
//                             margin: EdgeInsets.only(bottom: 10, right: 30),
//                             height: 150,
//                             width: 150,
//                             decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                     image: _image == null
//                                         ? NetworkImage(
//                                             'https://media.istockphoto.com/vectors/user-avatar-profile-icon-black-vector-illustration-vector-id1209654046?k=20&m=1209654046&s=612x612&w=0&h=Atw7VdjWG8KgyST8AXXJdmBkzn0lvgqyWod9vTb2XoE=')
//                                         : FileImage(_image),
//                                     fit: BoxFit.cover),
//                                 color: Colors.white.withOpacity(0.9),
//                                 border: Border.all(color: Colors.white, width: 10),
//                                 borderRadius: BorderRadius.circular(25),
//                                 boxShadow: [
//                                   BoxShadow(color: Colors.grey, blurRadius: 10)
//                                 ]),
//                           ),
//                           Positioned(
//                             top: 110,
//                             left: 100,
//                             child: FlatButton(
//                               onPressed: () async {
//                                 pickImage();
//                               },
//                               child: Container(
//                                 height: 45,
//                                 width: 45,
//                                 decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     border: Border.all(
//                                         color: Colors.white, width: 10),
//                                     borderRadius: BorderRadius.circular(25),
//                                     boxShadow: [
//                                       BoxShadow(
//                                           color: Colors.grey, blurRadius: 10)
//                                     ]),
//                                 child: Icon(
//                                   Icons.camera_alt,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Center(
//                     child: Text(
//                       'Set up your profile',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF677294),
//                           fontSize: 20),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Center(
//                     child: Text(
//                       'Update your profile to connect your doctor with ',
//                       style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           color: Color(0xFF677294),
//                           fontSize: 17),
//                     ),
//                   ),
//                   Center(
//                     child: Text(
//                       'better impression',
//                       style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           color: Color(0xFF677294),
//                           fontSize: 17),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     'Registration',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: TextFormField(
//                           controller: fname,
//                           validator: (value) {
//                             if (value.trim().isEmpty) {
//                               return 'This field is required';
//                             } else if (!RegExp('[a-zA-Z]').hasMatch(value)) {
//                               return 'please enter valid name';
//                             }
//                             return null;
//                           },
//                           keyboardType: TextInputType.name,
//                           inputFormatters: [
//                             LengthLimitingTextInputFormatter(20)
//                           ],
//                           onChanged: (value) => _userName = value,
//                           decoration: InputDecoration(
//                               hintText: 'First Name',
//                               filled: true,
//                               focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: BorderSide(
//                                       color: Colors.blue.withOpacity(0.5),
//                                       width: 2)),
//                               enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: BorderSide(
//                                       color: Colors.grey.withOpacity(0.5),
//                                       width: 2)),
//                               focusedErrorBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 borderSide:
//                                     BorderSide(color: Colors.red, width: 2),
//                               ),
//                               errorBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 borderSide:
//                                     BorderSide(color: Colors.red, width: 2),
//                               )),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       Expanded(
//                         child: TextFormField(
//                           validator: (value) {
//                             if (value.trim().isEmpty) {
//                               return 'This field is required';
//                             } else if (!RegExp('[a-zA-Z]').hasMatch(value)) {
//                               return 'please enter valid name';
//                             }
//                             return null;
//                           },
//                           onTap: () {},
//                           controller: lname,
//                           decoration: InputDecoration(
//                               hintText: 'Last Name',
//                               filled: true,
//                               focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: BorderSide(
//                                       color: Colors.blue.withOpacity(0.5),
//                                       width: 2)),
//                               enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: BorderSide(
//                                       color: Colors.grey.withOpacity(0.5),
//                                       width: 2)),
//                               focusedErrorBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 borderSide:
//                                     BorderSide(color: Colors.red, width: 2),
//                               ),
//                               errorBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 borderSide:
//                                     BorderSide(color: Colors.red, width: 2),
//                               )),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   TextFormField(
//                     controller: email,
//                     decoration: InputDecoration(
//                         hintText: 'Email',
//                         filled: true,
//                         focusedErrorBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(color: Colors.red, width: 2),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: BorderSide(
//                                 color: Colors.blue.withOpacity(0.5), width: 2)),
//                         enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: BorderSide(
//                                 color: Colors.grey.withOpacity(0.5), width: 2)),
//                         errorBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(color: Colors.red, width: 2),
//                         )),
//                     validator: (email) {
//                       if (isEmailValid(email))
//                         return null;
//                       else
//                         return 'Enter a valid email address';
//                     },
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   TextFormField(
//                     validator: (value) {
//                       if (value.trim().isEmpty) {
//                         return 'This field is required';
//                       }
//                       if (RegExp("r'(^(?:[+0]9)?[0-9]{10,12}\$)")
//                           .hasMatch(value)) {
//                         return 'please enter valid number';
//                       }
//
//                       return null;
//                     },
//                     controller: phn,
//                     keyboardType: TextInputType.phone,
//                     inputFormatters: [LengthLimitingTextInputFormatter(10)],
//                     decoration: InputDecoration(
//                         hintText: 'Mobile no.',
//                         filled: true,
//                         focusedErrorBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(color: Colors.red, width: 2),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: BorderSide(
//                                 color: Colors.blue.withOpacity(0.5), width: 2)),
//                         enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: BorderSide(
//                                 color: Colors.grey.withOpacity(0.5), width: 2)),
//                         errorBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(color: Colors.red, width: 2),
//                         )),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Row(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 19),
//                         child: Text(
//                           'Gender',
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 17),
//                         ),
//                       ),
//                       Expanded(
//                         child: ListTile(
//                           title: const Text('Male'),
//                           leading: Radio<SingingCharacter>(
//                             value: SingingCharacter.male,
//                             groupValue: _character,
//                             onChanged: (SingingCharacter value) {
//                               setState(() {
//                                 _character = value;
//                               });
//                               print(_character);
//                             },
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: ListTile(
//                           title: const Text('Female'),
//                           leading: Radio<SingingCharacter>(
//                             value: SingingCharacter.female,
//                             groupValue: _character,
//                             onChanged: (SingingCharacter value) {
//                               setState(() {
//                                 _character = value;
//                               });
//                               print(_character);
//                             },
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Container(
//                     width: 400,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey)],
//                     ),
//                     child: DropdownButton(
//                       hint: _dropDownValue == null
//                           ? Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text('City'),
//                             )
//                           : Padding(
//                               padding: const EdgeInsets.all(10),
//                               child: Text(
//                                 _dropDownValue,
//                                 style: TextStyle(
//                                     color: Colors.black, fontSize: 17),
//                               ),
//                             ),
//                       underline: SizedBox(),
//                       isExpanded: true,
//                       iconSize: 30,
//                       style: TextStyle(color: Colors.black),
//                       items: ['India', 'America', 'paris'].map(
//                         (val) {
//                           return DropdownMenuItem<String>(
//                             value: val,
//                             child: Text(val),
//                           );
//                         },
//                       ).toList(),
//                       onChanged: (val) {
//                         setState(
//                           () {
//                             _dropDownValue = val;
//                             print(_dropDownValue);
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         child: Text(
//                           'Hobbies',
//                           style: TextStyle(fontSize: 17),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 20,
//                       ),
//                       Checkbox(
//                         value: this.value1,
//                         onChanged: (bool value) {
//                           setState(() {
//                             this.value1 = value;
//
//                             hobbies.add('singing');
//                             print(hobbies);
//                           });
//                         },
//                       ), //Checkbox
//                       Text('Singing'),
//                       Checkbox(
//                         value: this.value2,
//                         onChanged: (bool value) {
//                           setState(() {
//                             this.value2 = value;
//                             hobbies.add('dancing');
//                           });
//
//                           print(hobbies);
//                         },
//                       ), //Checkbox
//                       Text('Dancing')
//                     ],
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   TextFormField(
//                       obscureText: selected ? false : true,
//                       controller: pass,
//                       decoration: InputDecoration(
//                           hintText: 'Password',
//                           filled: true,
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               selected == false
//                                   ? Icons.remove_red_eye
//                                   : Icons.remove_red_eye_outlined,
//                               color: selected ? Colors.black : Colors.grey,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 selected = !selected;
//                               });
//                             },
//                           ),
//                           focusedErrorBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: BorderSide(color: Colors.red, width: 2),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide: BorderSide(
//                                   color: Colors.blue.withOpacity(0.5),
//                                   width: 2)),
//                           enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide: BorderSide(
//                                   color: Colors.grey.withOpacity(0.5),
//                                   width: 2)),
//                           errorBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide:
//                                   BorderSide(color: Colors.red, width: 2))),
//                       validator: (password) {
//                         if (password.isEmpty) {
//                           return 'Please enter password';
//                         } else if (!isPasswordValid(password)) {
//                           return 'Enter a valid password';
//                         }
//                         return null;
//                         /*  if (isPasswordValid(password)) {
//                           return null;
//                         } else if(isPasswordValid(password).) {
//                           return 'Enter a valid password';
//                         }*/
//                       }),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   InkWell(
//                     child: Container(
//                       width: 400,
//                       height: 50,
//                       decoration: BoxDecoration(
//                           color: Colors.lightBlue,
//                           borderRadius: BorderRadius.circular(10)),
//                       child: Center(
//                           child: Text(
//                         'Submit',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 17),
//                       )),
//                     ),
//                     onTap: () {
//                       if (formGlobalKey.currentState.validate()) {
//                         // formGlobalKey.currentState.save();
//
//                         RegisterRepo.emailRegister(
//                                 email: email.text, pass: pass.text)
//                             .then((value) async {
//                           var imageUrl = await uploadImageToFirebase(
//                               contex: context,
//                               file: _image,
//                               fileName: '${email.text}_profile.jpg');
//                           print('Image$imageUrl');
//                           uploadImage = imageUrl;
//                         }).then((value) => RegisterRepo.currentUser()
//                                 .then((value) {
//                                   userCollection
//                                       .doc('${PreferenceManager.getUId()}')
//                                       .set({
//                                     'email': email.text,
//                                     'password': pass.text,
//                                     'phoneno': phn.text,
//                                     'firstname': fname.text,
//                                     'lastname': lname.text,
//                                     'gender':
//                                         _character == SingingCharacter.male
//                                             ? "Male"
//                                             : "Female",
//                                     'city': _dropDownValue,
//                                     'hobbies': hobbies,
//                                     'imageProfile': uploadImage
//                                   });
//                                   print("Success");
//                                 })
//                                 .catchError((e) => print('Error ===>>> $e'))
//                                 .then((value) =>
//                                     Navigator.push(context, MaterialPageRoute(
//                                       builder: (context) {
//                                         return UserData();
//                                       },
//                                     ))));
//                       }
//                     },
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// mixin StorageReference {}
//
// mixin InputValidationMixin {
//   bool isPasswordValid(String password) => password.length <= 8;
//
//   bool isEmailValid(String email) {
//     Pattern pattern =
//         r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
//     RegExp regex = new RegExp(pattern);
//     return regex.hasMatch(email);
//   }
// }
