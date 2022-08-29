import 'dart:io';

import 'package:bootcamp_app/controller/base/base_state.dart';
import 'package:bootcamp_app/controller/blog/blog_controller.dart';
import 'package:bootcamp_app/controller/blog/state/blog_state.dart';
import 'package:bootcamp_app/model/blog_model.dart';
import 'package:bootcamp_app/services/asset_service.dart';
import 'package:bootcamp_app/views/styles/k_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class CreateUpdateBlogScreen extends ConsumerStatefulWidget {
  final bool isCreate;
  final BlogModel? blogModel;
  const CreateUpdateBlogScreen({Key? key, this.isCreate = true, this.blogModel}) : super(key: key);

  @override
  _CreateUpdateBlogScreenState createState() => _CreateUpdateBlogScreenState();
}

class _CreateUpdateBlogScreenState extends ConsumerState<CreateUpdateBlogScreen> {
  XFile? pickedImage;
  String? uplodedImageUrl;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (!widget.isCreate) {
      titleController.text = widget.blogModel!.title ?? '';
      subtitleController.text = widget.blogModel!.subtitle ?? '';
      descriptionController.text = widget.blogModel!.description ?? '';
      uplodedImageUrl = widget.blogModel!.image ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final blogState = ref.watch(blogProvider);

    ref.listen(
      blogProvider,
      (_, state) {
        if (state is BlogSuccessState) {
          Navigator.pop(context);
        }
      },
    );

    return Scaffold(
      appBar: AppBar(title: Text('${widget.isCreate ? 'Create' : 'Update'} Blog')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            KTextField(
              controller: titleController,
              hintText: 'Enter title',
            ),
            KTextField(
              controller: subtitleController,
              hintText: 'Enter subtitle',
            ),
            KTextField(
              controller: descriptionController,
              hintText: 'Enter description',
              minLines: 4,
              maxLines: null,
            ),
            InkWell(
              onTap: () async {
                pickedImage = await AssetService.pickImage();
                print('pickedImage = $pickedImage');
                setState(() {});
                if (pickedImage != null) {
                  uplodedImageUrl = await AssetService.uploadImage(image: File(pickedImage!.path));
                  print('uplodedImageUrl = $uplodedImageUrl');
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 235,
                margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(6)),
                child: pickedImage != null
                    ? Image.file(
                        File(pickedImage!.path),
                      )
                    : !widget.isCreate
                        ? Image.network(widget.blogModel!.image!)
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.cloud_upload_rounded, size: 35, color: Colors.grey),
                              Text('Upload image'),
                            ],
                          ),
              ),
            ),
            ElevatedButton(
              onPressed: blogState is LoadingState
                  ? null
                  : () async {
                      widget.isCreate
                          ? await ref.read(blogProvider.notifier).createBlog(
                                title: titleController.text,
                                subtitle: subtitleController.text,
                                description: descriptionController.text,
                                image: uplodedImageUrl,
                              )
                          : await ref.read(blogProvider.notifier).updateBlog(
                                title: titleController.text,
                                subtitle: subtitleController.text,
                                description: descriptionController.text,
                                image: uplodedImageUrl,
                                blogId: widget.blogModel!.id,
                              );
                      // Navigator.pop(context);
                    },
              style: ElevatedButton.styleFrom(
                primary: blogState is LoadingState ? Colors.grey : Colors.blue,
              ),
              child: Text(
                blogState is LoadingState
                    ? 'Please wait...'
                    : widget.isCreate
                        ? 'Create'
                        : 'Update',
              ),
            )
          ],
        ),
      ),
    );
  }
}
