import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // Pastikan Anda mengimpor intl

class DetailHotelPage extends StatelessWidget {
  final Map<String, dynamic> hotel;

  const DetailHotelPage({Key? key, required this.hotel}) : super(key: key);

  // Fungsi untuk format harga menjadi Rupiah
  String formatRupiah(int price) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return format.format(price);
  }

  @override
  Widget build(BuildContext context) {
     // Mengubah hotel['price'] menjadi integer terlebih dahulu
    int price = hotel['price'] is String
        ? int.parse(hotel['price'])  // Jika hotel['price'] berupa string
        : hotel['price'].toInt();    // Jika hotel['price'] sudah berupa angka (double)
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Warna latar belakang AppBar putih
        title: Text(
          hotel['name'],
          style: TextStyle(color: Colors.black), // Warna teks AppBar hitam
        ),
        iconTheme: const IconThemeData(color: Colors.black), // Warna ikon hitam
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'images/${hotel['image']}', // Menggunakan nama gambar dari data hotel
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                      Icons.broken_image); // Menampilkan icon jika gambar error
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              hotel['name'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Address: ${hotel['address']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            // Menggunakan fungsi formatRupiah untuk menampilkan harga
            Text(
              'Price: ${formatRupiah(price)}',
              style: const TextStyle(fontSize: 16, color: Colors.green),
            ),
            const SizedBox(height: 16),
            Text(
              'Description: ${hotel['description'] ?? 'No description available.'}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            // Fasilitas Hotel
            const Text(
              'Facilities:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildFacilityItem('Wi-Fi'),
            _buildFacilityItem('Air Conditioning'),
            _buildFacilityItem('Parking'),
            _buildFacilityItem('Swimming Pool'),
            _buildFacilityItem('Restaurant'),
            const SizedBox(height: 16),
            // Ulasan Hotel
            const Text(
              'Reviews:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildReviewItem(
                'Great service and comfortable rooms. Highly recommend!'),
            _buildReviewItem('Nice location, very close to the beach.'),
            _buildReviewItem('Affordable and clean. Will visit again!'),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan fasilitas hotel
  Widget _buildFacilityItem(String facility) {
    return Row(
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 18),
        const SizedBox(width: 8),
        Text(facility),
      ],
    );
  }

  // Widget untuk menampilkan ulasan hotel
  Widget _buildReviewItem(String review) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        review,
        style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
      ),
    );
  }
}
