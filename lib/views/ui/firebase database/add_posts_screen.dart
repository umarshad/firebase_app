import 'package:firebase_app/components/buttons/custom_button.dart';
import 'package:firebase_app/components/utils/colors.dart';
import 'package:firebase_app/components/utils/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddPostsScreen extends StatefulWidget {
  const AddPostsScreen({super.key});

  @override
  State<AddPostsScreen> createState() => _AddPostsScreenState();
}

class _AddPostsScreenState extends State<AddPostsScreen> {
  final postsController = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref('Posts');
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColors.whiteColor,
        ),
        centerTitle: true,
        title: const Text(
          'Add Posts',
          style: TextStyle(color: AppColors.whiteColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextFormField(
              controller: postsController,
              maxLines: 6,
              decoration: const InputDecoration(
                  hintText: 'Type here....', border: OutlineInputBorder()),
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
                databaseRef.child(id).set(
                  {"title": postsController.text.toString(), "id": id},
                ).then((value) {
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage("Post added");
                }).onError((error, stackTrace) {
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage(error.toString());
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
