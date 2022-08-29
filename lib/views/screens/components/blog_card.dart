import 'package:bootcamp_app/controller/blog/blog_details_controller.dart';
import 'package:bootcamp_app/model/blog_model.dart';
import 'package:bootcamp_app/views/screens/blog_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlogCard extends ConsumerWidget {
  const BlogCard({Key? key, required this.blogModel}) : super(key: key);

  final BlogModel blogModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        ref.read(blogDetailsProvider.notifier).fetchBlogDetails(blogId: blogModel.id!);
        Navigator.push(context, CupertinoPageRoute(builder: (context) => const BlogDetailsScreen()));
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(color: Colors.blueGrey.withOpacity(0.1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              blogModel.image!,
              width: MediaQuery.of(context).size.width,
              height: 150,
              fit: BoxFit.cover,
              errorBuilder: (context, object, stackTrace) {
                return const Center(child: Text('Image not found'));
              },
            ),
            const SizedBox(height: 10),
            Text(
              blogModel.createdAt,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 5),
            Text(
              blogModel.title ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              blogModel.subtitle ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 5),
            Text(
              blogModel.description ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
