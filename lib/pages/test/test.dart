import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_pagewise/flutter_pagewise.dart';


class TestCode extends StatefulWidget {
  @override
  _TestCodeState createState() => _TestCodeState();
}

class _TestCodeState extends State<TestCode> {
  int PAGE_SIZE = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Area"),
      ),
      body: PagewiseListView(
        pageSize: PAGE_SIZE,
        padding: EdgeInsets.all(15.0),
        scrollDirection: Axis.horizontal,
        primary: false,
        itemBuilder: this._itemBuilder,
        pageFuture: (pageIndex) =>
            BackendService.getData(pageIndex * PAGE_SIZE, PAGE_SIZE),
      ),
    );
  }

  Widget _itemBuilder(context, ProductModel entry, _) {
    return Card(
      elevation: 0.0,
      child: InkWell(
//                      color: Colors.green,
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  "images/botol.png",
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 7),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  entry.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 3),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  entry.id,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.grey[400],
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
          onTap: () {
            Navigator.pushNamed(context, "/details");
          }
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
    final responseBody = await http.get(
        Uri.encodeFull("http://192.168.100.27/warungislamibogor_shop/api/produk_beranda_android?_limit=0&_recLimit=$limit"),
        headers: {
          "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjY1MTFjYmNlM2I4Nzg1ZGNkNmU3NDY4OTAxYThhYWUwMTNjM2UxZmY0YjhkNDAyMDFkM2JiODZmYWFhMjQ4ZTA5NDdkOWE3YTVmYjZhNmI1In0.eyJhdWQiOiIyIiwianRpIjoiNjUxMWNiY2UzYjg3ODVkY2Q2ZTc0Njg5MDFhOGFhZTAxM2MzZTFmZjRiOGQ0MDIwMWQzYmI4NmZhYWEyNDhlMDk0N2Q5YTdhNWZiNmE2YjUiLCJpYXQiOjE1NzE3OTc2NTksIm5iZiI6MTU3MTc5NzY1OSwiZXhwIjoxNjAzNDIwMDU4LCJzdWIiOiIzIiwic2NvcGVzIjpbXX0.TfBOgh4nwlEw3UGADLn02mlB-BmX-k8_s1iGiCR809iD1iMFYOf7RTHQc5SrghM7XCK51tS-6lGZ2IaMQ41RGBvqSpylwibuZTiktcq1yPxT_TieGKRkdnx-CnOpgCFRct7mM3ylcWxzK8jlm1EyAtaay4zYeSolRQlWoS9Vz050114ncAvQWmS0GJ9JF0Zjti6yd3tl9I69bnkB1B7I9YB24CSkJDxOR6C4pjiVW4Ew6RL0JYTMFgEUf0liz_twR2uULUUPPDaMB0uhAtPsG7-cAaeZv8BKmMGjVenyIDJyLVqT1-4lUTxDgJIUXSM_IfzgoMfgILznDhD6dKv1l9gm0kHJkgcdu9sKTEpxoR7lEs7UopeKzKFnHbNDkrECwlBudeyKdkMZ-TCLjDZOK5CfTXNmInPZY_fO9eFKvj52jGd9rH2TSdNLoiiGSPrZL3dCZhePPAyAJPCX2CGO3vY6bRv91O2hDAsmqHakQjS7oRiwd9CE-MpR_K11noP0vqlgq26alKNfOtH74MVayF0Os_2PVtmrfaBcbaKw7bQlBhaT08SWQBS3W5Yxt4lYquc04l9upMjgkZ4cwl-mle86DA-6PZNT7AOnql4sTVSxcd9i-8SfPBbIMS0jS33Gb03Cpb72y90fVMiMAWx2v1lk0f-ndjWogdujw_dGEjs"
        }
    );

    var data = json.decode(responseBody.body);
    var product = data['itemslider'];

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
