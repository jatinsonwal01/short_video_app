import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sasta_tiktok/constants.dart';
import 'package:sasta_tiktok/models/user.dart' as model;
import 'package:sasta_tiktok/views/screens/auth/login_screen.dart';
import 'package:sasta_tiktok/views/screens/home_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  late Rx<File?> _pickedImage;
  late Rx<User?> _user;
  bool check = false;
  User get user => _user.value!;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setIntialScreen);
  }

  _setIntialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }

  File? get profilePhoto => _pickedImage.value;

  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Get.snackbar('Profile Picture', 'profile picture successfully selected');
    }
    _pickedImage = Rx<File?>(File(pickedImage!.path));
  }

  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser!.uid);
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadURL = await snap.ref.getDownloadURL();
    return downloadURL;
  }

  void registerUser(
      String username, String email, String password, File? image) async {
    try {
       if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        String downloadURL = await _uploadToStorage(image);
        model.User user = model.User(
            name: username,
            profilePhoto: downloadURL,
            uid: cred.user!.uid,
            email: email);
        await fireStore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
      } else {
        Get.snackbar('error creating account', 'please enter all the details');
      }
    } catch (e) {
      Get.snackbar('error creating account', e.toString());
    }
  }

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        Get.snackbar('Error logging in', 'please enter all the fields');
      }
    } catch (e) {
      Get.snackbar('error logging in', e.toString());
    }
  }

  void signOut() async {
    await firebaseAuth.signOut();
  }
}
