import 'package:firebase_app/components/buttons/custom_button.dart';
import 'package:firebase_app/components/utils/colors.dart';
import 'package:firebase_app/components/utils/utils.dart';
import 'package:firebase_app/views/auth/login_screen.dart';
import 'package:firebase_app/views/ui/firebase%20database/add_posts_screen.dart';
import 'package:firebase_app/views/ui/firestore/firestore_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final auth = FirebaseAuth.instance;
  final searchController = TextEditingController();
  final editController = TextEditingController();
  final ref = FirebaseDatabase.instance.ref('Posts');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Firebase',
          style: TextStyle(color: AppColors.whiteColor),
        ),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Utils().toastMessage("Logged out successfully");
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
              });
            },
            icon: const Icon(
              Icons.logout_outlined,
              color: AppColors.whiteColor,
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              controller: searchController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Search...'),
              onChanged: (String value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
                query: ref,
                defaultChild: const Center(
                    child: CircularProgressIndicator(
                  color: AppColors.tealColor,
                )),
                itemBuilder: (context, snapshot, animation, index) {
                  final title = snapshot.child('title').value.toString();
                  if (searchController.text.isEmpty) {
                    return ListTile(
                      trailing: PopupMenuButton(
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                showMyDialogue(title,
                                    snapshot.child('id').value.toString());
                              },
                              title: const Text('Edit'),
                              leading: const Icon(Icons.edit),
                            ),
                          ),
                          PopupMenuItem(
                            child: ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                ref
                                    .child(
                                        snapshot.child('id').value.toString())
                                    .remove()
                                    .then((value) {
                                  Utils().toastMessage("Post Deleted");
                                }).onError((error, stackTrace) {
                                  Utils().toastMessage(error.toString());
                                });
                              },
                              title: const Text('Delete'),
                              leading: const Icon(Icons.delete),
                            ),
                          ),
                        ],
                      ),
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                    );
                  } else if (title.toLowerCase().contains(
                      searchController.text.toLowerCase().toLowerCase())) {
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                    );
                  } else {
                    return Container();
                  }
                }),
          )
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
                  title: "Firestore",
                  onPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FirestoreListScreen()));
                  }),
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddPostsScreen(),
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
                ref.child(id).update(
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
