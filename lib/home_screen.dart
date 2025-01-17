import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottu_flutter_checkout_sample/home_screen_cubit.dart';
import 'package:ottu_flutter_checkout_sample/home_screen_state.dart';

const oneDotPattern = r'^\d+(\.)?(\d{1,2})?$';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController amountEditingController;
  late TextEditingController currencyCodeEditingController;
  late TextEditingController merchantIdEditingController;
  late TextEditingController apiKeyEditingController;
  late TextEditingController customerIdEditingController;
  late TextEditingController phoneNumberEditingController;

  @override
  void initState() {
    super.initState();
    final state = context
        .read<HomeScreenCubit>()
        .state;
    amountEditingController = TextEditingController(text: state.amount);
    currencyCodeEditingController = TextEditingController(text: state.currencyCode);
    merchantIdEditingController = TextEditingController(text: state.merchantId);
    apiKeyEditingController = TextEditingController(text: state.apiKey);
    customerIdEditingController = TextEditingController(text: state.customerId);
    phoneNumberEditingController = TextEditingController(text: state.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    final oneDotRegExp = RegExp(oneDotPattern);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer App Form'),
        actions: <Widget>[],
      ),
      body: BlocListener<HomeScreenCubit, HomeScreenState>(
        listenWhen: (previous, current) =>
        previous.hasSessionLoaded != current.hasSessionLoaded && current.hasSessionLoaded,
        listener: (context, state) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 1),
            content: Text('Session has been loaded!'),
          ));
        },
        child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: BlocBuilder<HomeScreenCubit, HomeScreenState>(builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: amountEditingController,
                        onChanged: (text) {
                          context.read<HomeScreenCubit>().onAmountChanged(text);
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Amount',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(oneDotRegExp,
                              replacementString: amountEditingController.text),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: currencyCodeEditingController,
                        onChanged: (text) {
                          context.read<HomeScreenCubit>().onCurrencyCodeChanged(text);
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Currency code',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: merchantIdEditingController,
                        onChanged: (text) {
                          context.read<HomeScreenCubit>().onMerchantIdChanged(text);
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Merchant Id',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: apiKeyEditingController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Api key',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: customerIdEditingController,
                        onChanged: (text) {
                          context.read<HomeScreenCubit>().onCustomerIdChanged(text);
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Customer Id',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: phoneNumberEditingController,
                        onChanged: (text) {
                          context.read<HomeScreenCubit>().onPhoneNumberChanged(text);
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Phone number',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(children: [
                        Checkbox(
                          checkColor: Colors.white,
                          value: state.showPaymentDetails,
                          onChanged: (bool? value) {
                            context
                                .read<HomeScreenCubit>()
                                .onShowPaymentDetailsChecked(value ?? false);
                          },
                        ),
                        const Text('Show payment details')
                      ]),
                      Row(children: [
                        Checkbox(
                          checkColor: Colors.white,
                          value: state.preloadPayload ?? false,
                          onChanged: (bool? value) {
                            context.read<HomeScreenCubit>().onPreloadPayloadChecked(value);
                          },
                        ),
                        const Text('Preload payload')
                      ]),
                      Row(children: [
                        Checkbox(
                          checkColor: Colors.white,
                          value: state.noForms ?? false,
                          onChanged: (bool? value) {
                            context.read<HomeScreenCubit>().onNoFormsChecked(value);
                          },
                        ),
                        const Text('No forms of payment')
                      ]),
                      nativePayMethod(
                          value: state.formsOfPaymentChecked?[nativePayMethodKey] ?? false),
                      Row(children: [
                        Checkbox(
                          checkColor: Colors.white,
                          value: state.formsOfPaymentChecked?['redirect'] ?? false,
                          onChanged: (bool? value) {
                            context
                                .read<HomeScreenCubit>()
                                .onFormsOfPaymentChecked('redirect', value ?? false);
                          },
                        ),
                        const Text('Redirect')
                      ]),
                      /*              Row(children: [
                        Checkbox(
                          checkColor: Colors.white,
                          value: state.formsOfPaymentChecked?['flex_methods'] ?? false,
                          onChanged: (bool? value) {
                            context
                                .read<HomeScreenCubit>()
                                .onFormsOfPaymentChecked('flex_methods', value ?? false);
                          },
                        ),
                        const Text('Flex methods')
                      ]),*/
                      Row(children: [
                        Checkbox(
                          checkColor: Colors.white,
                          value: state.formsOfPaymentChecked?['stc_pay'] ?? false,
                          onChanged: (bool? value) {
                            context
                                .read<HomeScreenCubit>()
                                .onFormsOfPaymentChecked('stc_pay', value ?? false);
                          },
                        ),
                        const Text('Stc Pay')
                      ]),
                      Row(children: [
                        Checkbox(
                          checkColor: Colors.white,
                          value: state.formsOfPaymentChecked?['ottu_pg'] ?? false,
                          onChanged: (bool? value) {
                            context
                                .read<HomeScreenCubit>()
                                .onFormsOfPaymentChecked('ottu_pg', value ?? false);
                          },
                        ),
                        const Text('Ottu PG')
                      ]),
                      Row(children: [
                        Checkbox(
                          checkColor: Colors.white,
                          value: state.formsOfPaymentChecked?['token_pay'] ?? false,
                          onChanged: (bool? value) {
                            context
                                .read<HomeScreenCubit>()
                                .onFormsOfPaymentChecked('token_pay', value ?? false);
                          },
                        ),
                        const Text('Token Pay')
                      ]),
                      /* Row(children: [
                        Checkbox(
                          checkColor: Colors.white,
                          value: state.newCard ?? false,
                          onChanged: (bool? value) {
                            context.read<HomeScreenCubit>().onNewCardChecked(value);
                          },
                        ),
                        const Text('Add new Card')
                      ]),*/
                      const SizedBox(height: 16),
                      ElevatedButton(
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            context.read<HomeScreenCubit>().onThemeCustomization();
                          },
                          child: const Text("Theme customization")),
                      const SizedBox(height: 16),
                      ElevatedButton(
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            context.read<HomeScreenCubit>().getSessionId(
                                merchantId: merchantIdEditingController.text,
                                apiKey: apiKeyEditingController.text);
                          },
                          child: const Text("Get Session Id")),
                      const SizedBox(height: 16),
                      ElevatedButton(
                          onPressed: state.sessionId != null
                              ? () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            context.read<HomeScreenCubit>().onPay();
                          }
                              : null,
                          child: const Text("Pay")),
                    ],
                  );
                }))),
      ),
    );
  }

  Widget nativePayMethod({bool value = false}) {
    if (Platform.isAndroid) {
      return SizedBox.shrink();
    } else {
      return Row(children: [
        Checkbox(
          checkColor: Colors.white,
          value: value,
          onChanged: (bool? value) {
            context
                .read<HomeScreenCubit>()
                .onFormsOfPaymentChecked(nativePayMethodKey, value ?? false);
          },
        ),
        Text(_nativePayMethodName())
      ]);
    }
  }

  String _nativePayMethodName() {
    if (Platform.isAndroid) {
      return 'Google pay';
    } else if (Platform.isIOS) {
      return 'Apple pay';
    } else {
      return 'Native pay';
    }
  }
}
