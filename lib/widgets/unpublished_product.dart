import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firebase_services.dart';

class UnPublishedProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    return Container(
      child: StreamBuilder(
        stream:
            _services.products.where('published', isEqualTo: false).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Somthing want Wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: DataTable(
              showBottomBorder: true,
              dataRowHeight: 70,
              headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
              columns: [
                DataColumn(label: Expanded(child: Text('Product Name'))),
                DataColumn(label: Text('Image')),
                DataColumn(label: Text('Action')),
              ],
              rows: _productDetails(snapshot.data),
            ),
          );
        },
      ),
    );
  }

  List<DataRow> _productDetails(QuerySnapshot snapshot) {
    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document) {
      if (document != null) {
        return DataRow(cells: [
          DataCell(
            Container(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Name : ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        document.data()['productName'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'SKU : ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        document.data()['sku'],
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          DataCell(
            Container(
              height: 50,
              width: 60,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Image.network(
                  document.data()['productImage'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          DataCell(
            popUpButton(document.data()),
          ),
        ]);
      }
    }).toList();
    return newList;
  }

  Widget popUpButton(data, {BuildContext context}) {
    FirebaseServices _services = FirebaseServices();
    return PopupMenuButton<String>(
        onSelected: (String value) {
          if (value == 'publish') {
            print(value);
            _services.publishProduct(id: data['productId']);
          }
          if (value == 'delete') {
            print(value);
            _services.deleteProduct(id: data['productId']);
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem(
                value: 'publish',
                child: ListTile(
                  leading: Icon(Icons.check),
                  title: Text('Publish'),
                ),
              ),
              const PopupMenuItem(
                value: 'preview',
                child: ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Preview'),
                ),
              ),
              const PopupMenuItem(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit_outlined),
                  title: Text('Edit Product'),
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete_outline),
                  title: Text('Delete'),
                ),
              ),
            ]);
  }
}
