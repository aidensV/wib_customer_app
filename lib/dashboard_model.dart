class ProductModel {
  String item;
  String price;
  String gambar;
  String code;
  String wishlist;
  String desc;
  String tipe;
  String diskon;

  ProductModel({
    this.code,
    this.desc,
    this.diskon,
    this.gambar,
    this.item,
    this.price,
    this.tipe,
    this.wishlist,
  });


}

class ListBanner {
  final String idbanner;
  final String banner;

  ListBanner({this.idbanner, this.banner});
}

class RecomendationModel {
  String item;
  String price;
  String gambar;
  String code;
  String wishlist;
  String desc;
  String tipe;
  String diskon;

  RecomendationModel({
    this.item,
    this.code,
    this.desc,
    this.diskon,
    this.gambar,
    this.price,
    this.tipe,
    this.wishlist,
  });

}

