import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:vertex/features/home/data/models/job_model.dart';

class JobPortalDB {
  static Db? db;
  static DbCollection? collection;

  JobPortalDB();

  static Future<void> connect(String connectionURL) async {
    db = await Db.create(connectionURL);
    await db?.open();
    inspect(db);
    collection = db?.collection('Job Portal');
  }

  // Get All Data Method
  Future<List<Job>> getJobs() async {
    try {
      final jobs = await collection?.find().toList();
      if (jobs != null) {
        return jobs.map((job) => Job.fromJson(job)).toList();
      } else {
        return [];
      }
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  // Close Connection
  Future<void> close() async {
    await db?.close();
    // print('Connection to MongoDB closed');
  }
}
