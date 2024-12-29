import 'package:flutter/material.dart';
import '../service/booking_service.dart';
import 'DetailBookingPage.dart'; // Import halaman detail

class BookingListPage extends StatefulWidget {
  const BookingListPage({super.key});

  @override
  _BookingListPageState createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage> {
  final _bookingService = BookingService(); // Instance of the service

  // Ambil data booking dari API
  Future<List<Map<String, dynamic>>> _fetchBookings() async {
    return await _bookingService.fetchBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking List'),
        backgroundColor: Colors.orangeAccent, // Warna app bar cerah
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>( // FutureBuilder untuk mengambil data
        future: _fetchBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Loading indicator
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No bookings found'));
          }

          // Data sudah tersedia, tampilkan daftar booking
          final bookings = snapshot.data!;
          return SingleChildScrollView( // Menambahkan SingleChildScrollView untuk menghindari overflow
            child: Column(
              children: List.generate(bookings.length, (index) {
                final booking = bookings[index];
                final hotel = booking['hotel']; // Data hotel terkait
                return Card(
                  margin: EdgeInsets.all(10),
                  elevation: 5, // Efek bayangan untuk card
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Card dengan sudut melengkung
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(15), // Padding dalam card
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.orangeAccent, // Warna lingkaran
                      child: Icon(
                        Icons.hotel,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      booking['full_name'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey, // Warna teks judul
                      ),
                    ),
                    subtitle: Text(
                      'Hotel: ${hotel['name']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Class: ${booking['kelas']}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.orangeAccent, // Warna cerah
                          ),
                        ),
                        Text(
                          'Check-in: ${booking['tanggal_checkin']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          'Check-out: ${booking['tanggal_checkout']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Navigasi ke halaman detail
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailBookingPage(
                            booking: booking, // Kirim data booking ke halaman detail
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
