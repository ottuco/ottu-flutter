import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

const _nestedChannel = MethodChannel('com.ottu.flutter/checkout/nested');

/// Reports the content height from the merchant route's nested Flutter engine.
///
/// The child receives an unbounded height so it can grow and shrink independently
/// of the native viewport. Use content that sizes itself, rather than Expanded
/// or a vertically expanding scroll view.
class NestedWrapperWidget extends StatelessWidget {
  const NestedWrapperWidget({super.key, required this.child});

  final Widget child;

  Future<void> _reportHeight(double height) async {
    try {
      await _nestedChannel.invokeMethod<void>(
        'METHOD_NESTED_WIDGET_HEIGHT',
        height,
      );
    } catch (error, stack) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stack,
          library: 'ottu_flutter_checkout',
          context: ErrorDescription('while reporting nested widget height'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _HeightObserver(onHeightChanged: _reportHeight, child: child);
  }
}

class _HeightObserver extends SingleChildRenderObjectWidget {
  const _HeightObserver({required this.onHeightChanged, required super.child});

  final ValueChanged<double> onHeightChanged;

  @override
  _RenderHeightObserver createRenderObject(BuildContext context) =>
      _RenderHeightObserver(onHeightChanged);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderHeightObserver renderObject,
  ) {
    renderObject.onHeightChanged = onHeightChanged;
  }
}

class _RenderHeightObserver extends RenderProxyBox {
  _RenderHeightObserver(this.onHeightChanged);

  ValueChanged<double> onHeightChanged;
  double? _reportedHeight;
  double _contentHeight = 0;
  bool _notificationPending = false;

  @override
  void performLayout() {
    child!.layout(
      constraints.copyWith(minHeight: 0, maxHeight: double.infinity),
      parentUsesSize: true,
    );
    size = constraints.constrain(child!.size);
    _contentHeight = child!.size.height;
    // The nested engine can lay out before Android has attached it at its
    // real width. Text at zero width wraps into an artificially tall column.
    if (size.width <= 0 ||
        !size.width.isFinite ||
        !_contentHeight.isFinite ||
        _contentHeight == _reportedHeight ||
        _notificationPending)
      return;
    _notificationPending = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationPending = false;
      if (!attached ||
          size.width <= 0 ||
          !size.width.isFinite ||
          !_contentHeight.isFinite ||
          _contentHeight == _reportedHeight)
        return;
      _reportedHeight = _contentHeight;
      onHeightChanged(_contentHeight);
    });
  }
}
