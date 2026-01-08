# dynamo_data_table

A feature-rich, customizable data table for Flutter, built for enterprise dashboards and data-heavy applications.
Supports pagination, grouping, sorting, filtering, expandable rows, and summary formulas out of the box.

Optimized for Flutter Web, Desktop, and large-screen apps.

[![pub package](https://img.shields.io/pub/v/dynamo_data_table.svg)](https://pub.dev/packages/dynamo_data_table)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## 🌟 Features

* Simple table mode.
* Pagination with configurable page size.
* Grouping with Sortkey, Summary & Footer rows.
* Expandable (drawer) rows
* 🔍 Interactive Columns: Support for sorting and filtering out of the box.
* 📊 Built-in support for mathematical formulas like SUM, AVERAGE, VARIANCE, and STANDARD DEVIATION across columns.
* Custom column widths & styling
* 🎨 Highly Customizable: Custom header colors, column widths, and cell styling.

## 📦 Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  dynamo_data_table: ^1.0.0
```
Or run:

```flutter pub add dynamo_data_table```

## 🚀 Usage

Import the library

```import 'package:dynamo_data_table/dynamo_data_table.dart';```

Simple Example

```
import 'package:dynamo_data_table/dynamo_data_table.dart';

Widget buildSimpleDataTable(BuildContext context, List<DynamoSalesRecord> salesRecordList) {
    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DynamoDataTable(
                headerColor: Colors.blue.shade100,
                tableWidth: MediaQuery.of(context).size.width * 0.6,
                tableName: "Sales Table",
                key: ValueKey(++_counter),
                columns: [
                  DynamoColumn(
                    label: Text(
                      'Item Name',
                    ),
                  ),
                  DynamoColumn(
                    label: Text(
                      'Item Quantity',
                    ),
                  ),
                  DynamoColumn(
                    label: Text(
                      'Item Price',
                    ),
                  ),
                  DynamoColumn(
                    label: Text(
                      'Transact Date',
                    ),
                  ),
                  DynamoColumn(
                    label: Text(
                      'Sales Agent',
                    ),
                  ),
                  DynamoColumn(
                    label: Text(
                      'Actions',
                    ),
                    width: 120,
                  ),
                ],
                rows: salesRecordList
                    .map(
                      (data) => DynamoRow(
                    cells: [
                      DynamoCell(
                        cellContent: Text(data.itemName != null ? data.itemName! : ""),
                      ),
                      DynamoCell(
                        cellContent: Text(
                          data.itemQuantity != null ? data.itemQuantity!.toString() : "0",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DynamoCell(
                        cellContent: Text(
                          data.itemPrice != null ? DynamoCommons.getMoneyFormat(data.itemPrice!) : "0.00",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DynamoCell(
                        cellContent: Text(
                          data.transactionDate != null ? data.transactionDate! : "",
                        ),
                      ),
                      DynamoCell(
                        cellContent: Text(data.salesAgent != null ? data.salesAgent! : ""),
                      ),
                      DynamoCell(
                        cellContent: Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: TableWidgetCommons.getFineRoundedButton(
                            "Edit",
                                () {},
                            Icon(
                              Icons.edit,
                              color: Colors.indigo,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
```

Pagination & Expandable Rows

```
Widget buildPaginatedDataTable(BuildContext context, List<DynamoSalesRecord> salesRecordList) {
    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DynamoDataTable(
                headerColor: Colors.blue.shade100,
                tableWidth: MediaQuery.of(context).size.width * 0.6,
                tableName: "Sales Table",
                showPaginator: true,
                pageRows: 5,
                key: ValueKey(++_counter),
                expandedRow: tableExpandedRow,
                onDrawerTapped: (bool rowExpanded, int expandedRow) {
                  tableExpandedRow = expandedRow;
                  setState(() {});
                },
                columns: [
                  DynamoColumn(
                    label: Text(
                      'Item Name',
                    ),
                    sortable: true,
                    filterable: true,
                  ),
                  DynamoColumn(
                    label: Text(
                      'Item Quantity',
                    ),
                    sortable: true,
                    filterable: true,
                  ),
                  DynamoColumn(
                    label: Text(
                      'Item Price',
                    ),
                    sortable: true,
                    filterable: true,
                  ),
                  DynamoColumn(
                    label: Text(
                      'Transact Date',
                    ),
                    sortable: true,
                    filterable: true,
                  ),
                  DynamoColumn(
                    label: Text(
                      'Sales Agent',
                    ),
                    sortable: true,
                    filterable: true,
                  ),
                  DynamoColumn(
                    label: Text(
                      'Actions',
                    ),
                    width: 120,
                  ),
                ],
                rows: salesRecordList
                    .map(
                      (data) => DynamoRow(
                    cells: [
                      DynamoCell(
                        cellContent: Text(data.itemName != null ? data.itemName! : ""),
                      ),
                      DynamoCell(
                        cellContent: Text(
                          data.itemQuantity != null ? data.itemQuantity!.toString() : "0",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DynamoCell(
                        cellContent: Text(
                          data.itemPrice != null ? DynamoCommons.getMoneyFormat(data.itemPrice!) : "0.00",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DynamoCell(
                        cellContent: Text(
                          data.transactionDate != null ? data.transactionDate! : "",
                        ),
                      ),
                      DynamoCell(
                        cellContent: Text(data.salesAgent != null ? data.salesAgent! : ""),
                      ),
                      DynamoCell(
                        cellContent: Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: TableWidgetCommons.getFineRoundedButton(
                            "Edit",
                                () {},
                            Icon(
                              Icons.edit,
                              color: Colors.indigo,
                            ),
                          ),
                        ),
                      ),
                    ],
                    drawer: Card(
                      elevation: 18.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    "Total Amount",
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.13,
                                    child: Text(
                                      DynamoCommons.getMoneyFormat(data.totalAmount!),
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    "Txn Currency",
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.13,
                                    child: Text(
                                      data.currency!,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    "Branch",
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.13,
                                    child: Text(
                                      data.branchName!,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          ...TableWidgetCommons.buildSpacerDividerSet(context),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    "Discount",
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.13,
                                    child: Text(
                                      '${DynamoCommons.getMoneyFormat((data.discountRate! * data.totalAmount!) / 100)} (${DynamoCommons.getMoneyFormat(data.discountRate!)}%)',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    "Sales Tax",
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.13,
                                    child: Text(
                                      '${DynamoCommons.getMoneyFormat((data.salesTaxRate! * data.totalAmount!) / 100)} (${DynamoCommons.getMoneyFormat(data.salesTaxRate!)}%)',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    drawerHeight: 150,
                  ),
                )
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
```

Grouping, Formulars, Sorting, Filtering, Group Summaries, and Footer Summary

```
Widget buildGroupingDataTable(BuildContext context, List<DynamoSalesRecord> salesRecordList) {
    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DynamoDataTable(
                headerColor: Colors.blue.shade100,
                tableWidth: MediaQuery.of(context).size.width * 0.6,
                tableName: "Sales Table",
                key: ValueKey(++_counter),
                expandedRow: tableExpandedRow,
                onDrawerTapped: (bool rowExpanded, int expandedRow) {
                  tableExpandedRow = expandedRow;
                  setState(() {});
                },
                columns: [
                  DynamoColumn(
                    label: Text(
                      'Item Name',
                    ),
                    sortable: true,
                    filterable: true,
                  ),
                  DynamoColumn(
                    label: Text(
                      'Item Quantity',
                    ),
                    sortable: true,
                    filterable: true,
                  ),
                  DynamoColumn(
                    label: Text(
                      'Item Price',
                    ),
                    sortable: true,
                    filterable: true,
                  ),
                  DynamoColumn(
                    label: Text(
                      'Transact Date',
                    ),
                    sortable: true,
                    filterable: true,
                  ),
                  DynamoColumn(
                    label: Text(
                      'Sales Agent',
                    ),
                    sortable: true,
                    filterable: true,
                    sortKey: true,
                  ),
                  DynamoColumn(
                    label: Text(
                      'Actions',
                    ),
                    width: 120,
                  ),
                ],
                rows: salesRecordList
                    .map(
                      (data) => DynamoRow(
                    cells: [
                      DynamoCell(
                        cellContent: Text(data.itemName != null ? data.itemName! : ""),
                      ),
                      DynamoCell(
                        cellContent: Text(
                          data.itemQuantity != null ? data.itemQuantity!.toString() : "0",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DynamoCell(
                        cellContent: Text(
                          data.itemPrice != null ? DynamoCommons.getMoneyFormat(data.itemPrice!) : "0.00",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DynamoCell(
                        cellContent: Text(
                          data.transactionDate != null ? data.transactionDate! : "",
                        ),
                      ),
                      DynamoCell(
                        cellContent: Text(data.salesAgent != null ? data.salesAgent! : ""),
                      ),
                      DynamoCell(
                        cellContent: Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: TableWidgetCommons.getFineRoundedButton(
                            "Edit",
                                () {},
                            Icon(
                              Icons.edit,
                              color: Colors.indigo,
                            ),
                          ),
                        ),
                      ),
                    ],
                    drawer: Card(
                      elevation: 18.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    "Total Amount",
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.13,
                                    child: Text(
                                      DynamoCommons.getMoneyFormat(data.totalAmount!),
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    "Txn Currency",
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.13,
                                    child: Text(
                                      data.currency!,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    "Branch",
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.13,
                                    child: Text(
                                      data.branchName!,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          ...TableWidgetCommons.buildSpacerDividerSet(context),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    "Discount",
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.13,
                                    child: Text(
                                      '${DynamoCommons.getMoneyFormat((data.discountRate! * data.totalAmount!) / 100)} (${DynamoCommons.getMoneyFormat(data.discountRate!)}%)',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    "Sales Tax",
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.13,
                                    child: Text(
                                      '${DynamoCommons.getMoneyFormat((data.salesTaxRate! * data.totalAmount!) / 100)} (${DynamoCommons.getMoneyFormat(data.salesTaxRate!)}%)',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    drawerHeight: 150,
                  ),
                )
                    .toList(),
                summaryRow: DynamoRow(
                  cells: [
                    DynamoCell(
                      cellContent: Text(""),
                    ),
                    DynamoCell(
                      cellContent: Text(""),
                    ),
                    DynamoCell(
                      summaryFormula: TableSummaryFormula.SUM,
                    ),
                    DynamoCell(
                      summaryFormula: TableSummaryFormula.SUM,
                    ),
                    DynamoCell(
                      cellContent: Text(""),
                    ),
                    DynamoCell(
                      cellContent: Text(""),
                    ),
                    DynamoCell(
                      cellContent: Text(""),
                    ),
                  ],
                ),
                footerRow: DynamoRow(
                  cells: [
                    DynamoCell(
                      cellContent: Text(""),
                    ),
                    DynamoCell(
                      summaryFormula: TableSummaryFormula.SUM,
                    ),
                    DynamoCell(
                      summaryFormula: TableSummaryFormula.SUM,
                    ),
                    DynamoCell(
                      cellContent: Text(""),
                    ),
                    DynamoCell(
                      cellContent: Text(""),
                    ),
                    DynamoCell(
                      cellContent: Text(""),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
```

## 🧪 Example

A complete working example is available in /example, showcasing:

* Simple table
* Pagination
* Grouping with summary rows
* Expandable drawers

## 🎥 Demo

![Simple Table](https://raw.githubusercontent.com/patushie/dynamo_data_table/main/assets/simple_table.png)
![Paginated Table](https://raw.githubusercontent.com/patushie/dynamo_data_table/main/assets/pagination_table.png)
![Grouping Table](https://raw.githubusercontent.com/patushie/dynamo_data_table/main/assets/grouping_table.png)
![Watch Demo](https://raw.githubusercontent.com/patushie/dynamo_data_table/main/assets/dynamo_table_optimized.gif)

## 📄 License

This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/patushie/dynamo_data_table/issues).