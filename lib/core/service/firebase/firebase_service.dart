import 'package:firebase_core/firebase_core.dart';
import 'package:haditv/core/service/firebase/firebase_notification_service.dart';

class FirebaseService {
  FirebaseService._();

  static final FirebaseService instance = FirebaseService._();

  Future<void> initialize() async {
    await Firebase.initializeApp();

    await FirebaseNotificationService.instance.requestPermission();
    await FirebaseNotificationService.instance.subscribeToTopic();
  }
}
