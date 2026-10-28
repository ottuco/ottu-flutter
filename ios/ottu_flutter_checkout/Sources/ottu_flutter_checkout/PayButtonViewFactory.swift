import Flutter
import UIKit
import ottu_checkout_sdk

private let methodPayButtonHeight = "METHOD_PAY_BUTTON_HEIGHT"

// Checkout and button platform views can be created in either order. Keep the
// active session weak: its lifetime belongs to CheckoutPlatformView.
final class PayButtonCoordinator {
    private let views = NSHashTable<PayButtonPlatformView>.weakObjects()

    weak var checkout: Checkout? {
        didSet {
            for view in views.allObjects {
                view.setController(buttonController())
            }
        }
    }

    fileprivate func register(_ view: PayButtonPlatformView) {
        views.add(view)
        view.setController(buttonController())
    }

    func clear(_ checkout: Checkout?) {
        if let checkout, self.checkout === checkout {
            self.checkout = nil
        }
    }

    private func buttonController() -> UIViewController? {
        guard let checkout, checkout.isSplitPayButton else { return nil }
        return checkout.payButtonViewController()
    }
}

final class PayButtonViewFactory: NSObject, @preconcurrency FlutterPlatformViewFactory {
    private let messenger: FlutterBinaryMessenger
    private let coordinator: PayButtonCoordinator

    init(messenger: FlutterBinaryMessenger, coordinator: PayButtonCoordinator) {
        self.messenger = messenger
        self.coordinator = coordinator
        super.init()
    }

    @MainActor func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        let view = PayButtonPlatformView(frame: frame, viewId: viewId, messenger: messenger)
        coordinator.register(view)
        return view
    }
}

private final class PayButtonPlatformView: NSObject, FlutterPlatformView {
    private let container: PayButtonContainerView
    private let channel: FlutterMethodChannel
    private var controller: UIViewController?
    private var hiddenObservation: NSKeyValueObservation?
    private var lastHeight: CGFloat?

    init(frame: CGRect, viewId: Int64, messenger: FlutterBinaryMessenger) {
        container = PayButtonContainerView(frame: frame)
        channel = FlutterMethodChannel(
            name: "com.ottu.flutter.checkout/pay_button/\(viewId)",
            binaryMessenger: messenger
        )
        super.init()
        container.onLayout = { [weak self] in self?.reportHeight() }
        container.onWindowChanged = { [weak self] in self?.updateContainment() }
        channel.setMethodCallHandler { [weak self] call, result in
            guard call.method == methodPayButtonHeight else {
                result(FlutterMethodNotImplemented)
                return
            }
            result(Double(self?.buttonHeight() ?? 0))
        }
    }

    func view() -> UIView { container }

    func setController(_ controller: UIViewController?) {
        guard self.controller !== controller else { return }
        hiddenObservation = nil
        detachController()
        self.controller?.view.removeFromSuperview()
        self.controller = controller
        if let buttonView = controller?.view {
            buttonView.translatesAutoresizingMaskIntoConstraints = false
            container.content.addSubview(buttonView)
            NSLayoutConstraint.activate([
                buttonView.leadingAnchor.constraint(equalTo: container.content.leadingAnchor),
                buttonView.trailingAnchor.constraint(equalTo: container.content.trailingAnchor),
                buttonView.topAnchor.constraint(equalTo: container.content.topAnchor),
                buttonView.bottomAnchor.constraint(equalTo: container.content.bottomAnchor),
            ])
            hiddenObservation = buttonView.observe(\.isHidden, options: [.new]) { [weak self] _, _ in
                self?.container.setNeedsLayout()
            }
        }
        updateContainment()
        container.setNeedsLayout()
    }

    private func updateContainment() {
        guard let controller else { return }
        guard container.window != nil else {
            detachController()
            return
        }
        var responder: UIResponder? = container.next
        while let current = responder {
            if let parent = current as? UIViewController {
                if controller.parent !== parent {
                    detachController()
                    parent.addChild(controller)
                    controller.didMove(toParent: parent)
                }
                break
            }
            responder = current.next
        }
    }

    private func detachController() {
        guard let controller, controller.parent != nil else { return }
        controller.willMove(toParent: nil)
        controller.removeFromParent()
    }

    private func buttonHeight() -> CGFloat {
        guard let buttonView = controller?.view, !buttonView.isHidden else { return 0 }
        // Measure at the available width without Flutter's current height, so a
        // previously collapsed button can grow again.
        let size = buttonView.systemLayoutSizeFitting(
            CGSize(width: container.bounds.width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        return size.height.isFinite ? max(0, ceil(size.height)) : 0
    }

    private func reportHeight() {
        let height = buttonHeight()
        guard lastHeight != height else { return }
        lastHeight = height
        channel.invokeMethod(methodPayButtonHeight, arguments: Double(height))
    }

    deinit {
        hiddenObservation = nil
        channel.setMethodCallHandler(nil)
        detachController()
        controller?.view.removeFromSuperview()
    }
}

private final class PayButtonContainerView: UIView {
    let content = UIView()
    var onLayout: (() -> Void)?
    var onWindowChanged: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        content.translatesAutoresizingMaskIntoConstraints = false
        addSubview(content)
        // Leave the bottom free so native constraints determine content height.
        NSLayoutConstraint.activate([
            content.leadingAnchor.constraint(equalTo: leadingAnchor),
            content.trailingAnchor.constraint(equalTo: trailingAnchor),
            content.topAnchor.constraint(equalTo: topAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        onLayout?()
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        onWindowChanged?()
    }
}
