import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';


abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  final String username;
  final String password;

  const LoginButtonPressed({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];
}


abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginSuccess extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure({required this.error});

  @override
  List<Object> get props => [error];
}

// BLoC for managing the login form state
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      // Add your authentication logic here
      // For simplicity, let's assume the login is successful after a delay
      await Future.delayed(Duration(seconds: 2));

      // Check the username and password (this is just a basic example)
      if (event.username == 'user' && event.password == 'password') {
        yield LoginSuccess();
      } else {
        yield LoginFailure(error: 'Invalid username or password');
      }
    }
  }
}

// UI for the login form
class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: LoginFormWidget(),
    );
  }
}

class LoginFormWidget extends StatefulWidget {
  @override
  _LoginFormWidgetState createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Form'),
      ),
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          // ... (unchanged)
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (state is LoginLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(labelText: 'Username'),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(labelText: 'Password'),
                      ),
                      SizedBox(height: 32),
                      // Customized login button design
                      GestureDetector(
                        onTap: () {
                          // Dispatch the login event when the button is pressed
                          BlocProvider.of<LoginBloc>(context).add(
                            LoginButtonPressed(
                              username: _usernameController.text,
                              password: _passwordController.text,
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}



void main() {
  runApp(MaterialApp(
    home: LoginForm(),
  ));
}
