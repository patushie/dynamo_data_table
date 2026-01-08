import 'package:flutter/material.dart';

import 'dynamo_cell.dart';

class DynamoRow extends StatefulWidget {
  final List<DynamoCell>? cells;
  final Widget? drawer;
  final double? drawerHeight;
  final bool? rowExpanded;
  final Color? rowColor;
  final bool? isHeaderRow;
  final int? rowIndex;

  const DynamoRow({
    super.key,
    this.cells,
    this.drawer,
    this.drawerHeight,
    this.isHeaderRow = false,
    this.rowExpanded = false,
    this.rowColor,
    this.rowIndex = 0,
  });

  int calculateTotalColSpan() {
    int totalColSpan = 0;

    for (DynamoCell element in cells!) {
      totalColSpan += element.colSpan!;
    }

    return totalColSpan;
  }

  DynamoRow copyCellWith({List<DynamoCell>? cells}) {
    return DynamoRow(
      cells: cells ?? this.cells,
      rowIndex: rowIndex,
      drawer: drawer,
      drawerHeight: drawerHeight,
      isHeaderRow: isHeaderRow,
      rowExpanded: rowExpanded,
      rowColor: rowColor,
    );
  }

  DynamoRow copyRowIndexWith({int? rowIndex}) {
    return DynamoRow(
      cells: cells,
      rowIndex: rowIndex ?? this.rowIndex,
      drawer: drawer,
      drawerHeight: drawerHeight,
      isHeaderRow: isHeaderRow,
      rowExpanded: rowExpanded,
      rowColor: rowColor,
    );
  }

  DynamoRow copyRowExpandedWith({bool? rowExpanded}) {
    return DynamoRow(
      cells: cells,
      rowIndex: rowIndex,
      drawer: drawer,
      drawerHeight: drawerHeight,
      isHeaderRow: isHeaderRow,
      rowExpanded: rowExpanded ?? this.rowExpanded,
      rowColor: rowColor,
    );
  }

  @override
  State<DynamoRow> createState() => _DynamoRowState();
}

class _DynamoRowState extends State<DynamoRow> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
