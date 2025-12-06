import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../constants/app_language.dart';
import '../constants/app_routes.dart';
import '../constants/assets.dart';
import '../core/theme/bloc/theme_bloc.dart';
import '../core/theme/bloc/theme_event.dart';
import '../logic/blocs/auth/auth_bloc.dart';
import '../logic/blocs/auth/auth_event.dart';
import '../logic/blocs/auth/auth_state.dart';
import '../utils/app_validators.dart';
import '../utils/custom_snackbar.dart';
import '../widgets/app_text_form_field.dart';
import '../widgets/auth_form_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _resetEmailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _resetFormKey = GlobalKey<FormState>();

  bool isSignInMode = true;

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (isSignInMode) {
      BlocProvider.of<AuthBloc>(context).add(SignInWithEmailEvent(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ));
      return;
    }
    BlocProvider.of<AuthBloc>(context).add(SignUpWithEmailEvent(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // final deviceSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccessState) {
          CustomSnackbar.success(
            context: context,
            text: "An Email is sent to your registered email address!",
          );
        }
        if (state is AuthErrorState) {
          CustomSnackbar.error(
            context: context,
            text: state.e.message,
          );
        }

        if (state is SignUpWithEmailSuccessState) {
          context.go(AppRoutes.candidate);
          CustomSnackbar.success(
            context: context,
            text: "Logged in successfully!",
          );
        }

        if (state is LoggedInState) {
          BlocProvider.of<ThemeBloc>(context).add(LoadUserTheme(state.userId));
          if (state.role == AppConstants.admin) {
            context.go(AppRoutes.admin);
            CustomSnackbar.success(
              context: context,
              text: "Logged in successfully!",
            );
          } else if (state.role == AppConstants.candidate) {
            context.go(AppRoutes.candidate);
            CustomSnackbar.success(
              context: context,
              text: "Logged in successfully!",
            );
          } else {
            BlocProvider.of<AuthBloc>(context).add(LogoutEvent());
            context.go(AppRoutes.signIn);
          }
        }

        if (state is LoggedOutState) {
          CustomSnackbar.neutral(
            context: context,
            text: "Logged Out Successfully",
          );
        }
      },
      builder: (context, state) {
        final AppColors appColors = AppColors(context);

        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: appColors.background,
          body: state is AuthLoadingState
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.black,
                    color: Colors.white,
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 70),
                        Container(
                          height: 200,
                          padding: EdgeInsets.symmetric(
                            vertical: 24,
                            horizontal: 24,
                          ),
                          width: double.infinity,
                          child: ClipRRect(
                            // child: Image.network(
                            //   "https://cdn-icons-png.flaticon.com/512/6715/6715844.png",
                            //   fit: BoxFit.contain,
                            // ),
                            child: Image.asset(
                              Assets.logoTransparent,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 30,
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Welcome",
                                  style: theme.textTheme.displaySmall!.copyWith(
                                    fontFamily: GoogleFonts.oswald().fontFamily,
                                    color: appColors.onBackground,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(height: 3),
                                Text(
                                  isSignInMode
                                      ? "Sign in to continue"
                                      : "Sign up to continue",
                                  style: theme.textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: GoogleFonts.inter().fontFamily,
                                    color: appColors.onBackground,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(height: 15),
                                if (!isSignInMode)
                                  AuthFormField(
                                    hintText: AppLanguage.fullName,
                                    icon: Icons.person_outline,
                                    controller: _nameController,
                                    validator: AppValidators.textRequired,
                                  ),
                                if (!isSignInMode) SizedBox(height: 10),
                                AuthFormField(
                                  hintText: AppLanguage.email,
                                  icon: Icons.email_outlined,
                                  controller: _emailController,
                                  validator: AppValidators.emailRequired,
                                ),
                                SizedBox(height: 10),
                                AuthFormField(
                                  hintText: AppLanguage.password,
                                  icon: Icons.password,
                                  controller: _passwordController,
                                  validator: AppValidators.passwordRequired,
                                  isPassword: true,
                                ),
                                if (!isSignInMode) SizedBox(height: 10),
                                if (!isSignInMode)
                                  AuthFormField(
                                    hintText: AppLanguage.confirmPassword,
                                    icon: Icons.password,
                                    controller: _confirmPasswordController,
                                    validator: (value) {
                                      if (_confirmPasswordController.text
                                              .trim() !=
                                          _passwordController.text.trim()) {
                                        return "Passwords do not match";
                                      }
                                      return null;
                                    },
                                    isPassword: true,
                                  ),
                                if (isSignInMode)
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          backgroundColor: theme
                                              .colorScheme.secondaryContainer,
                                          title: Text("Reset Password"),
                                          content: Form(
                                            key: _resetFormKey,
                                            child: AppTextFormField(
                                              controller: _resetEmailController,
                                              hintText:
                                                  "Enter Registered Email",
                                              validator:
                                                  AppValidators.emailRequired,
                                            ),
                                          ),
                                          actions: [
                                            FilledButton(
                                              style: FilledButton.styleFrom(
                                                backgroundColor:
                                                    Colors.white.withAlpha(200),
                                                foregroundColor: Colors.black,
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              child: Text(AppLanguage.cancel),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            FilledButton(
                                              style: FilledButton.styleFrom(
                                                backgroundColor:
                                                    Colors.white.withAlpha(200),
                                                foregroundColor: Colors.black,
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              onPressed: () {
                                                if (_resetFormKey.currentState
                                                        ?.validate() ??
                                                    false) {
                                                  _resetFormKey.currentState!
                                                      .save();

                                                  BlocProvider.of<AuthBloc>(
                                                          context)
                                                      .add(ResetPasswordEvent(
                                                    _resetEmailController.text
                                                        .trim(),
                                                  ));
                                                  Navigator.of(context).pop();
                                                }
                                              },
                                              child: Text(AppLanguage.submit),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 8,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Forgot Password?",
                                            style: theme.textTheme.labelLarge!
                                                .copyWith(
                                              color: theme.colorScheme.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                SizedBox(height: 20),
                                // Login Button
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    state is AuthLoadingState
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              color: appColors.onBackground,
                                            ),
                                          )
                                        : ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  theme.colorScheme.primary,
                                              // foregroundColor:
                                              //     appColors.background,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 80,
                                                      vertical: 12),
                                            ),
                                            onPressed: state is AuthLoadingState
                                                ? null
                                                : _onSubmit,
                                            child: Text(
                                              isSignInMode
                                                  ? AppLanguage.signIn
                                                  : AppLanguage.signUp,
                                              style: theme.textTheme.titleLarge!
                                                  .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    theme.colorScheme.onPrimary,
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Center(
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: isSignInMode
                                          ? "Don't have an account? "
                                          : "Already have an account? ",
                                      style:
                                          theme.textTheme.bodyMedium!.copyWith(
                                        color: appColors.onBackground
                                            .withAlpha(200),
                                      ),
                                      children: [
                                        TextSpan(
                                          text: isSignInMode
                                              ? "Sign Up"
                                              : "Sign In",
                                          style: theme.textTheme.bodyMedium!
                                              .copyWith(
                                            color: theme.colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              setState(() {
                                                isSignInMode = !isSignInMode;
                                              });
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
