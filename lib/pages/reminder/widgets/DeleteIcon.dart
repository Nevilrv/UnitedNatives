import 'package:flutter/material.dart';
import '../../reminder//animations/fade_animation.dart';
import 'package:scoped_model/scoped_model.dart';
import '../database/moor_database.dart';
import '../models/Medicine.dart';

class DeleteIcon extends StatefulWidget {
  final Color color = Colors.grey;

  const DeleteIcon({super.key});
  @override
  State<DeleteIcon> createState() => _DeleteIconState();
}

class _DeleteIconState extends State<DeleteIcon> {
  Color? color;

  @override
  initState() {
    color = widget.color;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 20,
        left: 100,
        right: 100,
        child: ScopedModelDescendant<MedicineModel>(
            builder: (context, child, model) {
          return DragTarget<MedicinesTableData>(
            builder: (context, rejectedData, candidtateData) {
              return FadeAnimation(
                .5,
                Container(
                  width: 250,
                  height: 220,
                  color: Colors.transparent,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Icon(
                      Icons.delete,
                      color: widget.color,
                      size: 60,
                    ),
                  ),
                ),
              );
            },
            onWillAcceptWithDetails: (medicine) {
              setState(() {
                color = Colors.red;
              });
              return true;
            },
            onLeave: (v) {
              setState(() {
                color = Colors.grey;
              });
            },
            onAcceptWithDetails: (medicine) {
              // remove it from the database
              model
                  .getDatabase()
                  .deleteMedicine(medicine as MedicinesTableData);
              //remove the medicine notifcation

              // for debugging
              // show delete snakbar

              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  'Reminder deleted',
                  style: TextStyle(fontSize: 22),
                ),
                duration: Duration(seconds: 1),
              ));
            },
          );
        }));
  }
}
