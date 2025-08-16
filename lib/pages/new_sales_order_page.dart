import 'package:erp_mini_app/custom_widgets/custom_container.dart';
import 'package:erp_mini_app/custom_widgets/custom_text.dart';
import 'package:erp_mini_app/main.dart';
import 'package:erp_mini_app/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../custom_widgets/custom_fab.dart';
import '../custom_widgets/custom_form_text_field.dart';

class NewSalesOrderPage extends StatefulWidget {
  const NewSalesOrderPage({super.key});

  @override
  State<StatefulWidget> createState() => NewSalesOrderPageState();
}

class NewSalesOrderPageState extends State<NewSalesOrderPage> {
  GlobalKey<FormState> formState = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: CustomText(
            text: "Add New Order",
            textBoldness: FontWeight.bold,
            textSize: 30,
          ),
          centerTitle: true,
        ),
        body: Consumer<DataBaseProvider>(
          builder: (ctx, provider, _) {
            final message = ScaffoldMessenger.of(context);
            return CustomContainer(
              backgroundColor: provider.getThemeMode()
                  ? Colors.transparent
                  : Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 25.0),
                      child: Center(
                        child: CustomText(
                          text: "Enter Order details",
                          textSize: 25,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Form(
                      key: formState,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            CustomFormTextField(
                              inputType: TextInputType.name,
                              hintText: 'Enter Customer Name',
                              icon: Icon(Icons.person_outline),
                              validate: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter Customer Name";
                                } else if (value.length < 3) {
                                  return "Customer Name iss short";
                                }
                                return null;
                              },
                              savedValue: (String? value) {
                                String name = value.toString().trim();
                                provider.setName(name);
                                return null;
                              },
                            ),
                            DropdownButton(
                              isExpanded: true,
                              value: provider.getSelectedItem(),
                              borderRadius: BorderRadius.circular(10),
                              iconSize: 30,
                              underline: Divider(height: 5, color: Colors.grey),
                              items: provider.getGroceryList().map((item) {
                                return DropdownMenuItem(
                                  value: item,
                                  child: CustomText(text: item),
                                );
                              }).toList(),
                              onChanged: (value) {
                                provider.setSelectedItem(value!);
                              },
                            ),
                            CustomFormTextField(
                              inputType: TextInputType.number,
                              hintText: 'Enter Quantity',
                              icon: Icon(Icons.numbers_outlined),
                              changedValue: (value) {
                                String changedValue = value.toString().trim();
                                if (changedValue.isEmpty) {
                                  provider.setQuantity(0);
                                  return null;
                                }
                                int quantity = int.parse(value.toString());
                                provider.setQuantity(quantity);
                                return null;
                              },
                              validate: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter Quantity";
                                }
                                if (RegExp('[A-Za-z]').hasMatch(value)) {
                                  return "Only numbers are allowed";
                                }
                                int quantity = int.parse(value.toString());
                                if (quantity < 1) {
                                  return "Quantity should be more than 0";
                                }
                                return null;
                              },
                              savedValue: (String? value) {
                                int quantity = int.parse(value.toString());
                                provider.setQuantity(quantity);
                                return null;
                              },
                            ),
                            CustomFormTextField(
                              inputType: TextInputType.number,
                              hintText: 'Enter Rate',
                              icon: Icon(Icons.currency_rupee_rounded),
                              validate: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter Rate";
                                }
                                if (RegExp('[A-Za-z]').hasMatch(value)) {
                                  return "Only numbers are allowed";
                                }
                                int rate = int.parse(value.toString());
                                if (rate < 1) {
                                  return "Rate should be more than 0";
                                }

                                return null;
                              },
                              changedValue: (value) {
                                String changedValue = value.toString().trim();
                                if (changedValue.isEmpty) {
                                  provider.setRate(0);
                                  return null;
                                }
                                int rate = int.parse(value.toString());
                                provider.setRate(rate);
                                return null;
                              },
                              savedValue: (String? value) {
                                int rate = int.parse(value.toString());
                                provider.setRate(rate);
                                return null;
                              },
                            ),
                            provider.getTotal() > 0
                                ? CustomText(
                                    textSize: 25,
                                    text: 'Total: ₹ ${provider.getTotal()}',
                                  )
                                : CustomText(textSize: 25, text: "Total: ₹ 0"),
                            CustomButton(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              buttonText: "Add Order",
                              callback: () {
                                bool isValidate = formState.currentState!
                                    .validate();
                                if (isValidate) {
                                  message
                                      .showSnackBar(
                                        SnackBar(
                                          duration: Duration(milliseconds: 600),
                                          content: Row(
                                            children: [
                                              Icon(
                                                Icons.info,
                                                color: Colors.green.shade600,
                                              ),
                                              CustomText(
                                                text:
                                                    " Order Added Successfully!!!",
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                      .closed
                                      .then((_) {
                                        formState.currentState!.save();
                                        provider.addOrder(
                                          customerName: provider.getName(),
                                          rate: provider.getRate(),
                                        );
                                        Navigator.pop(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType
                                                .leftToRightWithFade,
                                            child: MyHomePage(),
                                            duration: Duration(
                                              milliseconds: 600,
                                            ),
                                          ),
                                        );
                                        provider.setTotal();
                                        provider
                                            .initializeData(); // go back to home page
                                      });
                                } else {
                                  message.showSnackBar(
                                    SnackBar(
                                      duration: Duration(milliseconds: 600),
                                      content: Row(
                                        children: [
                                          Icon(
                                            Icons.warning,
                                            color: Colors.red,
                                          ),
                                          CustomText(
                                            text: " Failed to add Order!!!",
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            CustomButton(
                              backgroundColor: Colors.red,
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              buttonText: "Cancel",
                              callback: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
