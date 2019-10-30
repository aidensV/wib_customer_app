import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_pagewise/flutter_pagewise.dart';


class TestCode extends StatefulWidget {
  @override
  _TestCodeState createState() => _TestCodeState();
}

class _TestCodeState extends State<TestCode> {
  int PAGE_SIZE = 6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Area"),
      ),
      body: PagewiseGridView.count(
        pageSize: PAGE_SIZE,
        primary: false,
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 5.0,
        childAspectRatio: 0.7,
        itemBuilder: this._itemBuilder,
        pageFuture: (pageIndex) =>
            BackendService.getData(pageIndex, PAGE_SIZE),
      ),
    );
  }

  Widget _itemBuilder(context, ProductModel entry, _) {
    return SingleChildScrollView(
      child: Card(
        elevation: 0.0,
        child: InkWell(
          child: Container(
//                            color: Colors.red,
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
//                                  clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        "images/botol.png",
                        fit: BoxFit.cover,
                        height: 150.0,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  ],
                ),
                // SizedBox(width: 15),
                Padding(
                  padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
                  child: Container(
                    width:
                    MediaQuery.of(context).size.width - 130,
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            entry.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            entry.id,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.deepOrange
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, "/details");
          },
        ),
      ),
    );
  }

}

class BackendService {
  static Future<List<PostModel>> getPosts(offset, limit) async {
    final responseBody = (await http.get(
        'http://jsonplaceholder.typicode.com/posts?_start=$offset&_limit=$limit'))
        .body;

    // The response body is an array of items
    return PostModel.fromJsonList(json.decode(responseBody));
  }

  static Future<List<ProductModel>> getData(offset, limit) async {
    final responseBody = await http.post(
        Uri.encodeFull("http://192.168.100.27/warungislamibogor_shop/api/listProdukKategoriAndroid?_limit=$limit"),
        headers: {
          "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjM4MWVmMzU2ODIzYTg0NGE0M2U3N2FkNzAwODQwOGEyNGM2MTg1YTBlMTFmMjk5YTljNGE4Njk3YTRlMDgzY2JiN2VmMzM2NWVlNTc4MjM0In0.eyJhdWQiOiIyIiwianRpIjoiMzgxZWYzNTY4MjNhODQ0YTQzZTc3YWQ3MDA4NDA4YTI0YzYxODVhMGUxMWYyOTlhOWM0YTg2OTdhNGUwODNjYmI3ZWYzMzY1ZWU1NzgyMzQiLCJpYXQiOjE1NzI0MDI0MDksIm5iZiI6MTU3MjQwMjQwOSwiZXhwIjoxNjA0MDI0ODA5LCJzdWIiOiIzIiwic2NvcGVzIjpbXX0.ssAeZmljQ8UJxhROxefjsP-l-WpxsCKvQOUuVnRlzhUgBpngUzuh8CFkwceaNh6I3H72jL5Jko2UkJ_g262gf0E12wS3Pcwgzsq54MTerY1L6DKmeaLCydBjSUfr5l3n8fNQrLMrtDLNwzhFqb_Xq1ATYoBXCVw25ZQrPDIERmCtX_rhSWvXOHMJe6VxhZAgdeX-liEf5Oi53h57PeHnCS77UU2_vCS2-zCHzQ27k0X9V0WMtiDIGWUFxImKWBFFZJILeymsUFRb1mCCPGXWdUVL2K8EImiUVghNIFwENRSuPu8yB7MF39JpOCoNmEh2nMkulHF-KK6jotUfSNe1p2kaoMpg69bQrKror9I8aAdbeCn1t2YDEbOzLgVCxS9ggK2PsTxDzhvVYqhT6E_6zuXPKVfCYyH-ithskO1EDADNrCxIuFptAGKGsfoJhy-gIfGy6GbhG_iOLSToX33ImMZEZrodZdkaJ-4vWXTUh5ilc6J9yLBqW-tOK_l_gN2oQf0KxBCcc4HfrkEToNdZxyOVKS7iBVgrldf6QAqh-6FbhvFq-mxeTzLlTDariRle2HhgsfsnKeRN-Lov1Z_Unpu2ScnkOCsRE9mFFJDiInRQHeHM0eKQ5MjMjjyp_TFgNMMFjBblEnx9OL9vl1JHmdyqBISavo4jXY35yzZG3dM"
        },
        body: {
          "kategori" : "1"
        }
    );

    var data = json.decode(responseBody.body);
    var product = data['item'];

    return ProductModel.fromJsonList(product);
  }
}

class PostModel {
  String title;
  String body;

  PostModel.fromJson(obj) {
    this.title = obj['title'];
    this.body = obj['body'];
  }

  static List<PostModel> fromJsonList(jsonList) {
    return jsonList.map<PostModel>((obj) => PostModel.fromJson(obj)).toList();
  }
}

class ProductModel {
  String title;
  String id;
  String thumbnailUrl;

  ProductModel.fromJson(obj) {
    this.title = obj['i_name'];
    this.id = obj['ipr_sunitprice'];
    this.thumbnailUrl = obj['thumbnailUrl'];
  }

  static List<ProductModel> fromJsonList(jsonList) {
    return jsonList.map<ProductModel>((obj) => ProductModel.fromJson(obj)).toList();
  }
}
