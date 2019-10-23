import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


var ids, categorys, categoryids;
String accessToken, tokenType;
Map<String, String> requestHeaders = Map();
bool isLoading;
class CategoryItem extends StatefulWidget {
  final String id, category, category_id;
  CategoryItem({
    Key key,
    @required this.id,
    @required this.category,
    @required this.category_id,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CategoryItemState(
      id: id,
      category: category,
      category_id: category_id,
    );
  }
}

class _CategoryItemState extends State<CategoryItem> {
  Color _isPressed = Colors.grey;

  final String id, category, category_id;
  _CategoryItemState({
    Key key,
    @required this.id,
    @required this.category,
    @required this.category_id,
  });

  List category_item = [];

  Future<String> getCategoryItem() async {
    var response = await http.post(
        Uri.encodeFull("http://192.168.100.27/warungislamibogor_shop/api/listProdukKategoriAndroid"),
        headers: {
          "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjY1MTFjYmNlM2I4Nzg1ZGNkNmU3NDY4OTAxYThhYWUwMTNjM2UxZmY0YjhkNDAyMDFkM2JiODZmYWFhMjQ4ZTA5NDdkOWE3YTVmYjZhNmI1In0.eyJhdWQiOiIyIiwianRpIjoiNjUxMWNiY2UzYjg3ODVkY2Q2ZTc0Njg5MDFhOGFhZTAxM2MzZTFmZjRiOGQ0MDIwMWQzYmI4NmZhYWEyNDhlMDk0N2Q5YTdhNWZiNmE2YjUiLCJpYXQiOjE1NzE3OTc2NTksIm5iZiI6MTU3MTc5NzY1OSwiZXhwIjoxNjAzNDIwMDU4LCJzdWIiOiIzIiwic2NvcGVzIjpbXX0.TfBOgh4nwlEw3UGADLn02mlB-BmX-k8_s1iGiCR809iD1iMFYOf7RTHQc5SrghM7XCK51tS-6lGZ2IaMQ41RGBvqSpylwibuZTiktcq1yPxT_TieGKRkdnx-CnOpgCFRct7mM3ylcWxzK8jlm1EyAtaay4zYeSolRQlWoS9Vz050114ncAvQWmS0GJ9JF0Zjti6yd3tl9I69bnkB1B7I9YB24CSkJDxOR6C4pjiVW4Ew6RL0JYTMFgEUf0liz_twR2uULUUPPDaMB0uhAtPsG7-cAaeZv8BKmMGjVenyIDJyLVqT1-4lUTxDgJIUXSM_IfzgoMfgILznDhD6dKv1l9gm0kHJkgcdu9sKTEpxoR7lEs7UopeKzKFnHbNDkrECwlBudeyKdkMZ-TCLjDZOK5CfTXNmInPZY_fO9eFKvj52jGd9rH2TSdNLoiiGSPrZL3dCZhePPAyAJPCX2CGO3vY6bRv91O2hDAsmqHakQjS7oRiwd9CE-MpR_K11noP0vqlgq26alKNfOtH74MVayF0Os_2PVtmrfaBcbaKw7bQlBhaT08SWQBS3W5Yxt4lYquc04l9upMjgkZ4cwl-mle86DA-6PZNT7AOnql4sTVSxcd9i-8SfPBbIMS0jS33Gb03Cpb72y90fVMiMAWx2v1lk0f-ndjWogdujw_dGEjs"
        },
        body: {
          "kategori" : "$category_id"
        }
    );

    this.setState(() {
      var data = json.decode(response.body);
      category_item = data['item'];
    });

    return "Success!";
  }

  @override
  void initState() {
    getCategoryItem();
    print(category_id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color(0xff25282b)
        ),
        title: Text("Menampilkan kategori $category" ,style: TextStyle(color: Color(0xff25282b)),),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: GridView.count(
                  primary: false,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 5.0,
                  childAspectRatio: 0.7,
                  children: List.generate(category_item.length == 0 ? 0 : category_item.length, (index) {
                    return Card(
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
                                  Positioned(
                                      top: 5.0,
                                      left: 108.0,
                                      child: Container(
                                        width: 40.0,
                                        height: 40.0,
                                        decoration: new BoxDecoration(
                                          color: Colors.grey[100],
                                          shape: BoxShape.circle,
                                        ),
                                        child: new IconButton(
                                          icon: Icon(Icons.favorite, color: _isPressed),
                                          onPressed: () {
                                            setState(() {
                                              _isPressed = Colors.pink[400];
                                            });
                                          },
                                        ),
                                      )
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
                                          category_item[index]["i_name"],
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
                                          category_item[index]["ipr_bunitprice"],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.deepOrange
                                          ),
                                          maxLines: 1,
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          category_item[index]["i_code"],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Colors.grey[400],
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
                    );
                  })
              ),
            ),
          ],
        ),
      )
    );
  }
}
