import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<dynamic, SignUpPageViewModel>(
      distinct: true,
      converter: (store) => SignUpPageViewModel.fromStore(context, store),
      builder: (_, viewModel) => SignUpPageContent(viewModel, token),
    );
  }
}

class SignUpPageContent extends StatefulWidget {
  SignUpPageContent(this.viewModel, this.token);
  final SignUpPageViewModel viewModel;
  final String token;

  @override
  _SignUpPageContentState createState() {
    return new _SignUpPageContentState();
  }
}

class _SignUpPageContentState extends State<SignUpPageContent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Contact newContact = new Contact();

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final GlobalKey<FormFieldState<String>> _nameFieldKey =
      new GlobalKey<FormFieldState<String>>();

  final GlobalKey<FormFieldState<String>> _phoneFieldKey =
      new GlobalKey<FormFieldState<String>>();

  final GlobalKey<FormFieldState<String>> _emailFieldKey =
      new GlobalKey<FormFieldState<String>>();

  final GlobalKey<FormFieldState<String>> _birthdateFieldKey =
      new GlobalKey<FormFieldState<String>>();

  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      new GlobalKey<FormFieldState<String>>();

  final GlobalKey<FormFieldState<String>> _passwordConfirmFieldKey =
      new GlobalKey<FormFieldState<String>>();
  final MaskedTextController _dateControler =
      new MaskedTextController(mask: '00/00/0000');
  final MaskedTextController _phoneControler =
      new MaskedTextController(mask: '000-0000000');
  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  bool _autovalidate = false;
  bool _error = false;
  bool checkboxNotifications = true;
  bool checkboxTerms = false;
  bool checkboxPolicies = false;

  bool _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      setState(() {
        _error = true;
      });
      return false;
    } else {
      // Text forms has validated.
      // Let's validate radios and checkbox
      if (!checkboxTerms) {
        // The checkbox wasn't checked
        showInSnackBar('Porfavor acepte los terminos y condiciones');
        return false;
      } else if (!checkboxPolicies) {
        // The checkbox wasn't checked
        showInSnackBar('Porfavor acepte las politicas de privacidad');
        return false;
      } else {
        // Every of the data in the form are valid at this point
        form.save();
        setState(() {
          _error = false;
        });
        return true;
      }
    }
  }

  String _validatePhoneNumber(String value) {
    return validatePhoneNumber(context, value);
  }

  String _validateName(String value) {
    return validateName(context, value);
  }

  String _validateEmail(String value) {
    return validateEmail(context, value);
  }

  String _validatePassword(String value) {
    return validatePassword(context, value);
  }

  String _validateConfirmPassword(String value) {
    return validateConfirmPassword(
        context, value, _passwordConfirmFieldKey.currentState.value);
  }

  String _validateDate(String value) {
    return validateDate(context, value);
  }

  Future _chooseDate(BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now);

    var result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now());

    if (result == null) return;

    setState(() {
      _dateControler.text = new DateFormat('ddMMyyyy').format(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    var config = AppConfig.of(context);
    var store = StoreProvider.of<dynamic>(context);

    Widget _buildHeader() {
      return Container(
        padding: const EdgeInsets.only(left: 20.0, top: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
//            new Row(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                Radio<int>(
//                  value: 1,
//                  groupValue: 1,
//                  onChanged: (int) {},
//                ),
//                Radio<int>(
//                  value: 2,
//                  groupValue: 1,
//                  onChanged: (int) {},
//                )
//              ],
//            ),
//            SizedBox(
//              height: 20.0,
//            ),
            new Text(
              MyLocalizations.of(context).affiliateAccountMsg1,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(color: Colors.black54),
            )
          ],
        ),
      );
    }

    Widget _buildInputs() {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    border: Border.all(style: BorderStyle.none)),
                child: TextFormField(
                  key: _nameFieldKey,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: MyLocalizations.of(context).name,
                    labelStyle: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(color: Theme.of(context).hintColor),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                    border: InputBorder.none,
                  ),
                  maxLines: 1,
                  validator: _validateName,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    border: Border.all(style: BorderStyle.none)),
                child: TextFormField(
                  key: _phoneFieldKey,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: MyLocalizations.of(context).phone,
                    labelStyle: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(color: Theme.of(context).hintColor),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                    border: InputBorder.none,
                  ),
                  validator: _validatePhoneNumber,
                  controller: _phoneControler,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      border: Border.all(style: BorderStyle.none)),
                  child: new TextFormField(
                    key: _birthdateFieldKey,
                    decoration: InputDecoration(
                      suffixIcon: new IconButton(
                        icon: new Icon(Icons.calendar_today),
                        tooltip: 'Escoja una fecha',
                        onPressed: (() {
                          _chooseDate(context, _dateControler.text);
                        }),
                      ),
                      labelText: 'Fecha de Nacimiento',
                      hintText: 'dd/mm/yyyy',
                      labelStyle: Theme.of(context)
                          .textTheme
                          .body1
                          .copyWith(color: Theme.of(context).hintColor),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 15.0),
                      border: InputBorder.none,
                    ),
                    controller: _dateControler,
                    keyboardType: TextInputType.datetime,
                    validator: _validateDate,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    border: Border.all(style: BorderStyle.none)),
                child: TextFormField(
                  key: _emailFieldKey,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: MyLocalizations.of(context).email,
                    labelStyle: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(color: Theme.of(context).hintColor),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                    border: InputBorder.none,
                  ),
                  maxLines: 1,
                  validator: _validateEmail,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    border: Border.all(style: BorderStyle.none)),
                child: PasswordField(
                  fieldKey: _passwordFieldKey,
                  labelText: MyLocalizations.of(context).password,
                  validator: _validatePassword,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    border: Border.all(style: BorderStyle.none)),
                child: PasswordField(
                  fieldKey: _passwordConfirmFieldKey,
                  labelText: MyLocalizations.of(context).reTypePassword,
                  validator: _validateConfirmPassword,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildCheckbox() {
      return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: checkboxNotifications,
                      onChanged: (bool value) {
                        setState(() {
                          checkboxNotifications = value;
                        });
                      },
                    ),
                    Text('Envío de Comunicaciones')
                  ],
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: checkboxTerms,
                      onChanged: (bool value) {
                        setState(() {
                          checkboxTerms = value;
                        });
                      },
                    ),
                    Text('Acepto los ' +
                        MyLocalizations.of(context).termsAndConditions)
                  ],
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: checkboxPolicies,
                      onChanged: (bool value) {
                        setState(() {
                          checkboxPolicies = value;
                        });
                      },
                    ),
                    Text('Acepto la ' +
                        MyLocalizations.of(context).privacyPolicies)
                  ],
                ),
              ],
            ),
          ]);
    }

    Widget _buildTerms() {
      return Column(
        children: <Widget>[
          Container(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: Colors.black26),
                children: <TextSpan>[
                  new TextSpan(
                    text: MyLocalizations.of(context).termsAndConditionsMsg1,
                  ),
                  new TextSpan(
                    text: MyLocalizations.of(context).termsAndConditionsMsg2,
                  ),
                  new TextSpan(
                    text: MyLocalizations.of(context)
                        .termsAndConditionsMsg3
                        .split('%')[0],
                  ),
                  new TextSpan(
                      text: MyLocalizations.of(context).termsAndConditions,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(color: Theme.of(context).accentColor)),
                  new TextSpan(
                    text: MyLocalizations.of(context)
                        .termsAndConditionsMsg3
                        .split('%')[1],
                  ),
                  new TextSpan(
                      text: MyLocalizations.of(context).privacyPolicies,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(color: Theme.of(context).accentColor)),
                  new TextSpan(
                      text: MyLocalizations.of(context).termsAndConditionsMsg4),
                ],
              ),
            ),
          ),
          _buildCheckbox()
        ],
      );
    }

    return new Scaffold(
        bottomNavigationBar: Container(
          height: 50.0,
          child: Column(
            children: <Widget>[
              Divider(height: 1.0),
              Container(
                  height: 49.0,
                  width: double.infinity,
                  child: Image.asset(
                    AppConfig.of(context).images.poweredBy,
                    alignment: Alignment.center,
                  )),
            ],
          ),
        ),
        appBar: _error
            ? new AppBar(
                title: new Text(
                  MyLocalizations.of(context).affiliateAccount,
                  style: Theme.of(context)
                      .textTheme
                      .subhead
                      .copyWith(color: Colors.white),
                ),
                centerTitle: true,
              )
            : new AppBar(
                title: new Text(
                  MyLocalizations.of(context).affiliateAccount,
                  style: Theme.of(context)
                      .textTheme
                      .subhead
                      .copyWith(color: Colors.white),
                ),
                centerTitle: true,
              ),
        key: _scaffoldKey,
        body: LoadingView(
          status: widget.viewModel.status,
          errorContent: null,
          loadingContent: const PlatformAdaptiveProgressIndicator(),
          successContent: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidate: _autovalidate,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildHeader(),
                    _buildInputs(),
                    _buildTerms(),
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      child: RaisedButton(
                        splashColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        onPressed: () {
                          if (_handleSubmitted()) {
                            print('registrado');
                            Map jsonMap = {
                              "name":
                                  _nameFieldKey.currentState.value.toString(),
                              "email":
                                  _emailFieldKey.currentState.value.toString(),
                              "password": _passwordFieldKey.currentState.value
                                  .toString(),
                              "birthdate": convertToDate(
                                      _birthdateFieldKey.currentState.value)
                                  .toString()
                                  .split(' ')[0],
                              "phone_number": _passwordFieldKey
                                  .currentState.value
                                  .toString()
                            };
                            print(jsonMap);
                            store.dispatch(UserSignUpAction(context, jsonMap));
                          } else {
                            print('error');
                          }
                        },
                        color: Colors.lightGreen,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Text(MyLocalizations.of(context).next,
                              style: Theme.of(context).primaryTextTheme.body1),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
  });

  final Key fieldKey;
  final String hintText;
  final String labelText;
  final String helperText;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;

  @override
  _PasswordFieldState createState() => new _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
          shape: BoxShape.rectangle,
          border: Border.all(style: BorderStyle.none)),
      child: new TextFormField(
        key: widget.fieldKey,
        obscureText: _obscureText,
        onSaved: widget.onSaved,
        validator: widget.validator,
        onFieldSubmitted: widget.onFieldSubmitted,
        decoration: new InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          border: InputBorder.none,
          hintText: widget.hintText,
          labelText: widget.labelText,
          labelStyle: TextStyle(color: Theme.of(context).hintColor),
          suffixIcon: new GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: new Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).hintColor,
            ),
          ),
        ),
      ),
    );
  }
}

class Contact {
  String name;
  DateTime dob;
  String phone = '';
  String email = '';
  String favoriteColor = '';
}
