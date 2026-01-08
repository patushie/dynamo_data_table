// ignore_for_file: comment_references

import 'dart:math';

import 'package:dynamo_data_table/dynamo/project/commons/system/entities/unique_value_field.dart';
import 'package:dynamo_data_table/dynamo/project/commons/system/handlers/dynamo_commons.dart';
import 'package:dynamo_data_table/dynamo/project/commons/types/table_internal_memory.dart';
import 'package:dynamo_data_table/dynamo/project/commons/views/input_text_field.dart';
import 'package:flutter/material.dart';

import 'dynamo_cell.dart';
import 'dynamo_column.dart';
import 'dynamo_row.dart';
import 'table_sort_order.dart';
import 'table_summary_formula.dart';

class DynamoDataTable extends StatefulWidget {
  final TableSortOrder? sortOrder;
  final List<DynamoColumn>? columns;
  final List<DynamoRow>? rows;
  final DynamoRow? footerRow;
  final DynamoRow? summaryRow;
  final Color? headerColor;
  final double? headerColumnHeight;
  final double? tableWidth;
  final String? tableName;
  final bool showPaginator;
  final int? pageRows;
  final int? expandedRow;
  final int currentPage;
  final Color? tableButtonColor;
  //
  final String? colFilterText;
  final int? colFilterIndex;
  //
  final Function(bool, int)? onDrawerTapped;
  final Function(int, String, int)? onPageChanged;
  final double Function(List<DynamoRow>, int)? customFormula;

  const DynamoDataTable({
    super.key,
    this.sortOrder = TableSortOrder.ascending,
    this.columns,
    this.rows,
    this.footerRow,
    this.summaryRow,
    this.headerColor,
    this.headerColumnHeight = 0,
    this.tableWidth = 0,
    this.tableName = "",
    this.showPaginator = false,
    this.pageRows = 0,
    this.expandedRow = -1,
    this.currentPage = 1,
    this.colFilterText,
    this.colFilterIndex,
    this.onDrawerTapped,
    this.onPageChanged,
    this.customFormula,
    this.tableButtonColor = Colors.indigo,
  });

  @override
  State<DynamoDataTable> createState() => _DynamoDataTableState();
}

class _DynamoDataTableState extends State<DynamoDataTable> {
  final ScrollController scrollController = ScrollController();

  //
  List<DynamoRow>? tableDataRows;
  Map<String, List<DynamoRow>>? sortedDataRowsMap;
  Map<String, DynamoRow>? sortedKeySummaryRow;
  List<UniqueValueField> sortKeyHeaderList = <UniqueValueField>[];
  //
  int currentPage = 1;
  int numberOfPages = 0;
  int tablePageRows = 0;
  int sortColumnIndex = 0;
  bool stateInitialized = false;
  //
  String colFilterText = "";
  int colFilterIndex = -1;
  //
  late List<String> _tablePageNumberList;
  late String? _selectedPageNumber;
  //
  DynamoColumn? sortHeaderColumn;
  List<DynamoColumn> baselineColumns = <DynamoColumn>[];
  //
  late TableInternalMemory internalMemory;
  //
  static final double drawerWidth = 50.0;

