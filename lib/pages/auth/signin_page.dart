import 'package:acakkata/pages/auth/signup_page.dart';
import 'package:acakkata/providers/auth_provider.dart';
import 'package:acakkata/widgets/btn_raised.dart';
import 'package:acakkata/service/socket_service.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/clicky_button.dart';
import 'package:acakkata/widgets/custom_page_route.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  // const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController(text: '');

  TextEditingController passwordController = TextEditingController(text: '');

  bool isLoading = false;

  SocketService socket = SocketService();

  @override
  void initState() {
    // TODO: implement initState
    getInit();
    super.initState();
  }

  getInit() async {
    await socket.fireSocket();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    handleSignIn() async {
      print("on handle Sign in");
      setState(() {
        isLoading = true;
      });
      try {
        if (await authProvider.login(
            email: emailController.text, password: passwordController.text)) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (route) => false,
          );
        }
      } catch (e, stack) {
        print(e);
        print(stack);
        String error = e.toString().replaceAll('Exception:', '');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            '${error}',
            textAlign: TextAlign.center,
          ),
          backgroundColor: alertColor,
        ));
      }

      setState(() {
        isLoading = false;
      });
    }

    checkSocket() async {
      await socket.onTest();
    }

    Widget btnBack() {
      return BouncingWidget(
        onPressed: () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/home', (route) => false);
        },
        child: Container(
          width: 39,
          height: 39,
          margin: EdgeInsets.all(11),
          decoration: BoxDecoration(color: whiteColor, shape: BoxShape.circle),
          padding: EdgeInsets.all(10),
          child: Center(
            child: Icon(Icons.arrow_back_ios_new, size: 20),
          ),
        ),
      );
    }

    Widget header() {
      return Container(
        child: Stack(children: [
          Container(
            margin: EdgeInsets.only(left: 10, top: 10),
            alignment: Alignment.topLeft,
            child: btnBack(),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, top: 80),
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/logo_putih.png',
              height: 132,
              width: 158,
            ),
          )
        ]),
      );
    }

    Widget emailInput() {
      return Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email',
              style:
                  blackTextStyle.copyWith(fontSize: 17, fontWeight: semiBold),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  border: Border.all(color: blackColor),
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      controller: emailController,
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
        margin: EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Password',
              style:
                  blackTextStyle.copyWith(fontSize: 17, fontWeight: semiBold),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  border: Border.all(color: blackColor),
                  color: backgroundColor1,
                  borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      obscureText: true,
                      style: primaryTextStyle,
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

    Widget signInButton() {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 20),
        alignment: Alignment.center,
        child: ClickyButton(
            onPressed: handleSignIn,
            color: backgroundColor1,
            shadowColor: backgroundColor2,
            margin: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
            width: 245,
            height: 60,
            child: Text(
              'SIGN IN',
              style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: bold),
            )),
      );
    }

    Widget body() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 50),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: BoxDecoration(
            color: whiteColor, borderRadius: BorderRadius.circular(5)),
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            emailInput(),
            passwordInput(),
            signInButton(),
            // offlineModeBtn(),
          ],
        )),
      );
    }

    Widget footer() {
      return Container(
        margin: EdgeInsets.only(bottom: 30, top: 50),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Don \'t have an account? ',
              style: whiteTextStyle.copyWith(fontSize: 12, fontWeight: bold),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  CustomPageRoute(SignUpPage()),
                  (route) => false,
                );
              },
              child: Text(
                'Sign Up',
                style: purpleTextStyle.copyWith(
                    fontSize: 12, fontWeight: semiBold),
              ),
            )
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor2,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          children: [header(), body(), footer()],
        )),
      ),
    );
  }
}
