import 'package:flutter/material.dart';
import 'package:vertex/features/home/presentation/widgets/dashboard_card.dart';

import '../../../../utils/functions.dart';

class QuickLinksPage extends StatelessWidget {
  QuickLinksPage({super.key});

  final Map<String, List<List<dynamic>>> iitMandiLinks = {
    "Institute": [
      [
        "IIT Mandi\nWebsite",
        "https://www.iitmandi.ac.in/",
        "https://dcs.iitmandi.ac.in/images/logo_hires.png"
      ],
      [
        "Student\nGymkhana",
        "https://iitmandi.co.in/",
        "https://dcs.iitmandi.ac.in/images/logo_hires.png"
      ]
    ],
    "Academic": [
      [
        "UG Academic",
        "https://iitmandi.co.in/ug_acad.html",
        "https://scontent.flko13-1.fna.fbcdn.net/v/t1.6435-9/156115286_113182970821703_6848107539166284676_n.png?_nc_cat=107&ccb=1-7&_nc_sid=a5f93a&_nc_ohc=is8ZuS7ZD68Q7kNvwFZdEcG&_nc_oc=AdndBasVE6VzneSx0zSDxSOiQQmerwhuBR3vYp8UA-U4RRa595CeAlFwrqWRhQp96cg-gI9kBeW4rQFZSbZ-xrvR&_nc_zt=23&_nc_ht=scontent.flko13-1.fna&_nc_gid=2rnj4moxB92t2CQDdEYupA&oh=00_AfOde4WaC2jTNf8-EQ4PeNqTrhbxPRissLimgoHU1tvKlw&oe=68777618"
      ],
      [
        "PG Academic",
        "https://iitmandi.co.in/pg_acad.html",
        "https://scontent.flko13-1.fna.fbcdn.net/v/t1.6435-9/156115286_113182970821703_6848107539166284676_n.png?_nc_cat=107&ccb=1-7&_nc_sid=a5f93a&_nc_ohc=is8ZuS7ZD68Q7kNvwFZdEcG&_nc_oc=AdndBasVE6VzneSx0zSDxSOiQQmerwhuBR3vYp8UA-U4RRa595CeAlFwrqWRhQp96cg-gI9kBeW4rQFZSbZ-xrvR&_nc_zt=23&_nc_ht=scontent.flko13-1.fna&_nc_gid=2rnj4moxB92t2CQDdEYupA&oh=00_AfOde4WaC2jTNf8-EQ4PeNqTrhbxPRissLimgoHU1tvKlw&oe=68777618"
      ],
    ],
    "Technical Society": [
      [
        "SnTC\nWebsite",
        "https://sntc.iitmandi.co.in/",
        "https://sntc.iitmandi.co.in/images/logo_nobg.png"
      ],
      [
        "Kamand\nPrompt",
        "https://pc.iitmandi.co.in/",
        "https://raw.githubusercontent.com/dev-community-dev/temp/main/HD_kamandprompt.jpg"
      ],
      [
        "Robotronics\nClub",
        "https://robotronics.iitmandi.co.in/",
        "https://yt3.googleusercontent.com/ytc/AIdro_mdtFt02CYLJYA5d-av_qMdgjHTtCDIsfuhqjOeClYFqCM=s160-c-k-c0x00ffffff-no-rj"
      ],
      [
        "Space Technology & Astronomy Cell",
        "https://stac.iitmandi.co.in/",
        "https://miro.medium.com/v2/resize:fit:2400/1*TuaClC2f0aRRTK8aA7y8cA.png"
      ],
      [
        "Yantrik\nClub",
        "https://yantrik.iitmandi.co.in/",
        "https://yantrikiitmandi.github.io/images/Favicon/Logo.png"
      ],
      [
        "Nirmaan\nClub",
        "https://nirmaan.iitmandi.co.in/",
        "https://d1fdloi71mui9q.cloudfront.net/nVg9vLC7SJyuooohtNMm_0o7jxu7oXGNe6746"
      ],
      [
        "SAE\nClub",
        "https://clubsae.iitmandi.co.in/about-us",
        "https://scontent.flko13-1.fna.fbcdn.net/v/t39.30808-1/300282907_2808443049464161_852160344148903201_n.jpg?stp=dst-jpg_s200x200_tt6&_nc_cat=111&ccb=1-7&_nc_sid=2d3e12&_nc_ohc=mG1j9DAq6mYQ7kNvwEBH2jM&_nc_oc=AdnO-hoYOTTfyfktm5OiScSlNke0dGK68NqKQJKA6zvSeyjIl5Zjdzj3ZQ6dhQ_ioujKUzpIys5TijkGUSgTZ-UV&_nc_zt=24&_nc_ht=scontent.flko13-1.fna&_nc_gid=d8i9NhOnpZZ8IEt-xVrv_A&oh=00_AfMqC1zNAxumnIOqgIPFq5NkfWn7op8VdwEEy8eDQHUpSw&oe=6855CD51"
      ],
      [
        "Entrepreneurship\nCell",
        "https://ecell.iitmandi.co.in/",
        "https://ecell.iitmandi.co.in/images/ecell.png"
      ],
      [
        "Kamand BioEngineering Group",
        "https://www.instagram.com/kbg_iitmandi/",
        "https://ugc.production.linktr.ee/J6H7ApXRGA363gYf2lAg_At7Q82ZaDm2XD9wK?io=true&size=avatar-v3_0"
      ],
    ],
    'Cells': [
      [
        "Google Developer Group",
        "https://www.linkedin.com/company/google-developer-groups-iit-mandi/",
        "https://media.licdn.com/dms/image/v2/D560BAQEJkYNliPLrTA/company-logo_200_200/company-logo_200_200/0/1730527502463?e=1755734400&v=beta&t=cTJ2t49HJOoKyFIm1Yb5pF7l1SYIgbYsJTelzR39BuA"
      ],
      [
        "Heuristics Cell",
        "https://kamandprompt.github.io/heuristics/HTML/",
        "https://kamandprompt.github.io/heuristics/HTML/img/logo-dark.png"
      ],
      [
        "CG2D - Game\nDevelopment Cell",
        "https://linktr.ee/cg2d?utm_source=linktree_profile_share&ltsid=5316f635-f23a-459c-9979-404e8fc00412",
        "https://ugc.production.linktr.ee/YGe1E2x4QBiEs0lLkHLH_image?io=true&size=avatar-v3_0"
      ],
      [
        "System Administration and Infosec Cell (SAIC)",
        "https://saic.iitmandi.co.in/",
        "https://avatars.githubusercontent.com/u/113166810?s=200&v=4"
      ]
    ],
    'Cultural Society': [
      [
        "Society Website",
        "https://iitmandi.co.in/cultural.html",
        "https://dcs.iitmandi.ac.in/images/logo_hires.png"
      ],
      [
        "Designauts - Designing Club",
        "https://linktr.ee/designauts.iitmandi?utm_source=linktree_profile_share&ltsid=f2e68197-466f-429c-a14e-e5337e19f80d",
        "https://scontent.flko13-1.fna.fbcdn.net/v/t39.30808-1/291616245_421202806686493_2165792946564014054_n.jpg?stp=dst-jpg_s200x200_tt6&_nc_cat=109&ccb=1-7&_nc_sid=2d3e12&_nc_ohc=WRTMq-eR07YQ7kNvwERSz7e&_nc_oc=Adky3_ncDRQZWvWnUYKduKJ1bIh6BCO09ZGLdBw7A11GaFrqS5t0fDRa-WS3HNRQztI&_nc_zt=24&_nc_ht=scontent.flko13-1.fna&_nc_gid=cthAFID0eCemXHo_DE2qSQ&oh=00_AfPt24Ak4Gx44Te8AmGo3R5uP-m75C5txgcMzsZ0aiR3TQ&oe=6855D8B9"
      ],
      [
        "Gustaakh Saale - Dramatics Club",
        "https://www.instagram.com/gustaakhsaale.iitmandi/?hl=en",
        "https://raw.githubusercontent.com/dev-community-dev/temp/main/HD_dramasociety_iitmandi.jpg"
      ],
      [
        "Music Club - Uhl Beats",
        "https://musicclub.iitmandi.co.in/",
        "https://raw.githubusercontent.com/dev-community-dev/temp/main/logo1.png"
      ],
      [
        "Dance Club - Uhl Dance Crew (UDC)",
        "https://www.instagram.com/udc.iitmandi/?hl=en",
        "https://raw.githubusercontent.com/dev-community-dev/temp/main/HD_udc.iitmandi.jpg"
      ],
      [
        "Photography Club - Shutterbugs",
        "https://www.instagram.com/shutterbugs.iitmandi/",
        "https://raw.githubusercontent.com/dev-community-dev/temp/main/HD_shutterbugs.iitmandi%20(1).jpg"
      ],
      [
        "Movie Making Club - Perception",
        "https://www.youtube.com/@PerceptionIITMandi",
        "https://yt3.googleusercontent.com/ytc/AIdro_m7yKGuFqOhtCiHR-8w6L2a-A8RAj60bPClyBo784RKig=s160-c-k-c0x00ffffff-no-rj"
      ],
      [
        "SPIC\nMACAY",
        "https://www.youtube.com/@SPICMACAYIITMANDI",
        "https://yt3.googleusercontent.com/6aYrEufKCmznqx-C8yadBswItDllHZjei3QPCYvwZvfrUCaEXCYZYPWPgPHsw6Rr_8CGEDyGpw=s160-c-k-c0x00ffffff-no-rj"
      ]
    ],
    'Sports Society': [
      [
        'Socity Website',
        "https://iitmandi.co.in/sports.html",
        "https://dcs.iitmandi.ac.in/images/logo_hires.png"
      ],
      [
        'Mountain Biking Club',
        "https://mtb.iitmandi.co.in/",
        "https://mtb.iitmandi.co.in/assets/MTBlogo-51dc0387.png"
      ],
      [
        'Hiking and Trekking Club',
        "https://hnt.iitmandi.co.in/",
        "https://hnt.iitmandi.co.in/assets/logo.png"
      ],
    ],
    "Literary Society": [
      [
        "Society Website",
        "https://iitmandi.co.in/literary.html",
        "https://ugc.production.linktr.ee/7344d94c-4bd1-4225-b497-94ada30612e8_1000018149.png?io=true&size=avatar-v3_0"
      ],
      [
        "Debating Club",
        "https://iitmandi.co.in/literary.html",
        "https://ugc.production.linktr.ee/7344d94c-4bd1-4225-b497-94ada30612e8_1000018149.png?io=true&size=avatar-v3_0"
      ],
      [
        "Writing Club",
        "https://www.linkedin.com/company/uhllekh/",
        "https://media.licdn.com/dms/image/v2/D4D0BAQHgxVtBgudOvA/company-logo_200_200/company-logo_200_200/0/1693765050913/uhllekh_logo?e=1755734400&v=beta&t=t6OJXKycoOegaImUWJ5-1BjthwhGKzp352RqXgYp26A"
      ],
      [
        "Quizzing Club",
        "https://www.instagram.com/qurosity_iitmandi/",
        "https://th.bing.com/th/id/OIP.pMTnyILp9nwUTtSygy_b5QAAAA?r=0&o=7rm=3&rs=1&pid=ImgDetMain&cb=idpwebpc1"
      ],
      [
        "Student Media Body - Griffinsight",
        "https://www.linkedin.com/company/griffinsight/",
        "https://media.licdn.com/dms/image/v2/D4D0BAQGV81nIHLPEvw/company-logo_200_200/company-logo_200_200/0/1667474581349/griffinsight_logo?e=1755734400&v=beta&t=Uyhf_aZsrm3iOgliy1OkBqOUc1mMZ5wVx4bU8ZNmysQ"
      ]
    ],
    'Others': [
      [
        "Hostel\nAffairs",
        "https://iitmandi.co.in/hostel.html",
        "https://dcs.iitmandi.ac.in/images/logo_hires.png"
      ],
      [
        "Research\nSociety",
        "https://iitmandi.co.in/research.html",
        "https://dcs.iitmandi.ac.in/images/logo_hires.png"
      ]
    ]
  };

  @override
  Widget build(BuildContext context) {
    List<String> keys = iitMandiLinks.keys.toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title:
            Text("Quick Links", style: Theme.of(context).textTheme.bodyMedium),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: ListView.separated(
            primary: true,
            physics: const ClampingScrollPhysics(),
            itemCount: iitMandiLinks.length,
            itemBuilder: (context, idx) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                  Text(keys[idx],
                      style: Theme.of(context).textTheme.bodyMedium),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                  GridView.count(
                    crossAxisCount: 2,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    shrinkWrap: true,
                    primary: false,
                    childAspectRatio: 1.1,
                    children: [
                      for (int i = 0; i < iitMandiLinks[keys[idx]]!.length; i++)
                        DashboardCard(
                          title: iitMandiLinks[keys[idx]]![i][0],
                          icon: iitMandiLinks[keys[idx]]![i][2],
                          onTap: () async {
                            await launchURL(iitMandiLinks[keys[idx]]![i][1]);
                          },
                          maxLines: 2,
                        ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                ],
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                thickness: 2,
                color: Theme.of(context).colorScheme.scrim,
              );
            }),
      ),
    );
  }
}
