import 'package:acakkata/providers/auth_provider.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/btn_loading.dart';
import 'package:acakkata/widgets/button/button_bounce.dart';
import 'package:acakkata/widgets/button/circle_bounce_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  TextEditingController nameController = TextEditingController(text: '');

  TextEditingController emailController = TextEditingController(text: '');

  TextEditingController usernameController = TextEditingController(text: '');

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    handleUpdateProfile() async {
      setState(() {
        isLoading = true;
      });

      try {
        if (await authProvider.updateProfile(
            email: emailController.text,
            username: usernameController.text,
            name: nameController.text)) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(
              "Successfuly update profile !",
              textAlign: TextAlign.center,
            ),
            backgroundColor: successColor,
          ));
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
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      style: whiteTextStyle,
                      controller: usernameController,
                      decoration: InputDecoration.collapsed(
                          hintText: 'Your Username', hintStyle: whiteTextStyle),
                    ))
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget nameInput() {
      return Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama',
              style: whiteTextStyle.copyWith(fontSize: 19, fontWeight: bold),
            ),
            const SizedBox(
              height: 2,
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
                      style: whiteTextStyle,
                      controller: nameController,
                      decoration: InputDecoration.collapsed(
                          hintText: 'Nama', hintStyle: whiteTextStyle),
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

    Widget updateButton() {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 30),
        alignment: Alignment.center,
        child: ButtonBounce(
            onClick: handleUpdateProfile,
            color: whiteColor,
            borderColor: whiteColor2,
            shadowColor: whiteColor3,
            widthButton: 245,
            heightButton: 50,
            child: Center(
              child: Text(
                'Update',
                style: primaryTextStyle.copyWith(
                    fontSize: 16, fontWeight: extraBold),
              ),
            )),
      );
    }

    Widget body() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            usernameInput(),
            emailInput(),
            isLoading ? ButtonLoading() : updateButton(),
          ],
        )),
      );
    }

    return Scaffold(
      backgroundColor: primaryColor5,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          children: [header(), body()],
        )),
      ),
    );
  }
}
