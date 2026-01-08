import 'package:dynamo_data_table/dynamo_data_table.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int _counter = 0;
  int tableExpandedRow = -1;
  TableViewMode _currentMode = TableViewMode.simple;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamo Datatable Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dynamo Table Demo'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(65.0),
            child: Container(
              padding: EdgeInsets.only(top: 20, bottom: 35),
              child: DropdownButton<TableViewMode>(
                value: _currentMode,
                icon: const Icon(Icons.settings, color: Colors.white),
                underline: Container(), // Removes the default line
                onChanged: (TableViewMode? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _currentMode = newValue;
                    });
                  }
                },
                items: const [
                  DropdownMenuItem(
                    value: TableViewMode.simple,
                    child: Text("Simple Table"),
                  ),
                  DropdownMenuItem(
                    value: TableViewMode.pagination,
                    child: Text("Pagination Mode"),
                  ),
                  DropdownMenuItem(
                    value: TableViewMode.grouping,
                    child: Text("Grouping (Summary)"),
                  ),
                ],
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildDynamoDataTable(context),
          ],
        ),
      ),
    );
  }

  Widget buildDynamoDataTable(BuildContext context) {
    List<DynamoSalesRecord> salesRecordList = <DynamoSalesRecord>[];

    salesRecordList.add(DynamoSalesRecord.init(
      itemName: "Mozzarella Cheese",
      itemQuantity: 2,
      itemPrice: 7500,
      totalAmount: 15000,
      currency: "NGN",
      transactionDate: "22/09/2024",
      salesAgent: "John Doe",
      branchName: "Ikeja",
      discountRate: 10,
      salesTaxRate: 7.5,
    ));

    salesRecordList.add(DynamoSalesRecord.init(
      itemName: "Tortilla - Shawarma Bread",
      itemQuantity: 20,
      itemPrice: 200,
      totalAmount: 4000,
      currency: "NGN",
      transactionDate: "20/09/2024",
      salesAgent: "John Doe",
      branchName: "Ikeja",
      discountRate: 10,
      salesTaxRate: 7.5,
    ));

    salesRecordList.add(DynamoSalesRecord.init(
      itemName: "Cadbury Bournvita",
      itemQuantity: 7,
      itemPrice: 1200,
      totalAmount: 8400,
      currency: "NGN",
      transactionDate: "22/09/2024",
      salesAgent: "Michael Bolton",
      branchName: "Surulere",
      discountRate: 10,
      salesTaxRate: 7.5,
    ));

    salesRecordList.add(DynamoSalesRecord.init(
      itemName: "Asparagus",
      itemQuantity: 8,
      itemPrice: 300,
      totalAmount: 2400,
      currency: "NGN",
      transactionDate: "22/09/2024",
      salesAgent: "John Doe",
      branchName: "Ikeja",
      discountRate: 10,
      salesTaxRate: 7.5,
    ));

    salesRecordList.add(DynamoSalesRecord.init(
      itemName: "Mozzarella Cheese",
      itemQuantity: 3,
      itemPrice: 7500,
      totalAmount: 22500,
      currency: "NGN",
      transactionDate: "20/09/2024",
      salesAgent: "Michael Bolton",
      branchName: "Surulere",
      discountRate: 10,
      salesTaxRate: 7.5,
    ));

    salesRecordList.add(DynamoSalesRecord.init(
      itemName: "Canned Sardine",
      itemQuantity: 12,
      itemPrice: 450,
      totalAmount: 5400,
      currency: "NGN",
      transactionDate: "22/09/2024",
      salesAgent: "Michael Bolton",
      branchName: "Surulere",
      discountRate: 10,
      salesTaxRate: 7.5,
    ));

    salesRecordList.add(DynamoSalesRecord.init(
      itemName: "Danish Red Tin Tomatoes",
      itemQuantity: 4,
      itemPrice: 2500,
      totalAmount: 10000,
      currency: "NGN",
      transactionDate: "20/09/2024",
      salesAgent: "John Doe",
      branchName: "Ikeja",
      discountRate: 10,
      salesTaxRate: 7.5,
    ));

    salesRecordList.add(DynamoSalesRecord.init(
      itemName: "Sweet Corn",
      itemQuantity: 6,
      itemPrice: 700,
      totalAmount: 4200,
      currency: "NGN",
      transactionDate: "22/09/2024",
      salesAgent: "Michael Bolton",
      branchName: "Surulere",
      discountRate: 10,
      salesTaxRate: 7.5,
    ));

    salesRecordList.add(DynamoSalesRecord.init(
      itemName: "Full Cream Ovaltine - Blended, With Cocoa Crystals And Coffee Flavour, Topped With Oragonam Nuts",
      itemQuantity: 5,
      itemPrice: 3500,
      totalAmount: 17500,
      currency: "NGN",
      transactionDate: "20/09/2024",
      salesAgent: "John Doe",
      branchName: "Ikeja",
      discountRate: 10,
      salesTaxRate: 7.5,
    ));

    salesRecordList.add(DynamoSalesRecord.init(
      itemName: "American Chickpeas",
      itemQuantity: 7,
      itemPrice: 800,
      totalAmount: 5600,
      currency: "NGN",
      transactionDate: "20/09/2024",
      salesAgent: "Michael Bolton",
      branchName: "Surulere",
      discountRate: 10,
      salesTaxRate: 7.5,
    ));

    salesRecordList.add(DynamoSalesRecord.init(
      itemName: "Peak Powdered Milk",
      itemQuantity: 5,
      itemPrice: 3000,
      totalAmount: 15000,
      currency: "NGN",
      transactionDate: "20/09/2024",
      salesAgent: "John Doe",
      branchName: "Ikeja",
      discountRate: 10,
      salesTaxRate: 7.5,
    ));

    salesRecordList.add(DynamoSalesRecord.init(
      itemName: "Nigerian Canned Green Beans",
      itemQuantity: 10,
      itemPrice: 500,
      totalAmount: 5000,
      currency: "NGN",
      transactionDate: "20/09/2024",
      salesAgent: "Michael Bolton",
      branchName: "Surulere",
      discountRate: 10,
      salesTaxRate: 7.5,
    ));

    if (_currentMode == TableViewMode.grouping) {
      return buildGroupingDataTable(context, salesRecordList);
    } else if (_currentMode == TableViewMode.pagination) {
      return buildPaginatedDataTable(context, salesRecordList);
    } else {
      return buildSimpleDataTable(context, salesRecordList);
    }
  }

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
                                  SizedBox(
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
                                  SizedBox(
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
                                  SizedBox(
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
                                  SizedBox(
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
                                  SizedBox(
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
                      summaryFormula: TableSummaryFormula.sum,
                    ),
                    DynamoCell(
                      summaryFormula: TableSummaryFormula.sum,
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
                      summaryFormula: TableSummaryFormula.sum,
                    ),
                    DynamoCell(
                      summaryFormula: TableSummaryFormula.sum,
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
                      elevation: 5.0,
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
                                  SizedBox(
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
                                  SizedBox(
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
                                  SizedBox(
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
                                  SizedBox(
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
                                  SizedBox(
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
}

enum TableViewMode {
  pagination,
  grouping,
  simple,
}

class DynamoSalesRecord {
  String? itemName;
  int? itemQuantity;
  double? itemPrice;
  double? totalAmount;
  String? currency;
  String? transactionDate;
  String? salesAgent;
  String? branchName;
  double? discountRate;
  double? salesTaxRate;
  double? shippingAmount;

  DynamoSalesRecord.init({
    this.itemName = "",
    this.itemQuantity = 0,
    this.itemPrice = 0,
    this.totalAmount = 0,
    this.currency = "",
    this.transactionDate,
    this.salesAgent = "",
    this.branchName = "",
    this.discountRate = 0,
    this.shippingAmount = 0,
    this.salesTaxRate = 0,
  });
}
