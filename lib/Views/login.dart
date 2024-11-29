import 'package:feel_sync/Routes/RouteNames.dart';
import 'package:feel_sync/Utilities/ReusableUI/ErrorMessage.dart';
import 'package:feel_sync/Utilities/LoginAndRegisterationStatus.dart';
import 'package:feel_sync/bloc/LoginBloc/login&Registration_bloc.dart';
import 'package:feel_sync/bloc/PasswordBloc/password_visibility_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late PasswordVisibilityBloc _passwordVisibilityBloc;
  late LoginBloc loginBloc;
  bool loading = false;
  bool passwordInvisible = true;
  late TextEditingController email;
  late TextEditingController password;
  @override
  void initState() {
    super.initState();
    email = TextEditingController();
    password = TextEditingController();
    _passwordVisibilityBloc = PasswordVisibilityBloc();
    loginBloc = LoginBloc();
  }

  @override
  void dispose() {
    password.dispose();
    email.dispose();
    loginBloc.close();
    _passwordVisibilityBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => _passwordVisibilityBloc),
          BlocProvider(create: (_) => loginBloc)
        ],
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 2.w, right: 2.w),
              child: Column(
                children: [
                  const Spacer(
                    flex: 8,
                  ),
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
                              fontSize: 17.w,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                  TextField(
                    cursorColor: Colors.white,
                    enableSuggestions: true,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    controller: email,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                        width: 1,
                        // color: primaryColor,
                      )),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.white),
                      ),
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  BlocBuilder<PasswordVisibilityBloc, PasswordVisibilityState>(
                    builder: (context, state) {
                      return TextField(
                        cursorColor: Colors.white,
                        obscureText: !state.visibility,
                        enableSuggestions: false,
                        autocorrect: false,
                        controller: password,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.white)),
                            focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.white)),
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: Colors.white),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  context
                                      .read<PasswordVisibilityBloc>()
                                      .add(Toggle());
                                },
                                icon: Icon(
                                  state.visibility
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ))),
                      );
                    },
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
                            onPressed: () {
                              final e = email.text;
                              final p = password.text;
                              if (e.isNotEmpty && p.isNotEmpty) {
                                context
                                    .read<LoginBloc>()
                                    .add(Login(email: e, password: p));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(370, 50),
                                backgroundColor:
                                    const Color.fromARGB(255, 8, 152, 204),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            child: state.status ==
                                    Loginandregisterationstatus.loading
                                ? const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    strokeCap: StrokeCap.round,
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Login",
                                    style: TextStyle(color: Colors.white),
                                  ));
                      },
                    ),
                  ),
                  const Spacer(
                    flex: 8,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            RouteNames.registeration,
                            (Route<dynamic> route) => false);
                      },
                      child: const Text(
                        "Not registered yet ? Register here",
                        style: TextStyle(color: Colors.grey),
                      )),
                ],
              ),
            ),
          ),
        ));
  }
}
