import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vertex/features/authentication/domain/entities/user_entity.dart';
import 'package:vertex/features/home/domain/entities/post_entity.dart';
import 'package:vertex/features/home/presentation/bloc/post_bloc/post_bloc.dart';

import '../../../../widgets/form_field_widget.dart';
import '../../../../widgets/screen_width_button.dart';

class PostAddOrEditItemPage extends StatefulWidget {
  final UserEntity user;
  final bool postEditing;
  final PostItemEntity? postDetails;
  const PostAddOrEditItemPage(
      {super.key,
      required this.user,
      this.postEditing = false,
      this.postDetails});

  @override
  State<PostAddOrEditItemPage> createState() => _PostAddOrEditItemPageState();
}

class _PostAddOrEditItemPageState extends State<PostAddOrEditItemPage> {
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
  final TextEditingController emailIdController = TextEditingController();
  final FocusNode emailIdFocusNode = FocusNode();
  String? errorEmailIdValue;
  final GlobalKey<FormState> emailIdKey = GlobalKey();
  //
  String postType = "Feed";
  List<String> types = ["Feed", "Event", "Achievement"];
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
  void initState() {
    super.initState();
    if (widget.postEditing) {
      titleController.text = widget.postDetails!.title;
      hostController.text = widget.postDetails!.host;
      emailIdController.text = widget.postDetails!.emailId;
      linkController.text = widget.postDetails!.link;
      descriptionController.text = widget.postDetails!.description;
      postType = widget.postDetails!.type;
      if (widget.postDetails!.images.isNotEmpty) {
        picker = FilePickerResult([
          for (String imageUrl in widget.postDetails!.images)
            PlatformFile(
              name: 'image_${widget.postDetails!.images.indexOf(imageUrl)}.jpg',
              size: 0,
              path: imageUrl,
              bytes: null,
            ),
        ]);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailIdController.dispose();
    emailIdFocusNode.dispose();
    titleController.dispose();
    titleFocusNode.dispose();
    hostController.dispose();
    hostFocusNode.dispose();
    linkController.dispose();
    linkFocusNode.dispose();
    descriptionController.dispose();
    descriptionFocusNode.dispose();
  }

  Widget _buildImageWidget(String path) {
    if (path.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: path,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => const Icon(
          Icons.error_outline,
          size: 40,
        ),
      );
    } else {
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        alignment: Alignment.center,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final aspectRatio = MediaQuery.of(context).size.aspectRatio;
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
            widget.postEditing
                ? "Edit Post"
                : "Add Post",
            style: Theme.of(context).textTheme.bodyMedium),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: BlocListener<PostBloc, PostState>(
        listener: (context, state) {
          if (state is PostAddingOrEditingItem) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(!widget.postEditing ? "Adding post..." : "Editing post...",
                    style: Theme.of(context).textTheme.labelSmall),
                backgroundColor: Theme.of(context).cardColor));
            setState(() {
              itemAdding = true;
            });
          } else if (state is PostItemAddedOrEdited) {
            setState(() {
              itemAdding = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(widget.postEditing ? "Post edited successfully" : "Post added successfully",
                    style: Theme.of(context).textTheme.labelSmall),
                backgroundColor: Theme.of(context).cardColor));
            GoRouter.of(context).pop();
          } else if (state is PostItemsAddingOrEditingError) {
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
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                physics: const ClampingScrollPhysics(),
                primary: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await pickImage();
                      },
                      child: SizedBox(
                        width: width - 20,
                        height: height * 0.3,
                        child: Card(
                          color: Theme.of(context).cardColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                  color: Theme.of(context).colorScheme.scrim,
                                  width: 1.5,
                                  strokeAlign: BorderSide.strokeAlignOutside)),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            child: (picker == null || picker!.files.isEmpty)
                                ? Icon(
                                    Icons.image_rounded,
                                    color: Theme.of(context).colorScheme.scrim,
                                    size: aspectRatio * 150,
                                  )
                                : GridView.builder(
                                    itemCount: picker!.files.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return _buildImageWidget(
                                          picker!.files[index].path!);
                                    }),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FormFieldWidget(
                            focusNode: emailIdFocusNode,
                            fieldKey: emailIdKey,
                            controller: emailIdController
                              ..text = widget.user.email,
                            obscureText: false,
                            validator: (value) => null,
                            maxLines: 1,
                            keyboardType: TextInputType.emailAddress,
                            errorText: null,
                            prefixIcon: Icons.email,
                            showSuffixIcon: false,
                            hintText: "Email ID",
                            textInputAction: TextInputAction.next,
                            readOnly: true,
                          ),
                          SizedBox(height: height * 0.015),
                          FormFieldWidget(
                            focusNode: titleFocusNode,
                            fieldKey: titleKey,
                            controller: titleController,
                            obscureText: false,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Post title is required.';
                              }
                              return null;
                            },
                            maxLines: 1,
                            keyboardType: TextInputType.text,
                            errorText: errorTitleValue,
                            prefixIcon: Icons.feed,
                            showSuffixIcon: false,
                            hintText: "Event Title",
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(height: height * 0.015),
                          FormFieldWidget(
                            focusNode: hostFocusNode,
                            fieldKey: hostKey,
                            controller: hostController,
                            obscureText: false,
                            validator: (value) {
                              return null;
                            },
                            maxLines: 1,
                            keyboardType: TextInputType.text,
                            errorText: errorHostValue,
                            prefixIcon: Icons.person,
                            showSuffixIcon: false,
                            hintText: "Enter host (Club/School)",
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(height: height * 0.015),
                          FormField<String>(
                              builder: (FormFieldState<String> state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 15),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Theme.of(context).colorScheme.scrim,
                                        width: 1),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                    gapPadding: 24),
                                fillColor: Theme.of(context).cardColor,
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 2),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                    gapPadding: 24),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: postType,
                                  isDense: true,
                                  hint: Text(
                                    "Post Type",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .scrim),
                                  ),
                                  dropdownColor: Theme.of(context).cardColor,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      postType = newValue ?? "Feed";
                                    });
                                  },
                                  items: types.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          }),
                          SizedBox(height: height * 0.015),
                          FormFieldWidget(
                            focusNode: descriptionFocusNode,
                            fieldKey: descriptionKey,
                            controller: descriptionController,
                            obscureText: false,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Post description is required.';
                              }
                              return null;
                            },
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            errorText: errorDescriptionValue,
                            prefixIcon: null,
                            showSuffixIcon: false,
                            hintText: "Enter post description",
                            textInputAction: TextInputAction.newline,
                          ),
                          SizedBox(height: height * 0.015),
                          FormFieldWidget(
                            focusNode: linkFocusNode,
                            fieldKey: linkKey,
                            controller: linkController,
                            obscureText: false,
                            validator: (value) {
                              return null;
                            },
                            maxLines: 1,
                            keyboardType: TextInputType.url,
                            errorText: errorLinkValue,
                            prefixIcon: Icons.link_rounded,
                            showSuffixIcon: false,
                            hintText: "Enter post required link",
                            textInputAction: TextInputAction.done,
                          ),
                          SizedBox(height: height * 0.08),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!isKeyboardVisible)
                Positioned(
                    bottom: 20,
                    child: ScreenWidthButton(
                      text: widget.postEditing ? "Update Post" : "Add Post",
                      buttonFunc: () {
                        final bool isTitleValid =
                            titleKey.currentState!.validate();
                        final bool isHostValid =
                            hostKey.currentState!.validate();
                        final bool isLinkValid =
                            linkKey.currentState!.validate();
                        final bool isDescriptionValid =
                            descriptionKey.currentState!.validate();

                        // if (picker == null || picker!.files.isEmpty) {
                        //   return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        //       content: Text("Please Upload Images",
                        //           style:
                        //               Theme.of(context).textTheme.labelSmall),
                        //       backgroundColor: Theme.of(context).cardColor));
                        // }

                        if (isTitleValid &&
                            isHostValid &&
                            isLinkValid &&
                            isDescriptionValid) {
                          BlocProvider.of<PostBloc>(context).add(
                              AddorEditPostItemEvent(
                                  id: widget.postEditing
                                      ? widget.postDetails!.id
                                      : null,
                                  host: hostController.text,
                                  title: titleController.text,
                                  description: descriptionController.text,
                                  link: linkController.text,
                                  images: picker ?? FilePickerResult([]),
                                  type: postType,
                                  emailId: emailIdController.text,
                                  updatedAt: DateTime.now(),
                                  createdAt: widget.postEditing
                                      ? widget.postDetails!.createdAt
                                      : DateTime.now()));
                        }
                      },
                    )),
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
