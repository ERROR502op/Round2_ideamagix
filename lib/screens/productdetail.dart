import 'package:ecommerce/database/cart_database.dart';
import 'package:ecommerce/model/product_model.dart';
import 'package:ecommerce/screens/cart.dart';
import 'package:ecommerce/screens/homescreen.dart';
import 'package:ecommerce/screens/wishlist.dart';

import 'package:ecommerce/theme/color_theme.dart';
import 'package:ecommerce/theme/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:share_plus/share_plus.dart';

import '../database/wishlist_database.dart';

class ProductDetails extends StatefulWidget {
  final Product product;

  const ProductDetails({Key? key, required this.product}) : super(key: key);

  @override
  ProductDetailsState createState() => ProductDetailsState();
}

class ProductDetailsState extends State<ProductDetails> {
  int itemCount = 1;

  bool isFavorite = false; // Track the favorite status

  void incrementItem() {
    setState(() {
      itemCount++;
    });
  }

  void decrementItem() {
    setState(() {
      if (itemCount > 0) {
        itemCount--;
      }
    });
  }

  void addToCart() {
    CartDatabase.addToCart(
      title: widget.product.title,
      image: widget.product.image,
      price: widget.product.price.toString(),
      quantity: itemCount,
    );
    // Optionally, you can show a snackbar or display a message to indicate that the item was added to the cart.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text('Added to cart'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      if (isFavorite) {
        WishlistDatabase.addToWishlist(
          title: widget.product.title,
          image: widget.product.image,
          price: widget.product.price.toString(),
        );
        // Optionally, you can show a snackbar or display a message to indicate that the item was added to the wishlist.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Added to wishlist'),
          ),
        );
      } else {
        WishlistDatabase.removeFromWishlist(widget.product.title);
        // Optionally, you can show a snackbar or display a message to indicate that the item was removed from the wishlist.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Removed from wishlist'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColorTheme.darkcolor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined,  color: Colors.white),
        ),
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Homepage()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Icon(Icons.search),
                    SizedBox(width: 8.0),
                    Text(
                      'Search...',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WishListScreen()),
                );
              },
              icon: const Icon(Icons.favorite),
              color: Colors.white),
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
                  color: Colors.white),
              itemCount > 0
                  ? Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
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
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 260,
                      child: Image.network(widget.product.image),
                    ),
                    Positioned(
                      bottom: 8.0,
                      right: 8.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Card(
                            color: MyColorTheme.lightcolor,
                            child: IconButton(
                              onPressed: toggleFavorite,
                              // Call toggleFavorite when the favorite icon is clicked
                              icon: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: MyColorTheme.darkcolor,
                              ),
                            ),
                          ),
                          Card(
                            color: MyColorTheme.lightcolor,
                            child: IconButton(
                              icon: Icon(
                                Icons.share,
                                color: MyColorTheme.darkcolor,
                              ),
                              onPressed: () {
                                Share.share(
                                    'check out my website https://example.com',
                                    subject: 'Look what I made!');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(thickness:1),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: Text(
                    widget.product.title,
                    style: editTextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      child: Text(
                        "₹${widget.product.price}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                      child: Row(
                        children: <Widget>[
                          RatingStars(
                            value: widget.product.rating.rate,
                            starSize: 20,
                            valueLabelColor: Colors.amber,
                            starColor: Colors.amber,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10, top: 4),
                  child: Text(
                    "(Incl. of all taxes)",
                    style: TextStyle(fontSize: 10),
                  ),
                ),

                const Divider(),
                Card(
                    color: Colors.green.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Available in stock",
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                    alignment: const Alignment(-1.0, -1.0),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        widget.product.description,
                        style: const TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 70.0,
        width: 200.0, // Set the width as needed
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topRight: Radius.circular(25),topLeft:Radius.circular(25)),
          color: MyColorTheme.darkcolor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.remove,
                    color: Colors.white,
                  ),
                  onPressed: decrementItem,
                ),
                SizedBox(width: 20,),
                Text(
                  itemCount.toString(),
                  style: const TextStyle(fontSize: 18.0, color: Colors.white),
                ),
                SizedBox(width: 20,),
                IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: incrementItem,
                ),
              ],
            ),
            ElevatedButton(
              onPressed: addToCart,
              style: ElevatedButton.styleFrom(
                primary: Colors.white, // Background color
                onPrimary: Colors.black, // Text color
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.black), // Border color
                ),
              ),
              child: Text('Add to Cart'),
            ),

          ],
        ),
      ),
    );
  }
}
