import 'package:ecommerce/database/address_database.dart';
import 'package:ecommerce/screens/addnewaddress.dart';
import 'package:ecommerce/screens/update_address.dart';
import 'package:ecommerce/theme/color_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../popup_menu/failedalert.dart';

class SavedAddress extends StatefulWidget {
  const SavedAddress({Key? key}) : super(key: key);

  @override
  State<SavedAddress> createState() => _SavedAddressState();
}

class _SavedAddressState extends State<SavedAddress> {
  List<Map<String, dynamic>> addresses = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAddresses();
  }

  void fetchAddresses() async {
    final List<Map<String, dynamic>> fetchedAddresses =
        await AddressDatabase.getAddresses();
    setState(() {
      addresses = fetchedAddresses;
      isLoading = false;
    });
  }

  void editAddress(int index) {
    final address = addresses[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateAddress(address: address),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: MyColorTheme.darkcolor,
          ),
        ),
        title: Text(
          "Saved Address of user ",
          style: TextStyle(color: MyColorTheme.darkcolor),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 5),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddNewAddress(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.add_circle,
                      color: MyColorTheme.darkcolor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Add a new address",
                      style: TextStyle(
                        color: MyColorTheme.darkcolor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : addresses.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/saved Address.png"),
                            const SizedBox(height: 20),
                            Container(
                              height: 70,
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MyColorTheme.darkcolor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AddNewAddress(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Add a new address",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: addresses.length,
                          itemBuilder: (context, index) {
                            final address = addresses[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
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
                                                address[AddressDatabase
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
                                                    address[AddressDatabase
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
                                          PopupMenuButton(
                                            itemBuilder: (context) => [
                                              PopupMenuItem(
                                                child: ListTile(
                                                  leading: Icon(
                                                    Icons.edit,
                                                    color: MyColorTheme
                                                        .darkcolor,
                                                  ),
                                                  title: const Text("Edit"),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    editAddress(index);
                                                  },
                                                ),
                                              ),
                                              PopupMenuItem(
                                                child: ListTile(
                                                  leading: Icon(
                                                    CupertinoIcons.delete,
                                                    color: MyColorTheme
                                                        .darkcolor,
                                                  ),
                                                  title: const Text("Delete"),
                                                  onTap: () async {
                                                    Navigator.pop(
                                                        context); // Close the menu

                                                    // Assuming 'index' is the ID of the address to be deleted
                                                    try {
                                                      await AddressDatabase
                                                          .deleteAddress(index);
                                                    } catch (e) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return const FailedAlertDialog();
                                                        },
                                                      );
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                            icon: Icon(
                                              Icons.more_vert,
                                              color: MyColorTheme.darkcolor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        address[
                                            AddressDatabase.columnFlatBuilding],
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        address[AddressDatabase.columnLandmark],
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        "${address[AddressDatabase.columnCity]}, ${address[AddressDatabase.columnState]},${address[AddressDatabase.columnPincode]}",
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
                                                address[AddressDatabase
                                                    .columnFullName],
                                                style: const TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Visibility(
                                            visible: address[AddressDatabase
                                                    .columnAlternateMobile]
                                                .isNotEmpty,
                                            child: Row(
                                              children: [
                                                Icon(Icons.phone),
                                                Text(
                                                  " ${address[AddressDatabase.columnAlternateMobile]}",
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
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
