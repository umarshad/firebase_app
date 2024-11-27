import 'package:firebase_app/components/buttons/custom_button.dart';
import 'package:firebase_app/components/utils/colors.dart';
import 'package:firebase_app/components/utils/images.dart';
import 'package:firebase_app/components/utils/utils.dart';
import 'package:firebase_app/views/auth/login_screen.dart';
import 'package:firebase_app/views/ui/firebase%20database/posts_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 50.h),
                SizedBox(
                  height: 150.h,
                  width: double.infinity,
                  child: Image.asset(AppImages.firebaseLogo),
                ),
                SizedBox(
                  height: 50.h,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_2_outlined),
                          hintText: 'Name',
                          hintStyle: TextStyle(
                            color: AppColors.blackColor.withOpacity(0.5),
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter your Name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.mail_outline_rounded),
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            color: AppColors.blackColor.withOpacity(0.5),
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter your Email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            color: AppColors.blackColor.withOpacity(0.5),
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter your Password';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50.h),
                CustomButton(
                  loading: loading,
                  title: 'Signup',
                  onPress: () {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                      });
                      _auth
                          .createUserWithEmailAndPassword(
                              email: emailController.text.toString(),
                              password: passwordController.text.toString())
                          .then((value) {
                        Utils().toastMessage("Signed up Successfully");
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PostsScreen(),
                          ),
                        );
                        setState(() {
                          loading = false;
                        });
                      }).onError(
                        (error, stackTrace) {
                          Utils().toastMessage(error.toString());
                          setState(() {
                            loading = false;
                          });
                        },
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 122.h,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                            fontSize: 15.sp, color: AppColors.blackColor),
                      ),
                      TextSpan(
                        text: 'Login',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
