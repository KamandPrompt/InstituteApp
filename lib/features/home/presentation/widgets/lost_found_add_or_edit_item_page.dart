import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vertex/features/authentication/domain/entities/user_entity.dart';
import 'package:vertex/features/home/domain/entities/lost_found_item_entity.dart';

import '../../../../widgets/form_field_widget.dart';
import '../../../../widgets/screen_width_button.dart';
import '../bloc/lost_found_bloc/lnf_bloc.dart';

class LostFoundAddOrEditItemPage extends StatefulWidget {
  final UserEntity user;
  final bool isEditing;
  final LostFoundItemEntity? lnfItem;
  const LostFoundAddOrEditItemPage(
      {super.key, required this.user, this.isEditing = false, this.lnfItem});

  @override
  State<LostFoundAddOrEditItemPage> createState() => _LostFoundAddOrEditItemPageState();
}

class _LostFoundAddOrEditItemPageState extends State<LostFoundAddOrEditItemPage> {
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
  void initState() {
    super.initState();
    if (widget.isEditing && widget.lnfItem != null) {
      nameController.text = widget.lnfItem!.name;
      contactController.text = widget.lnfItem!.phoneNo;
      dateController.text = widget.lnfItem!.updatedAt.toString();
      dateController.text =
          DateFormat.yMMMd().format(widget.lnfItem!.updatedAt);
      descriptionController.text = widget.lnfItem!.description;
      itemStatus = widget.lnfItem!.lostOrFound;
      if (widget.lnfItem!.images.isNotEmpty) {
        picker = FilePickerResult([
          for (String imageUrl in widget.lnfItem!.images)
            PlatformFile(
              name: 'image_${widget.lnfItem!.images.indexOf(imageUrl)}.jpg',
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
    nameController.dispose();
    nameFocusNode.dispose();
    contactController.dispose();
    contactFocusNode.dispose();
    dateController.dispose();
    dateFocusNode.dispose();
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
    UserEntity user = widget.user;
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(widget.isEditing ? "Edit Item" : "Add Item",
            style: Theme.of(context).textTheme.bodyMedium),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: BlocListener<LnfBloc, LnfState>(
        listener: (context, state) {
          if (state is LnfAddingOrEditingItem) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    widget.isEditing ? "Editing item..." : "Adding item...",
                    style: Theme.of(context).textTheme.labelSmall),
                backgroundColor: Theme.of(context).cardColor));
            setState(() {
              itemAdding = true;
            });
          } else if (state is LnfItemAddedOrEdited) {
            setState(() {
              itemAdding = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    widget.isEditing
                        ? "Item edited successfully"
                        : "Item added successfully",
                    style: Theme.of(context).textTheme.labelSmall),
                backgroundColor: Theme.of(context).cardColor));
            GoRouter.of(context).pop();
          } else if (state is LnfItemsAddingOrEditingError) {
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
                                strokeAlign: BorderSide.strokeAlignOutside),
                          ),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            child: (picker == null || picker!.files.isEmpty)
                                ? Center(
                                    child: Icon(
                                      Icons.image_rounded,
                                      color:
                                          Theme.of(context).colorScheme.scrim,
                                      size: aspectRatio * 150,
                                    ),
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
                          SizedBox(height: height * 0.015),
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
                          SizedBox(height: height * 0.015),
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
                            prefixIcon: Icons.description_rounded,
                            showSuffixIcon: false,
                            hintText: "Describe Lost Item",
                            textInputAction: TextInputAction.newline,
                          ),
                          SizedBox(height: height * 0.015),
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
                                  DateFormat.yMMMd().format(date);
                            },
                            keyboardType: TextInputType.emailAddress,
                            errorText: errorDateValue,
                            prefixIcon: Icons.date_range_rounded,
                            showSuffixIcon: false,
                            hintText: "Enter Date of Lost/Found",
                            textInputAction: TextInputAction.done,
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
                      text: widget.isEditing ? "Update Item" : "Add Item",
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

                        if (picker == null || picker!.files.isEmpty) {
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
                            itemStatus != null &&
                            picker != null) {
                          BlocProvider.of<LnfBloc>(context)
                              .add(AddOrEditLostFoundItemEvent(
                            id: widget.isEditing ? widget.lnfItem!.id : null,
                            name: nameController.text,
                            phoneNo: contactController.text,
                            description: descriptionController.text,
                            lostOrFound: itemStatus!,
                            from: user.email,
                            images: picker!,
                            createdAt: widget.isEditing
                                ? widget.lnfItem!.createdAt
                                : DateTime.now(),
                            updatedAt: DateTime.now(),
                          ));
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
