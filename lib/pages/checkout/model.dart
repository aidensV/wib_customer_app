class ListProvinsi {
  final String id;
  final String nama;

  ListProvinsi({
    this.id,
    this.nama,
  });
}

class ListKabupaten {
  final String id;
  final String nama;
  final String ongkir;

  ListKabupaten({
    this.id,
    this.nama,
    this.ongkir,
  });
}

class ListKecamatan {
  final String id;
  final String nama;

  ListKecamatan({
    this.id,
    this.nama,
  });
}

class ListCheckout {
  final String id;
  final String item;
  final String harga;
  final String type;
  final String image;
  final String jumlah;
  final String satuan;
  final String total;
  final String gudang;

  ListCheckout(
      {this.id,
      this.item,
      this.harga,
      this.type,
      this.image,
      this.jumlah,
      this.satuan,
      this.total,
      this.gudang});
}
