import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uhl_link/config/routes/routes_consts.dart';
import 'package:uhl_link/features/home/domain/entities/job_entity.dart';
import 'package:uhl_link/features/home/presentation/bloc/job_portal_bloc/job_bloc.dart';
import 'package:uhl_link/features/home/presentation/widgets/job_card.dart';

class JobPortalPage extends StatefulWidget {
  const JobPortalPage({super.key});

  @override
  State<JobPortalPage> createState() => _JobPortalPageState();
}

class _JobPortalPageState extends State<JobPortalPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3));
    BlocProvider.of<JobPortalBloc>(context).add(const GetJobsEvent());
  }

  List<JobEntity> jobs = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JobPortalBloc, JobPortalState>(
        builder: (context, state) {
      if (state is JobsLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is JobsLoaded) {
        jobs = state.jobs;
        return ListView.separated(
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final job = jobs[index];
            return JobCard(
              title: job.name,
              company: job.company, // Safe fallback
              location: job.location,
              stipend: job.stipend,
              jobType: job.type,
              image: job.image ?? "",
              onViewDetails: () {
                GoRouter.of(context).pushNamed(
                    UhlLinkRoutesNames.jobDetailsPage,
                    pathParameters: {"job": jsonEncode(job.toMap())});
              },
            );
          },
          separatorBuilder: (context, index) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.01,
            );
          },
        );
      } else if (state is JobsLoadingError) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }
}
