import 'package:erp_mini_app/DataBase/local/dbHelper.dart';
import 'package:erp_mini_app/model/sales_order.dart';
import 'package:flutter/cupertino.dart';

enum Filters { today, pending, delivered, noFilter }

class DataBaseProvider extends ChangeNotifier {
  bool? _isDarkMode;
  DBHelper dbHelper;
  List<Map<String, dynamic>> allData = [];
  DataBaseProvider({required this.dbHelper});
  Filters currentFilter = Filters.noFilter;
  String name = "";
  int rate = 0;
  int quantity = 0;
  int total = 0;
  String selectedItem = "Select Item";
  bool alertPopShowed = true;
  int highestValueOrderNumber = 0;
  bool pendingAlertShown = false;

  List<Map<String, dynamic>> getPendingOrdersList() {
    return allData
        .where((order) => order[DBHelper.COLUMN_NAME_STATUS] == 'Pending')
        .toList();
  }

  void setPendingAlertShown(bool shown) {
    pendingAlertShown = shown;
    notifyListeners();
  }

  bool getPendingAlertShown() {
    return pendingAlertShown;
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

  setHighestValueOrders(int i) {
    highestValueOrderNumber = i;
    notifyListeners();
  }

  setAlertPopUpShow(bool set) {
    alertPopShowed = set;
    notifyListeners();
  }

  bool getAlertPopUpShow() {
    return alertPopShowed;
  }

  setSelectedItem(String item) {
    selectedItem = item;
    notifyListeners();
  }

  String getSelectedItem() {
    return selectedItem;
  }

  List<String> getGroceryList() {
    return dbHelper.groceryList;
  }

  setName(String name) {
    this.name = name;
    notifyListeners();
  }

  String getName() {
    return name;
  }

  setTotal() {
    rate = 0;
    quantity = 0;
    notifyListeners();
  }

  int getTotal() {
    total = rate * quantity;
    return total;
  }

  setRate(int rate) {
    this.rate = rate;
    notifyListeners();
  }

  setQuantity(int quantity) {
    this.quantity = quantity;
    notifyListeners();
  }

  int getRate() {
    return rate;
  }

  int getQuantity() {
    return quantity;
  }

  initializeData() async {
    allData = await dbHelper.getOrders();
    notifyListeners();
  }

  bool getThemeMode() {
    return _isDarkMode ?? false;
  }

  setThemeMode({required bool setThemeMode}) {
    _isDarkMode = setThemeMode;
    notifyListeners();
  }

  setFilter({required Filters filter}) {
    currentFilter = filter;
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

  addOrder({required customerName, required rate, int? quantity}) {
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
      alertPopShowed = false;
    }
    notifyListeners();
  }

  deletetable() {
    dbHelper.deleleAll();
    notifyListeners();
  }
}
