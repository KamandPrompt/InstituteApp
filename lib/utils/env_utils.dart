import 'package:flutter_dotenv/flutter_dotenv.dart';

/// ✅ Reads admin emails from `.env` file
List<String> getAdminEmails() {
  String? adminEmailsString = dotenv.env["ADMIN_EMAILS"];
  if (adminEmailsString == null || adminEmailsString.isEmpty) {
    return [];
  }
  return adminEmailsString.split(',').map((email) => email.trim()).toList();
}

/// ✅ Checks if a user is an admin
bool isAdmin(String email) {
  return getAdminEmails().contains(email);
}
