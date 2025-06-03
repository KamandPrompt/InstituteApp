import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vertex/features/authentication/domain/entities/user_entity.dart';

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

  //
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

  String? itemStatus;
  List<String> lostOrFound = ["Lost", "Found"];

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    nameFocusNode.dispose();
    contactController.dispose();
    contactFocusNode.dispose();
    dateController.dispose();
    dateFocusNode.dispose();
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
        title: Text("Add Lost Item",
            style: Theme.of(context).textTheme.bodyMedium),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: BlocListener<LnfBloc, LnfState>(
        listener: (context, state) {
          if (state is LnfAddingItem) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Adding Item...",
                    style: Theme.of(context).textTheme.labelSmall),
                backgroundColor: Theme.of(context).cardColor));
            setState(() {
              itemAdding = true;
            });
          } else if (state is LnfItemAdded) {
            setState(() {
              itemAdding = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Item Added Successfully",
                    style: Theme.of(context).textTheme.labelSmall),
                backgroundColor: Theme.of(context).cardColor));
            GoRouter.of(context).pop();
          } else if (state is LnfItemsAddingError) {
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
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      errorText: errorNameValue,
                      prefixIcon: Icons.person,
                      showSuffixIcon: false,
                      hintText: "Enter your Name",
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: height * 0.02),
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
                      maxLines: 1,
                      keyboardType: TextInputType.phone,
                      errorText: errorContactValue,
                      prefixIcon: Icons.location_searching_rounded,
                      showSuffixIcon: false,
                      hintText: "Enter your Contact No.",
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
                          return 'Description is required.';
                        }
                        return null;
                      },
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      errorText: errorDescriptionValue,
                      prefixIcon: Icons.image_aspect_ratio,
                      showSuffixIcon: false,
                      hintText: "Describe Lost Item",
                      textInputAction: TextInputAction.newline,
                    ),
                    SizedBox(height: height * 0.02),
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
                          firstDate:
                              DateTime.now().subtract(const Duration(days: 7)),
                          lastDate: DateTime.now(),
                        ))!;

                        dateController.text = date.toString().substring(0, 10);
                      },
                      keyboardType: TextInputType.emailAddress,
                      errorText: errorDateValue,
                      prefixIcon: Icons.date_range_rounded,
                      showSuffixIcon: false,
                      hintText: "Enter Date of Lost/Found",
                      textInputAction: TextInputAction.done,
                    ),
                    SizedBox(height: height * 0.02),
                    FormField<String>(builder: (FormFieldState<String> state) {
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
                                      color:
                                          Theme.of(context).colorScheme.scrim),
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
                                  style: Theme.of(context).textTheme.labelSmall,
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
              Visibility(
                visible: MediaQuery.of(context).viewInsets.bottom == 0,
                child: Positioned(
                    bottom: 20,
                    child: ScreenWidthButton(
                      text: "Add Item",
                      buttonFunc: () {
                        final bool isNameValid = nameKey.currentState!.validate();
                        final bool isContactValid =
                            contactKey.currentState!.validate();
                        final bool isDescriptionValid =
                            descriptionKey.currentState!.validate();
                        final bool isDateValid = dateKey.currentState!.validate();

                        if (itemStatus == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Please Select Lost or Found",
                                  style: Theme.of(context).textTheme.labelSmall),
                              backgroundColor: Theme.of(context).cardColor));
                        }

                        if (picker == null || picker!.files.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Please Upload Images",
                                  style: Theme.of(context).textTheme.labelSmall),
                              backgroundColor: Theme.of(context).cardColor));
                        }

                        if (isNameValid &&
                            isDateValid &&
                            isContactValid &&
                            isDescriptionValid &&
                            itemStatus != null &&
                            picker != null) {
                          BlocProvider.of<LnfBloc>(context)
                              .add(AddLostFoundItemEvent(
                            name: nameController.text,
                            phoneNo: contactController.text,
                            description: descriptionController.text,
                            date: DateTime.parse(dateController.text),
                            lostOrFound: itemStatus!,
                            from: user.email,
                            images: picker!,
                          ));
                        }
                      },
                      // isLoading: userLoading,
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
