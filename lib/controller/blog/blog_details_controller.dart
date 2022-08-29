import 'package:bootcamp_app/controller/base/base_state.dart';
import 'package:bootcamp_app/controller/blog/state/blog_state.dart';
import 'package:bootcamp_app/model/blog_model.dart';
import 'package:bootcamp_app/network/endpoints.dart';
import 'package:bootcamp_app/network/network_utils.dart';
import 'package:riverpod/riverpod.dart';

final blogDetailsProvider = StateNotifierProvider<BlogDetailsController, BaseState>(
  (ref) => BlogDetailsController(ref: ref),
);

class BlogDetailsController extends StateNotifier<BaseState> {
  final Ref? ref;
  BlogDetailsController({this.ref}) : super(const InitialState());

  BlogModel? blogModel;

  Future fetchBlogDetails({required int blogId}) async {
    state = const LoadingState();
    dynamic responseBody;

    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.getBlogDetails(blogId: blogId)),
      );
      if (responseBody != null) {
        blogModel = BlogModel.fromJson(responseBody['data'][0]);

        state = BlogDetailsSuccessState(blogModel!);
      } else {
        state = const ErrorState();
      }
    } catch (error, stackTrace) {
      print('fetchBlogDetails() error = $error');
      print(stackTrace);
      state = const ErrorState();
    }
  }
}
