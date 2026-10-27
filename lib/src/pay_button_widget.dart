import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

const _methodPayButtonHeight = 'METHOD_PAY_BUTTON_HEIGHT';

/// The native Android payment button for the active `OttuCheckoutWidget` session.
///
/// Set `CheckoutArguments.isSplitPayButton` to `true`. The native SDK manages
/// presentation and payment dispatch; callbacks remain on `OttuCheckoutWidget`.
/// Height follows the native button, collapsing when it is hidden. Other
/// platforms render nothing.
class PayButtonWidget extends StatefulWidget {
  const PayButtonWidget({super.key});

  @override
  State<PayButtonWidget> createState() => _PayButtonWidgetState();
}

class _PayButtonWidgetState extends State<PayButtonWidget> {
  MethodChannel? _channel;
  // AndroidView needs a nonzero initial size to create the native view.
  double _height = 1;

  Future<void> _onPlatformViewCreated(int id) async {
    final channel = MethodChannel('com.ottu.flutter.checkout/pay_button/$id');
    _channel?.setMethodCallHandler(null);
    _channel = channel;
    var receivedHeight = false;
    channel.setMethodCallHandler((call) async {
      if (call.method == _methodPayButtonHeight) {
        receivedHeight = true;
        _updateHeight(call.arguments);
      } else {
        throw MissingPluginException();
      }
    });
    // The native view may have completed layout before this handler was bound.
    final height = await channel.invokeMethod<num>(_methodPayButtonHeight);
    if (mounted && identical(_channel, channel) && !receivedHeight) {
      _updateHeight(height);
    }
  }

  void _updateHeight(Object? value) {
    if (!mounted || value is! num) return;
    final height = value.toDouble();
    if (!height.isFinite || height < 0 || height == _height) return;
    setState(() => _height = height);
  }

  @override
  void dispose() {
    _channel?.setMethodCallHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: _height,
      child: AndroidView(
        viewType: 'PayButtonWidget',
        onPlatformViewCreated: _onPlatformViewCreated,
      ),
    );
  }
}
