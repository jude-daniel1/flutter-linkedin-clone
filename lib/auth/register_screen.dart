import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkedin_clone/auth/login_screen.dart';
import 'package:flutter_linkedin_clone/services/global_methods.dart';
import 'package:flutter_linkedin_clone/services/global_variables.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final TextEditingController _fullNameController =
      TextEditingController(text: '');
  final TextEditingController _emailTextController =
      TextEditingController(text: '');
  final TextEditingController _passTextController =
      TextEditingController(text: '');
  final TextEditingController _locationController =
      TextEditingController(text: '');
  final TextEditingController _phoneNumberController =
      TextEditingController(text: '');
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();
  final FocusNode _positionFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  bool _obsecureText = true;

  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  File? imageFile;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? imageUrl;

  void _submitFormOnSignUp() async {
    final isValid = _signUpFormKey.currentState!.validate();
    if (isValid) {
      if (imageFile == null) {
        GlobalMethod.showErrorDialog(
            error: "Please pick an image", ctx: context);
        return;
      }
      setState(() {
        _isLoading = true;
      });

      try {
        await _auth.createUserWithEmailAndPassword(
            email: _emailTextController.text.trim().toLowerCase(),
            password: _passTextController.text.trim());
        final User? user = _auth.currentUser;
        final _uid = user!.uid;
        final ref = FirebaseStorage.instance
            .ref()
            .child("userImages")
            .child(_uid + ".jpg");
        await ref.putFile(imageFile!);
        imageUrl = await ref.getDownloadURL();
        FirebaseFirestore.instance.collection("users").doc(_uid).set({
          "id": _uid,
          "name": _fullNameController.text.trim(),
          "email": _emailTextController.text.trim().toLowerCase(),
          "userImage": imageUrl,
          "phoneNumber": _phoneNumberController.text.trim(),
          "location": _locationController.text.trim(),
          "createdAt": Timestamp.now()
        });
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        GlobalMethod.showErrorDialog(error: e.toString(), ctx: context);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fullNameController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();
    _locationController.dispose();
    _phoneNumberController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _positionFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward();
            }
          });

    _animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: signUpUrlImage,
            placeholder: (context, url) => Image.asset(
              "assets/images/wallpaper.jpg",
              fit: BoxFit.fill,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Container(
            color: Colors.black54,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
              child: ListView(
                children: [
                  Form(
                    key: _signUpFormKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showImageDialog();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: size.width * 0.24,
                              height: size.width * 0.24,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.white),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: imageFile == null
                                    ? const Icon(
                                        Icons.camera_enhance,
                                        color: Colors.blue,
                                        size: 30,
                                      )
                                    : Image.file(
                                        imageFile!,
                                        fit: BoxFit.fill,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_emailFocusNode),
                          keyboardType: TextInputType.name,
                          controller: _fullNameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This field is missing";
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              hintText: "Full name / Company name",
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red))),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_passFocusNode),
                          focusNode: _emailFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailTextController,
                          validator: (value) {
                            if (value!.isEmpty || !value.contains("@")) {
                              return "Please enter a valide email address";
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              hintText: "Email",
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red))),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          obscureText: !_obsecureText,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_phoneNumberFocusNode),
                          keyboardType: TextInputType.visiblePassword,
                          focusNode: _passFocusNode,
                          controller: _passTextController,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 7) {
                              return "Please enter a valid password";
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: "Password",
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(
                                    () {
                                      _obsecureText = !_obsecureText;
                                    },
                                  );
                                },
                                child: Icon(
                                  _obsecureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                              ),
                              hintStyle: const TextStyle(color: Colors.white),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red))),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_positionFocusNode),
                          focusNode: _phoneNumberFocusNode,
                          keyboardType: TextInputType.phone,
                          controller: _phoneNumberController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This field is missing";
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              hintText: "Phone Number",
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red))),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_positionFocusNode),
                          focusNode: _positionFocusNode,
                          keyboardType: TextInputType.text,
                          controller: _locationController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This field is missing";
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              hintText: "Company Address",
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red))),
                        ),
                        const SizedBox(height: 20),
                        _isLoading
                            ? const Center(
                                child: SizedBox(
                                  width: 70,
                                  height: 70,
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : MaterialButton(
                                onPressed: () {
                                  _submitFormOnSignUp();
                                },
                                color: Colors.blue,
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'Sign up',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        const SizedBox(
                          height: 40,
                        ),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Already have an account?",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const TextSpan(text: "   "),
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen())),
                                  text: "Login here",
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  //==============show image dialog =============
  _showImageDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Please choose an option",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    _getFromCamera();
                  },
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.camera,
                          color: Colors.purple,
                        ),
                      ),
                      Text(
                        "Camera",
                        style: TextStyle(color: Colors.purple),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    _getFroomGallery();
                  },
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.image,
                          color: Colors.purple,
                        ),
                      ),
                      Text(
                        "Gallery",
                        style: TextStyle(color: Colors.purple),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          );
        });
  }

  //getFromCamera
  void _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker()
        .getImage(source: ImageSource.camera, maxHeight: 800, maxWidth: 800);

    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  Future<void> _cropImage(String filePath) async {
    File? croppedImage = await ImageCropper()
        .cropImage(sourcePath: filePath, maxHeight: 600, maxWidth: 600);

    if (croppedImage != null) {
      setState(() {
        imageFile = croppedImage;
      });
    }
  }

  Future<void> _getFroomGallery() async {
    PickedFile? pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, maxHeight: 800, maxWidth: 800);

    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }
}
