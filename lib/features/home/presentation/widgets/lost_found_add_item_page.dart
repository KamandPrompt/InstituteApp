import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uhl_link/features/authentication/domain/entities/user_entity.dart';

import '../../../../widgets/form_field_widget.dart';
import '../../../../widgets/screen_width_button.dart';
import '../bloc/lost_found_bloc/lnf_bloc.dart';

class LostFoundAddItemPage extends StatefulWidget {
  final Map<String, dynamic> user;
  const LostFoundAddItemPage({super.key, required this.user});

  @override
  State<LostFoundAddItemPage> createState() => _LostFoundAddItemPageState();
}

class _LostFoundAddItemPageState extends State<LostFoundAddItemPage> {
  bool imageSelected = false;

  //
  final TextEditingController nameController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  String? errorNameValue;
  final GlobalKey<FormState> nameKey = GlobalKey();

  //
  final TextEditingController contactController = TextEditingController();
  final FocusNode contactFocusNode = FocusNode();
  String? errorContactValue;
  final GlobalKey<FormState> contactKey = GlobalKey();

  //
  final TextEditingController dateController = TextEditingController();
  final FocusNode dateFocusNode = FocusNode();
  String? errorDateValue;
  final GlobalKey<FormState> dateKey = GlobalKey();

  //
  final TextEditingController descriptionController = TextEditingController();
  final FocusNode descriptionFocusNode = FocusNode();
  String? errorDescriptionValue;
  final GlobalKey<FormState> descriptionKey = GlobalKey();

  List<String> images = [];
  final ImagePicker picker = ImagePicker();

  Future<void> pickImage() async {
    try {
      final List<XFile> pickedImages = await picker.pickMultiImage(limit: 3);

      setState(() {
        for (XFile image in pickedImages) {
          images.add(image.path);
        }
      });
        } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error uploading image.")));
    }
  }

  String? itemStatus;
  List<String> lostOrFound = ["Lost", "Found"];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final aspectRatio = MediaQuery.of(context).size.aspectRatio;
    UserEntity user = UserEntity.fromJson(widget.user);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text("Add Lost Item",
            style: Theme.of(context).textTheme.bodyMedium),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                SingleChildScrollView(
                  reverse: true,
                  // physics: const ClampingScrollPhysics(),
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
                              child: images != []
                                  ? SizedBox(
                                      width: width - 40,
                                      height: height * 0.3,
                                      child: GridView.builder(
                                          itemCount: images.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Image.file(
                                              File(images[index]),
                                              fit: BoxFit.cover,
                                              alignment: Alignment.center,
                                            );
                                          }),
                                    )
                                  : Icon(
                                      Icons.image_rounded,
                                      color:
                                          Theme.of(context).colorScheme.scrim,
                                      size: aspectRatio * 200,
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
                        prefixIcon: Icons.person,
                        showSuffixIcon: false,
                        hintText: "Enter your Name",
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(height: height * 0.03),
                      FormFieldWidget(
                        focusNode: contactFocusNode,
                        fieldKey: contactKey,
                        controller: contactController,
                        obscureText: false,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Contact number is required.";
                          }
                          if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                            return "Enter a valid 10-digit Contact Number.";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                        errorText: errorContactValue,
                        prefixIcon: Icons.location_searching_rounded,
                        showSuffixIcon: false,
                        hintText: "Enter your Contact No.",
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(height: height * 0.03),
                      FormFieldWidget(
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
                        hintText: "Describe Lost Item",
                        textInputAction: TextInputAction.done,
                      ),
                      SizedBox(height: height * 0.03),
                      FormFieldWidget(
                        focusNode: dateFocusNode,
                        fieldKey: dateKey,
                        controller: dateController,
                        obscureText: false,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Lost Date is required";
                          }
                          return null;
                        },
                        onTap: () async {
                          DateTime date = DateTime.now();
                          FocusScope.of(context).requestFocus(FocusNode());

                          date = (await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 7)),
                            lastDate: DateTime.now(),
                          ))!;

                          dateController.text =
                              date.toString().substring(0, 10);
                        },
                        keyboardType: TextInputType.emailAddress,
                        errorText: errorDateValue,
                        prefixIcon: Icons.date_range_rounded,
                        showSuffixIcon: false,
                        hintText: "Enter Date of Lost/Found",
                        textInputAction: TextInputAction.done,
                      ),
                      SizedBox(height: height * 0.03),
                      FormField<String>(
                          builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.scrim,
                                    width: 1),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                gapPadding: 24),
                            fillColor: Theme.of(context).cardColor,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 2),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                gapPadding: 24),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: itemStatus,
                              isDense: true,
                              hint: Text(
                                "Lost/Found",
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
                                  itemStatus = newValue;
                                });
                              },
                              items: lostOrFound.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: height * 0.1),
                    ],
                  ),
                ),
                Positioned(
                    bottom: 1,
                    child: ScreenWidthButton(
                      text: "Add Item",
                      buttonFunc: () {
                        final bool isNameValid =
                            nameKey.currentState!.validate();
                        final bool isContactValid =
                            contactKey.currentState!.validate();
                        final bool isDescriptionValid =
                            descriptionKey.currentState!.validate();
                        final bool isDateValid =
                            dateKey.currentState!.validate();

                        if (itemStatus == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Please Select Lost or Found",
                                  style:
                                      Theme.of(context).textTheme.labelSmall),
                              backgroundColor: Theme.of(context).cardColor));
                        }

                        if (images.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Please Upload Images",
                                  style:
                                      Theme.of(context).textTheme.labelSmall),
                              backgroundColor: Theme.of(context).cardColor));
                        }

                        if (isNameValid &&
                            isDateValid &&
                            isContactValid &&
                            isDescriptionValid &&
                            itemStatus != null) {
                          BlocProvider.of<LnfBloc>(context)
                              .add(AddLostFoundItemEvent(
                            name: nameController.text,
                            phoneNo: contactController.text,
                            description: descriptionController.text,
                            date: DateTime.parse(dateController.text),
                            lostOrFound: itemStatus!,
                            from: user.email,
                            images: images,
                          ));

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Please Upload Images",
                                  style:
                                  Theme.of(context).textTheme.labelSmall),
                              backgroundColor: Theme.of(context).cardColor));
                          GoRouter.of(context).pop();
                        }
                      },
                      // isLoading: userLoading,
                    ))
              ],
            ),
          )),
    );
  }
}
