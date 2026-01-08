class TableInternalMemory {

  static TableInternalMemory? _instance;
  //
  int tablePageRows = 0;
  int tableExpandedRow = -1;
  int currentPage = 0;
  String tableName = "";

  TableInternalMemory._(String tableTitle) {
    tablePageRows = 0;
    tableExpandedRow = -1;
    currentPage = 0;

    tableName = tableTitle;
  }

  static TableInternalMemory getInstance(String tableTitle) {
    if(_instance == null) {
      _instance = TableInternalMemory._(tableTitle);
    } else if(_instance!.tableName != tableTitle) {
      _instance = TableInternalMemory._(tableTitle);
    }

    return _instance!;
  }
}