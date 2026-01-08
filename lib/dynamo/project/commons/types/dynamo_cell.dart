import 'package:flutter/material.dart';

import 'table_summary_formula.dart';

class DynamoCell extends StatefulWidget {
  final Widget? cellContent;
  final int? numberOfLines;
  final TableSummaryFormula? summaryFormula;
  final String? cellStringValue;
  final int? colSpan;
  final Function(double)? valueFormatter;

  const DynamoCell({
    super.key,
    this.cellContent,
    this.numberOfLines = 1,
    this.summaryFormula,
    this.cellStringValue,
    this.valueFormatter,
    this.colSpan = 1,
  });

  @override
  State<DynamoCell> createState() => _DynamoCellState();
}

class _DynamoCellState extends State<DynamoCell> {
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
    return widget.cellContent!;
  }
}
