import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadImage({
    required File imageFile,
    required String folder,
    required String fileName,
  }) async {
    try {
      Reference ref = _storage.ref().child('$folder/$fileName');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  Future<List<String>> uploadMultipleImages({
    required List<File> imageFiles,
    required String folder,
  }) async {
    List<String> urls = [];

    for (int i = 0; i < imageFiles.length; i++) {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
      String? url = await uploadImage(
        imageFile: imageFiles[i],
        folder: folder,
        fileName: fileName,
      );
      if (url != null) {
        urls.add(url);
      }
    }

    return urls;
  }

  Future<bool> deleteImage(String imageUrl) async {
    try {
      Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> uploadProfileImage({
    required File imageFile,
    required String userId,
  }) async {
    String fileName = 'profile_$userId.jpg';
    return await uploadImage(
      imageFile: imageFile,
      folder: 'profiles',
      fileName: fileName,
    );
  }

  Future<List<String>> uploadBookingPhotos({
    required List<File> imageFiles,
    required String bookingId,
    required String type, // 'before' or 'after'
  }) async {
    return await uploadMultipleImages(
      imageFiles: imageFiles,
      folder: 'bookings/$bookingId/$type',
    );
  }
}
