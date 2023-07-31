import 'package:ecommerce/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class filtterproductscreen extends StatefulWidget {
  final int selectedRowIndex;
  final Function(int) onRowTapped;

  const filtterproductscreen({
    Key? key,
    required this.selectedRowIndex,
    required this.onRowTapped,
  }) : super(key: key);

  @override
  filtterproductscreenState createState() => filtterproductscreenState();
}

class filtterproductscreenState extends State<filtterproductscreen> {
  int selectedRowIndex = -1;

  void onRowTapped(int index) {
    setState(() {
      selectedRowIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 10, top: 20),
        child: Column(

          children: [
            Text("You can filter product "),
            buildRow(FontAwesomeIcons.circle, "Top 5", 0),
            buildRow(FontAwesomeIcons.circle, "Top Asc", 1),
            buildRow(FontAwesomeIcons.circle, "Top Desc", 2),
            buildRow(FontAwesomeIcons.circle, "Electronics", 3),
            buildRow(FontAwesomeIcons.circle, "Jewelery", 4),
            buildRow(FontAwesomeIcons.circle, "Men's Clothing", 5),
            buildRow(FontAwesomeIcons.circle, "Women's Clothing", 6),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColorTheme.darkcolor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                minimumSize: const Size(100, 50),
              ),
              onPressed: () {
                widget.onRowTapped(
                    -1); // Reset selected sorting option to default (-1)
              },
              child: Text(
                "Back to Home",
                style: TextStyle(
                  color: MyColorTheme.whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRow(IconData iconData, String text, int index) {
    final isSelected =
        index == widget.selectedRowIndex; // Access selectedRowIndex from widget
    return GestureDetector(
      onTap: () => widget.onRowTapped(index),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            FaIcon(iconData, color: isSelected ? MyColorTheme.darkcolor : null),
            const SizedBox(
              width: 12,
            ),
            Text(
              text,
              style: TextStyle(color: isSelected ? MyColorTheme.darkcolor : null,fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => build(context),
    );
  }
}
