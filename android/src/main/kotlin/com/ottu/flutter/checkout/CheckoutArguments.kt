package com.ottu.flutter.checkout

import kotlinx.serialization.Serializable

@Serializable
data class CheckoutArguments(
    val merchantId: String,
    val apiKey: String,
    val sessionId: String,
    val amount: Double,
    val showPaymentDetails: Boolean,
    val apiTransactionDetails: String?,
    val formsOfPayment: List<String>?,
    val theme: CustomerTheme?,
)
