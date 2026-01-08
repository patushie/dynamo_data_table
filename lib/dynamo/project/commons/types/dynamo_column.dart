import 'package:dynamo_data_table/dynamo/project/commons/views/input_text_field.dart';
import 'package:flutter/material.dart';

import 'table_sort_order.dart';

class DynamoColumn extends StatefulWidget {

  static TableSortOrder systemTableSortOrder = TableSortOrder.none;
  //
  final Text? label;
  final bool? sortable;
  final bool? filterable;
  final InputTextField? filterField;
  final double? width;
  final int? columnIndex;
  final bool? isDrawerColumn;
  final bool? sortKey;
  final Color? sortKeyColor;
  //
  final List<DynamoColumn>? subHeadings;
  //
  final TableSortOrder tableSortOrder = TableSortOrder.none;

  const DynamoColumn({
    super.key,
    this.label,
    this.sortable = false,
    this.filterable = false,
    this.filterField,
    this.width = 0,
    this.columnIndex = 0,
    this.isDrawerColumn = false,
    this.sortKey = false,
    this.subHeadings,
    this.sortKeyColor = const Color(0xff006784),
  });

  int calculateHeaderDepth() {
    int headerDepth = 1;

    if (subHeadings != null) {
      int maxSubHeadDepth = 1;

      for(DynamoColumn element in subHeadings!) {
        int subHeadDepth = element.calculateHeaderDepth();

        if (subHeadDepth > maxSubHeadDepth) {
          maxSubHeadDepth = subHeadDepth;
        }
      }

      headerDepth = headerDepth + maxSubHeadDepth;
    }

    return headerDepth;
  }

  DynamoColumn copyLabelWith({Text? label}) {
    return DynamoColumn(
      label: label ?? this.label,
      columnIndex: columnIndex,
      sortable: sortable,
      filterable: filterable,
      filterField: filterField,
      width: width,
      isDrawerColumn: isDrawerColumn,
      sortKey: sortKey,
      subHeadings: subHeadings,
      sortKeyColor: sortKeyColor,
    );
  }

  DynamoColumn copyInputTextWith({InputTextField? filterField}) {
    return DynamoColumn(
      label: label,
      columnIndex: columnIndex,
      sortable: sortable,
      filterable: filterable,
      filterField: filterField ?? this.filterField,
      width: width,
      isDrawerColumn: isDrawerColumn,
      sortKey: sortKey,
      subHeadings: subHeadings,
      sortKeyColor: sortKeyColor,
    );
  }

  DynamoColumn copyColumnIndexWith({int? columnIndex}) {
    return DynamoColumn(
      label: label,
      columnIndex: columnIndex ?? this.columnIndex,
      sortable: sortable,
      filterable: filterable,
      filterField: filterField,
      width: width,
      isDrawerColumn: isDrawerColumn,
      sortKey: sortKey,
      subHeadings: subHeadings,
      sortKeyColor: sortKeyColor,
    );
  }

  Widget createHeaderHierarchy(
    int columnHeaderDepth,
    double headerTextWidth,
    BuildContext context, {
    Function(TableSortOrder sortOrder, int sortColumnIndex)? onTableSortTapped,
    Function(String filterText)? onTableFilterTapped,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Container(
        width: headerTextWidth,
        alignment: Alignment.center,
        child: label,
      ),
      subtitle: SizedBox(
        height: MediaQuery.of(context).size.height * 0.07,
        width: headerTextWidth,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 10.0),
          itemBuilder: (BuildContext buildContext, int i) {
            if (i < subHeadings!.length) {
              return Container(
                width: headerTextWidth / subHeadings!.length,
                alignment: Alignment.center,
                child: subHeadings![i].subHeadings != null
                    ? subHeadings![i].createHeaderHierarchy(
                        columnHeaderDepth - 1,
                        headerTextWidth / subHeadings![i].subHeadings!.length,
                        context,
                      )
                    : Column(
                        children: <Widget>[
                          subHeadings![i].sortable!
                              ? InkWell(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  onTap: () {
                                    int sortColumnIndex = i;

                                    if (systemTableSortOrder == TableSortOrder.none) {
                                      systemTableSortOrder = TableSortOrder.ascending;
                                    } else {
                                      if (systemTableSortOrder == TableSortOrder.ascending) {
                                        systemTableSortOrder = TableSortOrder.descending;
                                      } else {
                                        systemTableSortOrder = TableSortOrder.ascending;
                                      }
                                    }

                                    onTableSortTapped!(systemTableSortOrder, sortColumnIndex);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        subHeadings![i].label!,
                                        Icon(
                                          tableSortOrder == TableSortOrder.ascending ? Icons.arrow_downward : Icons.arrow_upward,
                                          color: sortKeyColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : subHeadings![i].label!,
                          if (subHeadings![i].filterable!)
                            Padding(
                              padding: const EdgeInsets.all(2),
                              child: TextField(
                                controller: subHeadings![i].filterField!.inputTextFilter,
                                onChanged: (text) {
                                  onTableFilterTapped!(text);
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
    );
  }

  int calculateBaselineColumnLength() {
    int columnLength = 0;

    if (subHeadings != null) {
      for(DynamoColumn element in subHeadings!) {
        if (element.subHeadings != null) {
          columnLength += element.calculateBaselineColumnLength();
        } else {
          columnLength += 1;
        }
      }
    } else {
      columnLength = 1;
    }

    return columnLength;
  }

  List<DynamoColumn> getBaselineColumns() {
    List<DynamoColumn> baselineColumns = <DynamoColumn>[];

    for(DynamoColumn element in subHeadings!) {
      if (element.subHeadings != null) {
        baselineColumns.addAll(element.getBaselineColumns());
      } else {
        baselineColumns.add(element);
      }
    }

    return baselineColumns;
  }

  @override
  State<DynamoColumn> createState() => _DynamoColumnState();
}

class _DynamoColumnState extends State<DynamoColumn> {
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
    return widget.label!;
  }
}