  @override
  void initState() {
    super.initState();

    internalMemory = TableInternalMemory.getInstance(widget.tableName!);

    _tablePageNumberList = <String>[];
    tableDataRows = widget.rows;

    int index = 0;
    for (int i = 0; i < tableDataRows!.length; i++) {
      tableDataRows![i] = tableDataRows![i].copyRowIndexWith(rowIndex: index++);
    }

    currentPage = widget.currentPage;
    int colIndex = 0;

    for(int i = 0;i <= widget.columns!.length-1;i++) {
      widget.columns![i] = widget.columns![i].copyColumnIndexWith(columnIndex: colIndex++);
    }

    if ((widget.colFilterIndex != null) && (widget.colFilterIndex! > -1)) {
      colFilterText = widget.colFilterText!;
      colFilterIndex = widget.colFilterIndex!;

      for (int i = 0; i <= widget.columns!.length - 1; i++) {
        if ((widget.columns![i].filterable!) && (i == widget.colFilterIndex!)) {
          widget.columns![i] = widget.columns![i].copyInputTextWith(filterField: InputTextField());
          widget.columns![i].filterField!.inputTextFilter.text = widget.colFilterText!;

          tableDataRows = <DynamoRow>[];

          for(int i = 0;i <= widget.rows!.length-1;i++) {
            if (widget.rows![i].cells![i].cellStringValue != null) {
              if (widget.rows![i].cells![i].cellStringValue!
                  .toUpperCase()
                  .startsWith(widget.columns![i].filterField!.inputTextFilter.text.toUpperCase())) {
                tableDataRows!.add(widget.rows![i]);
              }
            } else {
              String cell1Value = (widget.rows![i].cells![i].cellContent as Text).data!;

              if (cell1Value.toUpperCase().startsWith(widget.columns![i].filterField!.inputTextFilter.text.toUpperCase())) {
                tableDataRows!.add(widget.rows![i]);
              }
            }
          }

          break;
        }
      }
    } else {
      for (int i = 0; i <= widget.columns!.length - 1; i++) {
        if (widget.columns![i].filterable!) {
          widget.columns![i] = widget.columns![i].copyInputTextWith(filterField: InputTextField());
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double defaultColWidth = 0;
    double tableWidth = 0;
    double pagingSectionHeight = 48.8;

    if (widget.pageRows == 0) {
      if (internalMemory.tablePageRows > 0) {
        tablePageRows = internalMemory.tablePageRows;
      } else {
        tablePageRows = widget.rows!.length;
      }
    } else if (tablePageRows == 0) {
      if (internalMemory.tablePageRows > 0) {
        tablePageRows = internalMemory.tablePageRows;
      } else {
        tablePageRows = widget.pageRows!;
      }
    }

    if (internalMemory.currentPage > 0) {
      currentPage = internalMemory.currentPage;
    }

    if ((tableDataRows != null) && (tableDataRows!.isNotEmpty)) {
      if (tableDataRows![0].drawer != null) {
        if (!widget.columns![0].isDrawerColumn!) {
          widget.columns!.insert(
            0,
            DynamoColumn(
              label: Text(
                '',
              ),
              width: drawerWidth,
              isDrawerColumn: true,
            ),
          );
        }
      }
    }

    baselineColumns = getBaselineColumns(widget.columns!);

    if (!stateInitialized) {
      if ((tableDataRows != null) && (tableDataRows!.isNotEmpty)) {
        if (tableDataRows![0].drawer != null) {
          int rowIndex = 0;

          for (int i = 0; i < tableDataRows!.length; i++) {
            if ((widget.expandedRow! > -1) && (widget.expandedRow == rowIndex + 1)) {
              tableDataRows![i] = tableDataRows![i].copyRowExpandedWith(rowExpanded: true);
            }

            tableDataRows![i].cells!.insert(
                  0,
                  DynamoCell(
                    cellContent: IconButton(
                      icon: Icon(
                        tableDataRows![i].rowExpanded! ? Icons.arrow_drop_down : Icons.play_arrow,
                        color: widget.tableButtonColor,
                        size: tableDataRows![i].rowExpanded! ? 30 : 20,
                      ),
                      onPressed: () {
                        setState(() {
                          tableDataRows![i] = tableDataRows![i].copyRowExpandedWith(rowExpanded: !tableDataRows![i].rowExpanded!);

                          if (tableDataRows![i].rowExpanded!) {
                            if (widget.onDrawerTapped != null) {
                              widget.onDrawerTapped!(tableDataRows![i].rowExpanded!, tableDataRows![i].rowIndex! + 1);
                            }
                          } else {
                            if (widget.onDrawerTapped != null) {
                              widget.onDrawerTapped!(tableDataRows![i].rowExpanded!, 0);
                            }
                          }
                        });
                      },
                    ),
                  ),
                );

            rowIndex++;
          }

          if (widget.footerRow != null) {
            widget.footerRow!.cells!.insert(
              0,
              DynamoCell(
                cellContent: Text(""),
              ),
            );
          }
        }
      }
    } else {
      if ((tableDataRows != null) && (tableDataRows!.isNotEmpty)) {
        if (tableDataRows![0].drawer != null) {
          int rowIndex = 0;

          for (int i = 0; i < tableDataRows!.length; i++) {
            if ((widget.expandedRow! > -1) && (widget.expandedRow == rowIndex + 1)) {
              tableDataRows![i] = tableDataRows![i].copyRowExpandedWith(rowExpanded: true);
            }

            tableDataRows![i].cells!.setAll(
              0,
              [
                DynamoCell(
                  cellContent: IconButton(
                    icon: Icon(
                      tableDataRows![i].rowExpanded! ? Icons.arrow_drop_down : Icons.play_arrow,
                      color: widget.tableButtonColor,
                      size: tableDataRows![i].rowExpanded! ? 30 : 20,
                    ),
                    onPressed: () {
                      setState(() {
                        tableDataRows![i] = tableDataRows![i].copyRowExpandedWith(rowExpanded: !tableDataRows![i].rowExpanded!);

                        if (widget.onDrawerTapped != null) {
                          widget.onDrawerTapped!(tableDataRows![i].rowExpanded!, tableDataRows![i].rowIndex! + 1);
                        }
                      });
                    },
                  ),
                ),
              ],
            );

            rowIndex++;
          }

          if (widget.footerRow != null) {
            widget.footerRow!.cells!.setAll(
              0,
              [
                DynamoCell(
                  cellContent: Text(""),
                ),
              ],
            );
          }
        }
      }
    }

    if ((tableDataRows != null) && (tableDataRows!.isNotEmpty) && (tableDataRows![0].drawer != null)) {
      if (widget.tableWidth! > 0) {
        tableWidth = widget.tableWidth!;
        defaultColWidth = (tableWidth - drawerWidth) / (baselineColumns.length - 1);
      } else {
        if (DynamoCommons.isMobile(context)) {
          tableWidth = MediaQuery.of(context).size.width;
          defaultColWidth = (tableWidth - drawerWidth) / (baselineColumns.length - 1);
        } else {
          tableWidth = MediaQuery.of(context).size.width * 0.6;
          defaultColWidth = (tableWidth - drawerWidth) / (baselineColumns.length - 1);
        }
      }
    } else {
      if (widget.tableWidth! > 0) {
        tableWidth = widget.tableWidth!;
        defaultColWidth = tableWidth / baselineColumns.length;
      } else {
        if (DynamoCommons.isMobile(context)) {
          tableWidth = MediaQuery.of(context).size.width;
          defaultColWidth = tableWidth / baselineColumns.length;
        } else {
          tableWidth = MediaQuery.of(context).size.width * 0.6;
          defaultColWidth = tableWidth / baselineColumns.length;
        }
      }
    }

    double headerTextWidth = defaultColWidth * 0.85;

    bool hasFilters = false;
    bool hasSorting = false;

    double maxHeaderTextHeight = 0;

    double customeAggWidth = 0;
    int costumWidthCount = 0;
    bool hasDrawerColumn = false;
    int sortKeyCount = 0;

    for (int i = 0; i <= baselineColumns.length - 1; i++) {
      if (!hasFilters) {
        hasFilters = baselineColumns[i].filterable!;
      }

      if (!hasSorting) {
        hasSorting = baselineColumns[i].sortable!;
      }

      int charsThatFit = 0;

      baselineColumns[i] = baselineColumns[i].copyLabelWith(
        label: Text(
          baselineColumns[i].label!.data!,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 17.0,
            color: const Color(0xff006784),
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      );

      if (baselineColumns[i].label is Text) {
        charsThatFit = DynamoCommons.calculateCharactersThatFit(
          (baselineColumns[i].label as Text).data!,
          headerTextWidth,
          (baselineColumns[i].label as Text).style!,
        );

        double numberOfLines = (baselineColumns[i].label as Text).data!.length / charsThatFit;
        if (numberOfLines > maxHeaderTextHeight) {
          maxHeaderTextHeight = numberOfLines;
        }
      }

      if ((baselineColumns[i].width! > 0) && (!baselineColumns[i].isDrawerColumn!)) {
        customeAggWidth += baselineColumns[i].width!;
        costumWidthCount = costumWidthCount + 1;
      } else if (baselineColumns[i].isDrawerColumn!) {
        hasDrawerColumn = baselineColumns[i].isDrawerColumn!;
      }

      if (sortHeaderColumn == null && baselineColumns[i].sortKey!) {
        sortHeaderColumn = baselineColumns[i];
        sortKeyCount++;
      } else if (baselineColumns[i].sortKey! && sortHeaderColumn!.columnIndex != baselineColumns[i].columnIndex) {
        sortKeyCount++;
      }
    }

    if (sortKeyCount > 1) {
      throw Exception("Multiple Sort Keys Found: Only One 'DynamoColumn' "
          "Widget Is Allowed To Have 'sortKey' Flag Set To 'true'.");
    }

    bool hasDrawer = false;

    if ((tableDataRows != null) && (tableDataRows!.isNotEmpty)) {
      hasDrawer = true;
    }

    int columnIndex = 0;

    if (widget.footerRow != null) {
      for (int i = 0; i <= widget.footerRow!.cells!.length - 1; i++) {
        if (widget.footerRow!.cells![i].summaryFormula != null) {
          double summaryValue = 0;
          bool isFloatNumbr = false;

          List<double> numberSet = <double>[];

          for (int j = 0; j <= tableDataRows!.length - 1; j++) {
            if (tableDataRows![j].cells![columnIndex].cellContent is Text) {
              Text dataText = tableDataRows![j].cells![columnIndex].cellContent as Text;
              String numericalString = DynamoCommons.unformatMoneyValue(dataText.data!);

              if (DynamoCommons.isDigitSequence(numericalString)) {
                numberSet.add(double.parse(numericalString));
                summaryValue = summaryValue + int.parse(numericalString);
              } else if (DynamoCommons.isDigitSequenceWithADot(numericalString)) {
                numberSet.add(double.parse(numericalString));
                summaryValue = summaryValue + double.parse(numericalString);
                isFloatNumbr = true;
              }
            }
          }

          summaryValue = calculateFormular(summaryValue, numberSet, widget.footerRow!.cells![i]);

          if (isFloatNumbr) {
            widget.footerRow!.cells!.setAll(columnIndex, [
              DynamoCell(
                cellContent: Text(
                  DynamoCommons.getMoneyFormat(summaryValue),
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ]);
          } else {
            widget.footerRow!.cells!.setAll(
              columnIndex,
              [
                DynamoCell(
                  cellContent: Text(
                    DynamoCommons.getIntegerFormatted(summaryValue),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          }
        }

        columnIndex++;
      }
    }

    if (sortHeaderColumn != null) {
      sortedDataRowsMap = {};

      int indexOffset = 0;
      if ((tableDataRows != null) && (tableDataRows!.isNotEmpty) && (tableDataRows!.first.drawer != null)) {
        indexOffset = 1;
      }

      if ((tableDataRows != null) && (tableDataRows!.isNotEmpty)) {
        for (int i = 0; i <= tableDataRows!.length - 1; i++) {
          if (tableDataRows![i].cells![sortHeaderColumn!.columnIndex! + indexOffset].cellContent is Text) {
            Text sortKeyText = tableDataRows![i].cells![sortHeaderColumn!.columnIndex! + indexOffset].cellContent as Text;

            UniqueValueField keyHeader = UniqueValueField.init(sortKeyText.data);

            if (!sortKeyHeaderList.contains(keyHeader)) {
              sortKeyHeaderList.add(keyHeader);
            }
          } else {
            throw Exception("'Sort-Key Column Must Be A Plain Old Text: Please Ensure That The "
                "'DynamoCell' Corresponding To The 'DynamoColumn' Marked As 'sortKey' Has Parameter "
                "'cellContent' Of Widget Type 'Text'.");
          }
        }
      }

      sortKeyHeaderList.sort((a, b) => a.fieldValue!.compareTo(b.fieldValue!));

      for (UniqueValueField sortKeyHeader in sortKeyHeaderList) {
        List<DynamoRow> sortKeyRows = <DynamoRow>[];

        if (tableDataRows != null) {
          for (DynamoRow rowElement in tableDataRows!) {
            if ((rowElement.cells![sortHeaderColumn!.columnIndex! + indexOffset].cellContent as Text).data == sortKeyHeader.fieldValue!) {
              sortKeyRows.add(rowElement);
            }
          }
        }

        sortedDataRowsMap![sortKeyHeader.fieldValue!] = sortKeyRows;
      }

      sortedKeySummaryRow = {};

      for (UniqueValueField sortKeyHeader in sortKeyHeaderList) {
        if (widget.summaryRow != null) {
          DynamoRow sortedKeySumryRow = DynamoRow();
          sortedKeySumryRow = sortedKeySumryRow.copyCellWith(cells: <DynamoCell>[]);

          columnIndex = 0;

          if (widget.summaryRow != null) {
            for (DynamoCell sumryElement in widget.summaryRow!.cells!) {
              if (sumryElement.cellContent != null) {
                if (hasDrawer) {
                  if (sortedKeySumryRow.cells!.length < columnIndex + 2) {
                    sortedKeySumryRow.cells!.add(sumryElement);
                  }
                } else {
                  if (sortedKeySumryRow.cells!.length < columnIndex + 1) {
                    sortedKeySumryRow.cells!.add(sumryElement);
                  }
                }
              } else if (sumryElement.summaryFormula != null) {
                if ((sumryElement.summaryFormula != TableSummaryFormula.none) && (sumryElement.summaryFormula != TableSummaryFormula.userDefined)) {
                  bool canProcess = false;

                  if (hasDrawer) {
                    if (sortedKeySumryRow.cells!.length < columnIndex + 2) {
                      canProcess = true;
                    }
                  } else {
                    if (sortedKeySumryRow.cells!.length < columnIndex + 1) {
                      canProcess = true;
                    }
                  }

                  if (canProcess) {
                    double summaryValue = 0;
                    bool isFloatNumbr = false;
                    List<double> numberSet = <double>[];

                    Function(double)? valueFormatter;

                    for (DynamoRow dataRow in sortedDataRowsMap![sortKeyHeader.fieldValue!]!) {
                      if (dataRow.cells![columnIndex].cellContent is Text) {
                        Text dataText = dataRow.cells![columnIndex].cellContent as Text;
                        valueFormatter = dataRow.cells![columnIndex].valueFormatter;

                        String numericalString = DynamoCommons.unformatMoneyValue(dataText.data!);

                        if (DynamoCommons.isDigitSequence(numericalString)) {
                          numberSet.add(double.parse(numericalString));
                          summaryValue = summaryValue + int.parse(numericalString);
                        } else if (DynamoCommons.isDigitSequenceWithADot(numericalString)) {
                          numberSet.add(double.parse(numericalString));
                          summaryValue = summaryValue + double.parse(numericalString);

                          isFloatNumbr = true;
                        }
                      }
                    }

                    summaryValue = calculateFormular(summaryValue, numberSet, sumryElement);

                    if (valueFormatter != null) {
                      sortedKeySumryRow.cells!.add(
                        DynamoCell(
                          cellContent: Text(
                            valueFormatter(summaryValue),
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    } else if (isFloatNumbr) {
                      sortedKeySumryRow.cells!.add(
                        DynamoCell(
                          cellContent: Text(
                            DynamoCommons.getMoneyFormat(summaryValue),
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    } else {
                      sortedKeySumryRow.cells!.add(
                        DynamoCell(
                          cellContent: Text(
                            DynamoCommons.getIntegerFormatted(summaryValue),
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }
                  }
                } else if ((sumryElement.summaryFormula != TableSummaryFormula.userDefined) && (widget.customFormula != null)) {
                  bool canProcess = false;
                  Function(double)? valueFormatter;

                  if (hasDrawer) {
                    if (sortedKeySumryRow.cells!.length < columnIndex + 2) {
                      canProcess = true;
                    }
                  } else {
                    if (sortedKeySumryRow.cells!.length < columnIndex + 1) {
                      canProcess = true;
                    }
                  }

                  if (canProcess) {
                    bool isFloatNumbr = false;

                    double summaryValue = widget.customFormula!(sortedDataRowsMap![sortKeyHeader.fieldValue!]!, columnIndex);

                    for (DynamoRow dataRow in sortedDataRowsMap![sortKeyHeader.fieldValue!]!) {
                      if (dataRow.cells![columnIndex].cellContent is Text) {
                        valueFormatter = dataRow.cells![columnIndex].valueFormatter;
                      }
                    }

                    if (DynamoCommons.isDigitSequenceWithADot(summaryValue.toString())) {
                      isFloatNumbr = true;
                    }

                    if (valueFormatter != null) {
                      sortedKeySumryRow.cells!.add(
                        DynamoCell(
                          cellContent: Text(
                            valueFormatter(summaryValue),
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    } else if (isFloatNumbr) {
                      sortedKeySumryRow.cells!.add(
                        DynamoCell(
                          cellContent: Text(
                            DynamoCommons.getMoneyFormat(summaryValue),
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    } else {
                      sortedKeySumryRow.cells!.add(
                        DynamoCell(
                          cellContent: Text(
                            DynamoCommons.getIntegerFormatted(summaryValue),
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }
                  }
                }
              }

              columnIndex++;
            }

            sortedKeySummaryRow![sortKeyHeader.fieldValue!] = sortedKeySumryRow;
          }
        }
      }
    }

    if ((customeAggWidth > 0) && (baselineColumns.length > costumWidthCount)) {
      customeAggWidth = customeAggWidth / costumWidthCount;

      if (defaultColWidth > customeAggWidth) {
        double widthDifferential = defaultColWidth - customeAggWidth;
        double widthAverage = 0;

        if (hasDrawerColumn) {
          if (baselineColumns.length - (costumWidthCount + 1) > 0) {
            widthAverage = widthDifferential / (baselineColumns.length - (costumWidthCount + 1));
          } else {
            widthAverage = widthDifferential;
          }
        } else {
          if (baselineColumns.length - costumWidthCount > 0) {
            widthAverage = widthDifferential / (baselineColumns.length - costumWidthCount);
          } else {
            widthAverage = widthDifferential;
          }
        }

        defaultColWidth = defaultColWidth + widthAverage;
      } else if (defaultColWidth < customeAggWidth) {
        double widthDifferential = customeAggWidth - defaultColWidth;
        double widthAverage = 0;

        if (hasDrawerColumn) {
          if (baselineColumns.length - (costumWidthCount + 1) > 0) {
            widthAverage = widthDifferential / (baselineColumns.length - (costumWidthCount + 1));
          } else {
            widthAverage = widthDifferential;
          }
        } else {
          if (baselineColumns.length - costumWidthCount > 0) {
            widthAverage = widthDifferential / (baselineColumns.length - costumWidthCount);
          } else {
            widthAverage = widthDifferential;
          }
        }

        defaultColWidth = defaultColWidth - widthAverage;
      }
    }

    double headerColHeight = 0;

    if (widget.headerColumnHeight! > 0) {
      headerColHeight = widget.headerColumnHeight!;
    } else {
      int maxHeaderDepth = calculateHeaderDepth();
      headerColHeight = MediaQuery.of(context).size.height * 0.07 * maxHeaderDepth;

      if (maxHeaderDepth == 1) {
        if ((hasFilters) && (hasSorting)) {
          headerColHeight = MediaQuery.of(context).size.height * 0.11;
        } else if (hasFilters) {
          headerColHeight = MediaQuery.of(context).size.height * 0.1;
        } else if (hasSorting) {
          headerColHeight = MediaQuery.of(context).size.height * 0.08;
        }
      } else if (maxHeaderDepth > 1) {
        if ((hasFilters) && (hasSorting)) {
          headerColHeight = MediaQuery.of(context).size.height * 0.04 + MediaQuery.of(context).size.height * 0.07 * maxHeaderDepth;
        } else if (hasFilters) {
          headerColHeight = MediaQuery.of(context).size.height * 0.03 + MediaQuery.of(context).size.height * 0.07 * maxHeaderDepth;
        } else if (hasSorting) {
          headerColHeight = MediaQuery.of(context).size.height * 0.08 + MediaQuery.of(context).size.height * 0.07 * maxHeaderDepth;
        }
      }
    }

    if (widget.tableName!.trim().isNotEmpty) {
      if (maxHeaderTextHeight > 1) {
        headerColHeight += MediaQuery.of(context).size.height * 0.025 + ((maxHeaderTextHeight - 1) * MediaQuery.of(context).size.height * 0.02);
      } else {
        headerColHeight += MediaQuery.of(context).size.height * 0.025;
      }
    }

    Row pageNumbrContainer = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[],
    );

    if (widget.showPaginator) {
      headerColHeight += pagingSectionHeight;

      if ((tableDataRows != null) && (tablePageRows > 0)) {
        numberOfPages = (tableDataRows!.length / tablePageRows).toInt();

        if (tableDataRows!.length % tablePageRows > 0) {
          numberOfPages = numberOfPages + 1;
        }
      } else {
        numberOfPages = 1;
      }

      if (_tablePageNumberList.isEmpty) {
        _selectedPageNumber = "$tablePageRows";

        if ((tablePageRows < 10) || (tablePageRows > 500)) {
          _tablePageNumberList.add("$tablePageRows");
        }

        _tablePageNumberList.add("10");
        _tablePageNumberList.add("20");
        _tablePageNumberList.add("30");
        _tablePageNumberList.add("40");
        _tablePageNumberList.add("50");
        _tablePageNumberList.add("70");
        _tablePageNumberList.add("100");
        _tablePageNumberList.add("200");
        _tablePageNumberList.add("500");
      }

      if (numberOfPages > 0) {
        pageNumbrContainer.children.add(
          Text(
            "($currentPage of $numberOfPages)",
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14.0,
            ),
            textAlign: TextAlign.center,
          ),
        );

        pageNumbrContainer.children.add(
          SizedBox(
            width: 4,
          ),
        );
      }

      pageNumbrContainer.children.add(
        IconButton(
          icon: Icon(
            Icons.skip_previous,
            color: widget.tableButtonColor,
          ),
          onPressed: () {
            currentPage = 1;
            internalMemory.currentPage = currentPage;

            if (widget.onPageChanged != null) {
              widget.onPageChanged!(currentPage, colFilterText, colFilterIndex);
            }
            setState(() {});
          },
        ),
      );

      pageNumbrContainer.children.add(
        SizedBox(
          width: 1,
        ),
      );

      pageNumbrContainer.children.add(
        IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 15,
            color: widget.tableButtonColor,
          ),
          onPressed: () {
            if (currentPage > 1) {
              currentPage--;
              internalMemory.currentPage = currentPage;

              if (widget.onPageChanged != null) {
                widget.onPageChanged!(currentPage, colFilterText, colFilterIndex);
              }

              setState(() {});
            }
          },
        ),
      );

      pageNumbrContainer.children.add(
        SizedBox(
          width: 2,
        ),
      );

      int maxPages = numberOfPages > 12 ? 12 : numberOfPages;
      int offset = 1;

      if (currentPage > 12) {
        int pageFactor = currentPage ~/ 12;
        offset = (12 * pageFactor) + 1;

        if (numberOfPages >= offset + 11) {
          maxPages = offset + 11;
        } else {
          maxPages = offset + (numberOfPages - offset);
        }
      }

      for (int i = offset; i <= maxPages; i++) {
        pageNumbrContainer.children.add(
          InkWell(
            onTap: () {
              currentPage = i;
              internalMemory.currentPage = currentPage;

              if (widget.onPageChanged != null) {
                widget.onPageChanged!(currentPage, colFilterText, colFilterIndex);
              }

              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: i == currentPage
                  ? Text(
                      "$i",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Text(
                      "$i",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 15.0,
                      ),
                    ),
            ),
          ),
        );

        pageNumbrContainer.children.add(
          SizedBox(
            width: 4,
          ),
        );
      }

      pageNumbrContainer.children.add(
        IconButton(
          icon: Icon(
            Icons.arrow_forward_ios,
            size: 15,
            color: widget.tableButtonColor,
          ),
          onPressed: () {
            if (currentPage < numberOfPages) {
              currentPage++;
              internalMemory.currentPage = currentPage;

              if (widget.onPageChanged != null) {
                widget.onPageChanged!(currentPage, colFilterText, colFilterIndex);
              }

              setState(() {});
            }
          },
        ),
      );

      pageNumbrContainer.children.add(
        SizedBox(
          width: 1,
        ),
      );

      pageNumbrContainer.children.add(
        IconButton(
          icon: Icon(
            Icons.skip_next,
            color: widget.tableButtonColor,
          ),
          onPressed: () {
            currentPage = numberOfPages;
            internalMemory.currentPage = currentPage;

            if (widget.onPageChanged != null) {
              widget.onPageChanged!(currentPage, colFilterText, colFilterIndex);
            }

            setState(() {});
          },
        ),
      );

      pageNumbrContainer.children.add(
        SizedBox(
          width: 1,
        ),
      );

      if ((tableDataRows != null) && (tableDataRows!.isNotEmpty)) {
        pageNumbrContainer.children.add(
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              tableDataRows!.length > 1 ? "${tableDataRows!.length} Records" : "${tableDataRows!.length} Record",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }

      if ((tableDataRows != null) || (tableDataRows!.isNotEmpty)) {
        pageNumbrContainer.children.add(
          SizedBox(
            width: 1,
          ),
        );
      }

      pageNumbrContainer.children.add(
        SizedBox(
          width: MediaQuery.of(context).size.width * (DynamoCommons.isMobile(context) ? 0.09 : 0.055),
          height: 30,
          child: DropdownButton<String>(
            value: _selectedPageNumber,
            items: _tablePageNumberList.map((String aValue) {
              return DropdownMenuItem<String>(
                value: aValue,
                child: Text(aValue),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedPageNumber = value;
                tablePageRows = int.parse(_selectedPageNumber!);
                internalMemory.tablePageRows = tablePageRows;

                numberOfPages = (widget.rows!.length / tablePageRows).toInt();

                if (tableDataRows!.length % tablePageRows > 0) {
                  numberOfPages = numberOfPages + 1;
                }

                if (currentPage > 1) {
                  currentPage = 1;
                }

                internalMemory.currentPage = currentPage;

                setState(() {});
              });
            },
          ),
        ),
      );
    } else {
      headerColHeight += pagingSectionHeight / 2;
    }

    if ((tableDataRows != null) && (tableDataRows!.isNotEmpty)) {
      int dataRowColSpan = tableDataRows!.first.calculateTotalColSpan();
      if (baselineColumns.length != dataRowColSpan) {
        throw Exception("Table Header Column Count ${baselineColumns.length} "
            "Doesn't Match Table Body Column Count $dataRowColSpan");
      }
    }

    Widget? headerPane = ListTile(
      title: (widget.tableName!.trim().isNotEmpty)
          ? Padding(
              padding: !hasFilters ? const EdgeInsets.all(4.0) : const EdgeInsets.only(left: 4.0, right: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.tableName!,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 20.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : null,
      subtitle: (widget.showPaginator)
          ? Padding(
              padding: !hasFilters ? const EdgeInsets.all(4.0) : const EdgeInsets.only(left: 4.0, right: 4.0),
              child: pageNumbrContainer,
            )
          : null,
    );

    if (((widget.tableName == null) || (widget.tableName!.trim().isEmpty)) && ((!widget.showPaginator))) {
      headerPane = null;
    }

    stateInitialized = true;

    return Column(
      children: <Widget>[
        Container(
          width: widget.tableWidth! > 0 ? widget.tableWidth : MediaQuery.of(context).size.width * (DynamoCommons.isMobile(context) ? 1 : 0.6),
          height: headerColHeight,
          decoration: BoxDecoration(
            color: widget.headerColor ?? const Color(0xff006784).withAlpha(40),
          ),
          child: ListTile(
            title: headerPane,
            subtitle: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              padding: !hasFilters ? const EdgeInsets.only(top: 10.0) : const EdgeInsets.only(top: 0.0),
              itemBuilder: (BuildContext buildContext, int i) {
                if (i < widget.columns!.length) {
                  int columnHeaderDepth = widget.columns![i].calculateHeaderDepth();

                  if (widget.columns![i].width! > 0) {
                    if (widget.columns![i].sortable!) {
                      headerTextWidth = widget.columns![i].width! - (defaultColWidth * 0.14);
                    } else {
                      headerTextWidth = widget.columns![i].width!;
                    }
                  } else {
                    if (widget.columns![i].sortable!) {
                      headerTextWidth = defaultColWidth * 0.8;
                    } else {
                      headerTextWidth = defaultColWidth * 0.85;
                    }
                  }

                  return Container(
                    width: widget.columns![i].width! > 0 ? widget.columns![i].width : defaultColWidth * columnHeaderDepth,
                    alignment: Alignment.center,
                    child: Column(
                      children: <Widget>[
                        widget.columns![i].sortable!
                            ? InkWell(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                onTap: () {
                                  setState(() {
                                    sortColumnIndex = i;

                                    if (DynamoColumn.systemTableSortOrder == TableSortOrder.none) {
                                      DynamoColumn.systemTableSortOrder = TableSortOrder.ascending;
                                    } else {
                                      if (DynamoColumn.systemTableSortOrder == TableSortOrder.ascending) {
                                        DynamoColumn.systemTableSortOrder = TableSortOrder.descending;
                                      } else {
                                        DynamoColumn.systemTableSortOrder = TableSortOrder.ascending;
                                      }
                                    }

                                    sortTableRecords(DynamoColumn.systemTableSortOrder, sortColumnIndex);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 1.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      createHeaderHierarchy(widget.columns!, columnHeaderDepth, headerTextWidth, i),
                                      Icon(
                                        DynamoColumn.systemTableSortOrder == TableSortOrder.ascending ? Icons.arrow_downward : Icons.arrow_upward,
                                        color: widget.tableButtonColor,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : createHeaderHierarchy(widget.columns!, columnHeaderDepth, headerTextWidth, i),
                        if (widget.columns![i].filterable!)
                          Padding(
                            padding: const EdgeInsets.all(2),
                            child: TextField(
                              controller: widget.columns![i].filterField!.inputTextFilter,
                              onChanged: (text) {
                                if (widget.columns![i].filterField!.inputTextFilter.text.trim().isNotEmpty) {
                                  colFilterText = widget.columns![i].filterField!.inputTextFilter.text.trim();
                                  colFilterIndex = i;

                                  tableDataRows = <DynamoRow>[];
                                  currentPage = 1;

                                  for (DynamoRow rowElement in widget.rows!) {
                                    if (rowElement.cells![i].cellStringValue != null) {
                                      if (rowElement.cells![i].cellStringValue!
                                          .toUpperCase()
                                          .startsWith(widget.columns![i].filterField!.inputTextFilter.text.toUpperCase())) {
                                        tableDataRows!.add(rowElement);
                                      }
                                    } else {
                                      String cell1Value = (rowElement.cells![i].cellContent as Text).data!;

                                      if (cell1Value.toUpperCase().startsWith(widget.columns![i].filterField!.inputTextFilter.text.toUpperCase())) {
                                        tableDataRows!.add(rowElement);
                                      }
                                    }
                                  }

                                  setState(() {});
                                } else {
                                  setState(() {
                                    tableDataRows = widget.rows;
                                  });
                                }
                              },
                              style: TextStyle(fontFamily: 'Montserrat', fontSize: 17.0),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2.0),
                                  borderSide: BorderSide(
                                    color: Colors.indigo,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }

                return null;
              },
            ),
          ),
        ),
        buildTableBody(headerTextWidth, defaultColWidth, tableWidth),
        if ((widget.footerRow != null) && (widget.footerRow!.cells!.isNotEmpty))
          Container(
            width: widget.tableWidth! > 0 ? widget.tableWidth : MediaQuery.of(context).size.width * (DynamoCommons.isMobile(context) ? 1 : 0.6),
            height: calculateRowHeight(headerTextWidth, defaultColWidth),
            decoration: BoxDecoration(
              color: widget.headerColor ?? const Color(0xff006784).withAlpha(40),
            ),
            child: ListTile(
              title: buildTableSummaryRow(
                widget.footerRow!,
                headerTextWidth,
                defaultColWidth,
                tableWidth,
                calculateRowHeight(headerTextWidth, defaultColWidth),
              ),
            ),
          ),
        if ((widget.footerRow != null) && (widget.footerRow!.cells!.isNotEmpty))
          Container(
            height: 1.0, // Thickness of the line
            width: tableWidth, // Full width of the line
            color: Colors.grey,
          ),
        if ((widget.showPaginator) && (sortHeaderColumn == null))
          Container(
            width: widget.tableWidth! > 0 ? widget.tableWidth : MediaQuery.of(context).size.width * (DynamoCommons.isMobile(context) ? 1 : 0.6),
            height: pagingSectionHeight,
            decoration: BoxDecoration(
              color: widget.headerColor ?? const Color(0xff006784).withAlpha(40),
            ),
            child: ListTile(
              title: pageNumbrContainer,
            ),
          ),
      ],
    );
  }

  Widget createHeaderHierarchy(List<DynamoColumn> dataColumn, int columnHeaderDepth, double headerTextWidth, int colIndex) {
    Widget headerWidget = Container();

    if (colIndex <= dataColumn.length - 1) {
      if (columnHeaderDepth == 1) {
        headerWidget = Container(
          width: headerTextWidth,
          alignment: Alignment.center,
          child: dataColumn[colIndex].label!,
        );
      } else if (columnHeaderDepth > 1) {
        headerWidget = Container(
          width: headerTextWidth * dataColumn[colIndex].subHeadings!.length,
          alignment: Alignment.center,
          child: dataColumn[colIndex]
              .createHeaderHierarchy(columnHeaderDepth - 1, headerTextWidth * dataColumn[colIndex].subHeadings!.length, context, onTableSortTapped: (
            TableSortOrder sortOrder,
            int sortColIndex,
          ) {
            setState(() {
              sortTableRecords(sortOrder, sortColIndex);
            });
          }, onTableFilterTapped: (String filterText) {
            if (filterText.trim().isNotEmpty) {
              tableDataRows = <DynamoRow>[];

              setState(() {
                for (DynamoRow rowElement in widget.rows!) {
                  String cell1Value = (rowElement.cells![colIndex].cellContent as Text).data!;

                  if (cell1Value.toUpperCase().startsWith(filterText.toUpperCase())) {
                    tableDataRows!.add(rowElement);
                  }
                }
              });
            } else {
              setState(() {
                tableDataRows = widget.rows;
              });
            }
          }),
        );
      }
    }

    return headerWidget;
  }

  /*int calculateBaselineColumnLength() {
    int columnLength = 0;

    widget.columns!.forEach((element) {
      if (element.subHeadings != null) {
        columnLength += element.calculateBaselineColumnLength();
      } else {
        columnLength++;
      }
    });

    return columnLength;
  }*/

  int calculateHeaderDepth() {
    int maxHeaderDepth = 1;

    for (DynamoColumn element in widget.columns!) {
      int headerDepth = element.calculateHeaderDepth();

      if (headerDepth > maxHeaderDepth) {
        maxHeaderDepth = headerDepth;
      }
    }

    return maxHeaderDepth;
  }

  double calculateFormular(double summaryValue, List<double> numberSet, DynamoCell sumryElement) {
    if ((sumryElement.summaryFormula == TableSummaryFormula.average) ||
        (sumryElement.summaryFormula == TableSummaryFormula.variance) ||
        (sumryElement.summaryFormula == TableSummaryFormula.standardDeviation)) {
      double average = summaryValue / numberSet.length;

      if (sumryElement.summaryFormula == TableSummaryFormula.average) {
        summaryValue = average;
      } else {
        double variance = 0;

        for (double element in numberSet) {
          variance += pow((element - average), 2);
        }

        variance = variance / numberSet.length;

        if (sumryElement.summaryFormula == TableSummaryFormula.variance) {
          summaryValue = variance;
        } else if (sumryElement.summaryFormula == TableSummaryFormula.standardDeviation) {
          summaryValue = sqrt(variance);
        }
      }
    }

    return summaryValue;
  }

  void sortTableRecords(TableSortOrder sortOrder, int sortColumnIndex) {
    if (tableDataRows![0].cells![sortColumnIndex].cellContent is Text) {
      tableDataRows!.sort((a, b) {
        String cell1Value = (a.cells![sortColumnIndex].cellContent as Text).data!;
        String cell2Value = (b.cells![sortColumnIndex].cellContent as Text).data!;

        if (sortOrder == TableSortOrder.ascending) {
          if (DynamoCommons.isDigitSequence(cell1Value) && DynamoCommons.isDigitSequence(cell2Value)) {
            return int.parse(cell1Value).compareTo(int.parse(cell2Value));
          } else {
            return cell1Value.compareTo(cell2Value);
          }
        } else {
          if (DynamoCommons.isDigitSequence(cell1Value) && DynamoCommons.isDigitSequence(cell2Value)) {
            return int.parse(cell2Value).compareTo(int.parse(cell1Value));
          } else {
            return cell2Value.compareTo(cell1Value);
          }
        }
      });
    }
  }

  Column buildTableBody(double headerTextWidth, double defaultColWidth, double tableWidth) {
    Column tableContainer = Column(
      children: <Widget>[
        Container(),
      ],
    );

    if (sortHeaderColumn != null) {
      for (UniqueValueField sortKeyHeader in sortKeyHeaderList) {
        tableContainer.children.add(
          Container(
            height: 1.0,
            width: tableWidth,
            color: Colors.grey,
          ),
        );

        tableContainer.children.add(
          Container(
            width: widget.tableWidth! > 0 ? widget.tableWidth : MediaQuery.of(context).size.width * (DynamoCommons.isMobile(context) ? 1 : 0.6),
            height: calculateRowHeight(headerTextWidth, defaultColWidth),
            decoration: BoxDecoration(
              color: widget.headerColor ?? const Color(0xff006784).withAlpha(40),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 15),
              child: Text(
                sortKeyHeader.fieldValue!,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );

        int currentRowIndex = (currentPage - 1) * tablePageRows;

        for (int j = 0; j <= sortedDataRowsMap![sortKeyHeader.fieldValue!]!.length - 1; j++) {
          if (j - currentRowIndex < tablePageRows) {
            double rowHeight = 0;
            int colIndex = -1;

            for (DynamoCell element in sortedDataRowsMap![sortKeyHeader.fieldValue!]![j].cells!) {
              colIndex++;

              if (baselineColumns[colIndex].sortable!) {
                headerTextWidth = defaultColWidth * 0.8;
              } else {
                headerTextWidth = defaultColWidth * 0.85;
              }

              if (element.colSpan! > 1) {
                headerTextWidth = headerTextWidth * element.colSpan!;
              }

              if (element.numberOfLines! > rowHeight) {
                rowHeight = element.numberOfLines!.toDouble();
              } else if (element.cellContent is Text) {
                TextStyle? widgetStyle = (element.cellContent as Text).style;

                widgetStyle ??= TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16.0,
                  color: const Color(0xff006784),
                );

                int charsThatFit = DynamoCommons.calculateCharactersThatFit(
                  (element.cellContent as Text).data!,
                  headerTextWidth,
                  widgetStyle,
                );

                int numberOfLines = 0;

                if (charsThatFit > 0) {
                  numberOfLines = (element.cellContent as Text).data!.length ~/ charsThatFit;
                }

                if ((element.cellContent as Text).data!.length % charsThatFit > 0) {
                  numberOfLines = numberOfLines + 1;
                }

                if (numberOfLines > rowHeight) {
                  rowHeight = numberOfLines.toDouble();
                }
              } else {
                if ((element.cellStringValue != null) && (element.cellStringValue!.isNotEmpty)) {
                  TextStyle widgetStyle = TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                    color: const Color(0xff006784),
                  );

                  int charsThatFit = DynamoCommons.calculateCharactersThatFit(
                    element.cellStringValue!,
                    headerTextWidth,
                    widgetStyle,
                  );

                  double numberOfLines = element.cellStringValue!.length / charsThatFit;
                  if (numberOfLines > rowHeight) {
                    rowHeight = numberOfLines;
                  }
                }
              }
            }

            if (rowHeight <= 3) {
              rowHeight = 65;
            } else {
              rowHeight = 65 + (rowHeight - 3) * (65.0 / 3.0);
            }

            tableContainer.children.add(
              Container(
                height: rowHeight + 10,
                width: tableWidth,
                decoration: baselineColumns[colIndex].sortKey!
                    ? BoxDecoration(
                        color: widget.headerColor ?? const Color(0xff006784).withAlpha(40),
                      )
                    : sortedDataRowsMap![sortKeyHeader.fieldValue!]![j].rowColor != null
                        ? BoxDecoration(
                            color: sortedDataRowsMap![sortKeyHeader.fieldValue!]![j].rowColor,
                          )
                        : BoxDecoration(
                            color: Colors.transparent,
                          ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 10.0),
                  itemBuilder: (BuildContext buildCtx, int i) {
                    if ((i < baselineColumns.length) && (i < sortedDataRowsMap![sortKeyHeader.fieldValue!]![j].cells!.length)) {
                      if (baselineColumns[i].sortable!) {
                        headerTextWidth = defaultColWidth * 0.8;
                      } else {
                        headerTextWidth = defaultColWidth * 0.85;
                      }

                      return Container(
                        width: baselineColumns[i].width! > 0 ? baselineColumns[i].width : defaultColWidth,
                        alignment: Alignment.center,
                        child: sortedDataRowsMap![sortKeyHeader.fieldValue!]![j].cells![i].cellContent,
                      );
                    }

                    return null;
                  },
                ),
              ),
            );

            /*tableContainer.children.add(
            Container(
              height: 10,
            ),
          );*/

            if ((sortedDataRowsMap![sortKeyHeader.fieldValue!]![j].drawer != null) &&
                (sortedDataRowsMap![sortKeyHeader.fieldValue!]![j].rowExpanded!)) {
              tableContainer.children.add(
                Container(
                  height: 10,
                ),
              );
            }

            if ((sortedDataRowsMap![sortKeyHeader.fieldValue!]![j].drawer != null) &&
                (sortedDataRowsMap![sortKeyHeader.fieldValue!]![j].rowExpanded!)) {
              tableContainer.children.add(
                SizedBox(
                  height: sortedDataRowsMap![sortKeyHeader.fieldValue!]![j].drawerHeight,
                  width: tableWidth,
                  child: sortedDataRowsMap![sortKeyHeader.fieldValue!]![j].drawer,
                ),
              );
            }

            tableContainer.children.add(
              Container(
                height: 1.0,
                width: tableWidth,
                color: Colors.grey,
              ),
            );
          }
        }

        if ((sortedKeySummaryRow![sortKeyHeader.fieldValue!] != null) && (sortedKeySummaryRow![sortKeyHeader.fieldValue!]!.cells!.isNotEmpty)) {
          tableContainer.children.add(
            Container(
              width: widget.tableWidth! > 0 ? widget.tableWidth : MediaQuery.of(context).size.width * (DynamoCommons.isMobile(context) ? 1 : 0.6),
              height: calculateRowHeight(headerTextWidth, defaultColWidth),
              decoration: BoxDecoration(
                color: widget.headerColor ?? const Color(0xff006784).withAlpha(40),
              ),
              child: ListTile(
                title: buildTableSummaryRow(
                  sortedKeySummaryRow![sortKeyHeader.fieldValue!]!,
                  headerTextWidth,
                  defaultColWidth,
                  tableWidth,
                  calculateRowHeight(headerTextWidth, defaultColWidth),
                ),
              ),
            ),
          );

          tableContainer.children.add(
            Container(
              height: 1.0, // Thickness of the line
              width: tableWidth, // Full width of the line
              color: Colors.grey,
            ),
          );
        }
      }
    } else {
      int currentRowIndex = (currentPage - 1) * tablePageRows;

      for (int j = currentRowIndex; j <= tableDataRows!.length - 1; j++) {
        if (j - currentRowIndex < tablePageRows) {
          double rowHeight = 0;
          int colIndex = -1;

          for (DynamoCell element in tableDataRows![j].cells!) {
            colIndex++;

            if (baselineColumns[colIndex].sortable!) {
              headerTextWidth = defaultColWidth * 0.8;
            } else {
              headerTextWidth = defaultColWidth * 0.85;
            }

            if (element.colSpan! > 1) {
              headerTextWidth = headerTextWidth * element.colSpan!;
            }

            if (element.numberOfLines! > rowHeight) {
              rowHeight = element.numberOfLines!.toDouble();
            } else if (element.cellContent is Text) {
              TextStyle? widgetStyle = (element.cellContent as Text).style;

              widgetStyle ??= TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16.0,
                color: const Color(0xff006784),
              );

              int charsThatFit = DynamoCommons.calculateCharactersThatFit(
                (element.cellContent as Text).data!,
                headerTextWidth,
                widgetStyle,
              );

              int numberOfLines = 0;

              if (charsThatFit > 0) {
                numberOfLines = (element.cellContent as Text).data!.length ~/ charsThatFit;
              }

              if ((element.cellContent as Text).data!.length % charsThatFit > 0) {
                numberOfLines = numberOfLines + 1;
              }

              if (numberOfLines > rowHeight) {
                rowHeight = numberOfLines.toDouble();
              }
            } else {
              if ((element.cellStringValue != null) && (element.cellStringValue!.isNotEmpty)) {
                TextStyle widgetStyle = TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16.0,
                  color: const Color(0xff006784),
                );

                int charsThatFit = DynamoCommons.calculateCharactersThatFit(
                  element.cellStringValue!,
                  headerTextWidth,
                  widgetStyle,
                );

                double numberOfLines = element.cellStringValue!.length / charsThatFit;
                if (numberOfLines > rowHeight) {
                  rowHeight = numberOfLines;
                }
              } else if (element.numberOfLines! > rowHeight) {
                rowHeight = element.numberOfLines as double;
              }
            }
          }

          if (rowHeight <= 3) {
            rowHeight = 65;
          } else {
            rowHeight = 65 + (rowHeight - 3) * (65.0 / 3.0);
          }

          tableContainer.children.add(
            Container(
              height: rowHeight + 10,
              width: tableWidth,
              decoration: baselineColumns[colIndex].sortKey!
                  ? BoxDecoration(
                      color: widget.headerColor ?? const Color(0xff006784).withAlpha(40),
                    )
                  : tableDataRows![j].rowColor != null
                      ? BoxDecoration(
                          color: tableDataRows![j].rowColor,
                        )
                      : BoxDecoration(
                          color: Colors.transparent,
                        ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 10.0),
                itemBuilder: (BuildContext buildCtx, int i) {
                  if ((i < baselineColumns.length) && (i < tableDataRows![j].cells!.length)) {
                    if (baselineColumns[i].sortable!) {
                      headerTextWidth = defaultColWidth * 0.8;
                    } else {
                      headerTextWidth = defaultColWidth * 0.85;
                    }

                    return Container(
                      width: baselineColumns[i].width! > 0 ? baselineColumns[i].width : defaultColWidth,
                      alignment: Alignment.center,
                      child: tableDataRows![j].cells![i].cellContent,
                    );
                  }

                  return null;
                },
              ),
            ),
          );

          if ((tableDataRows![j].drawer != null) && (tableDataRows![j].rowExpanded!)) {
            tableContainer.children.add(
              Container(
                height: 10,
              ),
            );
          }

          if ((tableDataRows![j].drawer != null) && (tableDataRows![j].rowExpanded!)) {
            tableContainer.children.add(
              SizedBox(
                height: tableDataRows![j].drawerHeight,
                width: tableWidth,
                child: tableDataRows![j].drawer,
              ),
            );
          }

          /*tableContainer.children.add(
            SizedBox(height: 10),
          );*/

          tableContainer.children.add(
            Container(
              height: 1.0, // Thickness of the line
              width: tableWidth, // Full width of the line
              color: Colors.grey,
            ),
          );
        }
      }
    }

    return tableContainer;
  }

  double calculateRowHeight(double headerTextWidth, double defaultColWidth) {
    double rowHeight = 0;
    int colIndex = -1;

    if (widget.footerRow != null) {
      for (DynamoCell element in widget.footerRow!.cells!) {
        colIndex++;

        if (colIndex < baselineColumns.length) {
          if (baselineColumns[colIndex].sortable!) {
            headerTextWidth = defaultColWidth * 0.8;
          } else {
            headerTextWidth = defaultColWidth * 0.85;
          }

          if (element.cellContent is Text) {
            TextStyle? widgetStyle = (element.cellContent as Text).style;

            widgetStyle ??= TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16.0,
              color: const Color(0xff006784),
            );

            int charsThatFit = DynamoCommons.calculateCharactersThatFit(
              (element.cellContent as Text).data!,
              headerTextWidth,
              widgetStyle,
            );

            double numberOfLines = (element.cellContent as Text).data!.length / charsThatFit;
            if (numberOfLines > rowHeight) {
              rowHeight = numberOfLines;
            }
          } else {
            if ((element.cellStringValue != null) && (element.cellStringValue!.isNotEmpty)) {
              TextStyle widgetStyle = TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16.0,
                color: const Color(0xff006784),
              );

              int charsThatFit = DynamoCommons.calculateCharactersThatFit(
                element.cellStringValue!,
                headerTextWidth,
                widgetStyle,
              );

              double numberOfLines = element.cellStringValue!.length / charsThatFit;
              if (numberOfLines > rowHeight) {
                rowHeight = numberOfLines;
              }
            } else if (element.numberOfLines! > rowHeight) {
              rowHeight = element.numberOfLines as double;
            }
          }
        }
      }
    }

    if (rowHeight <= 3) {
      rowHeight = 65;
    } else {
      rowHeight = 65 + (rowHeight - 3) * (65.0 / 3.0);
    }

    return rowHeight;
  }

  List<DynamoColumn> getBaselineColumns(List<DynamoColumn> columns) {
    List<DynamoColumn> baselineColumns = <DynamoColumn>[];

    for (DynamoColumn element in columns) {
      if (element.subHeadings != null) {
        baselineColumns.addAll(element.getBaselineColumns());
      } else {
        baselineColumns.add(element);
      }
    }

    return baselineColumns;
  }

  Column buildTableSummaryRow(
    DynamoRow tabSummaryRow,
    double headerTextWidth,
    double defaultColWidth,
    double tableWidth,
    double footerRowHeight,
  ) {
    Column tableContainer = Column(
      children: <Widget>[
        Container(),
      ],
    );

    tableContainer.children.add(
      SizedBox(
        height: footerRowHeight,
        width: tableWidth,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 10.0),
          itemBuilder: (BuildContext buildCtx, int i) {
            if (i < baselineColumns.length) {
              if (baselineColumns[i].sortable!) {
                headerTextWidth = defaultColWidth * 0.8;
              } else {
                headerTextWidth = defaultColWidth * 0.85;
              }

              return Container(
                width: baselineColumns[i].width! > 0 ? baselineColumns[i].width : defaultColWidth,
                alignment: Alignment.center,
                child: i < tabSummaryRow.cells!.length ? tabSummaryRow.cells![i].cellContent : Container(),
              );
            }

            return null;
          },
        ),
      ),
    );

    return tableContainer;
  }
}
