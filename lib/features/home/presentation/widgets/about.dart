import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  AboutPage({super.key});

  final leads = [
    {
      "Abhijeet Jha":
          "https://github.com/Aman071106/IITApp/raw/main2/ContributorImages/AbhijeetJha.jpg"
    },
    {
      "Gaurav Kushwaha":
          "https://github.com/Gaurav-Kushwaha-1225/Gaurav-Kushwaha-1225/raw/main/IMG20231002114533.jpg"
    },
    {
      "Shubh Sahu":
          "https://raw.githubusercontent.com/shubhxtech/addplayer/refs/heads/main/Screenshot%202025-02-13%20200538.png"
    }
  ];

  final designTeam = [
    {
      "Shubh Sahu":
          "https://raw.githubusercontent.com/shubhxtech/addplayer/refs/heads/main/Screenshot%202025-02-13%20200538.png"
    },
    {
      "Gaurav Kushwaha":
          "https://github.com/Gaurav-Kushwaha-1225/Gaurav-Kushwaha-1225/raw/main/IMG20231002114533.jpg"
    },
    {
      "Shubham":
          "https://uxwing.com/wp-content/themes/uxwing/download/peoples-avatars/man-user-circle-icon.png"
    }
  ];

  final developers = [
    {
      "Gaurav Kushwaha":
          "https://github.com/Gaurav-Kushwaha-1225/Gaurav-Kushwaha-1225/raw/main/IMG20231002114533.jpg"
    },
    {
      "Shubh Sahu":
          "https://raw.githubusercontent.com/shubhxtech/addplayer/refs/heads/main/Screenshot%202025-02-13%20200538.png"
    },
    {
      "Aman Gupta":
          "https://github.com/Aman071106/IITApp/raw/main2/ContributorImages/profilePicAman.jpg"
    },
    {
      "Harsh Yadav":
          "https://github.com/Aman071106/IITApp/raw/main2/ContributorImages/profilePicHarsh.jpg"
    },
    {
      "Shivam Soni":
          "https://github.com/RandomYapper/Assests/raw/main/self_photo.jpg"
    },
    {
      "Utkarsh Sahu": "https://github.com/Utkarsh-1-Sahu/Image/raw/main/Utk.jpg"
    },
    {
      "Ayush Raj":
          "https://github.com/ayush18-pixel/cafeforvertex/raw/main/images/IMG_1173.JPG"
    },
    {
      "Anshika Goel":
          "https://github.com/anshika476/Assests/raw/main/anshika.png"
    },
    {
      "Naman Bhatia":
          "https://github.com/naman-bhatia-2006/project-1/raw/main/gitphoto.jpg"
    },
    {"Kripa Kanodia": "https://github.com/cooper235/image/raw/main/image.jpg"},
    {
      "Nishant":
          "https://github.com/Nishant-coder-cpu/image/raw/main/IMG_my.JPG"
    },
    {"Dhanad": "https://github.com/Blackcoat123/My-Photo/raw/main/dhanad.jpg"},
  ];

  Widget contributorsWidget(List<Map<String, String>> contributors) {
    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: contributors.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          String name = contributors[index].keys.first;
          return Column(
            children: [
              CircleAvatar(
                radius: 50,
                child: ClipOval(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.onPrimary);
                      },
                      contributors[index][name]!,
                      errorBuilder: (context, object, trace) {
                        return Icon(Icons.error_outline_outlined,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 30);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                name,
                style: Theme.of(context).textTheme.labelSmall,
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text("About", style: Theme.of(context).textTheme.bodyMedium),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "This app is your one-stop solution for everything related to IIT Mandi. Designed for students, faculty, and visitors, it offers features to simplify campus life, including:",
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.labelSmall,
                  // Base style
                  children: const [
                    TextSpan(
                      text: "○ ",
                    ),
                    TextSpan(
                      text: "Event Updates",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(
                      text:
                          ": Stay informed about upcoming academic and cultural events.",
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.labelSmall,
                  // Base style
                  children: const [
                    TextSpan(
                      text: "○ ",
                    ),
                    TextSpan(
                      text: "Navigation",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(
                      text:
                          ": Explore the campus with interactive maps and directions.",
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.labelSmall,
                  // Base style
                  children: const [
                    TextSpan(
                      text: "○ ",
                    ),
                    TextSpan(
                      text: "Others",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(
                        text:
                            ": Quick access to features like lost/found, buy/sell and other achievements updates."),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              /*Text(
                "Project Leads:",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 20,
              ),
              contributorsWidget(leads),
              Text(
                "Developers: ",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 20,
              ),
              contributorsWidget(developers),
              Text(
                "Design: ",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 20,
              ),
              contributorsWidget(designTeam),*/
            ],
          ),
        ),
      ),
    );
  }
}
