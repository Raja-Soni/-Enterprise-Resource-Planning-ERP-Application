import 'package:erp_mini_app/DataBase/local/dbHelper.dart';
import 'package:erp_mini_app/custom_widgets/custom_container.dart';
import 'package:erp_mini_app/custom_widgets/custom_fab.dart';
import 'package:erp_mini_app/custom_widgets/custom_text.dart';
import 'package:erp_mini_app/pages/new_sales_order_page.dart';
import 'package:erp_mini_app/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'custom_widgets/custom_alert_box.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => DataBaseProvider(dbHelper: DBHelper.dbhInstance),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ERP Mini Application',
      debugShowCheckedModeBanner: false,
      themeMode: context.watch<DataBaseProvider>().getThemeMode()
          ? ThemeMode.dark
          : ThemeMode.light,
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(brightness: Brightness.dark),
      ),
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.light(brightness: Brightness.light),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<DataBaseProvider>();
    provider.initializeData().then((_) {
      int pendingOrders = provider.getPendingOrdersList().length;
      double totalPendingAmount = provider.getTotalAmountOfPendingOrders();
      bool pendingPopUp = provider.getPendingAlertShown();
      if (pendingPopUp == false) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (context) => CustomAlertBox(
              buttonTextColor: provider.getThemeMode()
                  ? Colors.white
                  : Colors.black,
              title: 'Pending Orders',
              message:
                  'You have $pendingOrders pending orders today worth ₹$totalPendingAmount',
            ),
          );
        });
        provider.setPendingAlertShown(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.read<DataBaseProvider>();
    int highestValue = provider.getHighestValueOrders();
    bool popUpShowed = provider.getAlertPopUpShow();

    if (highestValue > 0 && popUpShowed == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) => CustomAlertBox(
            buttonTextColor: provider.getThemeMode()
                ? Colors.white
                : Colors.black,
            title: 'High Value Orders',
            message:
                '${provider.getHighestValueOrders()} order(s) crossed ₹10,000/-',
          ),
        );
      });
      provider.setAlertPopUpShow(true);
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: provider.getThemeMode()
              ? Colors.grey.shade900
              : Colors.blue.shade600,
          leading: Icon(Icons.list, size: 30),
          title: CustomText(
            text: "Order List",
            textSize: 30,
            textBoldness: FontWeight.bold,
          ),
          actions: [
            Consumer<DataBaseProvider>(
              builder: (ctx, provider, _) {
                return Switch(
                  padding: EdgeInsets.only(right: 30),
                  trackOutlineColor: WidgetStatePropertyAll(Colors.transparent),
                  activeTrackColor: Colors.grey.shade800,
                  inactiveTrackColor: Colors.blue.shade100,
                  activeThumbImage: AssetImage("assets/images/dark_mode.jpg"),
                  inactiveThumbImage: AssetImage(
                    "assets/images/light_mode.png",
                  ),
                  value: provider.getThemeMode(),
                  onChanged: (value) {
                    provider.setThemeMode(setThemeMode: value);
                  },
                );
              },
            ),
          ],
        ),
        body: CustomContainer(
          backgroundColor: provider.getThemeMode()
              ? Colors.transparent
              : Colors.white,
          child: Column(
            children: [
              CustomContainer(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                    top: 10.0,
                    bottom: 5.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(text: "Order Details", textSize: 25),
                      Card(
                        elevation: 6,
                        color: provider.getThemeMode()
                            ? Colors.grey[850]
                            : Colors.white,
                        child: DropdownButton(
                          icon: Icon(Icons.tune),
                          iconSize: 28,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          borderRadius: BorderRadius.circular(10),
                          value: context.read<DataBaseProvider>().currentFilter,
                          alignment: Alignment.centerLeft,
                          underline: SizedBox.shrink(),
                          items: [
                            DropdownMenuItem(
                              value: Filters.noFilter,
                              child: CustomText(text: "All Orders"),
                            ),
                            DropdownMenuItem(
                              value: Filters.today,
                              child: CustomText(text: "Today Orders"),
                            ),
                            DropdownMenuItem(
                              value: Filters.pending,
                              child: CustomText(text: "Pending Orders"),
                            ),
                            DropdownMenuItem(
                              value: Filters.delivered,
                              child: CustomText(text: "Delivered Orders"),
                            ),
                          ],
                          onChanged: (value) {
                            provider.setFilter(filter: value!);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Consumer<DataBaseProvider>(
                  builder: (ctx, provider, _) {
                    final filteredList = provider.appliedFilters();
                    if (filteredList.isEmpty) {
                      return Center(
                        child: CustomText(
                          textSize: 30,
                          text: '"No Orders ${provider.currentFilter.name}"',
                        ),
                      );
                    } else {
                      return ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        separatorBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Divider(
                            color: provider.getThemeMode()
                                ? Colors.white
                                : Colors.grey.shade600,
                          ),
                        ),
                        itemBuilder: (context, index) => Card(
                          elevation: 6,
                          color: provider.getThemeMode()
                              ? Colors.grey[850]
                              : Colors.white,
                          child: ListTile(
                            leading: CustomText(text: (index + 1).toString()),
                            isThreeLine: true,
                            title: CustomText(
                              textSize: 18,
                              text:
                                  '${provider.appliedFilters()[index][DBHelper.COLUMN_NAME_CUSTOMER]}',
                            ),
                            subtitle: CustomText(
                              textSize: 15,
                              text:
                                  'Date: ${provider.allData[index][DBHelper.COLUMN_NAME_DATE]} \n₹ ${provider.appliedFilters()[index][DBHelper.COLUMN_NAME_AMOUNT]}',
                            ),
                            trailing: CustomContainer(
                              height: 22,
                              width: 70,
                              backgroundColor:
                                  provider.appliedFilters()[index][DBHelper
                                          .COLUMN_NAME_STATUS] ==
                                      'Pending'
                                  ? Colors.orange
                                  : Colors.green,
                              borderRadius: 10,
                              child: Center(
                                child: CustomText(
                                  text: provider
                                      .appliedFilters()[index][DBHelper
                                          .COLUMN_NAME_STATUS]
                                      .toString(),
                                  textSize: 12,
                                  textColor: Colors.white,
                                  textBoldness: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        itemCount: provider.appliedFilters().length,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Consumer<DataBaseProvider>(
          builder: (ctx, provider, _) {
            return CustomButton(
              height: 50,
              width: MediaQuery.of(context).size.width / 2,
              buttonText: "Add New Order",
              callback: () {
                provider.setTotal();
                provider.setSelectedItem("Select Item");
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeftWithFade,
                    child: NewSalesOrderPage(),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
