import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class CardWidgetContent extends StatefulWidget {
  CardWidgetContent();

  @override
  _CardWidgetContentState createState() {
    return new _CardWidgetContentState();
  }
}

class _CardWidgetContentState extends State<CardWidgetContent> {
  Card newCard = Card();

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final GlobalKey<FormFieldState<String>> _nameFieldKey =
      new GlobalKey<FormFieldState<String>>();

  final GlobalKey<FormFieldState<String>> _numberFieldKey =
      new GlobalKey<FormFieldState<String>>();

  final GlobalKey<FormFieldState<String>> _dateFieldKey =
      new GlobalKey<FormFieldState<String>>();

  final GlobalKey<FormFieldState<String>> _cvcFieldKey =
      new GlobalKey<FormFieldState<String>>();

  static final dateTranslator = {
    'm': new RegExp(r'^([1-9]|1[012])$'),
    'y': new RegExp(r'[0-9]'),
  };

  final MaskedTextController _dateControler =
      new MaskedTextController(mask: 'm/y', translator: dateTranslator);

  bool _autovalidate = false;
  bool _error = false;

  bool _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      setState(() {
        _error = true;
      });
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

  @override
  Widget build(BuildContext context) {
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
                  child: new TextFormField(
                    key: _dateFieldKey,
                    decoration: InputDecoration(
                      labelText: 'Fecha de vto.',
                      hintText: 'MM/AA',
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 15.0),
                      border: InputBorder.none,
                    ),
                    controller: _dateControler,
                    keyboardType: TextInputType.datetime,
                  )),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        autovalidate: _autovalidate,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildInputs(),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text('Siguiente',
                      style: Theme.of(context).primaryTextTheme.body1),
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
