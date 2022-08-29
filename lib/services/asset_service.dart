import 'package:bootcamp_app/network/endpoints.dart';
import 'package:bootcamp_app/network/network_utils.dart';
import 'package:image_picker/image_picker.dart';

class AssetService {
  static pickImage() async {
    final ImagePicker picker = ImagePicker();

    var result = await picker.pickImage(source: ImageSource.gallery);
    if (result != null) {
      XFile image = result;

      print('image name  ${image.name}');
      print('image.mimeType ${image.mimeType}');
      print('image.path - ${image.path}');

      return image;
    }
  }

  static Future uploadImage({required image}) async {
    dynamic responseBody;

    try {
      responseBody = await Network.handleResponse(
        await Network.multiPartRequest(API.uploadImage, 'POST', file: image),
      );

      if (responseBody != null) {
        print(responseBody);
        return responseBody['url'];
      }
    } catch (error, stackTrace) {
      print('uploadImages() error = $error');
      print(stackTrace);
    }
  }
}
