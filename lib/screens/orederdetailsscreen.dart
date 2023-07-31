
import 'package:ecommerce/database/address_database.dart';
import 'package:ecommerce/database/cart_database.dart';
import 'package:ecommerce/screens/homescreen.dart';
import 'package:ecommerce/screens/selectaddress.dart';
import 'package:ecommerce/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../popup_menu/comingsoonalert.dart';
import '../popup_menu/paymentfailedalert.dart';

class OrderReviewscreen extends StatefulWidget {
  final Map<String, dynamic> address;

  const OrderReviewscreen({super.key, required this.address});

  @override
  State<OrderReviewscreen> createState() => _OrderReviewscreenState();
}

class _OrderReviewscreenState extends State<OrderReviewscreen> {
  String _paymentMethod = 'COD';
  TextEditingController couponController = TextEditingController();

  final Future<List<Map<String, dynamic>>> _cartItemsFuture =
      CartDatabase.getCartItems();
  double subtotal = 0;
  double discAmount = 0;
  double total = 0;

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    calculateSubtotal();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void payment() async {
    double amount = total * 100;
    var options = {
      'key': "rzp_test_cy6Y8H27J6FqrZ",
      'amount': amount,
      'currency': 'INR',
      'name': 'eCommerce.',
      'description': 'Payment Method',
      'timeout': 120,
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  void calculateSubtotal() async {
    List<Map<String, dynamic>> cartItems = await _cartItemsFuture;

    double tempSubtotal = 0;
    for (var item in cartItems) {
      int quantity = item['quantity'] ?? 1;
      double price = item['price'] is String
          ? double.tryParse(item['price'].replaceAll(',', '')) ?? 0
          : (item['price'] ?? 0).toDouble();
      tempSubtotal += price * quantity;
    }

    setState(() {
      subtotal = tempSubtotal;
      total = subtotal;
    });
  }

  void _handlePaymentMethodChange(String? value) {
    if (value != null) {
      setState(() {
        _paymentMethod = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColorTheme.whiteColor,
      appBar: AppBar(
        backgroundColor: MyColorTheme.darkcolor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: MyColorTheme.whiteColor,
          ),
        ),
        title: const Text(
          "Order Reiew",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: MyColorTheme.whiteColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Delivery Address",
                          style: TextStyle(fontWeight: FontWeight.w900,fontSize: 15),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: MyColorTheme.lightcolor,
                          border: Border.all(
                              color: MyColorTheme.darkcolor),
                          borderRadius: const BorderRadius.all(
                              Radius.circular(15)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, top: 10, right: 15, bottom: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        widget.address[AddressDatabase
                                            .columnFullName],
                                        style: const TextStyle(
                                            fontWeight:
                                            FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Container(
                                        height: 30,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          color:
                                          MyColorTheme.darkcolor,
                                          borderRadius:
                                          const BorderRadius.all(
                                              Radius.circular(4)),
                                        ),
                                        child: Center(
                                          child: Text(
                                            widget.address[AddressDatabase
                                                .columnAddressType],
                                            style: const TextStyle(
                                              fontWeight:
                                              FontWeight.bold,
                                              fontSize: 10,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              const BorderRadius.all(
                                                Radius.circular(25),
                                              ),
                                              border: Border.all(
                                                  color: Colors.grey,
                                                  width: 0.5)),
                                          child: IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                        const SelectAddress()));
                                              },
                                              icon: const Icon(Icons.edit)),
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                              Text(
                                widget.address[
                                AddressDatabase.columnFlatBuilding],
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                widget.address[AddressDatabase.columnLandmark],
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                "${widget.address[AddressDatabase.columnCity]}, ${widget.address[AddressDatabase.columnState]},${widget.address[AddressDatabase.columnPincode]}",
                                style: const TextStyle(fontSize: 12),
                              ),
                              Divider(thickness: 0.5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.person),
                                      Text(
                                        widget.address[AddressDatabase
                                            .columnFullName],
                                        style: const TextStyle(
                                            fontWeight:
                                            FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Visibility(
                                    visible: widget.address[AddressDatabase
                                        .columnAlternateMobile]
                                        .isNotEmpty,
                                    child: Row(
                                      children: [
                                        Icon(Icons.phone),
                                        Text(
                                          " ${widget.address[AddressDatabase.columnAlternateMobile]}",
                                          style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _cartItemsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                    List<Map<String, dynamic>> cartItems = snapshot.data ?? [];

                    if (cartItems.isEmpty) {
                      return Center(
                        child: Image.asset("assets/images/empty.png"),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        final imageUrl = item['image'];

                        Widget imageWidget;

                        if (imageUrl != null && Uri.parse(imageUrl).isAbsolute) {
                          imageWidget = Image.network(
                            imageUrl,
                            fit: BoxFit.contain,
                            height: 60,
                            width: 60,
                          );
                        } else {
                          imageWidget = Image.asset(
                            'assets/images/noimage.png',
                            fit: BoxFit.contain,
                            height: 135,
                            width: 135,
                          );
                        }

                        return Padding(
                          padding:EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  imageWidget,
                                  Column(
                                    children: [
                                      Container(
                                        width: 235,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          item['title'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                          maxLines: 2,
                                        ),
                                      ),
                                      Container(
                                        width: 235,
                                        padding:
                                            const EdgeInsets.only(left: 10, top: 5),
                                        child: Text(
                                          '₹${item['price']}',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                        ),
                                      ),
                                      Container(
                                        width: 235,
                                        padding:
                                            const EdgeInsets.only(left: 10, top: 5),
                                        child: Text(
                                          'Quantity: ${item['quantity']}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                          maxLines: 2,
                                        ),
                                      ),


                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                Divider(thickness: 0.5,color: Colors.grey,),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Payment Method:',
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Radio(
                            value: "COD",
                            groupValue: _paymentMethod,
                            activeColor: MyColorTheme.darkcolor,
                            onChanged: _handlePaymentMethodChange,
                          ),
                          const Text('Cash on Delivery'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: "ONLINE",
                            groupValue: _paymentMethod,
                            activeColor: MyColorTheme.darkcolor,
                            onChanged: _handlePaymentMethodChange,
                          ),
                          const Expanded(
                            child: Text(
                                'Pay Online (Credit/Debit Card, NetBanking, UPI) '),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(thickness: 0.5,color: Colors.grey,),
                Container(
                  color: MyColorTheme.whiteColor,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Payment Details",
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("MRP Total"),
                            Text(subtotal.toStringAsFixed(2)),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Product Discount"),
                            Text(
                              discAmount.toString(),
                              style: const TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                        const Divider(),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Delivery Fee"),
                            Text(
                              "FREE",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Total"),
                            Text(
                              total.toString(),
                              style: const TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  _showBottomSheet();
                },
                child: Row(
                  children: [
                    Text(
                      total.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w900, color: Colors.black),
                    ),
                    const Icon(Icons.arrow_drop_down_outlined),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_paymentMethod == "ONLINE") {
                    payment();
                  } else {
                    await CartDatabase.deleteAllCartItems();

                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const ComingSoonDialog();
                        },
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColorTheme.darkcolor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: const Text(
                  "Payment",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Set this property to true
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Payment Details",
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close,
                          color: MyColorTheme.darkcolor,
                        )),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("MRP Total"),
                    Text(subtotal.toString()),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Product Discount"),
                    Text(
                      discAmount.toString(),
                      style: const TextStyle(color: Colors.green),
                    ),
                  ],
                ),
                const Divider(),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Delivery Fee"),
                    Text(
                      "FREE",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total"),
                    Text(
                      total.toString(),
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Row(
                        children: [
                          Text(
                            total.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Colors.black),
                          ),
                          const Icon(Icons.arrow_drop_down_outlined),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_paymentMethod == "ONLINE") {
                          payment();
                        } else {
                          await CartDatabase.deleteAllCartItems();

                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const ComingSoonDialog();
                              },
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColorTheme.darkcolor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Payment",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      // Handle any callbacks or operations after the bottom sheet is closed
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Homepage()),
      (route) => false,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showPaymentFailedDialog(context);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }
}
