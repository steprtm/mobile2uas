import 'dart:convert';
import 'package:tokokita/helpers/api.dart';
import 'package:tokokita/helpers/api_url.dart';
import 'package:tokokita/model/produk.dart';

class ProdukBloc {
  static Future<List<Produk>> getProduks() async {
    try {
      String apiUrl = ApiUrl.listProduk;
      var response = await Api().get(apiUrl);
      var jsonObj = json.decode(response.body);
      List<dynamic> listProduk = (jsonObj as Map<String, dynamic>)['data'];
      List<Produk> produks =
          listProduk.map((item) => Produk.fromJson(item)).toList();

      print('List of products retrieved successfully: $produks');

      return produks;
    } catch (e) {
      print('Error fetching products: $e');
      throw e; // Rethrow the exception to handle it elsewhere if needed
    }
  }

  static Future<String> addProduk({required Produk produk}) async {
    print('Submitting new product...');
    try {
      String apiUrl = ApiUrl.createProduk;
      var body = {
        "kode_produk": produk.kodeProduk!,
        "nama_produk": produk.namaProduk!,
        "harga": produk.hargaProduk.toString(),
      };

      var response = await Api().post(apiUrl, body);
      var jsonObj = json.decode(response.body);

      if (jsonObj['status'] == true) {
        print('Add product response: $jsonObj');
        return 'success';
      } else {
        print('Add product failed: ${jsonObj['message']}');
        return jsonObj['message'] ?? 'Gagal menyimpan produk';
      }
    } catch (e) {
      print('Error adding product: $e');
      throw e;
    }
  }

  static Future<bool> updateProduk({required Produk produk}) async {
    try {
      String apiUrl = ApiUrl.updateProduk(produk.id!);
      var body = {
        "kode_produk": produk.kodeProduk!,
        "nama_produk": produk.namaProduk!,
        "harga": produk.hargaProduk.toString(),
      };

      print('Submitting update for product: ${produk.namaProduk}');
      var response = await Api().post(apiUrl, body);
      var jsonObj = json.decode(response.body);

      if (jsonObj['status'] == true) {
        print('Update product response: $jsonObj');
        return true;
      } else {
        print('Update product failed: ${jsonObj['message']}');
        return false;
      }
    } catch (e) {
      print('Error updating product: $e');
      throw e;
    }
  }

  static Future<bool> deleteProduk({required int id}) async {
    String apiUrl = ApiUrl.deleteProduk(id);
    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);
    bool success = (jsonObj as Map<String, dynamic>)['data'];

    // Jika penghapusan berhasil, refresh data
    if (success) {
      await getProduks(); // Memanggil kembali fungsi getProduks() untuk memperbarui data
    }

    return success;
  }
}
