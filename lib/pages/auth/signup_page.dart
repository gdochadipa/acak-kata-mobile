import 'package:acakkata/helper/validation_helper.dart';
import 'package:acakkata/pages/auth/signin_page.dart';
import 'package:acakkata/providers/auth_provider.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/btn_loading.dart';
import 'package:acakkata/widgets/button/button_bounce.dart';
import 'package:acakkata/widgets/button/circle_bounce_button.dart';
import 'package:acakkata/widgets/clicky_button.dart';
import 'package:acakkata/widgets/custom_page_route.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  // const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController nameController = TextEditingController(text: '');

  TextEditingController emailController = TextEditingController(text: '');

  TextEditingController passwordController = TextEditingController(text: '');

  bool isLoading = false;
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    handleSignUp() async {
      setState(() {
        isLoading = true;
      });

      try {
        if (await authProvider.register(
            name: nameController.text,
            email: emailController.text,
            password: passwordController.text)) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (route) => false,
          );
        }
      } catch (e) {
        String error = e.toString().replaceAll('Exception:', '');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            error,
            textAlign: TextAlign.center,
          ),
          backgroundColor: alertColor,
        ));
      }

      setState(() {
        isLoading = false;
      });
    }

    Widget btnBack() {
      return CircleBounceButton(
        onClick: () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/home', (route) => false);
        },
        widthButton: 39,
        heightButton: 39,
        color: whiteColor,
        borderColor: whiteColor2,
        shadowColor: whiteColor3,
        child: const Center(
          child: Icon(Icons.arrow_back_ios_new, size: 20),
        ),
      );
    }

    Widget header() {
      return Container(
        child: Stack(children: [
          Container(
            margin: const EdgeInsets.only(left: 10, top: 10),
            alignment: Alignment.topRight,
            child: btnBack(),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10, top: 80),
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/logo_baru_no.png',
              height: 132,
              width: 158,
            ),
          )
        ]),
      );
    }

    Widget usernameInput() {
      return Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Username',
              style: whiteTextStyle.copyWith(fontSize: 19, fontWeight: bold),
            ),
            const SizedBox(
              height: 2,
            ),
            Container(
              height: 55,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: primaryColor9,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      style: primaryTextStyle,
                      validator: (valid) =>
                          ValidationHelper.validateUsername(valid),
                      controller: nameController,
                      decoration: InputDecoration.collapsed(
                          hintText: 'Your Username',
                          hintStyle: subtitleTextStyle),
                    ))
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget emailInput() {
      return Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email',
              style: whiteTextStyle.copyWith(fontSize: 19, fontWeight: bold),
            ),
            const SizedBox(
              height: 2,
            ),
            Container(
              height: 55,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: primaryColor9,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      controller: emailController,
                      validator: (validate) =>
                          ValidationHelper.validateEmail(validate),
                      style: primaryTextStyle,
                      decoration: InputDecoration.collapsed(
                          hintText: 'Your Email Address',
                          hintStyle: subtitleTextStyle),
                    ))
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget passwordInput() {
      return Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Password',
              style: whiteTextStyle.copyWith(fontSize: 17, fontWeight: bold),
            ),
            const SizedBox(
              height: 2,
            ),
            Container(
              height: 55,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: primaryColor9,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      obscureText: true,
                      style: primaryTextStyle,
                      validator: (valid) =>
                          ValidationHelper.validatePassowrd(valid),
                      controller: passwordController,
                      decoration: InputDecoration.collapsed(
                          hintText: 'Your Password',
                          hintStyle: subtitleTextStyle),
                    ))
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget signUpButton() {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 30),
        alignment: Alignment.center,
        child: ButtonBounce(
            onClick: () {
              final isValid = _form.currentState!.validate();
              if (!isValid) {
                return;
              } else {
                handleSignUp();
              }
            },
            color: whiteColor,
            borderColor: whiteColor2,
            shadowColor: whiteColor3,
            widthButton: 245,
            heightButton: 50,
            child: Center(
              child: Text(
                'SIGN UP',
                style: primaryTextStyle.copyWith(
                    fontSize: 16, fontWeight: extraBold),
              ),
            )),
      );
    }

    Widget body() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
        padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: bottom),
        child: Form(
          key: _form,
          child: Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              usernameInput(),
              emailInput(),
              passwordInput(),
              isLoading ? ButtonLoading() : signUpButton(),
            ],
          )),
        ),
      );
    }

    Widget footer() {
      return Container(
        margin: const EdgeInsets.only(bottom: 30, top: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already have an account? ',
              style: whiteTextStyle.copyWith(fontSize: 15, fontWeight: bold),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, CustomPageRoute(SignInPage()));
              },
              child: Text(
                'Sign In',
                style: purpleTextStyle.copyWith(
                    fontSize: 15, fontWeight: semiBold),
              ),
            )
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: primaryColor5,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [header(), body(), footer()],
            )),
      ),
    );
  }
}
