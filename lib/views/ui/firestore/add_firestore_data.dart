import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/components/buttons/custom_button.dart';
import 'package:firebase_app/components/utils/colors.dart';
import 'package:firebase_app/components/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddFirestoreData extends StatefulWidget {
  const AddFirestoreData({super.key});

  @override
  State<AddFirestoreData> createState() => _AddFirestoreDataState();
}

class _AddFirestoreDataState extends State<AddFirestoreData> {
  final auth = FirebaseAuth.instance;
  final databaseRef = FirebaseFirestore.instance.collection("users");
  final postController = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
        title: const Text(
          'Add Firestore',
          style: TextStyle(color: AppColors.whiteColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextFormField(
              controller: postController,
              maxLines: 6,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 50.h,
            ),
            CustomButton(
              loading: loading,
              title: "Post",
              onPress: () {
                setState(() {
                  loading = true;
                });
                String id = DateTime.now().millisecondsSinceEpoch.toString();
                databaseRef.doc(id).set(
                  {"title": postController.text.toString(), "id": id},
                ).then((value) {
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage("Post added");
                }).onError((e, stackTrace) {
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage(e.toString());
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
