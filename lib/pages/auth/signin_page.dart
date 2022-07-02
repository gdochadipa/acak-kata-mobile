import 'package:acakkata/pages/auth/signup_page.dart';
import 'package:acakkata/providers/auth_provider.dart';
import 'package:acakkata/service/socket_service.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/button/button_bounce.dart';
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
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    handleSignIn() async {
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

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            e.toString().replaceAll('Exception:', ''),
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
          margin: const EdgeInsets.all(11),
          decoration: BoxDecoration(color: whiteColor, shape: BoxShape.circle),
          padding: const EdgeInsets.all(10),
          child: const Center(
            child: Icon(Icons.arrow_back_ios_new, size: 20),
          ),
        ),
      );
    }

    Widget header() {
      return Container(
        child: Stack(children: [
          Container(
            margin: const EdgeInsets.only(left: 10, top: 10),
            alignment: Alignment.topLeft,
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

    Widget emailInput() {
      return Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email',
              style: whiteTextStyle.copyWith(fontSize: 18, fontWeight: bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      controller: emailController,
                      style: whiteTextStyle,
                      decoration: InputDecoration.collapsed(
                          hintText: 'Your Email Address',
                          hintStyle: whiteTextStyle),
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
              height: 5,
            ),
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      obscureText: true,
                      style: whiteTextStyle,
                      controller: passwordController,
                      decoration: InputDecoration.collapsed(
                          hintText: 'Your Password', hintStyle: whiteTextStyle),
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
        margin: const EdgeInsets.only(top: 25),
        alignment: Alignment.center,
        child: ButtonBounce(
            onClick: handleSignIn,
            color: whiteColor,
            borderColor: whiteColor2,
            shadowColor: whiteColor3,
            widthButton: 245,
            heightButton: 50,
            child: Center(
              child: Text(
                'SIGN IN',
                style:
                    primaryTextStyle.copyWith(fontSize: 16, fontWeight: bold),
              ),
            )),
      );
    }

    Widget body() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 50),
        padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: bottom),
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
        margin: const EdgeInsets.only(bottom: 30, top: 20),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Don \'t have an account? ',
              style: whiteTextStyle.copyWith(fontSize: 14, fontWeight: bold),
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
                style: purpleTextStyle.copyWith(fontSize: 14, fontWeight: bold),
              ),
            )
          ],
        ),
      );
    }

    return WillPopScope(
        child: Scaffold(
          backgroundColor: primaryColor5,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  children: [header(), body(), footer()],
                )),
          ),
        ),
        onWillPop: () async => false);
  }
}
