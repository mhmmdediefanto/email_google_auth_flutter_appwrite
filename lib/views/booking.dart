import 'package:flutter/material.dart';
import '../service/booking_service.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _checkinController = TextEditingController();
  final _checkoutController = TextEditingController();

  String? _selectedKelas = 'ekonomi'; // Default value for kelas
  String? _selectedHotelId; // For selected hotel
  List<Map<String, dynamic>> _hotels = []; // List of hotels from API
  final _bookingService = BookingService(); // Instance of the service

  // Fetch hotels from API
  Future<void> _fetchHotels() async {
    final hotels = await _bookingService.fetchHotels();
    setState(() {
      _hotels = hotels;
    });
  }

  // Submit booking data
  Future<void> _submitBooking() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || 
        _selectedHotelId == null || _checkinController.text.isEmpty || 
        _checkoutController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    // Prepare booking data
    final bookingData = {
      'full_name': _nameController.text,
      'hotel_id': _selectedHotelId,
      'kelas': _selectedKelas,
      'tanggal_checkin': _checkinController.text,
      'tanggal_checkout': _checkoutController.text,
    };

    // Call the service to submit booking data
    final success = await _bookingService.submitBooking(bookingData);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking Submitted!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking failed. Please try again.')),
      );
    }
  }

  // Function to show date picker and format the date
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      // Format the selected date to 'yyyy-MM-dd' format
      final formattedDate = "${selectedDate.toLocal()}".split(' ')[0];
      controller.text = formattedDate; // Set the text field with selected date
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchHotels(); // Fetch hotels when page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Background color for the page
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Card(
              elevation: 10, // Shadow effect for the form card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // Rounded corners for the card
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Form Booking',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent, // Bright title color
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildTextField(_nameController, 'Full Name'),
                    SizedBox(height: 10),
                    _buildTextField(_emailController, 'Email'),
                    SizedBox(height: 10),
                    _buildDropdown(_hotels, 'Select Hotel'),
                    SizedBox(height: 10),
                    _buildClassDropdown(),
                    SizedBox(height: 10),
                    _buildDateField(_checkinController, 'Check-in Date'),
                    SizedBox(height: 10),
                    _buildDateField(_checkoutController, 'Check-out Date'),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _submitBooking,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent, // Button color
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30), // Rounded button
                          ),
                        ),
                        child: Text(
                          'Submit Booking',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // TextField widget builder
  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.orangeAccent), // Label color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // Rounded border for text fields
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orangeAccent), // Focused border color
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Dropdown for selecting hotel
  Widget _buildDropdown(List<Map<String, dynamic>> hotels, String label) {
    return DropdownButtonFormField<String>(
      value: _selectedHotelId,
      hint: Text('Select Hotel'),
      items: hotels.map((hotel) {
        return DropdownMenuItem<String>(
          value: hotel['id'].toString(),
          child: Text(hotel['name']),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedHotelId = value;
        });
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.orangeAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orangeAccent),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Dropdown for selecting class
  Widget _buildClassDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedKelas,
      items: ['ekonomi', 'standard', 'bisnis'].map((kelas) {
        return DropdownMenuItem<String>(
          value: kelas,
          child: Text(kelas),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedKelas = value;
        });
      },
      decoration: InputDecoration(
        labelText: 'Class',
        labelStyle: TextStyle(color: Colors.orangeAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orangeAccent),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Date picker for check-in and check-out dates
  Widget _buildDateField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.orangeAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orangeAccent),
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_today, color: Colors.orangeAccent),
          onPressed: () => _selectDate(context, controller),
        ),
      ),
      readOnly: true, // Disable manual input
    );
  }
}
