import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottu_flutter_checkout_sample/home_screen_cubit.dart';
import 'package:ottu_flutter_checkout_sample/home_screen_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final amountEditingController = TextEditingController();
  late TextEditingController currencyCodeEditingController;
  late TextEditingController merchantIdEditingController;
  late TextEditingController apiKeyEditingController;
  late TextEditingController customerIdEditingController;
  late TextEditingController phoneNumberEditingController;

  @override
  void initState() {
    super.initState();
    final state = context.read<HomeScreenCubit>().state;
    currencyCodeEditingController =
        TextEditingController(text: state.currencyCode);
    merchantIdEditingController = TextEditingController(text: state.merchantId);
    apiKeyEditingController = TextEditingController(text: state.apiKey);
    customerIdEditingController = TextEditingController(text: state.customerId);
    phoneNumberEditingController =
        TextEditingController(text: state.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer App Form'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            tooltip: 'Go to the next page',
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: BlocBuilder<HomeScreenCubit, HomeScreenState>(
                  builder: (context, state) {
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
                      keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: currencyCodeEditingController,
                      onChanged: (text) {
                        context
                            .read<HomeScreenCubit>()
                            .onCurrencyCodeChanged(text);
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
                        context
                            .read<HomeScreenCubit>()
                            .onMerchantIdChanged(text);
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
                        context
                            .read<HomeScreenCubit>()
                            .onCustomerIdChanged(text);
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
                        context
                            .read<HomeScreenCubit>()
                            .onPhoneNumberChanged(text);
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
                        value: false,
                        onChanged: (bool? value) {
                          context
                              .read<HomeScreenCubit>()
                              .onPreloadPayloadChecked(value);
                        },
                      ),
                      const Text('Preload payload')
                    ]),
                    Row(children: [
                      Checkbox(
                        checkColor: Colors.white,
                        value: false,
                        onChanged: (bool? value) {
                          context
                              .read<HomeScreenCubit>()
                              .onNoFormsChecked(value);
                        },
                      ),
                      const Text('No forms of payment')
                    ]),
                    Row(children: [
                      Checkbox(
                        checkColor: Colors.white,
                        value:
                            state.formsOfPaymentChecked?['google_pay'] ?? false,
                        onChanged: (bool? value) {
                          context
                              .read<HomeScreenCubit>()
                              .onFormsOfPaymentChecked(
                                  'google_pay', value ?? false);
                        },
                      ),
                      const Text('Google pay')
                    ]),
                    Row(children: [
                      Checkbox(
                        checkColor: Colors.white,
                        value:
                            state.formsOfPaymentChecked?['redirect'] ?? false,
                        onChanged: (bool? value) {
                          context
                              .read<HomeScreenCubit>()
                              .onFormsOfPaymentChecked(
                                  'redirect', value ?? false);
                        },
                      ),
                      const Text('Redirect')
                    ]),
                    Row(children: [
                      Checkbox(
                        checkColor: Colors.white,
                        value: state.formsOfPaymentChecked?['flex_methods'] ??
                            false,
                        onChanged: (bool? value) {
                          context
                              .read<HomeScreenCubit>()
                              .onFormsOfPaymentChecked(
                                  'flex_methods', value ?? false);
                        },
                      ),
                      const Text('Flex methods')
                    ]),
                    Row(children: [
                      Checkbox(
                        checkColor: Colors.white,
                        value: state.formsOfPaymentChecked?['stc_pay'] ?? false,
                        onChanged: (bool? value) {
                          context
                              .read<HomeScreenCubit>()
                              .onFormsOfPaymentChecked(
                                  'stc_pay', value ?? false);
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
                              .onFormsOfPaymentChecked(
                                  'ottu_pg', value ?? false);
                        },
                      ),
                      const Text('Ottu PG')
                    ]),
                    Row(children: [
                      Checkbox(
                        checkColor: Colors.white,
                        value:
                            state.formsOfPaymentChecked?['token_pay'] ?? false,
                        onChanged: (bool? value) {
                          context
                              .read<HomeScreenCubit>()
                              .onFormsOfPaymentChecked(
                                  'token_pay', value ?? false);
                        },
                      ),
                      const Text('Token Pay')
                    ]),
                    Row(children: [
                      Checkbox(
                        checkColor: Colors.white,
                        value: state.newCard ?? false,
                        onChanged: (bool? value) {
                          context
                              .read<HomeScreenCubit>()
                              .onNewCardChecked(value);
                        },
                      ),
                      const Text('Add new Card')
                    ]),
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
              }))

          /*const Center(
        child: Text(
          'This is the home page',
          style: TextStyle(fontSize: 24),
        ),
      ),*/
          ),
    );
  }
}
