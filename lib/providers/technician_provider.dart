import 'package:flutter/foundation.dart';
import '../models/booking_model.dart';
import '../services/firestore_service.dart';

class TechnicianProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<BookingModel> _jobs = [];
  BookingModel? _currentJob;
  bool _isLoading = false;

  List<BookingModel> get jobs => _jobs;
  BookingModel? get currentJob => _currentJob;
  bool get isLoading => _isLoading;

  List<BookingModel> get todayJobs {
    final today = DateTime.now();
    return _jobs.where((job) {
      return job.scheduledDate.year == today.year &&
          job.scheduledDate.month == today.month &&
          job.scheduledDate.day == today.day;
    }).toList();
  }

  List<BookingModel> get pendingJobs {
    return _jobs.where((job) => job.bookingStatus == 'assigned').toList();
  }

  List<BookingModel> get inProgressJobs {
    return _jobs.where((job) => job.bookingStatus == 'in_progress').toList();
  }

  List<BookingModel> get completedJobs {
    return _jobs.where((job) => job.bookingStatus == 'completed').toList();
  }

  Future<void> loadTechnicianJobs(String technicianId) async {
    _isLoading = true;
    notifyListeners();

    _jobs = await _firestoreService.getTechnicianBookings(technicianId);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> startJob(String bookingId) async {
    await _firestoreService.updateBooking(bookingId, {
      'bookingStatus': 'in_progress',
    });
    await loadTechnicianJobs(_currentJob?.technicianId ?? '');
  }

  Future<void> completeJob(String bookingId) async {
    await _firestoreService.updateBooking(bookingId, {
      'bookingStatus': 'completed',
      'completedAt': DateTime.now().toIso8601String(),
    });
    await loadTechnicianJobs(_currentJob?.technicianId ?? '');
  }

  void setCurrentJob(BookingModel job) {
    _currentJob = job;
    notifyListeners();
  }

  void clearCurrentJob() {
    _currentJob = null;
    notifyListeners();
  }
}
