package com.ottu.flutter.checkout

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonIgnoreUnknownKeys

@Serializable
@JsonIgnoreUnknownKeys
data class PaymentOptionsDisplaySettings(
    val mode: String,
    val defaultSelectedPgCode: String?,
    val visibleItemsCount: Int,
)