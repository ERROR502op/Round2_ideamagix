
import 'package:ecommerce/bottomsheet/sortbottomsheet.dart';
import 'package:ecommerce/model/product_model.dart';
import 'package:ecommerce/screens/cart.dart';
import 'package:ecommerce/screens/productdetail.dart';
import 'package:ecommerce/screens/wishlist.dart';
import 'package:ecommerce/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../popup_menu/failedalert.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Product> getProducts = [];
  String baseUrl = "https://fakestoreapi.com/products";
  int selectedRowIndex = -1; // Add the selectedRowIndex variable here
  TextEditingController searchController = TextEditingController();
  bool isLoading = true; // Add a loading indicator variable
  int itemCount = 1;

  @override
  void initState() {
    super.initState();
    getProductsFromApi();
  }


  void performSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        // If the search bar is empty, reset the product list to the original list
        getProductsFromApi();
      } else {
        // Filter the products based on the search query
        getProducts = getProducts.where((product) {
          final title = product.title.toLowerCase();
          final searchQuery = query.toLowerCase();
          return title.contains(searchQuery);
        }).toList();
      }
    });
  }


  void onRowTapped(int index) {
    setState(() {
      selectedRowIndex = index;
    });

    getProductsFromApi(); // Call getProductsFromApi with the new selected sorting option
    Navigator.pop(
        context); // Close the bottom sheet after selecting a sorting option
  }

  Future<void> getProductsFromApi() async {
    try {
      String url = baseUrl;

      // Check if any sorting option is selected
      if (selectedRowIndex != -1) {
        switch (selectedRowIndex) {
          case 0:
            url = "$baseUrl?limit=5";
            break;
          case 1:
            url = "$baseUrl?sort=asc";
            break;
          case 2:
            url = "$baseUrl?sort=desc";
            break;
          case 3:
            url = "$baseUrl/category/electronics";
            break;
          case 4:
            url = "$baseUrl/category/jewelery";
            break;
          case 5:
            url = "$baseUrl/category/men's clothing";
            break;
          case 6:
            url = "$baseUrl/category/women's clothing";
            break;
          default:
            break;
        }
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            getProducts = productFromJson(response.body);
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const FailedAlertDialog();
            },
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const FailedAlertDialog();
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColorTheme.lightcolor,
      appBar: AppBar(
        backgroundColor: MyColorTheme.lightcolor,
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.ac_unit, color: Colors.black,)),
        elevation: 0,
        title: SizedBox(height: 30,child: Image.asset("assets/images/ideamagix-logo-g.png")),

        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => filtterproductscreen(
                  selectedRowIndex: selectedRowIndex,
                  // Pass the selectedRowIndex to SortBottomSheetWidget
                  onRowTapped:
                  onRowTapped, // Pass the onRowTapped method to SortBottomSheetWidget
                ),
              );
            },
            icon: Icon(
              Icons.filter_alt_sharp,
              color: Colors.black,
            ),
          ),
          // IconButton(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const WishListScreen()),
          //     );
          //   },
          //   icon: const Icon(Icons.favorite),
          //   color: Colors.white,
          // ),
          Stack(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Cart()),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart),
                  color: Colors.black),
              itemCount > 0
                  ? Positioned(
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    itemCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
                  : const SizedBox(),
            ],
          ),
          SizedBox(width: 10,)
        ],
      ),
      body: SafeArea(
        child: Column(

          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10),
                  // Add this line to set the border color to red
                ),
                child: Center(
                  child: TextField(
                    controller: searchController,
                    onChanged: performSearch,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: MyColorTheme.darkcolor,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: MyColorTheme.darkcolor,
                        ),
                        onPressed: () {
                          searchController.clear();
                          getProductsFromApi();
                          FocusScope.of(context).unfocus();
                        },
                      ),
                      hintText: 'Search...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            if (isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: getProducts.length,
                  itemBuilder: (BuildContext context, int index) {
                    final product = getProducts[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(

                        padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10),
                        decoration: BoxDecoration(
                            color: MyColorTheme.whiteColor,
                          border: Border.all(color: Colors.grey,width: 0.2),
                          borderRadius: BorderRadius.all(Radius.circular(15))
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetails(product: product),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Card(
                                color: MyColorTheme.lightcolor,
                                child: Image.network(
                                  product.image,
                                  fit: BoxFit.contain,
                                  height: 135,
                                  width: 135,
                                ),
                              ),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 235,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text(
                                        product.title,
                                        style: TextStyle(
                                          fontSize: 16,fontWeight: FontWeight.bold,color: Colors.grey.shade600
                                        ),
                                        maxLines: 2,
                                      ),
                                    ),
                                    Container(
                                      width: 235,
                                      padding: EdgeInsets.only(
                                          left: 10, top: 5),
                                      child: Text(
                                        "₹${product.price}",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                      ),
                                    ),
                                    Container(
                                      width: 235,
                                      padding: const EdgeInsets.only(left: 10),
                                      child: const Text(
                                          'Get Free dileverry on 1000 Rs Shopping'),
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Card(
                                          color: Colors.green.shade50,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              "Available in stock",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        Card(
                                          color: Colors.red.shade50,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              "20% off",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            // Expanded(
            //   child: GridView.builder(
            //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //       crossAxisCount: 2, // You can change the crossAxisCount as per your desired grid layout
            //       crossAxisSpacing: 8.0,
            //       mainAxisSpacing: 8.0,
            //     ),
            //     itemCount: getProducts.length,
            //     itemBuilder: (BuildContext context, int index) {
            //       final product = getProducts[index];
            //       return GestureDetector(
            //         onTap: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => ProductDetails(product: product),
            //             ),
            //           );
            //         },
            //         child: Container(
            //           padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
            //           decoration: BoxDecoration(
            //             border: Border.all(color: Colors.grey),
            //             borderRadius: BorderRadius.all(Radius.circular(15)),
            //           ),
            //           child: Column(
            //             children: [
            //               Card(
            //                 color: Colors.orange.shade50,
            //                 child: Image.network(
            //                   product.image,
            //                   fit: BoxFit.contain,
            //                   height: 80,
            //                   width: 80,
            //                 ),
            //               ),
            //               Container(
            //                 width: 135,
            //                 padding: const EdgeInsets.symmetric(horizontal: 10),
            //                 child: Text(
            //                   product.title,
            //                   style: const TextStyle(
            //                     fontSize: 16,
            //                   ),
            //                   maxLines: 2,
            //                 ),
            //               ),
            //               Container(
            //                 width: 100,
            //                 padding: const EdgeInsets.only(left: 10, top: 5),
            //                 child: Text(
            //                   "₹${product.price}",
            //                   style: const TextStyle(
            //                     fontSize: 15,
            //                     fontWeight: FontWeight.bold,
            //                   ),
            //                   maxLines: 2,
            //                 ),
            //               ),
            //               Container(
            //                 width: 100,
            //                 padding: const EdgeInsets.only(left: 10),
            //                 child: const Text('Eligible for FREE Shipping'),
            //               ),
            //               Container(
            //                 width: 135,
            //                 padding: const EdgeInsets.only(left: 10, top: 5),
            //                 child: const Text(
            //                   'In Stock',
            //                   style: TextStyle(
            //                     color: Colors.teal,
            //                   ),
            //                   maxLines: 2,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),

          ],
        ),
      ),
    );
  }
}
