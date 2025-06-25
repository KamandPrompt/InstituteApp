import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vertex/config/routes/routes_consts.dart';
import 'package:vertex/features/authentication/domain/entities/user_entity.dart';

import '../../../../widgets/form_field_widget.dart';
import '../../../../widgets/screen_width_button.dart';
import '../bloc/user_bloc.dart';

class UpdateProfilePage extends StatefulWidget {
  final UserEntity user;

  const UpdateProfilePage({super.key, required this.user});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final TextEditingController passwordTextEditingController =
      TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();
  String? errorPasswordValue;
  final GlobalKey<FormState> passwordKey = GlobalKey();
  //
  final TextEditingController nameTextEditingController =
      TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  String? errorNameValue;
  final GlobalKey<FormState> nameKey = GlobalKey();

  @override
  void initState() {
    nameTextEditingController.text = widget.user.name;
    // passwordTextEditingController.text = widget.user["password"];
    super.initState();
  }

  @override
  void dispose() {
    //
    nameFocusNode.dispose();
    nameTextEditingController.dispose();
    nameKey.currentState?.dispose();
    //
    passwordFocusNode.dispose();
    passwordTextEditingController.dispose();
    passwordKey.currentState?.dispose();
    //
    super.dispose();
  }

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

  bool updatingProfile = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;
    final aspectRatio = MediaQuery.of(context).size.aspectRatio;
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is ProfileUpdating) {
          setState(() {
            updatingProfile = true;
          });
        } else if (state is ProfileUpdatedSuccessfully) {
          setState(() {
            updatingProfile = false;
          });
          GoRouter.of(context).goNamed(UhlLinkRoutesNames.splash);
        } else if (state is ProfileUpdateError) {
          setState(() {
            updatingProfile = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          title: Text("Update Profile",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                reverse: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                          width: height * 0.2,
                          height: height * 0.2,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(height * 0.1),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.scrim,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                              child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(height * 0.1)),
                            child: (widget.user.image == "" &&
                                    (picker == null || picker!.files.isEmpty))
                                ? Icon(
                                    Icons.image_rounded,
                                    color: Theme.of(context).colorScheme.scrim,
                                    size: aspectRatio * 100,
                                  )
                                : SizedBox(
                                    width: height * 0.2,
                                    height: height * 0.2,
                                    child: (widget.user.image != "" &&
                                            (picker == null ||
                                                picker!.files.isEmpty))
                                        ? CachedNetworkImage(
                                            imageUrl: widget.user.image ?? "",
                                            fit: BoxFit.cover,
                                            alignment: Alignment.center,
                                            progressIndicatorBuilder: (context,
                                                string, loadingProgress) {
                                              return CircularProgressIndicator(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary);
                                            },
                                            errorWidget:
                                                (context, object, trace) {
                                              return const Icon(
                                                  Icons.error_outline_outlined,
                                                  size: 30);
                                            })
                                        : Image.file(
                                            File(picker!.files.first.path!),
                                            fit: BoxFit.cover,
                                            alignment: Alignment.center,
                                          )),
                          )),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      FormFieldWidget(
                        focusNode: nameFocusNode,
                        fieldKey: nameKey,
                        maxLines: 1,
                        controller: nameTextEditingController,
                        obscureText: false,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your name.";
                          }
                          return null;
                        },
                        onChanged: (String? value) {},
                        keyboardType: TextInputType.text,
                        errorText: errorNameValue,
                        prefixIcon: Icons.person_rounded,
                        showSuffixIcon: false,
                        hintText: "Update your name",
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      FormFieldWidget(
                        focusNode: passwordFocusNode,
                        fieldKey: passwordKey,
                        controller: passwordTextEditingController,
                        maxLines: 1,
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter new password.";
                          }
                          return null;
                        },
                        onChanged: (String? value) {},
                        keyboardType: TextInputType.text,
                        errorText: errorPasswordValue,
                        prefixIcon: Icons.lock_outline_rounded,
                        showSuffixIcon: true,
                        hintText: "Update your password",
                        textInputAction: TextInputAction.done,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Text.rich(TextSpan(children: [
                        TextSpan(
                            text: '* ',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: Theme.of(context).primaryColor)),
                        TextSpan(
                            text:
                                "This will be your new password and updating the password can be done via some logged in device only.",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontSize: 15))
                      ])),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1),
                    ]),
              ),
              Positioned(
                bottom: 20,
                child: ScreenWidthButton(
                  text: "Update Profile",
                  buttonFunc: () {
                    bool nameValidator = nameKey.currentState!.validate();
                    bool passwordValidator =
                        passwordKey.currentState!.validate();

                    if (nameValidator && passwordValidator) {
                      BlocProvider.of<AuthenticationBloc>(context).add(
                          ProfileUpdateEvent(
                              email: widget.user.email,
                              newName: nameTextEditingController.text,
                              newPassword: passwordTextEditingController.text,
                              newImage: picker?.files.first.path ?? widget.user.image));
                    }
                  },
                ),
              ),
              if (updatingProfile)
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
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
