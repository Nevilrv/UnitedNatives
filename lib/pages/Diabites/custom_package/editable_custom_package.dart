// Copyright 2020 Godwin Asuquo. All rights reserved.
//
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

library editable;

import 'package:doctor_appointment_booking/data/pref_manager.dart';
import 'package:doctor_appointment_booking/pages/Diabites/custom_package/helpers.dart';
import 'package:doctor_appointment_booking/pages/Diabites/custom_package/row_builder.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Editable extends StatefulWidget {
  /// Builds an editable table using predefined row and column counts
  /// Or using a row and header data set provided
  ///
  /// if no data is provided for [row] and [column],
  /// [rowCount] and [columnCount] properties must be set
  /// this will generate an empty table
  ///
  /// it is useful for rendering data from an API or to create a spreadsheet-like
  /// data table
  ///
  /// example:
  ///
  /// ```dart
  ///  Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Column(
  ///       children: <Widget>[
  ///           Expanded(
  ///           flex: 1,
  ///           child: EdiTable(
  ///               showCreateButton: true,
  ///               tdStyle: TextStyle(fontSize: 20),
  ///               showSaveIcon: false,
  ///               borderColor: Colors.lightBlue,
  ///               columnCount: 4,
  ///               rowCount: 8
  ///              ),
  ///           ).
  ///         ]
  ///       ),
  ///   );
  /// }
  /// ```
  Editable(
      {Key key,
      this.columns,
      this.rows,
      this.columnRatio = 0.20,
      this.onSubmitted,
      this.onRowSaved,
      this.columnCount = 0,
      this.rowCount = 0,
      this.borderColor = Colors.grey,
      this.tdPaddingLeft = 8.0,
      this.tdPaddingTop = 8.0,
      this.tdPaddingRight = 8.0,
      this.tdPaddingBottom = 12.0,
      this.thPaddingLeft = 8.0,
      this.thPaddingTop = 0.0,
      this.thPaddingRight = 8.0,
      this.thPaddingBottom = 0.0,
      this.trHeight = 50.0,
      this.borderWidth = 0.5,
      this.thWeight = FontWeight.w600,
      this.thSize = 20,
      this.showSaveIcon = false,
      this.saveIcon = Icons.save,
      this.saveIconColor = Colors.black12,
      this.saveIconSize = 18,
      this.tdAlignment = TextAlign.start,
      this.tdStyle,
      this.tdEditableMaxLines = 1,
      this.thAlignment = TextAlign.start,
      this.thStyle,
      this.thVertAlignment = CrossAxisAlignment.center,
      this.showCreateButton = false,
      this.createButtonAlign = CrossAxisAlignment.start,
      this.createButtonIcon,
      this.createButtonColor,
      this.createButtonShape,
      this.createButtonLabel,
      this.stripeColor1 = Colors.white,
      this.stripeColor2 = Colors.black12,
      this.zebraStripe = false,
      this.popUpChild,
      this.popUpTitle,
      this.onAddButtonPressed,
      this.onDeleteButtonPressed,
      this.onEditButtonPressed,
      this.focusedBorder,
      this.onTap})
      : super(key: key);

  /// A data set to create headers
  ///
  /// Can be null if blank columns are needed, else:
  /// Must be array of objects
  /// with the following keys: [title], [widthFactor] and [key]
  ///
  /// example:
  /// ```dart
  /// List cols = [
  ///   {"title":'Name', 'widthFactor': 0.1, 'key':'name', 'editable': false},
  ///   {"title":'Date', 'widthFactor': 0.2, 'key':'date'},
  ///   {"title":'Month', 'widthFactor': 0.1, 'key':'month', 'editable': false},
  ///   {"title":'Status', 'widthFactor': 0.1, 'key':'status'},
  /// ];
  /// ```
  /// [title] is the column heading
  ///
  /// [widthFactor] a custom size ratio of each column width, if not provided, defaults to  [columnRatio = 0.20]
  /// ```dart
  /// 'widthFactor': 0.1 //gives 10% of screen size to the column
  /// 'widthFactor': 0.2 //gives 20% of screen size to the column
  /// ```
  ///
  /// [key] an identifier preferably a short string
  /// [editable] a boolean, if the column should be editable or not, [true] by default.
  final List columns;
  final Function onTap;

  /// A data set to create rows
  ///
  /// Can be null if empty rows are needed. else,
  /// Must be array of objects
  /// with keys matching [key] provided in the column array
  ///
  /// example:
  /// ```dart
  ///List rows = [
  ///          {"name": 'James Joe', "date":'23/09/2020',"month":'June',"status":'completed'},
  ///          {"name": 'Daniel Paul', "date":'12/4/2020',"month":'March',"status":'new'},
  ///        ];
  /// ```
  /// each objects DO NOT have to be positioned in same order as its column

  final List rows;

  /// Interger value of number of rows to be generated:
  ///
  /// Optional if row data is provided
  final int rowCount;

  /// Interger value of number of columns to be generated:
  ///
  /// Optional if column data is provided
  final int columnCount;

  /// aspect ration of each column,
  /// sets the ratio of the screen width occupied by each column
  /// it is set in fraction between 0 to 1.0
  /// 0.8 indicates 80 percent width per column
  final double columnRatio;

  /// Color of table border
  final Color borderColor;

  /// width of table borders
  final double borderWidth;

  /// Table data cell padding left
  final double tdPaddingLeft;

  /// Table data cell padding top
  final double tdPaddingTop;

  /// Table data cell padding right
  final double tdPaddingRight;

  /// Table data cell padding bottom
  final double tdPaddingBottom;

  /// Aligns the table data
  final TextAlign tdAlignment;

  /// Style the table data
  final TextStyle tdStyle;

  /// Max lines allowed in editable text, default: 1 (longer data will not wrap and be hidden), setting to 100 will allow wrapping and not increase row size
  final int tdEditableMaxLines;

  /// Table header cell padding left
  final double thPaddingLeft;

  /// Table header cell padding top
  final double thPaddingTop;

  /// Table header cell padding right
  final double thPaddingRight;

  /// Table header cell padding bottom
  final double thPaddingBottom;

  /// Aligns the table header
  final TextAlign thAlignment;

  /// Style the table header - use for more control of header style, using this OVERRIDES the thWeight and thSize parameters and those will be ignored.
  final TextStyle thStyle;

  /// Table headers fontweight (use thStyle for more control of header style)
  final FontWeight thWeight;

  /// Table header label vertical alignment
  final CrossAxisAlignment thVertAlignment;

  /// Table headers fontSize  (use thStyle for more control of header style)
  final double thSize;

  /// Table Row Height
  /// cannot be less than 40.0
  final double trHeight;

  /// Toogles the save button,
  /// if [true] displays an icon to save rows,
  /// adds an addition column to the right
  final bool showSaveIcon;

  /// Icon for to save row data
  /// example:
  ///
  /// ```dart
  /// saveIcon : Icons.add
  /// ````
  final IconData saveIcon;

  /// Color for the save Icon
  final Color saveIconColor;

  /// Size for the saveIcon
  final double saveIconSize;

  /// displays a button that adds a new row onPressed
  final bool showCreateButton;

  /// Aligns the button for adding new rows
  final CrossAxisAlignment createButtonAlign;

  /// Icon displayed in the create new row button
  final Icon createButtonIcon;

  /// Color for the create new row button
  final Color createButtonColor;

  /// border shape of the create new row button
  ///
  /// ```dart
  /// createButtonShape: RoundedRectangleBorder(
  ///   borderRadius: BorderRadius.circular(8)
  /// )
  /// ```
  final BoxShape createButtonShape;

  /// Label for the create new row button
  final Widget createButtonLabel;

  /// The first row alternate color, if stripe is set to true
  final Color stripeColor1;

  /// The Second row alternate color, if stripe is set to true
  final Color stripeColor2;

  /// enable zebra-striping, set to false by default
  /// if enabled, you can style the colors [stripeColor1] and [stripeColor2]
  final bool zebraStripe;

  final InputBorder focusedBorder;

  final popUpChild;

  final String popUpTitle;

  final Function onAddButtonPressed;

  final Function onDeleteButtonPressed;

  final Function onEditButtonPressed;

  ///[onSubmitted] callback is triggered when the enter button is pressed on a table data cell
  /// it returns a value of the cell data
  final ValueChanged<String> onSubmitted;

  /// [onRowSaved] callback is triggered when a [saveButton] is pressed.
  /// returns only values if row is edited, otherwise returns a string ['no edit']
  final ValueChanged<dynamic> onRowSaved;

  @override
  EditableState createState() => EditableState(
      rows: this.rows,
      columns: this.columns,
      rowCount: this.rowCount,
      columnCount: this.columnCount);
}

