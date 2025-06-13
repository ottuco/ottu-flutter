import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottu_flutter_checkout_sample/PGCodes.dart';
import 'package:ottu_flutter_checkout_sample/home_screen_cubit.dart';
import 'package:ottu_flutter_checkout_sample/home_screen_state.dart';

const oneDotPattern = r'^\d+(\.)?(\d{1,2})?$';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController amountEditingController;
  late TextEditingController currencyCodeEditingController;
  late TextEditingController merchantIdEditingController;
  late TextEditingController apiKeyEditingController;
  late TextEditingController customerIdEditingController;
  late TextEditingController phoneNumberEditingController;
  late TextEditingController cardExpiryTimeController;
  late TextEditingController paymentsListItemCountController;
  late TextEditingController defaultSelectedPaymentController;

  @override
  void initState() {
    super.initState();
    final state = context.read<HomeScreenCubit>().state;
    amountEditingController = TextEditingController(text: state.amount);
    currencyCodeEditingController = TextEditingController(text: state.currencyCode);
    merchantIdEditingController = TextEditingController(text: state.merchantId);
    apiKeyEditingController = TextEditingController(text: state.apiKey);
    customerIdEditingController = TextEditingController(text: state.customerId);
    phoneNumberEditingController = TextEditingController(text: state.phoneNumber);
    cardExpiryTimeController = TextEditingController(text: state.cardExpiryTime);
    paymentsListItemCountController = TextEditingController(text: state.paymentsListItemCount);
    defaultSelectedPaymentController = TextEditingController(text: state.defaultSelectedPayment);
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
                  return Form(
                    key: _formKey,
                    child: Column(
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
                        TextFormField(
                          controller: cardExpiryTimeController,
                          onChanged: (text) {
                            context.read<HomeScreenCubit>().onCardExpiryTimeChanged(text);
                          },
                          maxLength: 3,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) {
                            if (value != null && (int.tryParse(value) ?? 0) > 365) {
                              return 'Date rage is bigger than 365';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Card Expiry Time (day(s))',
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: defaultSelectedPaymentController,
                          onChanged: (text) {
                            context.read<HomeScreenCubit>().onDefaultSelectedPaymentChanged(text);
                          },
                          maxLength: 96,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Default selected payment',
                          ),
                        ),
                        const SizedBox(height: 24),
                        Divider(height: 2, thickness: 3),
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
                          Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: Checkbox(
                              checkColor: Colors.white,
                              value: state.showPaymentOptionsList ?? false,
                              onChanged: (bool? value) {
                                context
                                    .read<HomeScreenCubit>()
                                    .onShowPaymentOptionsListChange(value);
                              },
                            ),
                          ),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: const Text('Show payment options list'),
                          )),
                          SizedBox(
                            width: 120,
                            child: TextFormField(
                              controller: paymentsListItemCountController,
                              maxLength: 2,
                              enabled: state.showPaymentOptionsList ?? false,
                              onChanged: (text) {
                                context
                                    .read<HomeScreenCubit>()
                                    .onPaymentsListItemCountChange(text);
                              },
                              decoration: const InputDecoration(
                                counterText: "",
                                border: UnderlineInputBorder(),
                                labelText: 'Payment count',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            ),
                          ),
                        ]),
                        const SizedBox(height: 24),
                        Divider(height: 2, thickness: 3),
                        const Text('Payment methods:'),
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
                          paymentMethodCheckbox(state.formsOfPaymentChecked, 'redirect', context),
                          const Text('Redirect')
                        ]),
                        Row(children: [
                          paymentMethodCheckbox(
                              state.formsOfPaymentChecked, 'flex_methods', context),
                          const Text('Flex')
                        ]),
                        Row(children: [
                          paymentMethodCheckbox(state.formsOfPaymentChecked, 'stc_pay', context),
                          const Text('Stc Pay')
                        ]),
                        Row(children: [
                          paymentMethodCheckbox(
                              state.formsOfPaymentChecked, 'token_pay', context),
                          const Text('Token Pay')
                        ]),
                        Row(children: [
                          paymentMethodCheckbox(
                              state.formsOfPaymentChecked, 'card_onsite', context),
                          const Text('CardOnsite')
                        ]),
                        const SizedBox(height: 24),
                        const Text('Pg Codes:'),
                        Divider(height: 2, thickness: 3),
                        Wrap(spacing: 8.0, runSpacing: 4.0, children: [
                          for (PGCode code in pgPlatformCodes())
                            pgCodeCheckbox(state.pgCodesChecked, code, context),
                        ]),
                        const SizedBox(height: 26),
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
                              if (_formKey.currentState?.validate() == true) {
                                context.read<HomeScreenCubit>().getSessionId(
                                    merchantId: merchantIdEditingController.text,
                                    apiKey: apiKeyEditingController.text);
                              }
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
                    ),
                  );
                }))),
      ),
    );
  }

  Checkbox paymentMethodCheckbox(Map<String, bool>? payments, String key, BuildContext context) {
    return Checkbox(
      checkColor: Colors.white,
      value: payments?[key] ?? false,
      onChanged: (bool? value) {
        context.read<HomeScreenCubit>().onFormsOfPaymentChecked(key, value ?? false);
      },
    );
  }

  Widget pgCodeCheckbox(Map<PGCode, bool>? pgCodes, PGCode pgCode, BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Checkbox(
        checkColor: Colors.white,
        value: pgCodes?[pgCode] ?? false,
        onChanged: (bool? value) {
          context.read<HomeScreenCubit>().onPgCodeChecked(pgCode, value ?? false);
        },
      ),
      Text(pgCode.code)
    ]);
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

List<PGCode> pgPlatformCodes() {
  final List<PGCode> codes = List.from(PGCode.values);
  if (!(Platform.isIOS && kReleaseMode)) {
    codes.remove(PGCode.apple_pay);
  }
  return codes;
}
