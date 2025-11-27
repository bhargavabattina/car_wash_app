import 'package:flutter/foundation.dart';
import '../models/booking_model.dart';
import '../models/service_model.dart';
import '../models/car_model.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';
import 'dart:io';

class BookingProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final StorageService _storageService = StorageService();

  List<BookingModel> _bookings = [];
  List<ServiceModel> _services = [];
  BookingModel? _currentBooking;
  bool _isLoading = false;

  List<BookingModel> get bookings => _bookings;
  List<ServiceModel> get services => _services;
  BookingModel? get currentBooking => _currentBooking;
  bool get isLoading => _isLoading;

  Future<void> loadServices() async {
    _isLoading = true;
    notifyListeners();

    _services = await _firestoreService.getServices();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadUserBookings(String userId) async {
    _isLoading = true;
    notifyListeners();

    _bookings = await _firestoreService.getUserBookings(userId);

    _isLoading = false;
    notifyListeners();
  }

  Future<String> createBooking(BookingModel booking) async {
    _isLoading = true;
    notifyListeners();

    final bookingId = DateTime.now().millisecondsSinceEpoch.toString();
    final newBooking = booking.copyWith(id: bookingId);

    await _firestoreService.createBooking(newBooking);
    _bookings.insert(0, newBooking);
    _currentBooking = newBooking;

    _isLoading = false;
    notifyListeners();

    return bookingId;
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    await _firestoreService.updateBooking(bookingId, {'bookingStatus': status});
    await loadBooking(bookingId);
  }

  Future<void> loadBooking(String bookingId) async {
    _currentBooking = await _firestoreService.getBooking(bookingId);
    notifyListeners();
  }

  Future<void> uploadBeforePhotos(String bookingId, List<File> photos) async {
    final urls = await _storageService.uploadBookingPhotos(
      imageFiles: photos,
      bookingId: bookingId,
      type: 'before',
    );

    await _firestoreService.updateBooking(bookingId, {'beforePhotos': urls});
    await loadBooking(bookingId);
  }

  Future<void> uploadAfterPhotos(String bookingId, List<File> photos) async {
    final urls = await _storageService.uploadBookingPhotos(
      imageFiles: photos,
      bookingId: bookingId,
      type: 'after',
    );

    await _firestoreService.updateBooking(bookingId, {'afterPhotos': urls});
    await loadBooking(bookingId);
  }

  void setCurrentBooking(BookingModel? booking) {
    _currentBooking = booking;
    notifyListeners();
  }

  void clearCurrentBooking() {
    _currentBooking = null;
    notifyListeners();
  }
}