class EditableState extends State<Editable> {
  List rows, columns;
  int columnCount;
  int rowCount;

  ///Get all edited rows
  List get editedRows => _editedRows;

  ///Create a row after the last row
  createRow() => addOneRow(columns, rows);

  EditableState({this.rows, this.columns, this.columnCount, this.rowCount});

  /// Temporarily holds all edited rows
  List _editedRows = [];
  bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  @override
  Widget build(BuildContext context) {
    /// initial Setup of columns and row, sets count of column and row
    rowCount = rows == null || rows.isEmpty ? widget.rowCount : rows.length;
    columnCount =
        columns == null || columns.isEmpty ? columnCount : columns.length;
    columns = columns ?? columnBlueprint(columnCount, columns);
    rows = rows ?? rowBlueprint(rowCount, columns, rows);
    print('COLUMN COUNT====>$columnCount===>$columns');
    print('ROW COUNT====>$rowCount===>$rows');

    /// Builds saveIcon widget
    Widget _saveIcon(index) {
      return Flexible(
        fit: FlexFit.loose,
        child: Visibility(
          visible: widget.showSaveIcon,
          child: Row(
            children: [
              IconButton(
                padding: EdgeInsets.only(right: widget.tdPaddingRight),
                hoverColor: Colors.transparent,
                icon: Icon(
                  Icons.edit,
                  color: widget.saveIconColor,
                  size: widget.saveIconSize,
                ),
                onPressed: () {
                  widget.onEditButtonPressed(index);
                },
              ),
              IconButton(
                padding: EdgeInsets.only(right: widget.tdPaddingRight),
                hoverColor: Colors.transparent,
                icon: Icon(
                  Icons.delete,
                  color: widget.saveIconColor,
                  size: widget.saveIconSize,
                ),
                onPressed: () {
                  widget.onDeleteButtonPressed(index);
                },
              ),
            ],
          ),
        ),
      );
    }

    /// Generates table columns
    // List<Widget> _tableHeaders() {
    //   return List<Widget>.generate(columnCount + 1, (index) {
    //     return columnCount + 1 == (index + 1)
    //         ? iconColumn(widget.showSaveIcon, widget.thPaddingTop,
    //             widget.thPaddingBottom)
    //         : THeader(
    //             widthRatio: columns[index]['widthFactor'] != null
    //                 ? columns[index]['widthFactor'].toDouble()
    //                 : widget.columnRatio,
    //             thAlignment: widget.thAlignment,
    //             thStyle: widget.thStyle,
    //             thPaddingLeft: widget.thPaddingLeft,
    //             thPaddingTop: widget.thPaddingTop,
    //             thPaddingBottom: widget.thPaddingBottom,
    //             thPaddingRight: widget.thPaddingRight,
    //             headers: columns,
    //             thWeight: widget.thWeight,
    //             thSize: widget.thSize,
    //             index: index);
    //   });
    // }

    /// Generates table rows
    List<Widget> _tableRows() {
      return List<Widget>.generate(columnCount, (index) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(rowCount, (rowIndex) {
            var ckeys = [];
            var cTitle = [];
            var cwidths = [];
            var ceditable = <bool>[];
            columns.forEach((e) {
              ckeys.add(e['key']);
              cTitle.add(e['title']);
              cwidths.add(e['widthFactor'] ?? widget.columnRatio);
              ceditable.add(e['editable'] ?? true);
            });

            var list = rows[rowIndex];

            // print(
            //     'EDITABLE SCREEN=======$rowIndex====${cTitle[index]}=====${cwidths[index]}====>${rowIndex == 0 ? cwidths[index] : 0.40}');

            return Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (rowIndex == 0)
                  RowBuilder(
                    index: rowCount,
                    col: cTitle[index],
                    trHeight: widget.trHeight,
                    borderColor: widget.borderColor,
                    borderWidth: 0.5,
                    cellData: cTitle[index],
                    tdPaddingLeft: widget.tdPaddingLeft,
                    tdPaddingTop: widget.tdPaddingTop,
                    tdPaddingBottom: widget.tdPaddingBottom,
                    tdPaddingRight: widget.tdPaddingRight,
                    tdAlignment: widget.tdAlignment,
                    tdStyle: TextStyle(
                        fontWeight: widget.thWeight, fontSize: widget.thSize),
                    tdEditableMaxLines: widget.tdEditableMaxLines,
                    onSubmitted: widget.onSubmitted,
                    widthRatio: rowIndex == 0 ? cwidths[index] : 0.40,
                    isEditable: ceditable[rowIndex],
                    zebraStripe: widget.zebraStripe,
                    focusedBorder: widget.focusedBorder,
                    stripeColor1: widget.stripeColor1,
                    stripeColor2: widget.stripeColor2,
                    onChanged: (value) {
                      ///checks if row has been edited previously
                      var result = editedRows.indexWhere((element) {
                        return element['row'] != index ? false : true;
                      });

                      ///adds a new edited data to a temporary holder
                      if (result != -1) {
                        editedRows[result][ckeys[rowIndex]] = value;
                      } else {
                        var temp = {};
                        temp['row'] = index;
                        temp[ckeys[rowIndex]] = value;
                        editedRows.add(temp);
                      }
                    },
                  ),

                // RowBuilder(
                //   index: rowIndex,
                //   col: ckeys[index],
                //   trHeight: widget.trHeight,
                //   borderColor: widget.borderColor,
                //   borderWidth: widget.borderWidth,
                //   cellData: ckeys[index],
                //   tdPaddingLeft: widget.tdPaddingLeft,
                //   tdPaddingTop: widget.tdPaddingTop,
                //   tdPaddingBottom: widget.tdPaddingBottom,
                //   tdPaddingRight: widget.tdPaddingRight,
                //   tdAlignment: widget.tdAlignment,
                //   tdStyle: widget.tdStyle,
                //   tdEditableMaxLines: widget.tdEditableMaxLines,
                //   onSubmitted: widget.onSubmitted,
                //   widthRatio: 0.35,
                //   isEditable: ceditable[rowIndex],
                //   zebraStripe: widget.zebraStripe,
                //   focusedBorder: widget.focusedBorder,
                //   stripeColor1: widget.stripeColor1,
                //   stripeColor2: widget.stripeColor2,
                //   onChanged: (value) {
                //     ///checks if row has been edited previously
                //     var result = editedRows.indexWhere((element) {
                //       return element['row'] != index ? false : true;
                //     });
                //
                //     ///adds a new edited data to a temporary holder
                //     if (result != -1) {
                //       editedRows[result][ckeys[rowIndex]] = value;
                //     } else {
                //       var temp = {};
                //       temp['row'] = index;
                //       temp[ckeys[rowIndex]] = value;
                //       editedRows.add(temp);
                //     }
                //   },
                // ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RowBuilder(
                      index: rowCount,
                      col: ckeys[index],
                      trHeight: widget.trHeight,
                      borderColor: widget.borderColor,
                      borderWidth: 0.5,
                      cellData: list[ckeys[index]],
                      tdPaddingLeft: widget.tdPaddingLeft,
                      tdPaddingTop: widget.tdPaddingTop,
                      tdPaddingBottom: widget.tdPaddingBottom,
                      tdPaddingRight: widget.tdPaddingRight,
                      tdAlignment: widget.tdAlignment,
                      tdStyle: widget.tdStyle,
                      tdEditableMaxLines: widget.tdEditableMaxLines,
                      onSubmitted: widget.onSubmitted,
                      widthRatio: 0.30,
                      // widthRatio: cwidths[rowIndex].toDouble(),
                      isEditable: false,
                      zebraStripe: widget.zebraStripe,
                      focusedBorder: widget.focusedBorder,
                      stripeColor1: widget.stripeColor1,
                      stripeColor2: widget.stripeColor2,
                      onChanged: (value) {
                        ///checks if row has been edited previously
                        var result = editedRows.indexWhere((element) {
                          return element['row'] != index ? false : true;
                        });

                        ///adds a new edited data to a temporary holder
                        if (result != -1) {
                          editedRows[result][ckeys[rowIndex]] = value;
                        } else {
                          var temp = {};
                          temp['row'] = index;
                          temp[ckeys[rowIndex]] = value;
                          editedRows.add(temp);
                        }
                      },
                    ),
                    if (columnCount == (index + 1)) _saveIcon(rowIndex)
                  ],
                ),
              ],
            );
          }),
        );
      });
    }

    ///
    // /// Generates table rows
    // List<Widget> _tableRows() {
    //   return List<Widget>.generate(rowCount, (index) {
    //     return Row(
    //       mainAxisSize: MainAxisSize.min,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: List.generate(columnCount + 1, (rowIndex) {
    //         var ckeys = [];
    //         var cwidths = [];
    //         var ceditable = <bool>[];
    //         columns.forEach((e) {
    //           ckeys.add(e['key']);
    //           cwidths.add(e['widthFactor'] ?? widget.columnRatio);
    //           ceditable.add(e['editable'] ?? true);
    //         });
    //         var list = rows[index];
    //         return columnCount + 1 == (rowIndex + 1)
    //             ? _saveIcon(index)
    //             : RowBuilder(
    //                 index: index,
    //                 col: ckeys[rowIndex],
    //                 trHeight: widget.trHeight,
    //                 borderColor: widget.borderColor,
    //                 borderWidth: widget.borderWidth,
    //                 cellData: list[ckeys[rowIndex]],
    //                 tdPaddingLeft: widget.tdPaddingLeft,
    //                 tdPaddingTop: widget.tdPaddingTop,
    //                 tdPaddingBottom: widget.tdPaddingBottom,
    //                 tdPaddingRight: widget.tdPaddingRight,
    //                 tdAlignment: widget.tdAlignment,
    //                 tdStyle: widget.tdStyle,
    //                 tdEditableMaxLines: widget.tdEditableMaxLines,
    //                 onSubmitted: widget.onSubmitted,
    //                 widthRatio: cwidths[rowIndex].toDouble(),
    //                 isEditable: ceditable[rowIndex],
    //                 zebraStripe: widget.zebraStripe,
    //                 focusedBorder: widget.focusedBorder,
    //                 stripeColor1: widget.stripeColor1,
    //                 stripeColor2: widget.stripeColor2,
    //                 onChanged: (value) {
    //                   ///checks if row has been edited previously
    //                   var result = editedRows.indexWhere((element) {
    //                     return element['row'] != index ? false : true;
    //                   });
    //
    //                   ///adds a new edited data to a temporary holder
    //                   if (result != -1) {
    //                     editedRows[result][ckeys[rowIndex]] = value;
    //                   } else {
    //                     var temp = {};
    //                     temp['row'] = index;
    //                     temp[ckeys[rowIndex]] = value;
    //                     editedRows.add(temp);
    //                   }
    //                 },
    //               );
    //       }),
    //     );
    //   });
    // }
    print('-- widget.createButtonAlign--${widget.createButtonAlign}');
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: widget.createButtonAlign,
            children: [
              //Table Header
              createButton(),
              SizedBox(
                height: 10,
              ),
              // Container(
              //   padding: EdgeInsets.only(bottom: widget.thPaddingBottom),
              //   decoration: BoxDecoration(
              //       borderRadius:
              //           BorderRadius.vertical(top: Radius.circular(5)),
              //       color: Colors.grey[200],
              //       border: Border.all(color: Colors.grey, width: 0.5)),
              //   child: Row(
              //     crossAxisAlignment: widget.thVertAlignment,
              //     mainAxisSize: MainAxisSize.min,
              //     children: _tableHeaders(),
              //   ),
              // ),

              Column(
                children: _tableRows(),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Button for creating a new empty row
  Widget createButton() {
    return Visibility(
      visible: widget.showCreateButton,
      child: Padding(
        padding: EdgeInsets.only(left: 4.0, bottom: 4),
        child: InkWell(
          onTap: () {
            // rows = addOneRow(columns, rows);
            // rowCount++;
            // setState(() {});
            widget.onTap();
            _onAlertWithCustomContentPressed(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 40,
              width: 40,
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color:
                    widget.createButtonColor ?? Theme.of(context).canvasColor,
                boxShadow: [
                  BoxShadow(blurRadius: 2, color: Colors.grey.shade400)
                ],
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
              ),
              child: widget.createButtonIcon ??
                  Icon(
                    Icons.add,
                    color: Theme.of(context).iconTheme.color,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  _onAlertWithCustomContentPressed(context) async {
    Alert(
        context: context,
        title: widget.popUpTitle,
        style: AlertStyle(
            titleStyle:
                TextStyle(color: _isDark ? Colors.white : Colors.black)),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: widget.popUpChild,
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              widget.onAddButtonPressed();
            },
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
          )
        ]).show();
  }
}
