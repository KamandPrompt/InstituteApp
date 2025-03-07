import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uhl_link/features/authentication/domain/entities/user_entity.dart';
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

  final TextEditingController nameController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  String? errorNameValue;
  final GlobalKey<FormState> nameKey = GlobalKey();

  final TextEditingController linkController = TextEditingController();
  final FocusNode linkFocusNode = FocusNode();
  String? errorLinkValue;
  final GlobalKey<FormState> linkKey = GlobalKey();

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
    nameController.dispose();
    nameFocusNode.dispose();
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
    UserEntity user = UserEntity.fromJson(widget.user);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title:
            Text("Add Events", style: Theme.of(context).textTheme.bodyMedium),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: BlocListener<FeedBloc, FeedState>(
        listener: (context, state) {
          if (state is FeedAddingItem) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Adding Item...",
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
                content: Text("Item Added Successfully",
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
                    SizedBox(height: height * 0.03),
                    FormFieldWidget(
                      focusNode: nameFocusNode,
                      fieldKey: nameKey,
                      controller: nameController,
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Name is required.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      errorText: errorNameValue,
                      prefixIcon: Icons.event,
                      showSuffixIcon: false,
                      hintText: "Event Name",
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: height * 0.03),
                    FormFieldWidget(
                      isLargeField: true,
                      focusNode: descriptionFocusNode,
                      fieldKey: descriptionKey,
                      controller: descriptionController,
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Description is required.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      errorText: errorDescriptionValue,
                      prefixIcon: Icons.image_aspect_ratio,
                      showSuffixIcon: false,
                      hintText: "Description",
                      textInputAction: TextInputAction.done,
                    ),
                    SizedBox(height: height * 0.03),
                    FormFieldWidget(
                      focusNode: linkFocusNode,
                      fieldKey: linkKey,
                      controller: linkController,
                      obscureText: false,
                      validator: (value) {
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      errorText: errorLinkValue,
                      prefixIcon: Icons.app_registration_rounded,
                      showSuffixIcon: false,
                      hintText: "Enter registration link",
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: height * 0.03),
                  ],
                ),
              ),
              Visibility(
                visible: MediaQuery.of(context).viewInsets.bottom == 0,
                child: Positioned(
                    bottom: 20,
                    child: ScreenWidthButton(
                      text: "Add Item",
                      buttonFunc: () {
                        final bool isNameValid =
                            nameKey.currentState!.validate();
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

                        if (isNameValid &&
                            isLinkValid &&
                            isDescriptionValid &&
                            picker != null) {
                          BlocProvider.of<FeedBloc>(context)
                              .add(AddFeedItemEvent(
                            host: nameController.text,
                            description: descriptionController.text,
                            link: linkController.text,
                            images: picker!.files
                                .map((file) => file.path!)
                                .toList(),
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
