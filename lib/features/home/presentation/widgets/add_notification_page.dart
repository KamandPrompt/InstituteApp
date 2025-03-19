import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../widgets/form_field_widget.dart';
import '../../../../widgets/screen_width_button.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../bloc/notification_bloc/notification_bloc.dart';
import '../bloc/notification_bloc/notification_event.dart';
import '../bloc/notification_bloc/notification_state.dart';

class AddNotificationPage extends StatefulWidget {
  final Map<String, dynamic> user;
  const AddNotificationPage({super.key, required this.user});

  @override
  State<AddNotificationPage> createState() => _AddNotificationPageState();
}

class _AddNotificationPageState extends State<AddNotificationPage> {
  //
  final TextEditingController titleController = TextEditingController();
  final FocusNode titleFocusNode = FocusNode();
  String? errorTitleValue;
  final GlobalKey<FormState> titleKey = GlobalKey();

  //
  final TextEditingController byController = TextEditingController();
  final FocusNode byFocusNode = FocusNode();
  String? errorByValue;
  final GlobalKey<FormState> byKey = GlobalKey();

  //
  final TextEditingController descriptionController = TextEditingController();
  final FocusNode descriptionFocusNode = FocusNode();
  String? errorDescValue;
  final GlobalKey<FormState> descriptionKey = GlobalKey();

  //
  FilePickerResult? picker;

  Future<void> pickImage() async {
    try {
      FilePickerResult? files = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.custom,
          allowedExtensions: ["jpg", "jpeg", "png", "gif"]);
      setState(() {
        picker = files;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error uploading images.",
              style: Theme.of(context).textTheme.labelSmall),
          backgroundColor: Theme.of(context).cardColor));
    }
  }

  bool notificationAdding = false;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    titleFocusNode.dispose();
    byController.dispose();
    byFocusNode.dispose();
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
        title: Text("Add Notification",
            style: Theme.of(context).textTheme.bodyMedium),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: BlocListener<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state is NotificationAdding) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Adding Notification...",
                    style: Theme.of(context).textTheme.labelSmall),
                backgroundColor: Theme.of(context).cardColor));
            setState(() {
              notificationAdding = true;
            });
          } else if (state is NotificationAdded) {
            setState(() {
              notificationAdding = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Notification Added Successfully",
                    style: Theme.of(context).textTheme.labelSmall),
                backgroundColor: Theme.of(context).cardColor));
            GoRouter.of(context).pop();
          } else if (state is NotificationAddingError) {
            setState(() {
              notificationAdding = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message,
                    style: Theme.of(context).textTheme.labelSmall),
                backgroundColor: Theme.of(context).cardColor));
            GoRouter.of(context).pop();
          } else {
            setState(() {
              notificationAdding = false;
            });
          }
        },
        child: SizedBox(
          height: height,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                physics: const ClampingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.scrim,
                            width: 1.5,
                          ),
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
                                  child: Image.file(
                                    File(picker!.files.first.path!),
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                  )),
                        )),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    FormFieldWidget(
                      fieldKey: titleKey,
                      focusNode: titleFocusNode,
                      controller: titleController,
                      obscureText: false,
                      validator: (value) =>
                          value!.isEmpty ? 'Title is required.' : null,
                      keyboardType: TextInputType.text,
                      errorText: errorTitleValue,
                      prefixIcon: Icons.title,
                      showSuffixIcon: false,
                      hintText: "Enter Notification Title",
                      maxLines: 1,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: height * 0.03),
                    FormFieldWidget(
                      fieldKey: byKey,
                      focusNode: byFocusNode,
                      controller: byController,
                      obscureText: false,
                      validator: (value) =>
                          value!.isEmpty ? 'Author or Club Name is required.' : null,
                      keyboardType: TextInputType.text,
                      errorText: errorByValue,
                      prefixIcon: Icons.person,
                      maxLines: 1,
                      showSuffixIcon: false,
                      hintText: "Enter Author or Club Name",
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: height * 0.03),
                    FormFieldWidget(
                      fieldKey: descriptionKey,
                      focusNode: descriptionFocusNode,
                      controller: descriptionController,
                      obscureText: false,
                      validator: (value) =>
                          (value!.isEmpty || value.trim().isEmpty) ? 'Description is required.' : null,
                      keyboardType: TextInputType.multiline,
                      errorText: errorDescValue,
                      prefixIcon: Icons.description,
                      showSuffixIcon: false,
                      hintText: "Enter Description",
                      textInputAction: TextInputAction.newline,
                      maxLines: null,
                    ),
                    SizedBox(height: height * 0.1),
                  ],
                ),
              ),
              Visibility(
                visible: MediaQuery.of(context).viewInsets.bottom == 0,
                child: Positioned(
                  bottom: 20,
                  child: ScreenWidthButton(
                    text: "Add Notification",
                    buttonFunc: () {
                      final bool isTitleValid = titleKey.currentState!.validate();
                      final bool isAuthorValid = byKey.currentState!.validate();
                      final bool isDescriptionValid =
                      descriptionKey.currentState!.validate();

                      if (isTitleValid && isAuthorValid && isDescriptionValid) {
                        BlocProvider.of<NotificationBloc>(context)
                            .add(AddNotificationEvent(
                          title: titleController.text,
                          by: byController.text,
                          description: descriptionController.text,
                          image: picker?.files.first.path
                        ));
                      }
                    },
                  ),
                ),
              ),
              if (notificationAdding)
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
