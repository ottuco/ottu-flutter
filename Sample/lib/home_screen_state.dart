import 'package:equatable/equatable.dart';
import 'package:ottu_flutter_checkout_sample/PGCodes.dart';

final class HomeScreenState extends Equatable {
  final String merchantId;
  final String apiKey;
  final String? sessionId;
  final String? amount;
  final String? currencyCode;
  final String? phoneNumber;
  final String? customerId;
  final String? cardExpiryTime;
  final bool showPaymentDetails;
  final bool? noForms;
  final bool? preloadPayload;
  final bool hasSessionLoaded;
  final Map<String, bool>? formsOfPaymentChecked;
  final Map<PGCode, bool>? pgCodesChecked;

  const HomeScreenState({
    required this.merchantId,
    required this.apiKey,
    this.sessionId,
    this.amount,
    this.currencyCode,
    this.phoneNumber,
    this.customerId,
    this.cardExpiryTime,
    this.showPaymentDetails = true,
    this.preloadPayload,
    this.noForms,
    this.hasSessionLoaded = false,
    this.formsOfPaymentChecked,
    this.pgCodesChecked,
  });

  HomeScreenState copyWith({
    String? merchantId,
    String? apiKey,
    String? sessionId,
    String? amount,
    String? currencyCode,
    String? phoneNumber,
    String? customerId,
    String? cardExpiryTime,
    bool? showPaymentDetails,
    bool? noForms,
    bool? preloadPayload,
    bool? hasSessionLoaded,
    Map<String, bool>? formsOfPaymentChecked,
    Map<PGCode, bool>? pgCodesChecked,
  }) {
    return HomeScreenState(
        merchantId: merchantId ?? this.merchantId,
        apiKey: apiKey ?? this.apiKey,
        sessionId: sessionId ?? this.sessionId,
        amount: amount ?? this.amount,
        currencyCode: currencyCode ?? this.currencyCode,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        customerId: customerId ?? this.customerId,
        cardExpiryTime: cardExpiryTime ?? this.cardExpiryTime,
        showPaymentDetails: showPaymentDetails ?? this.showPaymentDetails,
        noForms: noForms ?? this.noForms,
        preloadPayload: preloadPayload ?? this.preloadPayload,
        hasSessionLoaded: hasSessionLoaded ?? this.hasSessionLoaded,
        formsOfPaymentChecked: formsOfPaymentChecked ?? this.formsOfPaymentChecked,
        pgCodesChecked: pgCodesChecked ?? this.pgCodesChecked);
  }

  @override
  List<Object?> get props => [
        showPaymentDetails,
        amount,
        currencyCode,
        noForms,
        customerId,
        cardExpiryTime,
        sessionId,
        preloadPayload,
        phoneNumber,
        hasSessionLoaded,
        formsOfPaymentChecked.hashCode,
        pgCodesChecked.hashCode
      ];
}
