import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:paymentez_flutter/paymentez_flutter.dart';

class CardWidget extends StatefulWidget {
  CardWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  CardWidgetState createState() => new CardWidgetState();
}

class CardWidgetState extends State<CardWidget> {
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

  var _numberIcon = Image.asset(
    'card_generic.png',
    package: 'paymentez_flutter',
  );
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
        _cardBrand = PaymentezUtils.getCardBrand(_numberController.text);
        print(_cardBrand);
        switch (_cardBrand) {
          case CardBrands.MASTERCARD:
            _numberController.updateMask('0000 0000 0000 0000');
            _cvvController.updateMask('000');
            _numberIcon = Image.asset('card_mastercard.png',
                package: 'paymentez_flutter');
            break;
          case CardBrands.VISA:
            _numberController.updateMask('0000 0000 0000 0000');
            _cvvController.updateMask('000');
            _numberIcon = Image.asset('card_visa.png',
                package: 'paymentez_flutter');
            break;
          case CardBrands.AMERICAN_EXPRESS:
            _numberController.updateMask('0000 0000 0000 000');
            _cvvController.updateMask('0000');
            _numberIcon = Image.asset('card_amex.png',
                package: 'paymentez_flutter');
            break;
          case CardBrands.DINERS_CLUB:
            _numberController.updateMask('0000 0000 0000 00');
            _cvvController.updateMask('000');
            _numberIcon = Image.asset('card_diners.png',
                package: 'paymentez_flutter');
            break;
          default:
            _numberController.updateMask('0000 0000 0000 0000');
            _cvvController.updateMask('000');
            _numberIcon = Image.asset('card_generic.png',
                package: 'paymentez_flutter');
            break;
        }
        _numberController.selection =
            new TextSelection.collapsed(offset: _numberController.text.length);
      });
    });
  }

  bool _autovalidate = false;

  bool _error = false;

  bool handleSubmitted() {
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

  Map<String, dynamic> getCard() => <String, dynamic>{
        'number': _numberKey.currentState.value.toString(),
        'holder_name': _nameFieldKey.currentState.value.toString(),
        'expiry_month':
            int.parse(_dateExpKey.currentState.value.toString().split('/')[0]),
        'expiry_year': int.parse(
            '20' + _dateExpKey.currentState.value.toString().split('/')[1]),
        'cvc': _cvvKey.currentState.value.toString(),
        'type': _cardBrand.toString(),
      };

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
    else if (!PaymentezUtils.validateNumberCard(_numberController.text))
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
                  child: TextFormField(
                    key: _nameFieldKey,
                    style: Theme.of(context).textTheme.subhead,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: 'Nombre del titular (igual que en la tarjeta)',
                      hintText: 'Nombre del titular',
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 15.0),
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: 1,
                    validator: _validateName,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new TextFormField(
                    key: _numberKey,
                    style: Theme.of(context).textTheme.subhead,
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
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 15.0),
                      border: const OutlineInputBorder(),
                    ),
                    controller: _numberController,
                    keyboardType: TextInputType.number,
                    validator: _validateNumber,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: new TextFormField(
                          key: _dateExpKey,
                          style: Theme.of(context).textTheme.subhead,
                          autovalidate: _autovalidate,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.calendar_today),
                            labelText: 'Fecha de vto',
                            hintText: 'MM/AA',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 15.0),
                            border: const OutlineInputBorder(),
                          ),
                          controller: _dateExpController,
                          keyboardType: TextInputType.datetime,
                          validator: _validateDate,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: new TextFormField(
                          key: _cvvKey,
                          autovalidate: _autovalidate,
                          style: Theme.of(context).textTheme.subhead,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.https),
                            labelText: 'CVV',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 15.0),
                            border: const OutlineInputBorder(),
                          ),
                          controller: _cvvController,
                          keyboardType: TextInputType.number,
                          validator: _validateCVV,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
