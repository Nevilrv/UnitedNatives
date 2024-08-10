import 'package:united_natives/pages/request/maintenace%20req.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key});

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  List<String> doctor = [
    'https://images.theconversation.com/files/304957/original/file-20191203-66986-im7o5.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=1200&h=1200.0&fit=crop',
    'https://media.istockphoto.com/photos/portrait-of-mature-male-doctor-wearing-white-coat-standing-in-picture-id1203995945?k=20&m=1203995945&s=612x612&w=0&h=g0_ioNezBqP0NXrR_36-A5NDHIR0nLabFFrAQVk4PhA=',
    'https://i2-prod.mirror.co.uk/incoming/article4843769.ece/ALTERNATES/s615/Doctor.jpg'
  ];
  List<String> name = [
    'Joshua Reynolds',
    'William Hogarth',
    'Thomas Gainsborough'
  ];
  List<String> specialist = ['MD', 'MBBS', 'BHMS'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Meet with doctor',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleMedium?.color,
                fontSize: 24),
            textAlign: TextAlign.center,
          ),
        ),
        body: SafeArea(
            child: ListView.builder(
          itemCount: doctor.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.all(Get.height * 0.01),
              child: Container(
                height: Get.height * 0.2,
                width: Get.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 0),
                        blurRadius: 10,
                      )
                    ]),
                child: Row(
                  children: [
                    doctorImage(index),
                    doctorDetail(index),
                  ],
                ),
              ),
            );
          },
        )));
  }

  Expanded doctorDetail(int index) {
    return Expanded(
        flex: 2,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.04,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name[index],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Get.width * 0.059,
                ),
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              Row(
                children: [
                  Text(
                    'Specialist : ',
                    style: TextStyle(
                        fontSize: Get.width * 0.049,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    specialist[index],
                    style: TextStyle(fontSize: Get.width * 0.049),
                  ),
                ],
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              Material(
                color: Colors.transparent,
                child: Ink(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15)),
                  child: InkWell(
                    onTap: () {
                      Get.to(const MaintenanceRequestScreen());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Request for meeting',
                        style: TextStyle(
                            fontSize: Get.width * 0.059,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Expanded doctorImage(int index) {
    return Expanded(
        flex: 1,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: NetworkImage(doctor[index])),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
          ),
        ));
  }
}
