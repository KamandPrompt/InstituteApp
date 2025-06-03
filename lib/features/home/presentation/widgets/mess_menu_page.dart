import 'package:flutter/material.dart';
import 'package:vertex/utils/constants.dart';

class MessMenuPage extends StatefulWidget {
  const MessMenuPage({super.key});

  @override
  State<MessMenuPage> createState() => _MessMenuPageState();
}

class _MessMenuPageState extends State<MessMenuPage> {
  @override
  Widget build(BuildContext context) {
    Map<String, Map<String, List<String>>> messMenu = Constants.messMenu;
    List<String> keys = messMenu.keys.toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text("Mess Menu", style: Theme.of(context).textTheme.bodyMedium),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ListView.separated(
          physics: const ClampingScrollPhysics(),
          primary: false,
          itemCount: keys.length,
          itemBuilder: (context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  keys[index],
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).primaryColor, fontSize: 20),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.005,
                ),
                for (var meal in messMenu[keys[index]]!.keys.toList())
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        meal,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onError),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.003,
                      ),
                      Text(messMenu[keys[index]]![meal]!.join(", "),
                          softWrap: true,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: 14)),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.005,
                      ),
                    ],
                  ),
              ],
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: MediaQuery.of(context).size.height * 0.03,
              thickness: 2,
              color: Theme.of(context).colorScheme.scrim,
            );
          },
        ),
      ),
    );
  }
}
