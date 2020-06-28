import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:authentication/shared/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'bloc/login_bloc.dart';
import 'bloc/login_event.dart';
import 'bloc/login_state.dart';

class Login extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute(builder: (_) => Login());
  }

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginBloc loginBloc;

  @override
  void initState() {
    loginBloc = widget.scope.get();
    super.initState();
  }

  @override
  void dispose() {
    widget.scope.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
          bloc: loginBloc,
          listener: (context, state) {
            if (state is LoginFailure) {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                    SnackBar(content: Text(state.message.toString())));
            }
          },
          child: LoginForm(loginBloc: loginBloc)),
    );
  }
}

class LoginForm extends StatefulWidget {
  final LoginBloc loginBloc;

  const LoginForm({Key key, this.loginBloc}) : super(key: key);
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController _emailController;
  TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Log In",
                        style: GoogleFonts.quicksand(
                            fontSize: 55,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff565558)),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        controller: _emailController,
                        labelTest: "Username",
                        textInputType: TextInputType.text,
                      ),
                      CustomTextField(
                        controller: _passwordController,
                        labelTest: "Password",
                        textInputType: TextInputType.visiblePassword,
                        obscureText: true,
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      LogInButton(
                        buttonText: "Log In",
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            widget.loginBloc.add(LoginWithCredentials(
                                _emailController.value.text,
                                'AdminAPIProdutos01!'));
                          }
                        },
                      ),
                      SizedBox(
                        height: 40,
                      )
                    ],
                  ),
                ),
              ),
              ArroBack()
            ],
          )),
    );
  }
}
