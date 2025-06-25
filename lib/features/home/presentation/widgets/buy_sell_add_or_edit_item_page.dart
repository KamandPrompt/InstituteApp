import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vertex/features/authentication/domain/entities/user_entity.dart';
import 'package:vertex/features/home/domain/entities/buy_sell_item_entity.dart';

import '../../../../widgets/form_field_widget.dart';
import '../../../../widgets/screen_width_button.dart';
import '../bloc/buy_sell_bloc/bns_bloc.dart';

class BuySellAddOrEditItemPage extends StatefulWidget {
  final UserEntity user;
  final bool isEditing;
  final BuySellItemEntity? bnsItem;
  const BuySellAddOrEditItemPage(
      {super.key, required this.user, this.isEditing = false, this.bnsItem});

  @override
  State<BuySellAddOrEditItemPage> createState() =>
      _BuySellAddOrEditItemPageState();
}

class _BuySellAddOrEditItemPageState extends State<BuySellAddOrEditItemPage> {
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
  final TextEditingController maxPriceController = TextEditingController();
  final FocusNode maxPriceFocusNode = FocusNode();
  String? errorMaxPriceValue;
  final GlobalKey<FormState> maxPriceKey = GlobalKey();
  //
  final TextEditingController minPriceController = TextEditingController();
  final FocusNode minPriceFocusNode = FocusNode();
  String? errorMinPriceValue;
  final GlobalKey<FormState> minPriceKey = GlobalKey();

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

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.bnsItem != null) {
      nameController.text = widget.bnsItem!.name;
      contactController.text = widget.bnsItem!.phoneNo;
      maxPriceController.text = widget.bnsItem!.maxPrice.toString();
      minPriceController.text = widget.bnsItem!.minPrice.toString();
      descriptionController.text = widget.bnsItem!.productDescription;
      if (widget.bnsItem!.productImage.isNotEmpty) {
        picker = FilePickerResult([
          for (String imageUrl in widget.bnsItem!.productImage)
            PlatformFile(
              name:
                  'image_${widget.bnsItem!.productImage.indexOf(imageUrl)}.jpg',
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
    UserEntity user = widget.user;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(widget.isEditing ? "Edit Item" : "Add Item",
            style: Theme.of(context).textTheme.bodyMedium),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: BlocListener<BuySellBloc, BuySellState>(
        listener: (context, state) {
          if (state is BuySellAddingOrEditingItem) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    widget.isEditing ? "Editing item..." : "Adding item...",
                    style: Theme.of(context).textTheme.labelSmall),
                backgroundColor: Theme.of(context).cardColor));
            setState(() {
              itemAdding = true;
            });
          } else if (state is BuySellItemAddedOrEdited) {
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
          } else if (state is BuySellItemsAddingOrEditingError) {
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
                              keyboardType: TextInputType.text,
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
                              keyboardType: TextInputType.multiline,
                              errorText: errorDescriptionValue,
                              prefixIcon: Icons.description_rounded,
                              showSuffixIcon: false,
                              hintText: "Describe Selling Item",
                              textInputAction: TextInputAction.newline,
                              maxLines: null,
                            ),
                            SizedBox(height: height * 0.015),
                            FormFieldWidget(
                              focusNode: minPriceFocusNode,
                              fieldKey: minPriceKey,
                              controller: minPriceController,
                              obscureText: false,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Minimum Price is required.';
                                }
                                final minPrice = double.tryParse(value);
                                final maxPrice =
                                    double.tryParse(maxPriceController.text);
                                if (minPrice == null) {
                                  return 'Enter a valid number for Min Price.';
                                }
                                if (maxPrice != null && minPrice >= maxPrice) {
                                  return 'Min Price must be less than Max Price.';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              errorText: errorMinPriceValue,
                              prefixIcon: Icons.currency_rupee_rounded,
                              showSuffixIcon: false,
                              hintText: "Enter Min Price of Product",
                              textInputAction: TextInputAction.next,
                              maxLines: 1,
                            ),
                            SizedBox(height: height * 0.015),
                            FormFieldWidget(
                              focusNode: maxPriceFocusNode,
                              fieldKey: maxPriceKey,
                              controller: maxPriceController,
                              obscureText: false,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Max Price is required.';
                                }
                                final maxPrice = double.tryParse(value);
                                final minPrice =
                                    double.tryParse(minPriceController.text);
                                if (maxPrice == null) {
                                  return 'Enter a valid number for Max Price.';
                                }
                                if (minPrice != null && maxPrice <= minPrice) {
                                  return 'Max Price must be greater than Min Price.';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              errorText: errorMaxPriceValue,
                              prefixIcon: Icons.currency_rupee_rounded,
                              showSuffixIcon: false,
                              hintText: "Enter Max Price of Product",
                              textInputAction: TextInputAction.done,
                              maxLines: 1,
                            ),
                            SizedBox(height: height * 0.08),
                          ]),
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
                      final bool isNameValid = nameKey.currentState!.validate();
                      final bool isContactValid =
                          contactKey.currentState!.validate();
                      final bool isDescriptionValid =
                          descriptionKey.currentState!.validate();
                      final bool isMaxPriceValid =
                          maxPriceKey.currentState!.validate();
                      final bool isMinPriceValid =
                          minPriceKey.currentState!.validate();

                      // if (itemStatus == null) {
                      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //       content: Text("Please Select Lost or Found",
                      //           style: Theme.of(context).textTheme.labelSmall),
                      //       backgroundColor: Theme.of(context).cardColor));
                      // }

                      // if (picker == null || picker!.files.isEmpty) {
                      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //       content: Text("Please Upload Images",
                      //           style: Theme.of(context).textTheme.labelSmall),
                      //       backgroundColor: Theme.of(context).cardColor));
                      // }

                      if (isNameValid &&
                              isContactValid &&
                              isDescriptionValid &&
                              isMaxPriceValid &&
                              isMinPriceValid
                          // && picker != null
                          ) {
                        BlocProvider.of<BuySellBloc>(context)
                            .add(AddOrEditBuySellItemEvent(
                          id: widget.isEditing ? widget.bnsItem!.id : null,
                          name: nameController.text,
                          phoneNo: contactController.text,
                          productDescription: descriptionController.text,
                          createdAt: widget.isEditing
                              ? widget.bnsItem!.createdAt
                              : DateTime.now(),
                          updatedAt: DateTime.now(),
                          soldBy: user.email,
                          maxPrice: maxPriceController.text,
                          minPrice: minPriceController.text,
                          productImage: picker ?? FilePickerResult([]),
                        ));
                      }
                    },
                  ),
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
