package com.ottu.flutter.checkout

import kotlinx.serialization.Serializable

@Serializable
data class CheckoutArguments(
    val merchantId: String,
    val apiKey: String,
    val sessionId: String,
    val amount: Double,
    val paymentOptionsListCount: Int,
    val showPaymentDetails: Boolean,
    val paymentOptionsListMode: String,
    val defaultSelectedPgCode: String?,
    val apiTransactionDetails: String?,
    val formsOfPayment: List<String>?,
    val theme: CustomerTheme?,
)
