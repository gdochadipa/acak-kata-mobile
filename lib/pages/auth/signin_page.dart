import 'package:acakkata/pages/auth/signup_page.dart';
import 'package:acakkata/providers/auth_provider.dart';
import 'package:acakkata/widgets/btn_raised.dart';
import 'package:acakkata/service/socket_service.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/clicky_button.dart';
import 'package:acakkata/widgets/custom_page_route.dart';
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
          Navigator.pushNamed(context, '/home');
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

    handleOfflineMode() {
      Navigator.pushNamed(context, '/home');
    }

    checkSocket() async {
      await socket.onTest();
    }

    Widget header() {
      return Container(
        margin: EdgeInsets.only(top: 70),
        child: Center(
          child: Image.asset(
            'assets/images/logo_putih.png',
            height: 132,
            width: 158,
          ),
        ),
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

    //set delay sebelum run on click
    Widget offlineModeBtn() {
      return Container(
        width: double.infinity,
        child: ClickyButton(
            color: backgroundColor2,
            shadowColor: shadowBackgroundColor2,
            margin: EdgeInsets.all(10),
            width: 300,
            height: 62,
            child: Text(
              "Offline Mode",
              style: whiteTextStyle.copyWith(fontSize: 16, fontWeight: medium),
            ),
            onPressed: handleOfflineMode),
      );
    }

    Widget body() {
      return Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 50),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: BoxDecoration(
            color: whiteColor, borderRadius: BorderRadius.circular(0)),
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
                Navigator.push(context, CustomPageRoute(SignUpPage()));
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
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: ListView(
            children: [header(), body(), footer()],
          ),
        ),
      ),
    );
  }
}
