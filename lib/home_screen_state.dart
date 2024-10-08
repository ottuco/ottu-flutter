import 'package:equatable/equatable.dart';

final class HomeScreenState extends Equatable {
  final String merchantId;
  final String apiKey;
  final String? sessionId;
  final String? amount;
  final String? currencyCode;
  final String? phoneNumber;
  final String? customerId;
  final bool showPaymentDetails;
  final bool? newCard;
  final bool? noForms;
  final bool? preloadPayload;
  final Map<String, bool>? formsOfPaymentChecked;

  const HomeScreenState(
      {required this.merchantId,
      required this.apiKey,
      this.sessionId,
      this.amount,
      this.currencyCode,
      this.phoneNumber,
      this.customerId,
      this.showPaymentDetails = true,
      this.preloadPayload,
      this.newCard,
      this.noForms,
      this.formsOfPaymentChecked});

  HomeScreenState copyWith({
    String? merchantId,
    String? apiKey,
    String? sessionId,
    String? amount,
    String? currencyCode,
    String? phoneNumber,
    String? customerId,
    bool? showPaymentDetails,
    bool? newCard,
    bool? noForms,
    bool? preloadPayload,
    Map<String, bool>? formsOfPaymentChecked,
  }) {
    return HomeScreenState(
      merchantId: merchantId ?? this.merchantId,
      apiKey: apiKey ?? this.apiKey,
      sessionId: sessionId ?? this.sessionId,
      amount: amount ?? this.amount,
      currencyCode: currencyCode ?? this.currencyCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      customerId: customerId ?? this.customerId,
      showPaymentDetails: showPaymentDetails ?? this.showPaymentDetails,
      newCard: newCard ?? this.newCard,
      noForms: noForms ?? this.noForms,
      preloadPayload: preloadPayload ?? this.preloadPayload,
      formsOfPaymentChecked:
          formsOfPaymentChecked ?? this.formsOfPaymentChecked,
    );
  }

  @override
  List<Object?> get props => [
        showPaymentDetails,
        amount,
        newCard,
        currencyCode,
        noForms,
        customerId,
        sessionId,
        preloadPayload,
        phoneNumber,
        formsOfPaymentChecked.hashCode
      ];
}
