import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../database/moor_database.dart';
import '../models/Medicine.dart';
import 'MedicineCard.dart';

class MedicineGridView extends StatelessWidget {
  final List<MedicinesTableData> list;
  final bool isDark;

  MedicineGridView(this.list, this.isDark);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MedicineModel>(
        builder: (context, child, model) {
      return GridView.count(
        crossAxisCount: 1,
        shrinkWrap: true,
        childAspectRatio: 2 / 0.7,
        children: list.map((medicine) {
          return InkWell(
            onTap: () {
              // details screen
            },
            child: buildLongPressDraggable(medicine, model, isDark),
          );
        }).toList(),
      );
    });
  }

  /*LongPressDraggable<MedicinesTableData>*/ buildLongPressDraggable(
      medicine, MedicineModel model, bool isDark) {
    return Card(
      margin: EdgeInsets.all(10),
      child: MecicineCard(medicine, isDark),
    );
    /*LongPressDraggable<MedicinesTableData>(
      */ /* data: medicine,
      onDragStarted: () {
        // show the delete icon
        model.toggleIconState();
      },
      onDragEnd: (v) {
        // hide the delete icon
        model.toggleIconState();
      },*/ /*
      child: Card(
        margin: EdgeInsets.all(10),
        child: MecicineCard(medicine, Colors.grey[100]),
      ),
      */ /*FadeAnimation(
        .05,
        Card(
          margin: EdgeInsets.all(10),
          child: MecicineCard(medicine, Colors.grey[100]),
        ),
      )*/ /*
      */ /* childWhenDragging: Container(
        color: Colors.blue.withOpacity(.3),
      ),*/ /*
      feedback: Card(
        child: MecicineCard(medicine, Colors.transparent),
      ),
    )*/
  }
}
