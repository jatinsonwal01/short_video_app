import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:sasta_tiktok/constants.dart';
import 'package:sasta_tiktok/controllers/comment_controller.dart';
import 'package:timeago/timeago.dart' as tago;

class CommentScreen extends StatefulWidget {
  final String id;

  const CommentScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();

  CommentController commentController = Get.put(CommentController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    commentController.updatePostId(widget.id);
    return Scaffold(
        body: SingleChildScrollView(
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                return ListView.builder(
                    itemCount: commentController.comments.length,
                    itemBuilder: (context, index) {
                      final comment = commentController.comments[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.black,
                          backgroundImage: NetworkImage(comment.profilePhoto),
                        ),
                        title: Row(
                          children: [
                            Text(
                              "${comment.username}  ",
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w700),
                            ),
                            Expanded(
                              child: Text(
                                comment.comment,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              tago.format(comment.datePublished.toDate()),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              '${comment.likes.length} likes',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        trailing: InkWell(
                          onTap: () =>
                              commentController.likeComment(comment.id),
                          child: Icon(
                            Icons.favorite,
                            size: 25,
                            color:
                                comment.likes.contains(authController.user.uid)
                                    ? Colors.red
                                    : Colors.white,
                          ),
                        ),
                      );
                    });
              }),
            ),
            const Divider(),
            ListTile(
              title: TextFormField(
                controller: _commentController,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: const InputDecoration(
                  labelText: 'comment',
                  labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
              trailing: TextButton(
                onPressed: () =>
                    commentController.postComment(_commentController.text),
                child: const Text('send',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
