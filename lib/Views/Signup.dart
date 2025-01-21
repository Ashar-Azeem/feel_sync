// ignore_for_file: file_names
import 'package:feel_sync/Routes/RouteNames.dart';
import 'package:feel_sync/Utilities/ReusableUI/ErrorMessage.dart';
import 'package:feel_sync/Utilities/LoginAndRegisterationStatus.dart';
import 'package:feel_sync/bloc/DateSelector/date_selector_bloc.dart';
import 'package:feel_sync/bloc/ImagePicker/image_picker_bloc.dart';
import 'package:feel_sync/bloc/LoginBloc/login&Registration_bloc.dart';
import 'package:feel_sync/bloc/PasswordBloc/password_visibility_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  String gender = "Male";
  DateTime? dataTime;
  TextEditingController DOB = TextEditingController();
  late PasswordVisibilityBloc _passwordVisibilityBloc;
  late LoginBloc loginBloc;
  late ImagePickerBloc imagePickerBloc;
  late DateSelectorBloc dateSelectorBloc;
  final GlobalKey<FormState> _fullName = GlobalKey<FormState>();
  final GlobalKey<FormState> _userName = GlobalKey<FormState>();
  final GlobalKey<FormState> _email = GlobalKey<FormState>();
  final GlobalKey<FormState> _password = GlobalKey<FormState>();
  final GlobalKey<FormState> _DOB = GlobalKey<FormState>();
  Uint8List? file;
  bool loading = false;
  bool passwordInvisible = true;
  late TextEditingController email;
  late TextEditingController password;
  late TextEditingController userName;
  late TextEditingController fullName;
  @override
  void initState() {
    super.initState();
    _passwordVisibilityBloc = PasswordVisibilityBloc();
    loginBloc = LoginBloc();
    imagePickerBloc = ImagePickerBloc();
    email = TextEditingController();
    password = TextEditingController();
    userName = TextEditingController();
    fullName = TextEditingController();
    dateSelectorBloc = DateSelectorBloc();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    fullName.dispose();
    userName.dispose();
    loginBloc.close();
    imagePickerBloc.close();
    _passwordVisibilityBloc.close();
    DOB.dispose();
    super.dispose();
  }

  bool _validateAllFields() {
    bool isFullNameValid = _fullName.currentState!.validate();
    bool isUserNameValid = _userName.currentState!.validate();
    bool isEmailValid = _email.currentState!.validate();
    bool isPasswordValid = _password.currentState!.validate();
    bool isdateValid = _DOB.currentState!.validate();

    if (isFullNameValid &&
        isUserNameValid &&
        isEmailValid &&
        isPasswordValid &&
        isdateValid) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => _passwordVisibilityBloc),
        BlocProvider(create: (_) => loginBloc),
        BlocProvider(create: (_) => imagePickerBloc),
        BlocProvider(create: (_) => dateSelectorBloc)
      ],
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 40,
              child: Column(
                children: [
                  const Spacer(),
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 2, 93, 205),
                          Color.fromARGB(255, 155, 225, 250),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.srcIn,
                    child: Text(
                      "FeelSync",
                      style: GoogleFonts.getFont('League Spartan',
                          textStyle: TextStyle(
                              fontSize: 10.w,
                              color: const Color.fromARGB(255, 8, 152, 204),
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                  BlocBuilder<ImagePickerBloc, ImagePickerState>(
                    builder: (context, state) {
                      file = state.file;

                      return Stack(alignment: Alignment.bottomRight, children: [
                        file == null
                            ? CircleAvatar(
                                radius: 15.w,
                                backgroundImage:
                                    const AssetImage('assets/blankprofile.png'),
                                backgroundColor: Colors.black,
                              )
                            : CircleAvatar(
                                radius: 15.w,
                                backgroundImage: MemoryImage(file!),
                                backgroundColor: Colors.black,
                              ),
                        IconButton(
                            padding: EdgeInsets.only(left: 4.w),
                            onPressed: () {
                              context
                                  .read<ImagePickerBloc>()
                                  .add(PickAnImage());
                            },
                            icon: Icon(
                              Icons.add_a_photo_outlined,
                              color: Colors.blue,
                              size: 10.w,
                            ))
                      ]);
                    },
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Form(
                        key: _fullName,
                        child: TextFormField(
                          enableSuggestions: false,
                          cursorColor: Colors.white,
                          autocorrect: false,
                          controller: fullName,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your 'full name'";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            isDense: true, // Added this
                            contentPadding: EdgeInsets.all(16),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.white),
                            ),
                            labelText: 'Full Name',
                            errorStyle:
                                TextStyle(color: Colors.red, fontSize: 10),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Color.fromARGB(255, 199, 78, 69),
                              ),
                            ),
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
                  const Spacer(),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Form(
                        key: _userName,
                        child: TextFormField(
                          enableSuggestions: false,
                          cursorColor: Colors.white,
                          autocorrect: false,
                          controller: userName,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your 'user name'";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            isDense: true, // Added this
                            contentPadding: EdgeInsets.all(16),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                              width: 1,
                              color: Colors.white,
                            )),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.white),
                            ),
                            labelText: 'User Name',
                            errorStyle:
                                TextStyle(color: Colors.red, fontSize: 10),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Color.fromARGB(255, 199, 78, 69),
                              ),
                            ),
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: BlocListener<DateSelectorBloc, DateSelectorState>(
                      listener: (context, state) {
                        if (state.dateTime != null) {
                          DOB.text =
                              '${state.dateTime!.toLocal()}'.split(' ')[0];
                          dataTime = state.dateTime;
                        }
                      },
                      child: BlocBuilder<DateSelectorBloc, DateSelectorState>(
                        builder: (context, state) {
                          return Form(
                            key: _DOB,
                            child: TextFormField(
                              controller: DOB,
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(16),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.white,
                                )),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.white),
                                ),
                                labelText: 'Date of Birth',
                                errorStyle:
                                    TextStyle(color: Colors.red, fontSize: 10),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color.fromARGB(255, 199, 78, 69),
                                  ),
                                ),
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                              readOnly: true,
                              onTap: () {
                                context
                                    .read<DateSelectorBloc>()
                                    .add(SelectDate(context: context));
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a date of birth.';
                                }

                                // Parse the selected date
                                DateTime? selectedDate =
                                    DateTime.tryParse(value);
                                if (selectedDate == null) {
                                  return 'Invalid date format.';
                                }

                                // Calculate the age
                                DateTime today = DateTime.now();
                                int age = today.year - selectedDate.year;
                                if (today.month < selectedDate.month ||
                                    (today.month == selectedDate.month &&
                                        today.day < selectedDate.day)) {
                                  age--; // Adjust for incomplete year
                                }

                                // Check if age is at least 16
                                if (age < 16) {
                                  return 'You must be at least 16 years old.';
                                }

                                return null; // Validation passed
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Form(
                        key: _email,
                        child: TextFormField(
                          enableSuggestions: false,
                          autocorrect: false,
                          cursorColor: Colors.white,
                          controller: email,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your 'email'";
                            } else if (!value.contains('@')) {
                              return "Invalid email";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            isDense: true, // Added this
                            contentPadding: EdgeInsets.all(16),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                              width: 1,
                              color: Colors.white,
                            )),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.white),
                            ),
                            labelText: 'Email',
                            errorStyle:
                                TextStyle(color: Colors.red, fontSize: 10),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Color.fromARGB(255, 199, 78, 69),
                              ),
                            ),
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Form(
                      key: _password,
                      child: BlocBuilder<PasswordVisibilityBloc,
                          PasswordVisibilityState>(
                        builder: (context, state) {
                          return TextFormField(
                            obscureText: !state.visibility,
                            cursorColor: Colors.white,
                            enableSuggestions: false,
                            autocorrect: false,
                            controller: password,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter 'password'";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                isDense: true, // Added this
                                contentPadding: const EdgeInsets.all(16),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.white)),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.white)),
                                labelText: 'Password',
                                errorStyle: const TextStyle(
                                    color: Colors.red, fontSize: 10),
                                errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color.fromARGB(255, 199, 78, 69),
                                  ),
                                ),
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      context
                                          .read<PasswordVisibilityBloc>()
                                          .add(Toggle());
                                    },
                                    icon: Icon(
                                      //ternary operator  bool ? open eye: close eye
                                      state.visibility
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ))),
                          );
                        },
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(left: 4.w),
                    child: Row(
                      children: [
                        const Text(
                          'Gender:',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 6.w),
                          child: DropdownButton<String>(
                            underline: null,
                            hint: const Text(
                              'Select Gender',
                              style: TextStyle(color: Colors.white),
                            ),
                            value: gender,
                            onChanged: (String? value) {
                              setState(() {
                                gender = value!;
                              });
                            },
                            items: ['Male', 'Female']
                                .map((gender) => DropdownMenuItem(
                                      value: gender,
                                      child: Text(gender),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  BlocListener<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state.status == Loginandregisterationstatus.failure) {
                        showErrorDialog(context, state.error);
                      } else if (state.status ==
                          Loginandregisterationstatus.sucess) {
                        Navigator.pushNamedAndRemoveUntil(context,
                            RouteNames.mainUI, (Route<dynamic> route) => false);
                      }
                    },
                    child: BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        return ElevatedButton(
                            onPressed: () async {
                              bool value = _validateAllFields();
                              if (value) {
                                final e = email.text;
                                final p = password.text;
                                final n = fullName.text;
                                final u = userName.text;

                                context.read<LoginBloc>().add(Registration(
                                    fullName: n,
                                    userName: u,
                                    email: e,
                                    password: p,
                                    file: file,
                                    DOB: dataTime!,
                                    gender: gender));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(370, 47),
                                backgroundColor:
                                    const Color.fromARGB(255, 8, 152, 204),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            child: state.status ==
                                    Loginandregisterationstatus.loading
                                ? const CupertinoActivityIndicator(
                                    color: Colors.white)
                                : const Text(
                                    "Login",
                                    style: TextStyle(color: Colors.white),
                                  ));
                      },
                    ),
                  ),
                  const Spacer(
                    flex: 3,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context,
                            RouteNames.login, (Route<dynamic> route) => false);
                      },
                      child: const Text(
                        "Already registered ? Login here",
                        style: TextStyle(color: Colors.grey),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
