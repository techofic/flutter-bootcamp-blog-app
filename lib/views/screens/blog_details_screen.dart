import 'package:bootcamp_app/controller/blog/blog_controller.dart';
import 'package:bootcamp_app/controller/blog/blog_details_controller.dart';
import 'package:bootcamp_app/controller/blog/state/blog_state.dart';
import 'package:bootcamp_app/model/blog_model.dart';
import 'package:bootcamp_app/views/screens/create_update_blog_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlogDetailsScreen extends ConsumerStatefulWidget {
  const BlogDetailsScreen({Key? key}) : super(key: key);

  @override
  _BlogDetailsScreenState createState() => _BlogDetailsScreenState();
}

class _BlogDetailsScreenState extends ConsumerState<BlogDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final blogDetailsState = ref.watch(blogDetailsProvider);
    final BlogModel? blogData = blogDetailsState is BlogDetailsSuccessState ? blogDetailsState.blogModel : null;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              ref.read(blogProvider.notifier).deleteBlog(blogId: blogData!.id!);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => CreateUpdateBlogScreen(
                          isCreate: false,
                          blogModel: blogData,
                        )),
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: blogDetailsState is BlogDetailsSuccessState
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    blogData!.image!,
                    // 'https://picsum.photos/300',
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          blogData.createdAt,
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          blogData.title!,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          blogData.subtitle!,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          blogData.description!,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
