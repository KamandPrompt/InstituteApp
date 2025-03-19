import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uhl_link/features/home/presentation/bloc/feed_page_bloc/feed_bloc.dart';

import '../../../../widgets/form_field_widget.dart';
import '../../../../widgets/screen_width_button.dart';

class FeedAddItemPage extends StatefulWidget {
  final Map<String, dynamic> user;
  const FeedAddItemPage({super.key, required this.user});

  @override
  State<FeedAddItemPage> createState() => _FeedAddItemPageState();
}

class _FeedAddItemPageState extends State<FeedAddItemPage> {
  bool imageSelected = false;

  // 
  final TextEditingController titleController = TextEditingController();
  final FocusNode titleFocusNode = FocusNode();
  String? errorTitleValue;
  final GlobalKey<FormState> titleKey = GlobalKey();
  // 
  final TextEditingController hostController = TextEditingController();
  final FocusNode hostFocusNode = FocusNode();
  String? errorHostValue;
  final GlobalKey<FormState> hostKey = GlobalKey();
  // 
  final TextEditingController linkController = TextEditingController();
  final FocusNode linkFocusNode = FocusNode();
  String? errorLinkValue;
  final GlobalKey<FormState> linkKey = GlobalKey();
  // 
  final TextEditingController descriptionController = TextEditingController();
  final FocusNode descriptionFocusNode = FocusNode();
  String? errorDescriptionValue;
  final GlobalKey<FormState> descriptionKey = GlobalKey();

  FilePickerResult? picker;

  Future<void> pickImage() async {
    try {
      FilePickerResult? files = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.custom,
          allowedExtensions: ["jpg", "jpeg", "png", "gif"]);
      if (files != null && files.files.length <= 4) {
        setState(() {
          picker = files;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Max. 4 Images is Allowed.",
                style: Theme.of(context).textTheme.labelSmall),
            backgroundColor: Theme.of(context).cardColor));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error uploading images.",
              style: Theme.of(context).textTheme.labelSmall),
          backgroundColor: Theme.of(context).cardColor));
    }
  }

  bool itemAdding = false;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    titleFocusNode.dispose();
    hostController.dispose();
    hostFocusNode.dispose();
    linkController.dispose();
    linkFocusNode.dispose();
    descriptionController.dispose();
    descriptionFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final aspectRatio = MediaQuery.of(context).size.aspectRatio;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title:
            Text("Add Feeds", style: Theme.of(context).textTheme.bodyMedium),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: BlocListener<FeedBloc, FeedState>(
        listener: (context, state) {
          if (state is FeedAddingItem) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Adding feed...",
                    style: Theme.of(context).textTheme.labelSmall),
                backgroundColor: Theme.of(context).cardColor));
            setState(() {
              itemAdding = true;
            });
          } else if (state is FeedItemAdded) {
            setState(() {
              itemAdding = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Feed added successfully",
                    style: Theme.of(context).textTheme.labelSmall),
                backgroundColor: Theme.of(context).cardColor));
            GoRouter.of(context).pop();
          } else if (state is FeedItemsAddingError) {
            setState(() {
              itemAdding = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message,
                    style: Theme.of(context).textTheme.labelSmall),
                backgroundColor: Theme.of(context).cardColor));
            GoRouter.of(context).pop();
          } else {
            setState(() {
              itemAdding = false;
            });
          }
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                physics: const ClampingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await pickImage();
                      },
                      child: Container(
                        width: width - 40,
                        height: height * 0.3,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          border: Border.all(
                              color: Theme.of(context).colorScheme.scrim,
                              width: 1.5),
                        ),
                        child: Center(
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            child: (picker == null || picker!.files.isEmpty)
                                ? Icon(
                                    Icons.image_rounded,
                                    color: Theme.of(context).colorScheme.scrim,
                                    size: aspectRatio * 150,
                                  )
                                : SizedBox(
                                    width: width - 40,
                                    height: height * 0.3,
                                    child: GridView.builder(
                                        itemCount: picker!.files.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Image.file(
                                            File(picker!.files[index].path!),
                                            fit: BoxFit.cover,
                                            alignment: Alignment.center,
                                          );
                                        }),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    FormFieldWidget(
                      focusNode: titleFocusNode,
                      fieldKey: titleKey,
                      controller: titleController,
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Feed title is required.';
                        }
                        return null;
                      },
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      errorText: errorTitleValue,
                      prefixIcon: Icons.feed,
                      showSuffixIcon: false,
                      hintText: "Event title",
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: height * 0.02),
                    FormFieldWidget(
                      focusNode: hostFocusNode,
                      fieldKey: hostKey,
                      controller: hostController,
                      obscureText: false,
                      validator: (value) {
                        return null;
                      },
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      errorText: errorHostValue,
                      prefixIcon: Icons.person,
                      showSuffixIcon: false,
                      hintText: "Enter host (Club/School)",
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: height * 0.02),
                    FormFieldWidget(
                      focusNode: descriptionFocusNode,
                      fieldKey: descriptionKey,
                      controller: descriptionController,
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Feed description is required.';
                        }
                        return null;
                      },
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      errorText: errorDescriptionValue,
                      prefixIcon: Icons.description_rounded,
                      showSuffixIcon: false,
                      hintText: "Enter feed description",
                      textInputAction: TextInputAction.newline,
                    ),
                    SizedBox(height: height * 0.02),
                    FormFieldWidget(
                      focusNode: linkFocusNode,
                      fieldKey: linkKey,
                      controller: linkController,
                      obscureText: false,
                      validator: (value) {
                        return null;
                      },
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      errorText: errorLinkValue,
                      prefixIcon: Icons.link_rounded,
                      showSuffixIcon: false,
                      hintText: "Enter feed required link",
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: height * 0.08),
                  ],
                ),
              ),
              Visibility(
                visible: MediaQuery.of(context).viewInsets.bottom == 0,
                child: Positioned(
                    bottom: 20,
                    child: ScreenWidthButton(
                      text: "Add Feed",
                      buttonFunc: () {
                        final bool isTitleValid =
                            titleKey.currentState!.validate();
                        final bool isHostValid =
                            hostKey.currentState!.validate();
                        final bool isLinkValid =
                            linkKey.currentState!.validate();
                        final bool isDescriptionValid =
                            descriptionKey.currentState!.validate();

                        if (picker == null || picker!.files.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Please Upload Images",
                                  style:
                                      Theme.of(context).textTheme.labelSmall),
                              backgroundColor: Theme.of(context).cardColor));
                        }

                        if (isTitleValid &&
                            isHostValid &&
                            isLinkValid &&
                            isDescriptionValid) {
                          BlocProvider.of<FeedBloc>(context)
                              .add(AddFeedItemEvent(
                            host: hostController.text,
                            title: titleController.text,
                            description: descriptionController.text,
                            link: linkController.text,
                            images: picker!,
                          ));
                        }
                      },
                    )),
              ),
              if (itemAdding)
                Container(
                  height: height,
                  width: width,
                  color: Theme.of(context).cardColor.withAlpha(200),
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                )
            ],
          ),
        ),
      ),
    );
  }
}
