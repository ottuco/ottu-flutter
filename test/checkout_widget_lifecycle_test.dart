import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ottu_flutter_checkout/ottu_flutter_checkout.dart';

const codec = StandardMethodCodec();

Future<Object?> nativeCall(
  WidgetTester tester,
  String channel,
  String method, [
  Object? arguments,
]) async {
  final reply = Completer<ByteData?>();
  await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
    channel,
    codec.encodeMethodCall(MethodCall(method, arguments)),
    reply.complete,
  );
  final data = await reply.future;
  return data == null ? null : codec.decodeEnvelope(data);
}

CheckoutArguments checkoutArguments() => CheckoutArguments(
  merchantId: 'test-merchant',
  apiKey: 'test-key',
  sessionId: 'test-session',
  amount: 1,
  showPaymentDetails: false,
  paymentOptionsDisplaySettings: PaymentOptionsDisplaySettings(
    mode: PaymentOptionsDisplayMode.LIST,
    visibleItemsCount: 2,
  ),
);

String channelFor(WidgetTester tester, Key key) {
  final view = tester.widget<UiKitView>(
    find.descendant(of: find.byKey(key), matching: find.byType(UiKitView)),
  );
  return (view.creationParams as Map<String, dynamic>)['channelName'] as String;
}

void main() {
  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          SystemChannels.platform_views,
          (_) async => null,
        );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform_views, null);
  });

  testWidgets(
    'key replacement preserves height, payment and verification callbacks',
    (tester) async {
      final messages = <String>[];
      final detached = <String>[];
      const oldKey = ValueKey('old');
      const newKey = ValueKey('new');
      Widget checkout(Key key) => MaterialApp(
        home: Align(
          alignment: Alignment.topCenter,
          child: OttuCheckoutWidget(
            key: key,
            arguments: checkoutArguments(),
            successCallback: (message) => messages.add('success:$message'),
            cancelCallback: (message) => messages.add('cancel:$message'),
            errorCallback: (message) => messages.add('error:$message'),
            verifyPayment: (payload) async {
              messages.add('verify:$payload');
              return CardVerificationResult.success();
            },
          ),
        ),
      );

      void mockDetach(String channel) {
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          MethodChannel(channel),
          (call) async {
            expect(call.method, 'METHOD_ON_WIDGET_DETACHED');
            detached.add(channel);
            return null;
          },
        );
        addTearDown(
          () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
            MethodChannel(channel),
            null,
          ),
        );
      }

      await tester.pumpWidget(checkout(oldKey));
      final oldChannel = channelFor(tester, oldKey);
      mockDetach(oldChannel);

      await tester.pumpWidget(checkout(newKey));
      final newChannel = channelFor(tester, newKey);
      mockDetach(newChannel);
      expect(newChannel, isNot(oldChannel));
      expect(detached, [oldChannel]);

      await nativeCall(tester, newChannel, 'METHOD_CHECKOUT_HEIGHT', 321);
      await tester.pump();
      expect(tester.getSize(find.byKey(newKey)).height, 321);
      await nativeCall(
        tester,
        newChannel,
        'METHOD_PAYMENT_SUCCESS_RESULT',
        'paid',
      );
      await nativeCall(
        tester,
        newChannel,
        'METHOD_PAYMENT_CANCEL_RESULT',
        'cancelled',
      );
      await nativeCall(
        tester,
        newChannel,
        'METHOD_PAYMENT_ERROR_RESULT',
        'failed',
      );
      expect(
        await nativeCall(
          tester,
          newChannel,
          'METHOD_VERIFY_PAYMENT',
          'payload',
        ),
        '',
      );
      expect(messages, [
        'success:paid',
        'cancel:cancelled',
        'error:failed',
        'verify:payload',
      ]);

      // A stale native view cannot deliver callbacks into the replacement.
      expect(
        await nativeCall(
          tester,
          oldChannel,
          'METHOD_PAYMENT_SUCCESS_RESULT',
          'stale',
        ),
        isNull,
      );
      expect(messages.length, 4);

      await tester.pumpWidget(const SizedBox.shrink());
      expect(detached, [oldChannel, newChannel]);
      expect(
        await nativeCall(tester, newChannel, 'METHOD_CHECKOUT_HEIGHT', 999),
        isNull,
      );
      expect(tester.takeException(), isNull);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.iOS),
  );

  testWidgets('disposing one checkout preserves a sibling channel', (
    tester,
  ) async {
    final messages = <String>[];
    const firstKey = ValueKey('first');
    const secondKey = ValueKey('second');
    Widget checkouts(bool includeFirst) => MaterialApp(
      home: Column(
        children: [
          if (includeFirst)
            OttuCheckoutWidget(key: firstKey, arguments: checkoutArguments()),
          OttuCheckoutWidget(
            key: secondKey,
            arguments: checkoutArguments(),
            successCallback: messages.add,
          ),
        ],
      ),
    );
    await tester.pumpWidget(checkouts(true));
    final channel = channelFor(tester, secondKey);
    await tester.pumpWidget(checkouts(false));
    expect(channelFor(tester, secondKey), channel);
    await nativeCall(tester, channel, 'METHOD_PAYMENT_SUCCESS_RESULT', 'paid');
    expect(messages, ['paid']);
    await tester.pumpWidget(const SizedBox.shrink());
    expect(tester.takeException(), isNull);
  }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

  testWidgets('verification finishing after disposal is rejected', (
    tester,
  ) async {
    final verification = Completer<CardVerificationResult<void, String>>();
    const key = ValueKey('checkout');
    await tester.pumpWidget(
      MaterialApp(
        home: OttuCheckoutWidget(
          key: key,
          arguments: checkoutArguments(),
          verifyPayment: (_) => verification.future,
        ),
      ),
    );
    final channel = channelFor(tester, key);
    final assertion = expectLater(
      nativeCall(tester, channel, 'METHOD_VERIFY_PAYMENT', 'payload'),
      throwsA(
        isA<PlatformException>().having(
          (e) => e.code,
          'code',
          'CHECKOUT_DISPOSED',
        ),
      ),
    );
    await tester.pump();
    await tester.pumpWidget(const SizedBox.shrink());
    verification.complete(CardVerificationResult.success());
    await assertion;
    expect(tester.takeException(), isNull);
  }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

  testWidgets(
    'native initialization callbacks arrive before view creation completes',
    (tester) async {
      const key = ValueKey('checkout');
      String? channel;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform_views,
        (call) async {
          if (call.method == 'create') {
            final params =
                const StandardMessageCodec().decodeMessage(
                      ByteData.sublistView(
                        (call.arguments as Map)['params'] as Uint8List,
                      ),
                    )
                    as Map;
            channel = params['channelName'] as String;
            await Future<void>.value();
            await nativeCall(tester, channel!, 'METHOD_CHECKOUT_HEIGHT', 345);
          }
          return null;
        },
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Align(
            child: OttuCheckoutWidget(key: key, arguments: checkoutArguments()),
          ),
        ),
      );
      await tester.pump();
      expect(channel, channelFor(tester, key));
      expect(tester.getSize(find.byKey(key)).height, 345);
      await tester.pumpWidget(const SizedBox.shrink());
      expect(tester.takeException(), isNull);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.iOS),
  );

  for (final error in <Exception>[
    MissingPluginException(),
    PlatformException(code: 'DETACH_FAILED'),
  ]) {
    testWidgets('native detach handles ${error.runtimeType}', (tester) async {
      const key = ValueKey('checkout');
      await tester.pumpWidget(
        MaterialApp(
          home: OttuCheckoutWidget(key: key, arguments: checkoutArguments()),
        ),
      );
      final channel = channelFor(tester, key);
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        MethodChannel(channel),
        (_) async => throw error,
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          MethodChannel(channel),
          null,
        ),
      );
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      expect(tester.takeException(), isNull);
    }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));
  }
}
