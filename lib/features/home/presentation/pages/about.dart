import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  AboutPage({super.key});
  final leads = [
    {
      "Abhijeet Jha":
          "https://github.com/Aman071106/IITApp/raw/main2/ContributorImages/AbhijeetJha.jpg"
    },
    {
      "Gaurav Kushawaha":
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
      "Gaurav Kushawaha":
          "https://github.com/Gaurav-Kushwaha-1225/Gaurav-Kushwaha-1225/raw/main/IMG20231002114533.jpg"
    },
    {
      "Shubham":
          "https://uxwing.com/wp-content/themes/uxwing/download/peoples-avatars/man-user-circle-icon.png"
    }
  ];
  final developers = [
    {
      "Shubh Sahu":
          "https://raw.githubusercontent.com/shubhxtech/addplayer/refs/heads/main/Screenshot%202025-02-13%20200538.png"
    },
    {
      "Gaurav Kushawaha":
          "https://github.com/Gaurav-Kushwaha-1225/Gaurav-Kushwaha-1225/raw/main/IMG20231002114533.jpg"
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Montserrat'),
      home: Scaffold(
        appBar: AppBar(
          title: const Center(
              child: Text(
            "About",
            style: TextStyle(
                fontSize: 22,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold),
          )),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                        "This app is your one-stop solution for everything related to IIT Mandi. Designed for students, faculty, and visitors, it offers features to simplify campus life, including:",
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF212121))),
                    const SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: Color(0xFF212121)), // Base style
                        children: [
                          TextSpan(
                            text: "- ",
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
                      text: const TextSpan(
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: Color(0xFF212121)), // Base style
                        children: [
                          TextSpan(
                            text: "- ",
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
                      text: const TextSpan(
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: Color(0xFF212121)), // Base style
                        children: [
                          TextSpan(
                            text: "- ",
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
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Project Leads:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 15,
                ),
                Contributors(leads),
                const Text(
                  "Developers: ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 15,
                ),
                Contributors(developers),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Design: ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 15,
                ),
                Contributors(designTeam),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container Contributors(List<Map<String, String>> contributors) {
    double h = contributors.length / 2 * 150;
    if (contributors.length % 2 != 0) h += 110;
    return Container(
      // color: Colors.amber,
      height: h,
      child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: contributors.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
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
                          fit: BoxFit.cover, contributors[index][name]!),
                    ),
                  ),
                ),
                Text(name)
              ],
            );
          }),
    );
  }
}
