import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailBookingPage extends StatelessWidget {
  final Map<String, dynamic> booking;

  const DetailBookingPage({super.key, required this.booking});

  String formatRupiah(int price) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return format.format(price);
  }

  @override
  Widget build(BuildContext context) {
    final hotel = booking['hotel']; // Ambil data hotel
    int price = hotel['price'] is String
        ? int.parse(hotel['price'])  // Jika hotel['price'] berupa string
        : hotel['price'].toInt();

    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Detail'),
        backgroundColor: Colors.orangeAccent, // Warna app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Gambar hotel menggunakan asset
            Image.asset(
              'images/${hotel['image']}', // Ganti dengan gambar yang sesuai
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Full Name: ${booking['full_name']}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Hotel: ${hotel['name']}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Address: ${hotel['address']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      'Price: ${formatRupiah(price)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Description:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      hotel['description'],
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    SizedBox(height: 20),
                    Divider(color: Colors.grey), // Pembatas antar bagian
                    SizedBox(height: 10),
                    Text(
                      'Class: ${booking['kelas']}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey,
                      ),
                    ),
                    Text(
                      'Check-in: ${booking['tanggal_checkin']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Check-out: ${booking['tanggal_checkout']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
