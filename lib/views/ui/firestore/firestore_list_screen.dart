import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/components/buttons/custom_button.dart';
import 'package:firebase_app/components/utils/colors.dart';
import 'package:firebase_app/components/utils/utils.dart';
import 'package:firebase_app/views/auth/login_screen.dart';
import 'package:firebase_app/views/ui/firebase%20database/posts_screen.dart';
import 'package:firebase_app/views/ui/firestore/add_firestore_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FirestoreListScreen extends StatefulWidget {
  const FirestoreListScreen({super.key});

  @override
  State<FirestoreListScreen> createState() => _FirestoreListScreenState();
}

class _FirestoreListScreenState extends State<FirestoreListScreen> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance.collection("users").snapshots();
  final ref = FirebaseFirestore.instance.collection("users");
  final editController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Firestore',
          style: TextStyle(color: AppColors.whiteColor),
        ),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then(
                (value) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                  Utils().toastMessage("logged out successfully");
                },
              ).onError(
                (e, stackTrace) {
                  Utils().toastMessage(
                    e.toString(),
                  );
                },
              );
            },
            icon:
                const Icon(Icons.logout_outlined, color: AppColors.whiteColor),
          ),
          SizedBox(
            width: 10.w,
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: firestore,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.tealColor,
                  ),
                );
              }

              if (snapshot.hasError) {
                return const Text('Some errors');
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      trailing: PopupMenuButton(
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: ListTile(
                              title: const Text('Edit'),
                              leading: const Icon(Icons.edit),
                              onTap: () {
                                // Get the title and id from the current document
                                final title = snapshot
                                    .data!.docs[index]['title']
                                    .toString();
                                final id =
                                    snapshot.data!.docs[index]['id'].toString();

                                // Close the PopupMenu before showing the dialog
                                Navigator.pop(context);

                                // Call the dialog with correct parameters
                                showMyDialogue(title, id);
                              },
                            ),
                          ),
                          PopupMenuItem(
                            child: ListTile(
                              title: const Text('Delete'),
                              leading: const Icon(Icons.delete),
                              onTap: () {
                                final id =
                                    snapshot.data!.docs[index]['id'].toString();
                                Navigator.pop(context);
                                ref.doc(id).delete().then((value) {
                                  Utils().toastMessage("Post Deleted");
                                }).onError((error, stackTrace) {
                                  Utils().toastMessage(error.toString());
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      title: Text(
                        snapshot.data!.docs[index]['title'].toString(),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Row(
        children: [
          SizedBox(
            width: 30.w,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: SizedBox(
              width: 250.w,
              child: CustomButton(
                  title: "Firebase",
                  onPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PostsScreen()));
                  }),
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddFirestoreData(),
                ),
              );
            },
            elevation: 5,
            shape: const CircleBorder(),
            backgroundColor: AppColors.tealColor,
            child: const Icon(
              Icons.add,
              color: AppColors.whiteColor,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showMyDialogue(String title, String id) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        editController.text = title;
        return AlertDialog(
          title: const Text("Update"),
          content: TextField(
            controller: editController,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ref.doc(id).update(
                    {"title": editController.text.toString()}).then((value) {
                  Utils().toastMessage("Post Updated");
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }
}
