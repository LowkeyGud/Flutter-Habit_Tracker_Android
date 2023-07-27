import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
   static UserController get instance => Get.find();

  final User? user = FirebaseAuth.instance.currentUser;
  late String userEmail;

  @override
  void onInit() {
    super.onInit();
    // Call the function to get the user's email when the controller is initialized
    fetchUserEmail();
    fetchUserHabit();
  }

  Future<void> fetchUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userEmail = user.email ?? '';
    }
  }

  Future<DocumentReference> fetchUserHabit() async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    final DocumentReference userDocument = userCollection.doc(userEmail);
    return userDocument;
  }
}
