import 'package:flutter/material.dart';
import 'dart:io';
import '../widgets/radioform.dart';
import 'package:flutter/services.dart';
import '../utilities/constans.dart';

class AuthForm extends StatefulWidget {
  AuthForm(
    this.submitFn,
    this.isLoading,
  );

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String confirmpassword,
    String usertype,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userConfirmPassword = '';
  var _userType = '';
  var _userPassword = '';
  bool _showpw = false;

  void _changeUser(String newvalue){
    _userType=newvalue;
  }

  void _trySubmit() {
    try {
      final isValid = _formKey.currentState.validate();
      FocusScope.of(context).unfocus();
      if (_userPassword != _userConfirmPassword) {
        print("jelszavak : " + _userPassword + " es " + _userConfirmPassword);
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('The 2 passwords don\'t match'),
          backgroundColor: Theme.of(context).errorColor,
        ));
        return;
      }
      if(_userType=='' && !_isLogin){
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('You have to choose: Customer or Service Provider'),
          backgroundColor: Theme.of(context).errorColor,
        ));
        return;
      }

      if (isValid) {
        _formKey.currentState.save();
        widget.submitFn(_userEmail.trim(), _userPassword.trim(),
            _userConfirmPassword.trim(), _userType,_isLogin, context);
      }
    } catch (error) {
      
    }
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            key: ValueKey('email'),
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            validator: (value) {
              if (value.isEmpty || !value.contains('@')) {
                return 'Please enter a valid email address.';
              }
              return null;
            },
            onSaved: (value) {
              _userEmail = value;
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Color(0xFF527DAA),
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF(String pwlabel, String pwhint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          pwlabel,
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            key: ValueKey('password'),
            autocorrect: false,
            textCapitalization: TextCapitalization.none,
            obscureText: _showpw ? false : true,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            onSaved: (value) {
              if (pwlabel == 'Password') {
                _userPassword = value;
              } else {
                _userConfirmPassword = value;
              }
            },
            validator: (value) {
              if (value.isEmpty || value.length < 6) {
                return 'Password must be at least 6 characters long.';
              }
              return null;
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.security,
                color: Color(0xFF527DAA),
              ),
              suffixIcon: IconButton(
                  icon: !_showpw
                      ? Icon(
                          Icons.lock,
                          color: Colors.black38,
                        )
                      : Icon(Icons.lock_open, color: Colors.black38),
                  onPressed: () {
                    setState(() {
                      _showpw = !_showpw;
                    });
                  }),
              hintText: pwhint,
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print('Forgot Password Button Pressed'),
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: widget.isLoading
          ? CircularProgressIndicator()
          : RaisedButton(
              elevation: 5.0,
              onPressed: _trySubmit,
              padding: EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.white,
              child: Text(
                _isLogin ? 'LOGIN' : 'REGISTER',
                style: TextStyle(
                  color: Color(0xFF527DAA),
                  letterSpacing: 1.5,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
    );
  }

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- OR -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Sign in with',
          style: kLabelStyle,
        ),
      ],
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () => print('Login with Google'),
            AssetImage(
              'assets/images/google.jpg',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isLogin = !_isLogin;
        });
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: _isLogin
                  ? 'Don\'t have an Account? '
                  : 'Already have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: _isLogin ? 'Sign Up' : 'Sign In',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: kGradientStyle
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  //height: double.infinity,
                  //child: Expanded(
                  // physics: AlwaysScrollableScrollPhysics(),
                  // padding: EdgeInsets.symmetric(
                  //   horizontal: 40.0,
                  //   vertical: 120.0,
                  // ),
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            _isLogin ? 'Sign In' : 'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: _isLogin ? 30.0 : 15.0),
                          if (!_isLogin)
                            FittedBox(fit: BoxFit.cover, child: RadioForm(_changeUser)),
                          SizedBox(height: _isLogin ? 30.0 : 15.0),
                          _buildEmailTF(),
                          SizedBox(
                            height: _isLogin ? 30.0 : 15.0,
                          ),
                          _buildPasswordTF("Password", 'Enter your Password'),
                          if (!_isLogin)
                            SizedBox(
                              height: _isLogin ? 20.0 : 10.0,
                            ),
                          if (!_isLogin)
                            _buildPasswordTF(
                                "Password again", 'Confirm your Password'),
                          if (_isLogin) _buildForgotPasswordBtn(),
                          _buildLoginBtn(),
                          _buildSignInWithText(),
                          _buildSocialBtnRow(),
                          _buildSignupBtn(),
                        ],
                      ),
                    ),
                  ),
                  //),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
