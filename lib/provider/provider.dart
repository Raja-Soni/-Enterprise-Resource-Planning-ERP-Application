import 'package:erp_mini_app/DataBase/local/dbHelper.dart';
import 'package:erp_mini_app/model/sales_order.dart';
import 'package:flutter/cupertino.dart';

enum Filters { today, pending, delivered, noFilter }

class DataBaseProvider extends ChangeNotifier {
  DBHelper dbHelper;
  bool? _isDarkMode;
  List<Map<String, dynamic>> allData = [];
  Filters currentFilter = Filters.noFilter;
  String name = "";
  String selectedItem = "Select Item";
  int _quantity = 0;
  int _rate = 0;
  int _total = 0;
  bool _pendingAlertShown = false;
  int highestValueOrderNumber = 0;
  bool _alertPopShow = true;

  DataBaseProvider({required this.dbHelper});

  ///////////// METHODS //////////////

  initializeData() async {
    allData = await dbHelper.getOrders();
    notifyListeners();
  }

  List<Map<String, dynamic>> appliedFilters() {
    List<Map<String, dynamic>> tempList = [];
    if (currentFilter == Filters.noFilter) {
      tempList = allData;
    } else if (currentFilter == Filters.today) {
      final today = DateTime.now();
      tempList = allData.where((order) {
        final orderDate = DateTime.parse(order[DBHelper.COLUMN_NAME_DATE]);
        return orderDate.year == today.year &&
            orderDate.month == today.month &&
            orderDate.day == today.day;
      }).toList();
    } else if (currentFilter == Filters.pending) {
      tempList = allData
          .where(
            (order) =>
                order[DBHelper.COLUMN_NAME_STATUS].toString() == "Pending",
          )
          .toList();
    } else if (currentFilter == Filters.delivered) {
      tempList = allData
          .where(
            (order) =>
                order[DBHelper.COLUMN_NAME_STATUS].toString() == "Delivered",
          )
          .toList();
    }
    return tempList;
  }

  void addOrder({required customerName, required rate, int? quantity}) {
    int totalAmount = getTotal();
    String newOrderStatus = (allData.length + 1) % 2 == 0
        ? "Pending"
        : "Delivered";
    String todayDate = DateTime.now().toString().split(' ')[0];
    SalesOrder newOrder = SalesOrder(
      customer: customerName,
      amount: totalAmount,
      status: newOrderStatus,
      date: todayDate,
    );
    dbHelper.addOrder(newOrder);
    if (totalAmount > 10000) {
      _alertPopShow = false;
    }
    notifyListeners();
  }

  ///////////// SETTERS //////////////

  void setThemeMode({required bool setThemeMode}) {
    _isDarkMode = setThemeMode;
    notifyListeners();
  }

  void setFilter({required Filters filter}) {
    currentFilter = filter;
    notifyListeners();
  }

  void setName(String name) {
    this.name = name;
    notifyListeners();
  }

  void setSelectedItem(String item) {
    selectedItem = item;
    notifyListeners();
  }

  void setQuantity(int quantity) {
    _quantity = quantity;
    notifyListeners();
  }

  void setRate(int rate) {
    _rate = rate;
    notifyListeners();
  }

  void setTotal() {
    _rate = 0;
    _quantity = 0;
    notifyListeners();
  }

  void setHighestValueOrders(int i) {
    highestValueOrderNumber = i;
    notifyListeners();
  }

  void setPendingAlertShown(bool shown) {
    _pendingAlertShown = shown;
    notifyListeners();
  }

  void setAlertPopUpShow(bool set) {
    _alertPopShow = set;
    notifyListeners();
  }

  ///////////// GETTERS //////////////

  bool getThemeMode() {
    return _isDarkMode ?? false;
  }

  String getName() {
    return name;
  }

  String getSelectedItem() {
    return selectedItem;
  }

  int getRate() {
    return _rate;
  }

  int getQuantity() {
    return _quantity;
  }

  int getTotal() {
    _total = _rate * _quantity;
    return _total;
  }

  bool getPendingAlertShown() {
    return _pendingAlertShown;
  }

  double getTotalAmountOfPendingOrders() {
    double totalAmount = 0;
    final pendingList = getPendingOrdersList();
    for (var amount in pendingList) {
      totalAmount += amount[DBHelper.COLUMN_NAME_AMOUNT] as double;
    }
    return totalAmount;
  }

  int getHighestValueOrders() {
    highestValueOrderNumber = allData
        .where((order) => order[DBHelper.COLUMN_NAME_AMOUNT] > 10000)
        .toList()
        .length;
    return highestValueOrderNumber;
  }

  List<Map<String, dynamic>> getPendingOrdersList() {
    return allData
        .where((order) => order[DBHelper.COLUMN_NAME_STATUS] == 'Pending')
        .toList();
  }

  bool getAlertPopUpShow() {
    return _alertPopShow;
  }

  List<String> getGroceryList() {
    return dbHelper.itemList;
  }
}
