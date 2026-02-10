package com.ottu.flutter.checkout

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonIgnoreUnknownKeys

@Serializable
@JsonIgnoreUnknownKeys
data class CheckoutArguments(
    val merchantId: String,
    val apiKey: String,
    val sessionId: String,
    val amount: Double,
    val showPaymentDetails: Boolean,
    val apiTransactionDetails: String?,
    val formsOfPayment: List<String>?,
    val theme: CustomerTheme?,
    val paymentOptionsDisplaySettings: PaymentOptionsDisplaySettings,
    val payButtonText: PayButtonText?,
)
