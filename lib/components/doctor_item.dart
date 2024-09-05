import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:united_natives/viewModel/book_appointment_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/utils.dart';
import 'package:united_natives/utils/utils.dart';

import '../utils/constants.dart';

class DoctorItem extends StatefulWidget {
  final String doctorAvatar;
  final String doctorName;
  final String doctorSpeciality;
  final String doctorPrice;
  final Function() onTap;
  final String rating;

  const DoctorItem(
      {super.key,
      required this.doctorAvatar,
      required this.doctorName,
      required this.doctorSpeciality,
      required this.doctorPrice,
      required this.onTap,
      required this.rating});

  @override
  State<DoctorItem> createState() => _DoctorItemState();
}

class _DoctorItemState extends State<DoctorItem> {
  final BookAppointmentController _bookAppointmentController =
      Get.find<BookAppointmentController>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: <Widget>[
              Utils().imageProfile(widget.doctorAvatar, 30),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            widget.doctorName,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        const Icon(
                          Icons.star,
                          color: kColorBlue,
                          size: 18,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.rating,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      widget.doctorSpeciality,
                      style: TextStyle(color: Colors.grey[400], fontSize: 16),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          '${Translate.of(context)?.translate('start_from')} \$${widget.doctorPrice}',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 15),
                        _bookAppointmentController.medicalName ==
                                "United Natives"
                            ? const SizedBox()
                            : Text(
                                Translate.of(context)!
                                    .translate('(Other Provider)'),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red),
                              ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
