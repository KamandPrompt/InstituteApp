import 'package:vertex/utils/functions.dart';

Future<List<String>> getAdminEmails() async {
  final config = await loadEncryptedConfig();
  String adminEmailsString = config["POR_EMAILS"] ?? "";
  if (adminEmailsString.isEmpty) {
    return [];
  }
  return adminEmailsString.split(',').map((email) => email.trim()).toList();
}

Future<bool> isAdmin(String email) async {
  final adminEmails = await getAdminEmails();
  return adminEmails.contains(email);
}
