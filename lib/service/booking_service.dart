import 'dart:convert';
import 'package:http/http.dart' as http;

class BookingService {
  static const String _baseUrl = 'http://192.168.1.14:8000/api';

  // Fungsi untuk mengambil daftar hotel
  Future<List<Map<String, dynamic>>> fetchHotels() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/hotels'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        return data.map((e) => e as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load hotels');
      }
    } catch (e) {
      print('Error fetching hotels: $e');
      return [];
    }
  }

  // Fungsi untuk mengirim data booking
  Future<bool> submitBooking(Map<String, dynamic> bookingData) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/booking'), // URL untuk POST data booking
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(bookingData), // Mengirimkan data dalam format JSON
      );

      if (response.statusCode == 200) {
        return true; // Booking berhasil
      } else {
        return false; // Booking gagal
      }
    } catch (e) {
      print('Error submitting booking: $e');
      return false; // Gagal mengirim data
    }
  }



   // Fungsi untuk mengambil daftar booking
  Future<List<Map<String, dynamic>>> fetchBookings() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/booking')); // Endpoint API untuk booking
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        return data.map((e) => e as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load bookings');
      }
    } catch (e) {
      print('Error fetching bookings: $e');
      return [];
    }
  }
}
