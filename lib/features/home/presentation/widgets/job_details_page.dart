import 'package:flutter/material.dart';
import 'package:vertex/features/home/domain/entities/job_entity.dart';

import '../../../../utils/functions.dart';
import '../../../../widgets/screen_width_button.dart';

class JobDetailsPage extends StatefulWidget {
  final Map<String, dynamic> job;

  const JobDetailsPage({super.key, required this.job});

  @override
  State<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  @override
  Widget build(BuildContext context) {
    JobEntity currentJob = JobEntity.fromJson(widget.job);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title:
            Text("Job Details", style: Theme.of(context).textTheme.bodyMedium),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              primary: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: Text(
                      currentJob.name,
                      softWrap: true,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontSize: 23),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          aboutJobWidget(context, "Job Type", currentJob.type),
                          aboutJobWidget(
                              context, "Location", currentJob.location),
                          aboutJobWidget(
                              context, "Stipend", currentJob.stipend),
                          //add stipend
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Image.network(
                              currentJob.image ?? "",
                              fit: BoxFit.contain,
                              height:
                                  MediaQuery.of(context).size.height * 0.135 +
                                      15,
                              width:
                                  (MediaQuery.of(context).size.width - 90) / 2,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.error,
                                  size:
                                      MediaQuery.of(context).size.width * 0.08,
                                  color: Theme.of(context).colorScheme.onError,
                                );
                              },
                            ),
                          ),
                          aboutJobWidget(
                              context, "Duration", currentJob.duration),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.av_timer_rounded,
                          size: 30,
                          color: Theme.of(context).colorScheme.onError,
                        ),
                        Text("Apply By ${currentJob.applyBy}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontSize: 16,
                                    color:
                                        Theme.of(context).colorScheme.onError)),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: Card(
                      color: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .scrim,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Eligibility Criteria",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontSize: 17),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            Text(
                              "Education: ${currentJob.eligibilityCriteria.education}",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(fontSize: 16),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            Text(
                              "CGPA: ${currentJob.eligibilityCriteria.cgpa}",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(fontSize: 16),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            Text(
                              "Skills: ${currentJob.eligibilityCriteria.skills}",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: Card(
                      color: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .scrim,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Job Details",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontSize: 17),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            Text(
                              currentJob.details,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: Card(
                      color: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .scrim,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Contact for Help",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontSize: 17),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            Text(
                              currentJob.contact.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(fontSize: 16),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            Text(
                              currentJob.contact.phoneNo,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  )
                ],
              ),
            ),
            Positioned(
                bottom: 20,
                child: ScreenWidthButton(
                  buttonFunc: () {
                    launchURL(currentJob.website);
                  },
                  text: "Apply Now",
                ))
          ],
        ),
      ),
    );
  }
}

Widget aboutJobWidget(BuildContext context, String heading, String value) {
  return Container(
    width: (MediaQuery.of(context).size.width - 60) / 2,
    height: MediaQuery.of(context).size.height * 0.065,
    margin: const EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.scrim,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(6),
        color: Theme.of(context).cardColor),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(heading,
            style:
                Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16)),
        Text(value,
            style:
                Theme.of(context).textTheme.labelSmall!.copyWith(fontSize: 16))
      ],
    ),
  );
}

//Column(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       Opacity(
//         opacity: 0.45,
//         child: Padding(
//           padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
//           child: Container(
//             width: 160,
//             height: 47,
//             decoration: BoxDecoration(
//               color: Color(0xFFD9D9D9),
//               borderRadius: BorderRadius.circular(6),
//               border: Border.all(
//                 color: Colors.black,
//                 width: 1,
//               ),
//             ),
//           ),
//         ),
//       ),
//       Column(
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Padding(
//             padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//             child: Text(
//               heading,
//               style: TextStyle(
//                 fontFamily: 'Montserrat',
//                 fontSize: 16,
//                 letterSpacing: 0.0,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 2),
//             child: Opacity(
//               opacity: 0.7,
//               child: Text(
//                 value,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   fontFamily: 'Montserrat',
//                   fontSize: 16,
//                   letterSpacing: 0.0,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ],
//   )
