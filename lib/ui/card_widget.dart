import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:paymentez_flutter/paymentez_flutter.dart';

class CardWidget extends StatefulWidget {
  CardWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CardWidgetState createState() => new _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  MaskedTextController _numberController =
      new MaskedTextController(mask: '0000 0000 0000 0000');
  MaskedTextController _dateExpController =
      new MaskedTextController(mask: '00/00');
  MaskedTextController _cvvController = new MaskedTextController(mask: '000');
  final GlobalKey<FormFieldState> _dateExpKey = new GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _numberKey = new GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _cvvKey = new GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState<String>> _nameFieldKey =
      new GlobalKey<FormFieldState<String>>();

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  var _numberIcon = Image.asset('assets/card_generic.png');
  var _cardBrand = CardBrands.UNKNOWN;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _dateExpController.addListener(() {
      _dateExpFormatter();
    });
    _numberController.addListener(() {
      setState(() {
        _cardBrand = getCardBrand(_numberController.text);
        print(_cardBrand);
        switch (_cardBrand) {
          case CardBrands.MASTERCARD:
            _numberController.updateMask('0000 0000 0000 0000');
            _cvvController.updateMask('000');
            _numberIcon = Image.asset('assets/card_mastercard.png');
            break;
          case CardBrands.VISA:
            _numberController.updateMask('0000 0000 0000 0000');
            _cvvController.updateMask('000');
            _numberIcon = Image.asset('assets/card_visa.png');
            break;
          case CardBrands.AMERICAN_EXPRESS:
            _numberController.updateMask('0000 0000 0000 000');
            _cvvController.updateMask('0000');
            _numberIcon = Image.asset('assets/card_amex.png');
            break;
          case CardBrands.DINERS_CLUB:
            _numberController.updateMask('0000 0000 0000 00');
            _cvvController.updateMask('000');
            _numberIcon = Image.asset('assets/card_diners.png');
            break;
          default:
            _numberController.updateMask('0000 0000 0000 0000');
            _cvvController.updateMask('000');
            _numberIcon = Image.asset('assets/card_generic.png');
            break;
        }
        _numberController.selection =
            new TextSelection.collapsed(offset: _numberController.text.length);
      });
    });
  }

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

  void _dateExpFormatter() {
    var text = _dateExpController.text.replaceAll('/', '');
    if (text.length == 1) {
      if (int.parse(text) > 1) _dateExpController.updateText('0$text');
    } else if (text.length == 2) {
      if (int.parse(text) > 12 || int.parse(text) == 0)
        _dateExpController.updateText(text[0]);
    }
    _dateExpController.selection =
        new TextSelection.collapsed(offset: _dateExpController.text.length);
  }

  DateTime _convertToDate(String input) {
    try {
      print(input.substring(0, 3) + '20' + input.substring(3));
      var d = new DateFormat.yM()
          .parseStrict(input.substring(0, 3) + '20' + input.substring(3));
      return d;
    } catch (e) {
      return null;
    }
  }

  String _validateName(String value) {
    if (value.isEmpty) return 'Ingresa el nombre del titular de la tarjeta';
    final RegExp nameExp = new RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value)) return 'Ingresa un nombre valido';
    return null;
  }

  String _validateDate(String value) {
    var d = _convertToDate(value);
    print(d);
    if (value.isEmpty)
      return 'Escriba la fecha de vencimiento de su tarjeta';
    else if (d != null && d.isAfter(new DateTime.now()))
      return null;
    else {
      return 'Ingresa una fecha de vencimiento válida';
    }
  }

  String _validateNumber(String value) {
    if (_numberController.text.length < 10)
      return 'Ingresa un número de tarjeta de crédito válido';
    else if (!validateNumberCard(_numberController.text))
      return 'Ingresa un número de tarjeta de crédito válido';
    return null;
  }

  String _validateCVV(String value) {
    if (value.length != _cvvController.mask.length)
      return 'Ingresa un número de tarjeta de crédito válido';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
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
                        labelText:
                            'Nombre del titular (igual que en la tarjeta)',
                        hintText: 'Nombre del titular',
                        labelStyle: Theme.of(context)
                            .textTheme
                            .body1
                            .copyWith(color: Theme.of(context).hintColor),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 15.0),
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
                      child: new TextFormField(
                        key: _numberKey,
                        autovalidate: _autovalidate,
                        decoration: InputDecoration(
                          prefixIcon: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            child: _numberIcon,
                            width: 20.0,
                          ),
                          suffixIcon: _numberController.text.length > 0
                              ? IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _numberController.updateText('');
                                    });
                                  },
                                )
                              : null,
                          labelText: 'Número de tarjeta',
                          labelStyle: Theme.of(context)
                              .textTheme
                              .body1
                              .copyWith(color: Theme.of(context).hintColor),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 15.0),
                          border: InputBorder.none,
                        ),
                        controller: _numberController,
                        keyboardType: TextInputType.number,
                        validator: _validateNumber,
                      )),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            decoration: new BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                border: Border.all(style: BorderStyle.none)),
                            child: new TextFormField(
                              key: _dateExpKey,
                              autovalidate: _autovalidate,
                              decoration: InputDecoration(
                                labelText: 'Fecha de vto',
                                hintText: 'MM/AA',
                                labelStyle: Theme.of(context)
                                    .textTheme
                                    .body1
                                    .copyWith(
                                        color: Theme.of(context).hintColor),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 15.0),
                                border: InputBorder.none,
                              ),
                              controller: _dateExpController,
                              keyboardType: TextInputType.datetime,
                              validator: _validateDate,
                            )),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            decoration: new BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                border: Border.all(style: BorderStyle.none)),
                            child: new TextFormField(
                              key: _cvvKey,
                              autovalidate: _autovalidate,
                              decoration: InputDecoration(
                                labelText: 'CVV',
                                labelStyle: Theme.of(context)
                                    .textTheme
                                    .body1
                                    .copyWith(
                                        color: Theme.of(context).hintColor),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 15.0),
                                border: InputBorder.none,
                              ),
                              controller: _cvvController,
                              keyboardType: TextInputType.number,
                              validator: _validateCVV,
                            )),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          RaisedButton(
            splashColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            onPressed: () {
              if (_handleSubmitted()) {
                print('enviada');
                Map jsonMap = {
                  "name": _nameFieldKey.currentState.value.toString(),
                  "number": _numberKey.currentState.value.toString(),
                  "monthExp":
                      _dateExpKey.currentState.value.toString().split('/')[0],
                  "yearExp": '20' +
                      _dateExpKey.currentState.value.toString().split('/')[1],
                  "cvv": _cvvKey.currentState.value.toString()
                };
                print(jsonMap);
//              store.dispatch(AddCardAction(context, jsonMap));
              } else {
                print('error');
              }
            },
            color: Colors.lightGreen,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text('Siguiente',
                  style: Theme.of(context).primaryTextTheme.body1),
            ),
          ),
        ],
      ),
    );
  }
}
