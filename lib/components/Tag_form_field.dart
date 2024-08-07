// import 'package:flutter/material.dart';
// import 'package:flutter_tagging/flutter_tagging.dart';
//
// class CustomTagField extends StatefulWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final bool obscureText;
//   final bool enabled;
//   final Widget suffixIcon;
//   final bool suffixIconTap;
//   final String error;
//   final TextInputType keyboardType;
//   final Function validator;
//
//   const CustomTagField({
//     Key key,
//     this.controller,
//     @required this.hintText,
//     this.keyboardType,
//     this.obscureText,
//     this.enabled,
//     this.suffixIcon,
//     this.suffixIconTap,
//     this.error,
//     this.validator,
//   }) : super(key: key);
//
//   @override
//   _CustomTagFieldState createState() => _CustomTagFieldState();
// }
//
// class _CustomTagFieldState extends State<CustomTagField> {
//   String text = "";
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(2.0),
//               child: FlutterTagging(
//                 textFieldDecoration: InputDecoration(
//                     hintText: "Speciality",),
//                 addButtonWidget: _buildAddButton(),
//                 chipsColor: Colors.blueAccent,
//                 chipsFontColor: Colors.white,
//                 deleteIcon: Icon(Icons.cancel,color: Colors.white),
//                 chipsPadding: EdgeInsets.all(2.0),
//                 chipsFontSize: 14.0,
//                 chipsSpacing: 5.0,
//                 chipsFontFamily: 'helvetica_neue_light',
//                 suggestionsCallback: (pattern) async {
//                   return await TagSearchService.getSuggestions(pattern);
//                 },
//                 onChanged: (result) {
//                   setState(() {
//                     text = result.toString();
//                   });
//                 },
//               ),
//             ),
//             SizedBox(
//               height: 3.0,
//             ),
//             Center(
//               child: Text(
//                 text,
//                 style: TextStyle(color: Colors.blue),
//               ),
//             )
//           ],
//         ),
//       );
//   }
//
//   Widget _buildAddButton() {
//     return Container(
//       padding: EdgeInsets.all(8.0),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//         color: Colors.blueAccent,
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Icon(
//             Icons.add,
//             color: Colors.white,
//             size: 15.0,
//           ),
//           Text(
//             "Add New Tag",
//             style: TextStyle(color: Colors.white, fontSize: 14.0),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class TagSearchService {
//   static Future<List> getSuggestions(String query) async {
//     await Future.delayed(Duration(milliseconds: 400), null);
//     List<dynamic> tagList = <dynamic>[];
//     List<dynamic> filteredTagList = <dynamic>[];
//     if (query.isNotEmpty) {
//       filteredTagList.add({'name': query, 'value': 0});
//     }
//     for (var tag in tagList) {
//       if (tag['name'].toLowerCase().contains(query)) {
//         filteredTagList.add(tag);
//       }
//     }
//     return filteredTagList;
//   }
// }
