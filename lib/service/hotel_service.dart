import 'dart:convert';
import 'package:http/http.dart' as http;

class HotelService {
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
    final response = await http.post(
      Uri.parse('$_baseUrl/bookings'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(bookingData),
    );

    return response.statusCode == 200;
  }
}
