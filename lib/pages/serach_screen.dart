import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:united_natives/viewModel/direct_doctor_view_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  DirectDoctorController directDoctorController =
      Get.put(DirectDoctorController());
  @override
  void initState() {
    // TODO: implement initState
    directDoctorController.getAllDoctor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Search',
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: const Color(0XFF343434), width: 1.0)),
              child: TextFormField(
                controller: searchController,
                onChanged: (str) {
                  setState(() {
                    // searchUserList(str: str);
                  });
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search Provider......',
                    hintStyle: const TextStyle(
                        color: Color(0XFFA5A5A5), fontWeight: FontWeight.w400),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        // setState(() {
                        // searchUserList();
                        // });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8)),
                        width: Get.width * 0.06,
                        child: const Icon(Icons.search, color: Colors.white),
                      ),
                    )),
                validator: (name) {
                  // Basic validation
                  if (name?.isEmpty ?? false) {
                    return "Please enter user name".tr;
                  }
                  return null;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
