class ListProvinsi {
   String id;
   String nama;

  ListProvinsi({
    this.id,
    this.nama,
  });
}

class ListKabupaten {
   String id;
   String nama;
   String ongkir;
   String totalbelanja;
   String textongkir;

  ListKabupaten({
    this.id,
    this.nama,
    this.ongkir,
    this.totalbelanja,
    this.textongkir,
  });
}

class ListKecamatan {
   String id;
   String nama;

  ListKecamatan({
    this.id,
    this.nama,
  });
}

class ListCheckout {
  final String id;
  final String item;
  final String code;
  final String harga;
  final String type;
  final String image;
  final String jumlah;
  final String satuan;
  final String total;
  final String gudang;
  String diskon;

  ListCheckout(
      {this.id,
      this.item,
      this.harga,
      this.type,
      this.image,
      this.code,
      this.jumlah,
      this.satuan,
      this.total,
      this.gudang,
      this.diskon});
}
