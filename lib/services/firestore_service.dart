import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/booking_model.dart';
import '../models/service_model.dart';
import '../models/car_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // User Operations
  Future<void> createUser(UserModel user) async {
    await _db.collection('users').doc(user.id).set(user.toJson());
  }

  Future<UserModel?> getUser(String userId) async {
    DocumentSnapshot doc = await _db.collection('users').doc(userId).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await _db.collection('users').doc(userId).update(data);
  }

  Stream<UserModel?> getUserStream(String userId) {
    return _db.collection('users').doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    });
  }

  // Car Operations
  Future<void> addCar(CarModel car) async {
    await _db.collection('cars').doc(car.id).set(car.toJson());
  }

  Future<List<CarModel>> getUserCars(String userId) async {
    QuerySnapshot snapshot = await _db
        .collection('cars')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs
        .map((doc) => CarModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Stream<List<CarModel>> getUserCarsStream(String userId) {
    return _db
        .collection('cars')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CarModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> deleteCar(String carId) async {
    await _db.collection('cars').doc(carId).delete();
  }

  // Service Operations
  Future<List<ServiceModel>> getServices() async {
    QuerySnapshot snapshot = await _db
        .collection('services')
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => ServiceModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Stream<List<ServiceModel>> getServicesStream() {
    return _db
        .collection('services')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ServiceModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<ServiceModel?> getService(String serviceId) async {
    DocumentSnapshot doc = await _db.collection('services').doc(serviceId).get();
    if (doc.exists) {
      return ServiceModel.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Booking Operations
  Future<void> createBooking(BookingModel booking) async {
    await _db.collection('bookings').doc(booking.id).set(booking.toJson());
  }

  Future<void> updateBooking(String bookingId, Map<String, dynamic> data) async {
    await _db.collection('bookings').doc(bookingId).update(data);
  }

  Future<BookingModel?> getBooking(String bookingId) async {
    DocumentSnapshot doc = await _db.collection('bookings').doc(bookingId).get();
    if (doc.exists) {
      return BookingModel.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Stream<BookingModel?> getBookingStream(String bookingId) {
    return _db.collection('bookings').doc(bookingId).snapshots().map((doc) {
      if (doc.exists) {
        return BookingModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    });
  }

  Future<List<BookingModel>> getUserBookings(String userId) async {
    QuerySnapshot snapshot = await _db
        .collection('bookings')
        .where('customerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => BookingModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Stream<List<BookingModel>> getUserBookingsStream(String userId) {
    return _db
        .collection('bookings')
        .where('customerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BookingModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<List<BookingModel>> getTechnicianBookings(String technicianId) async {
    QuerySnapshot snapshot = await _db
        .collection('bookings')
        .where('technicianId', isEqualTo: technicianId)
        .orderBy('scheduledDate', descending: false)
        .get();

    return snapshot.docs
        .map((doc) => BookingModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Stream<List<BookingModel>> getTechnicianBookingsStream(String technicianId) {
    return _db
        .collection('bookings')
        .where('technicianId', isEqualTo: technicianId)
        .orderBy('scheduledDate', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BookingModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<List<BookingModel>> getAllBookings() async {
    QuerySnapshot snapshot = await _db
        .collection('bookings')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => BookingModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Stream<List<BookingModel>> getAllBookingsStream() {
    return _db
        .collection('bookings')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BookingModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }

  // Admin Operations
  Future<List<UserModel>> getTechnicians() async {
    QuerySnapshot snapshot = await _db
        .collection('users')
        .where('userType', isEqualTo: 'technician')
        .get();

    return snapshot.docs
        .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<UserModel>> getCustomers() async {
    QuerySnapshot snapshot = await _db
        .collection('users')
        .where('userType', isEqualTo: 'customer')
        .get();

    return snapshot.docs
        .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
