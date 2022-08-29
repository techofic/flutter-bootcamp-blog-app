import 'package:bootcamp_app/controller/base/base_state.dart';
import 'package:bootcamp_app/controller/blog/state/blog_state.dart';
import 'package:bootcamp_app/model/blog_model.dart';
import 'package:bootcamp_app/network/endpoints.dart';
import 'package:bootcamp_app/network/network_utils.dart';
import 'package:riverpod/riverpod.dart';

final blogsListProvider = StateNotifierProvider<BlogsListController, BaseState>(
  (ref) => BlogsListController(ref: ref),
);

class BlogsListController extends StateNotifier<BaseState> {
  final Ref? ref;
  BlogsListController({this.ref}) : super(const InitialState());

  List<BlogModel> blogsList = [];

  

  Future fetchBlogsList() async {
    state = const LoadingState();
    dynamic responseBody;

    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.getAllBlogs),
      );
      if (responseBody != null) {
        blogsList = (responseBody['data'] as List<dynamic>).map((x) => BlogModel.fromJson(x)).toList();

        state = BlogsListSuccessState(blogsList);
      } else {
        state = const ErrorState();
      }
    } catch (error, stackTrace) {
      print('fetchBlogsList() error = $error');
      print(stackTrace);
      state = const ErrorState();
    }
  }
}
