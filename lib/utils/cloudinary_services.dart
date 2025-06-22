import "dart:developer";
import "dart:io";
import "package:file_picker/file_picker.dart";
import "package:http/http.dart" as http;
import "dart:convert";

import "package:vertex/utils/functions.dart";

Future<List<String>> uploadImagesToLNF(FilePickerResult? images) async {
  if (images == null || images.files.isEmpty) {
    return [];
  }

  final config = await loadEncryptedConfig();
  String cloudName = config["CLOUDINARY_CLOUD_NAME"] ?? "";
  List<String> imageUrls = [];

  for (PlatformFile image in images.files) {
    try {
      if (image.path!.contains('https://')) {
        imageUrls.add(image.path!);
        continue;
      }
      File imageFile = File(image.path!);
      var uri =
          Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/raw/upload");

      var request = http.MultipartRequest("POST", uri);
      request.fields["upload_preset"] = "lost_and_found";
      request.fields["resource_type"] = "raw"; // Change from "raw" to "image"

      var multipartFile =
          await http.MultipartFile.fromPath("file", imageFile.path);
      request.files.add(multipartFile);

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      // log(responseBody);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(responseBody);
        String imageUrl = jsonResponse["secure_url"];
        imageUrls.add(imageUrl);
        // log("Image uploaded successfully: $imageUrl");
      } else {
        // log("Image upload failed: ${response.statusCode}");
      }
    } catch (e) {
      log("Error uploading image: $e");
    }
  }

  return imageUrls;
}

Future<String?> uploadImageToNotifications(String image) async {
  final config = await loadEncryptedConfig();
  String cloudName = config["CLOUDINARY_CLOUD_NAME"] ?? "";

  try {
    File imageFile = File(image);
    var uri =
        Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/raw/upload");

    var request = http.MultipartRequest("POST", uri);
    request.fields["upload_preset"] = "notifications";
    request.fields["resource_type"] = "raw"; // Change from "raw" to "image"

    var multipartFile =
        await http.MultipartFile.fromPath("file", imageFile.path);
    request.files.add(multipartFile);

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    // log(responseBody);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(responseBody);
      String imageUrl = jsonResponse["secure_url"];
      // log("Image uploaded successfully: $imageUrl");
      return imageUrl;
    }
  } catch (e) {
    log("Error uploading image: $e");
  }
  return null;
}

Future<List<String>> uploadImagesToPosts(FilePickerResult? images) async {
  if (images == null || images.files.isEmpty) {
    return [];
  }

  final config = await loadEncryptedConfig();
  String cloudName = config["CLOUDINARY_CLOUD_NAME"] ?? "";
  List<String> imageUrls = [];

  for (PlatformFile image in images.files) {
    try {
      if (image.path!.contains('https://')) {
        imageUrls.add(image.path!);
        continue;
      }
      File imageFile = File(image.path!);
      var uri =
          Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/raw/upload");

      var request = http.MultipartRequest("POST", uri);
      request.fields["upload_preset"] = "vertex_feeds";
      request.fields["resource_type"] = "raw"; // Change from "raw" to "image"

      var multipartFile =
          await http.MultipartFile.fromPath("file", imageFile.path);
      request.files.add(multipartFile);

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      // log(responseBody);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(responseBody);
        String imageUrl = jsonResponse["secure_url"];
        imageUrls.add(imageUrl);
        // log("Image uploaded successfully: $imageUrl");
      }
    } catch (e) {
      log("Error uploading image: $e");
    }
  }

  return imageUrls;
}

Future<List<String>> uploadImagesToBNS(FilePickerResult? images) async {
  if (images == null || images.files.isEmpty) {
    return [];
  }

  final config = await loadEncryptedConfig();
  String cloudName = config["CLOUDINARY_CLOUD_NAME"] ?? "";
  List<String> imageUrls = [];

  for (PlatformFile image in images.files) {
    try {
      if (image.path!.contains('https://')) {
        imageUrls.add(image.path!);
        continue;
      }
      File imageFile = File(image.path!);
      var uri =
          Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/raw/upload");

      var request = http.MultipartRequest("POST", uri);
      request.fields["upload_preset"] = "buy_sell";
      request.fields["resource_type"] = "raw"; // Change from "raw" to "image"

      var multipartFile =
          await http.MultipartFile.fromPath("file", imageFile.path);
      request.files.add(multipartFile);

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      // log(responseBody);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(responseBody);
        String imageUrl = jsonResponse["secure_url"];
        imageUrls.add(imageUrl);
        // log("Image uploaded successfully: $imageUrl");
      }
    } catch (e) {
      log("Error uploading image: $e");
    }
  }

  return imageUrls;
}
