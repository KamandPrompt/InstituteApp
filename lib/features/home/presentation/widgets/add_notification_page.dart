import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../widgets/form_field_widget.dart';
import '../../../../widgets/screen_width_button.dart';
import '../bloc/notification_bloc/notification_bloc.dart';
import '../bloc/notification_bloc/notification_event.dart';

class AddNotificationPage extends StatefulWidget {
  final Map<String, dynamic>? user;
  const AddNotificationPage({super.key, this.user});

  @override
  State<AddNotificationPage> createState() => _AddNotificationPageState();
}

class _AddNotificationPageState extends State<AddNotificationPage> {
  final TextEditingController titleController = TextEditingController();
  final FocusNode titleFocusNode = FocusNode();
  final GlobalKey<FormState> titleKey = GlobalKey();

  final TextEditingController byController = TextEditingController();
  final FocusNode byFocusNode = FocusNode();
  final GlobalKey<FormState> byKey = GlobalKey();

  final TextEditingController descriptionController = TextEditingController();
  final FocusNode descriptionFocusNode = FocusNode();
  final GlobalKey<FormState> descriptionKey = GlobalKey();

  List<String> images = [];
  final ImagePicker picker = ImagePicker();

  Future<void> pickImage() async {
    try {
      final List<XFile> pickedImages = await picker.pickMultiImage(limit: 3);
      setState(() {
        images.addAll(pickedImages.map((image) => image.path));
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error uploading image.")));
    }
  }

  void _addNotification() {
    final bool isTitleValid = titleKey.currentState!.validate();
    final bool isByValid = byKey.currentState!.validate();
    final bool isDescriptionValid = descriptionKey.currentState!.validate();

    if (!isTitleValid || !isByValid || !isDescriptionValid) {
      return;
    }

    final notificationData = {
      'title': {'text': titleController.text},
      'by': {'name': byController.text},
      'description': {'content': descriptionController.text},
      if (images.isNotEmpty) 'image': {'url': images.first},
    };

    BlocProvider.of<NotificationBloc>(context).add(
      AddNotificationEvent(
        title: notificationData['title']!,
        by: notificationData['by']!,
        description: notificationData['description']!,
        image: notificationData.containsKey('image') ? notificationData['image'] : null,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Notification Added Successfully!")),
    );
    GoRouter.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text("Add Notification", style: Theme.of(context).textTheme.bodyMedium),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SizedBox(
          height: height,
          child: Stack(
            children: [
              SingleChildScrollView(
                reverse: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: pickImage,
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
                          child: images.isNotEmpty
                              ? GridView.builder(
                            itemCount: images.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                            itemBuilder: (context, index) {
                              return Image.file(File(images[index]), fit: BoxFit.cover);
                            },
                          )
                              : Icon(Icons.image_rounded, size: 100, color: Theme.of(context).colorScheme.scrim),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    FormFieldWidget(
                      fieldKey: titleKey,
                      focusNode: titleFocusNode,
                      controller: titleController,
                      obscureText: false,
                      validator: (value) => value!.isEmpty ? 'Title is required.' : null,
                      keyboardType: TextInputType.text,
                      errorText: '',
                      prefixIcon: Icons.title,
                      showSuffixIcon: false,
                      hintText: "Enter Notification Title",
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: height * 0.03),
                    FormFieldWidget(
                      fieldKey: byKey,
                      focusNode: byFocusNode,
                      controller: byController,
                      obscureText: false,
                      validator: (value) => value!.isEmpty ? 'Author is required.' : null,
                      keyboardType: TextInputType.text,
                      errorText: '',
                      prefixIcon: Icons.person,
                      showSuffixIcon: false,
                      hintText: "By (Author/Organization)",
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: height * 0.03),
                    FormFieldWidget(
                      fieldKey: descriptionKey,
                      focusNode: descriptionFocusNode,
                      controller: descriptionController,
                      obscureText: false,
                      validator: (value) => value!.isEmpty ? 'Description is required.' : null,
                      keyboardType: TextInputType.text,
                      errorText: '',
                      prefixIcon: Icons.description,
                      showSuffixIcon: false,
                      hintText: "Enter Description",
                      textInputAction: TextInputAction.done,
                    ),
                    SizedBox(height: height * 0.1),
                  ],
                ),
              ),
              Positioned(
                bottom: 1,
                child: ScreenWidthButton(
                  text: "Add Notification",
                  buttonFunc: _addNotification,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
