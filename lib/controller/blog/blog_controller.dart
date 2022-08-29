import 'package:bootcamp_app/controller/base/base_state.dart';
import 'package:bootcamp_app/controller/blog/blog_details_controller.dart';
import 'package:bootcamp_app/controller/blog/blogs_list_controller.dart';
import 'package:bootcamp_app/controller/blog/state/blog_state.dart';
import 'package:bootcamp_app/model/blog_model.dart';
import 'package:bootcamp_app/network/endpoints.dart';
import 'package:bootcamp_app/network/network_utils.dart';
import 'package:riverpod/riverpod.dart';

final blogProvider = StateNotifierProvider<BlogController, BaseState>(
  (ref) => BlogController(ref: ref),
);

class BlogController extends StateNotifier<BaseState> {
  final Ref? ref;
  BlogController({this.ref}) : super(const InitialState());

  Future createBlog({title, subtitle, description, image}) async {
    state = const LoadingState();

    dynamic requestBody = {
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'image': image,
    };
    dynamic responseBody;

    try {
      responseBody = await Network.handleResponse(
        await Network.postRequest(API.createBlog, requestBody),
      );
      if (responseBody != null) {
        BlogModel createdBlog = BlogModel.fromJson(responseBody['student']);
        print('createdBlog = $createdBlog');

        List<BlogModel> blogsList = ref!.read(blogsListProvider.notifier).blogsList;
        blogsList.add(createdBlog);

        ref!.read(blogsListProvider.notifier).state = BlogsListSuccessState(blogsList);

        state = const BlogSuccessState();
      } else {
        state = const ErrorState();
      }
    } catch (error, stackTrace) {
      print('createBlog() error = $error');
      print(stackTrace);
      state = const ErrorState();
    }
  }

  Future updateBlog({title, subtitle, description, image, blogId}) async {
    state = const LoadingState();

    dynamic requestBody = {
      'id': blogId,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'image': image,
    };
    dynamic responseBody;

    try {
      responseBody = await Network.handleResponse(
        await Network.postRequest(API.updateBlog, requestBody),
      );
      if (responseBody != null) {
        BlogModel blogData = ref!.read(blogDetailsProvider.notifier).blogModel!;
        blogData.title = title;
        blogData.subtitle = subtitle;
        blogData.description = description;
        blogData.image = image;

        ref!.read(blogDetailsProvider.notifier).state = BlogDetailsSuccessState(blogData);

        state = const BlogSuccessState();
      } else {
        state = const ErrorState();
      }
    } catch (error, stackTrace) {
      print('updateBlog() error = $error');
      print(stackTrace);
      state = const ErrorState();
    }
  }

  Future deleteBlog({required int blogId}) async {
    state = const LoadingState();

    dynamic requestBody = {};
    dynamic responseBody;

    try {
      responseBody = await Network.handleResponse(
        await Network.postRequest(API.deleteBlog(blogId: blogId), requestBody),
      );
      if (responseBody != null) {
        List<BlogModel> blogsList = ref!.read(blogsListProvider.notifier).blogsList;
        blogsList.removeWhere((element) => element.id == blogId);

        ref!.read(blogsListProvider.notifier).state = BlogsListSuccessState(blogsList);
        state = const BlogSuccessState();
      } else {
        state = const ErrorState();
      }
    } catch (error, stackTrace) {
      print('deleteBlog() error = $error');
      print(stackTrace);
      state = const ErrorState();
    }
  }
}
