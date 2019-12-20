class Produk {
  String idProduk,
      kodeProduk,
      linkProduk,
      namaProduk,
      deskripsiProduk,
      wishlist,
      idTipe,
      namaTipe,
      hargaProduk,
      gambar,
      hargaDiskon,
      minHarga,
      maxHarga;

  Produk({
    this.deskripsiProduk,
    this.gambar,
    this.idProduk,
    this.wishlist,
    this.namaProduk,
    this.hargaDiskon,
    this.hargaProduk,
    this.idTipe,
    this.kodeProduk,
    this.linkProduk,
    this.namaTipe,
    this.minHarga,
    this.maxHarga,
  });
}

class JenisProduk {
  String idJenis, namaJenis;

  JenisProduk({
    this.idJenis,
    this.namaJenis,
  });

  bool operator ==(other) => other is JenisProduk && other.idJenis == idJenis;

  int get hashCode => idJenis.hashCode;
}
