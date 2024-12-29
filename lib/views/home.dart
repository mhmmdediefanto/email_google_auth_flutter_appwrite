import 'package:flutter/material.dart';
import '../service/hotel_service.dart'; // Import layanan API
import 'booking.dart'; // Import halaman booking
import 'BookingListPage.dart'; // Import halaman list booking
import 'detail_hotel.dart'; // Import halaman detail hotel
// import '../controllers/auth.dart';
import 'package:intl/intl.dart';
import 'package:email_google_auth_flutter_appwrite/controllers/auth.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  // Fungsi untuk format harga menjadi Rupiah
  String formatRupiah(int price) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return format.format(price);
  }

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // late User _currentUser;
  bool isLoading = true;
  int _currentIndex = 0;
  List<Map<String, dynamic>> hotels = []; // List untuk menyimpan data hotel
  List<String> bookedList = []; // List untuk menyimpan daftar booking

  @override
  void initState() {
    getUser().then((value) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
    fetchHotels(); // Ambil data hotel saat aplikasi dimulai
  }

  // Fungsi untuk mengambil data dari API
  Future<void> fetchHotels() async {
    final hotelService = HotelService();
    final fetchedHotels = await hotelService.fetchHotels();
    setState(() {
      hotels = fetchedHotels;
      isLoading = false;
    });
  }

  // Widget untuk menampilkan card hotel
  Widget _buildHotelCards() {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      itemCount: hotels.length,
      itemBuilder: (context, index) {
        final hotel = hotels[index];

        // Tentukan gambar berdasarkan index atau ID hotel
        String imageAsset =
            'assets/images/hotels${(index % 10) + 1}.jpg'; // Menggunakan index untuk memilih gambar

        // Mengambil harga dan mengonversinya jika perlu
        int price = hotel['price'] is String
            ? int.parse(hotel['price']) // Jika hotel['price'] berupa string
            : hotel['price']; // Jika hotel['price'] sudah berupa integer

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: () {
              // Navigasi ke halaman detail hotel
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailHotelPage(hotel: hotel),
                ),
              );
            },
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      imageAsset, // Menggunakan gambar dari assets
                      fit: BoxFit.cover,
                      height: 120,
                      width: double.infinity,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    hotel['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(hotel['address']),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Price: ${widget.formatRupiah(price)}', // Menggunakan formatRupiah untuk menampilkan harga
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Fungsi untuk mengganti halaman sesuai dengan tab yang dipilih
  Widget _getBody() {
    switch (_currentIndex) {
      case 0:
        return isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildHotelCards();
      case 1:
        return const BookingPage();
      case 2:
        return const BookingListPage();
      case 3:
        // Panggil fungsi logout dari AuthService
        logoutUser().then((_) {
          // Setelah logout, arahkan ke halaman login
          Navigator.pushReplacementNamed(context, '/login');
        }).catchError((error) {
          // Tangani error jika terjadi
          print("Error saat logout: $error");
        });
        return const Center(child: Text("Logging Out..."));

      default:
        return const Center(child: Text("Select an option"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black.withOpacity(0.6),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
      ),
    );
  }
}
