import 'package:flutter/material.dart';

class JobCard extends StatelessWidget {
  final String title;
  final String company;
  final String location;
  final String stipend;
  final String jobType;
  final String image;
  final VoidCallback onViewDetails;

  const JobCard({
    super.key,
    required this.title,
    required this.company,
    required this.location,
    required this.stipend,
    required this.jobType,
    required this.image,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          side: BorderSide(
        color: Theme.of(context).colorScheme.scrim,
        width: 1.5,
      )),
      color: Theme.of(context).cardColor,
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: 18)),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.005,
                      ),
                      Text(
                        company,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: MediaQuery.of(context).size.width * 0.15,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .scrim,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(

                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      image,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.error,
                            size: MediaQuery.of(context).size.width * 0.08,
                            color: Theme.of(context).colorScheme.onError);
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.015),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.my_location_rounded,
                        size: MediaQuery.of(context).size.width * 0.05,
                        color: Theme.of(context).colorScheme.onSurface),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                    Text(location,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(fontSize: 17)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Job Type:",
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(fontSize: 17)),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                  ],
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.005),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(Icons.attach_money,
                        size: MediaQuery.of(context).size.width * 0.05,
                        color: Theme.of(context).colorScheme.onSurface),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                    Text(stipend,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(fontSize: 17)),
                  ],
                ),
                Row(
                  children: [
                    Text(jobType,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(fontSize: 17)),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.025),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            Divider(
                height: 1.5,
                color:
                    Theme.of(context).colorScheme.scrim),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onViewDetails,
                style: TextButton.styleFrom(
                    fixedSize: Size.fromHeight(
                        MediaQuery.of(context).size.width * 0.01)),
                child: Text('View More',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 16, color: Theme.of(context).primaryColor)),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.005),
          ],
        ),
      ),
    );
  }
}
