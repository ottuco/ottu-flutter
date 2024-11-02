import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:ottu_flutter_checkout/ottu_flutter_checkout.dart' as ch;
import 'package:ottu_flutter_checkout_sample/theme/theme_customization_screen_cubit.dart';
import 'package:ottu_flutter_checkout_sample/theme/theme_customization_state.dart';

class ThemeCustomizationScreen extends StatefulWidget {
  const ThemeCustomizationScreen({super.key});

  @override
  State<ThemeCustomizationScreen> createState() => _ThemeCustomizationScreenState();
}

const dividerPadding = 2.0;

class _ThemeCustomizationScreenState extends State<ThemeCustomizationScreen>
    with TickerProviderStateMixin {
  final amountEditingController = TextEditingController();

  final uiModeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Customize your Theme'),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: BlocBuilder<ThemeCustomizationScreenCubit, ThemeCustomizationState>(
                        builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DropdownMenu<ch.CustomerUiMode>(
                            initialSelection: state.theme?.uiMode ?? ch.CustomerUiMode.auto,
                            controller: uiModeController,
                            requestFocusOnTap: true,
                            label: const Text('Ui Mode'),
                            onSelected: (ch.CustomerUiMode? mode) {
                              final newTheme =
                                  (state.theme ?? ch.CheckoutTheme()).copyWith(uiMode: mode);
                              context
                                  .read<ThemeCustomizationScreenCubit>()
                                  .onThemeChanged(newTheme);
                            },
                            dropdownMenuEntries: ch.CustomerUiMode.values
                                .map<DropdownMenuEntry<ch.CustomerUiMode>>(
                                    (ch.CustomerUiMode mode) {
                              return DropdownMenuEntry<ch.CustomerUiMode>(
                                value: mode,
                                label: mode.name,
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 12),
                          _expandableOptionItem(
                              title: "Margins",
                              child: _marginsModifier(state.theme?.margins, (margins) {
                                final newTheme =
                                    (state.theme ?? ch.CheckoutTheme()).copyWith(margins: margins);
                                context
                                    .read<ThemeCustomizationScreenCubit>()
                                    .onThemeChanged(newTheme);
                              })),
                          const SizedBox(height: dividerPadding),
                          divider(),
                          _colorOptionItem(state.theme?.sdkBackgroundColor?.color, "SDK background",
                              (color) {
                            final newTheme = (state.theme ?? ch.CheckoutTheme())
                                .copyWith(sdkBackgroundColor: ch.ColorState(color: color));
                            context.read<ThemeCustomizationScreenCubit>().onThemeChanged(newTheme);
                          }),
                          const SizedBox(height: dividerPadding),
                          divider(),
                          const SizedBox(height: dividerPadding),
                          _colorOptionItem(
                              state.theme?.modalBackgroundColor?.color, "Modal background",
                              (color) {
                            final newTheme = (state.theme ?? ch.CheckoutTheme())
                                .copyWith(modalBackgroundColor: ch.ColorState(color: color));
                            context.read<ThemeCustomizationScreenCubit>().onThemeChanged(newTheme);
                          }),
                          const SizedBox(height: dividerPadding),
                          divider(),
                          const SizedBox(height: 8),
                          _colorOptionItem(
                              state.theme?.mainTitleText?.textColor?.color, "Main title", (color) {
                            final newTheme = (state.theme ?? ch.CheckoutTheme()).copyWith(
                                mainTitleText:
                                    ch.TextStyle(textColor: ch.ColorState(color: color)));
                            context.read<ThemeCustomizationScreenCubit>().onThemeChanged(newTheme);
                          }),
                          const SizedBox(height: dividerPadding),
                          divider(),
                          const SizedBox(height: dividerPadding),
                          _colorOptionItem(state.theme?.titleText?.textColor?.color, "Title",
                              (color) {
                            final newTheme = (state.theme ?? ch.CheckoutTheme()).copyWith(
                                titleText: ch.TextStyle(textColor: ch.ColorState(color: color)));
                            context.read<ThemeCustomizationScreenCubit>().onThemeChanged(newTheme);
                          }),
                          const SizedBox(height: dividerPadding),
                          divider(),
                          const SizedBox(height: dividerPadding),
                          _colorOptionItem(state.theme?.subtitleText?.textColor?.color, "Subtitle",
                              (color) {
                            final newTheme = (state.theme ?? ch.CheckoutTheme()).copyWith(
                                subtitleText: ch.TextStyle(textColor: ch.ColorState(color: color)));
                            context.read<ThemeCustomizationScreenCubit>().onThemeChanged(newTheme);
                          }),
                          const SizedBox(height: dividerPadding),
                          divider(),
                          const SizedBox(height: dividerPadding),
                          _colorOptionItem(
                              state.theme?.feesTitleText?.textColor?.color, "Fees Title", (color) {
                            final newTheme = (state.theme ?? ch.CheckoutTheme()).copyWith(
                                feesTitleText:
                                    ch.TextStyle(textColor: ch.ColorState(color: color)));
                            context.read<ThemeCustomizationScreenCubit>().onThemeChanged(newTheme);
                          }),
                          const SizedBox(height: dividerPadding),
                          divider(),
                          const SizedBox(height: dividerPadding),
                          _colorOptionItem(
                              state.theme?.feesSubtitleText?.textColor?.color, "Fees Subtitle",
                              (color) {
                            final newTheme = (state.theme ?? ch.CheckoutTheme()).copyWith(
                                feesSubtitleText:
                                    ch.TextStyle(textColor: ch.ColorState(color: color)));
                            context.read<ThemeCustomizationScreenCubit>().onThemeChanged(newTheme);
                          }),
                          const SizedBox(height: dividerPadding),
                          divider(),
                          const SizedBox(height: dividerPadding),
                          _colorOptionItem(
                              state.theme?.dataLabelText?.textColor?.color, "Data label", (color) {
                            final newTheme = (state.theme ?? ch.CheckoutTheme()).copyWith(
                                dataLabelText:
                                    ch.TextStyle(textColor: ch.ColorState(color: color)));
                            context.read<ThemeCustomizationScreenCubit>().onThemeChanged(newTheme);
                          }),
                          const SizedBox(height: dividerPadding),
                          divider(),
                          const SizedBox(height: dividerPadding),
                          _colorOptionItem(
                              state.theme?.dataValueText?.textColor?.color, "Data value", (color) {
                            final newTheme = (state.theme ?? ch.CheckoutTheme()).copyWith(
                                dataValueText:
                                    ch.TextStyle(textColor: ch.ColorState(color: color)));
                            context.read<ThemeCustomizationScreenCubit>().onThemeChanged(newTheme);
                          }),
                          const SizedBox(height: dividerPadding),
                          divider(),
                          const SizedBox(height: dividerPadding),
                          _colorOptionItem(
                              state.theme?.errorMessageText?.textColor?.color, "Error message",
                              (color) {
                            final newTheme = (state.theme ?? ch.CheckoutTheme()).copyWith(
                                errorMessageText:
                                    ch.TextStyle(textColor: ch.ColorState(color: color)));
                            context.read<ThemeCustomizationScreenCubit>().onThemeChanged(newTheme);
                          }),
                          const SizedBox(height: dividerPadding),
                          divider(),
                          const SizedBox(height: dividerPadding),
                          _expandableOptionItem(
                              title: "Input field",
                              child: _inputFieldModifier(state.theme?.inputTextField, (inputField) {
                                final newTheme = (state.theme ?? ch.CheckoutTheme())
                                    .copyWith(inputTextField: inputField);
                                context
                                    .read<ThemeCustomizationScreenCubit>()
                                    .onThemeChanged(newTheme);
                              })),
                          const SizedBox(height: dividerPadding),
                          divider(),
                          const SizedBox(height: dividerPadding),
                          _expandableOptionItem(
                              title: "Button",
                              child: _buttonModifier(state.theme?.button, (button) {
                                final newTheme =
                                    (state.theme ?? ch.CheckoutTheme()).copyWith(button: button);
                                context
                                    .read<ThemeCustomizationScreenCubit>()
                                    .onThemeChanged(newTheme);
                              })),
                          const SizedBox(height: dividerPadding),
                          divider(),
                          const SizedBox(height: dividerPadding),
                          _expandableOptionItem(
                              title: "Back Button",
                              child: _backButtonModifier(state.theme?.backButton, (button) {
                                final newTheme = (state.theme ?? ch.CheckoutTheme())
                                    .copyWith(backButton: button);
                                context
                                    .read<ThemeCustomizationScreenCubit>()
                                    .onThemeChanged(newTheme);
                              })),
                          const SizedBox(height: dividerPadding),
                          divider(),
                          const SizedBox(height: dividerPadding),
                          _expandableOptionItem(
                              title: "Selector Button",
                              child: _buttonModifier(state.theme?.selectorButton, (button) {
                                final newTheme = (state.theme ?? ch.CheckoutTheme())
                                    .copyWith(selectorButton: button);
                                context
                                    .read<ThemeCustomizationScreenCubit>()
                                    .onThemeChanged(newTheme);
                              })),
                          const SizedBox(height: dividerPadding),
                          divider(),
                          const SizedBox(height: dividerPadding),
                          _expandableOptionItem(
                              title: "Switch",
                              child: _switchModifier(state.theme?.switchControl, (switchControl) {
                                final newTheme = (state.theme ?? ch.CheckoutTheme())
                                    .copyWith(switchControl: switchControl);
                                context
                                    .read<ThemeCustomizationScreenCubit>()
                                    .onThemeChanged(newTheme);
                              })),
                          const SizedBox(height: dividerPadding),
                          divider(),
                          const SizedBox(height: dividerPadding),
                          _colorOptionItem(state.theme?.savePhoneNumberIconColor?.color,
                              "Save Phone Number Icon Color", (color) {
                            final newTheme = (state.theme ?? ch.CheckoutTheme())
                                .copyWith(savePhoneNumberIconColor: ch.ColorState(color: color));
                            context.read<ThemeCustomizationScreenCubit>().onThemeChanged(newTheme);
                          }),
                          const SizedBox(height: dividerPadding),
                          divider(),
                          const SizedBox(height: dividerPadding),
                          _colorOptionItem(
                              state.theme?.selectorIconColor?.color, "Select Payment Icon Color",
                              (color) {
                            final newTheme = (state.theme ?? ch.CheckoutTheme())
                                .copyWith(selectorIconColor: ch.ColorState(color: color));
                            context.read<ThemeCustomizationScreenCubit>().onThemeChanged(newTheme);
                          }),
                          const SizedBox(height: dividerPadding),
                          divider(),
                          const SizedBox(height: dividerPadding),
                          _colorOptionItem(state.theme?.paymentItemBackgroundColor?.color,
                              "Select Payment Background Color", (color) {
                            final newTheme = (state.theme ?? ch.CheckoutTheme())
                                .copyWith(paymentItemBackgroundColor: ch.ColorState(color: color));
                            context.read<ThemeCustomizationScreenCubit>().onThemeChanged(newTheme);
                          }),
                        ],
                      );
                    }))),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
                style: ButtonStyle(backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.pressed)) {
                      return Colors.lightBlueAccent;
                    }
                    return Colors.amber; // Use the component's default.
                  },
                )),
                onPressed: () {
                  context.read<ThemeCustomizationScreenCubit>().onSave();
                },
                child: const Text("Save")),
          ),
        ]));
  }

  Divider divider() =>
      const Divider(height: 1, thickness: 1, color: Colors.lightBlueAccent, endIndent: 0);

  InkWell _colorOptionItem(Color? colorStyle, String title, Function(Color color) onColorChange) {
    final color = colorStyle ?? Colors.grey;
    final isEmpty = colorStyle == null;
    return InkWell(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(1.0)),
          ),
          child: isEmpty ? CustomPaint(painter: CrossingLinesPainter()) : const SizedBox.shrink(),
        ),
      ]),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return pickerDialog(color, onColorChange);
          },
        );
      },
    );
  }

  Widget _expandableOptionItem({required String title, required Widget child}) {
    final AnimationController rotationController =
        AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    final ValueNotifier expanded = ValueNotifier(false);
    // final Animation<double> curve =
    //     CurvedAnimation(parent: rotationController, curve: Curves.easeOutQuint);
    expanded.addListener(() {
      if (expanded.value) {
        rotationController..reverse(from: 0.5);
      } else {
        rotationController..forward(from: 0.0);
      }
    });
    return ValueListenableBuilder(
        valueListenable: expanded,
        builder: (context, btnValue, __) => Column(children: [
              InkWell(
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(title),
                      RotationTransition(
                        turns: Tween(begin: 0.0, end: 1.0).animate(rotationController),
                        child: Icon(
                          Icons.arrow_drop_down_circle,
                          color: Colors.lightBlue[200],
                          size: 24.0,
                          semanticLabel: 'Expand button',
                        ),
                      )
                    ])),
                onTap: () {
                  expanded.value = !expanded.value;
                },
              ),
              expanded.value
                  ? Padding(
                      padding: const EdgeInsets.only(left: 14.0),
                      child: child,
                    )
                  : SizedBox.shrink()
            ]));
  }

  Widget _buttonModifier(ch.ButtonComponent? button, Function(ch.ButtonComponent button) onChange) {
    final ValueNotifier btn = ValueNotifier(button);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const SizedBox(height: dividerPadding),
      subDivider(),
      const SizedBox(height: dividerPadding),
      ValueListenableBuilder(
          valueListenable: btn,
          builder: (context, btnValue, __) =>
              _colorOptionItem(btnValue?.textColor.color, "Button Color", (color) {
                btn.value = (btnValue ?? ch.ButtonComponent())
                    .copyWith(textColor: ch.ColorState(color: color));
              })),
      const SizedBox(height: 10),
      ElevatedButton(
        child: const Text('Apply'),
        onPressed: () {
          onChange(btn.value);
        },
      )
    ]);
  }

  Widget _backButtonModifier(ch.RippleColor? button, Function(ch.RippleColor button) onChange) {
    final ValueNotifier btn = ValueNotifier(button);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const SizedBox(height: dividerPadding),
      subDivider(),
      const SizedBox(height: dividerPadding),
      ValueListenableBuilder(
          valueListenable: btn,
          builder: (context, btnValue, __) =>
              _colorOptionItem(btnValue?.textColor.color, "Back Button Color", (color) {
                btn.value = (btnValue ?? ch.RippleColor()).copyWith(color: color);
              })),
      const SizedBox(height: 10),
      ElevatedButton(
        child: const Text('Apply'),
        onPressed: () {
          onChange(btn.value);
        },
      )
    ]);
  }

  Widget _inputFieldModifier(
      ch.TextFieldStyle? inputField, Function(ch.TextFieldStyle inputField) onChange) {
    final ValueNotifier btn = ValueNotifier(inputField);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const SizedBox(height: dividerPadding),
      subDivider(),
      const SizedBox(height: dividerPadding),
      ValueListenableBuilder(
          valueListenable: btn,
          builder: (context, value, __) =>
              _colorOptionItem(value?.background?.color, "Background", (color) {
                btn.value = (value ?? ch.TextFieldStyle())
                    .copyWith(background: ch.ColorState(color: color));
              })),
      subDivider(),
      const SizedBox(height: dividerPadding),
      ValueListenableBuilder(
          valueListenable: btn,
          builder: (context, value, __) =>
              _colorOptionItem(value?.primaryColor?.color, "Primary Color", (color) {
                btn.value = (value ?? ch.TextFieldStyle())
                    .copyWith(primaryColor: ch.ColorState(color: color));
              })),
      const SizedBox(height: dividerPadding),
      subDivider(),
      const SizedBox(height: dividerPadding),
      ValueListenableBuilder(
          valueListenable: btn,
          builder: (context, value, __) =>
              _colorOptionItem(value?.focusedColor?.color, "Focused Color", (color) {
                btn.value = (value ?? ch.TextFieldStyle())
                    .copyWith(focusedColor: ch.ColorState(color: color));
              })),
      const SizedBox(height: dividerPadding),
      subDivider(),
      ValueListenableBuilder(
          valueListenable: btn,
          builder: (context, value, __) =>
              _colorOptionItem(value?.text?.textColor?.color, "Text Color", (color) {
                btn.value = (value ?? ch.TextFieldStyle())
                    .copyWith(text: ch.TextStyle(textColor: ch.ColorState(color: color)));
              })),
      const SizedBox(height: dividerPadding),
      subDivider(),
      ValueListenableBuilder(
          valueListenable: btn,
          builder: (context, value, __) =>
              _colorOptionItem(value?.error?.textColor?.color, "Error Color", (color) {
                btn.value = (value ?? ch.TextFieldStyle())
                    .copyWith(error: ch.TextStyle(textColor: ch.ColorState(color: color)));
              })),
      const SizedBox(height: 10),
      ElevatedButton(
        child: const Text('Apply'),
        onPressed: () {
          onChange(btn.value);
        },
      )
    ]);
  }

  Widget _switchModifier(
      ch.SwitchComponent? switchComponent, Function(ch.SwitchComponent switchComponent) onChange) {
    final ValueNotifier btn = ValueNotifier(switchComponent);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const SizedBox(height: dividerPadding),
      subDivider(),
      const SizedBox(height: dividerPadding),
      ValueListenableBuilder(
          valueListenable: btn,
          builder: (context, value, __) =>
              _colorOptionItem(value?.checkedThumbTintColor, "Checked Thumb", (color) {
                btn.value = (value ?? ch.SwitchComponent()).copyWith(checkedThumbTintColor: color);
              })),
      subDivider(),
      const SizedBox(height: dividerPadding),
      ValueListenableBuilder(
          valueListenable: btn,
          builder: (context, value, __) =>
              _colorOptionItem(value?.uncheckedThumbTintColor, "Unchecked Thumb", (color) {
                btn.value =
                    (value ?? ch.SwitchComponent()).copyWith(uncheckedThumbTintColor: color);
              })),
      const SizedBox(height: dividerPadding),
      subDivider(),
      const SizedBox(height: dividerPadding),
      ValueListenableBuilder(
          valueListenable: btn,
          builder: (context, value, __) =>
              _colorOptionItem(value?.checkedTrackTintColor, "Checked Track", (color) {
                btn.value = (value ?? ch.SwitchComponent()).copyWith(checkedTrackTintColor: color);
              })),
      const SizedBox(height: dividerPadding),
      subDivider(),
      ValueListenableBuilder(
          valueListenable: btn,
          builder: (context, value, __) =>
              _colorOptionItem(value?.uncheckedTrackTintColor, "Unchecked Track", (color) {
                btn.value =
                    (value ?? ch.SwitchComponent()).copyWith(uncheckedTrackTintColor: color);
              })),
      const SizedBox(height: dividerPadding),
      subDivider(),
      ValueListenableBuilder(
          valueListenable: btn,
          builder: (context, value, __) =>
              _colorOptionItem(value?.checkedTrackDecorationColor, "Checked Track Decoration", (color) {
                btn.value =
                    (value ?? ch.SwitchComponent()).copyWith(checkedTrackDecorationColor: color);
              })),
      subDivider(),
      ValueListenableBuilder(
          valueListenable: btn,
          builder: (context, value, __) => _colorOptionItem(
                  value?.uncheckedTrackDecorationColor, "Unchecked Track Decoration", (color) {
                btn.value =
                    (value ?? ch.SwitchComponent()).copyWith(uncheckedTrackDecorationColor: color);
              })),
      const SizedBox(height: 10),
      ElevatedButton(
        child: const Text('Apply'),
        onPressed: () {
          onChange(btn.value);
        },
      )
    ]);
  }

  Widget _marginsModifier(ch.Margins? margins, Function(ch.Margins margins) onChange) {
    final leftController = TextEditingController(text: margins?.left.toString() ?? "");
    final topController = TextEditingController(text: margins?.top.toString() ?? "");
    final rightController = TextEditingController(text: margins?.right.toString() ?? "");
    final bottomController = TextEditingController(text: margins?.bottom.toString() ?? "");
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const SizedBox(height: dividerPadding),
      marginInput(topController),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          marginInput(leftController),
          SizedBox(width: 34, height: 34),
          marginInput(rightController),
        ],
      ),
      marginInput(bottomController),
      const SizedBox(height: 10),
      ElevatedButton(
        child: const Text('Apply'),
        onPressed: () {
          onChange(
            ch.Margins(
                left: int.tryParse(leftController.text) ?? 0,
                top: int.tryParse(topController.text) ?? 0,
                right: int.tryParse(rightController.text) ?? 0,
                bottom: int.tryParse(bottomController.text) ?? 0),
          );
        },
      )
    ]);
  }

  SizedBox marginInput(TextEditingController topController) {
    return SizedBox(
        width: 34,
        child: TextFormField(
          maxLength: 2,
          textAlign: TextAlign.center,
          controller: topController,
          decoration: InputDecoration(
            counterText: "",
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 5),
            fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue[800] ?? Colors.black26,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue[500] ?? Colors.black26,
                width: 2.0,
              ),
            ),
          ),
          keyboardType: TextInputType.number,
        ));
  }

  Divider subDivider() =>
      Divider(height: 1, thickness: 1, color: Colors.lightBlue[100], endIndent: 0);

  Widget pickerDialog(Color initialColor, Function(Color color) onColorChanged) {
    Color localColor = initialColor;
    return AlertDialog(
      title: const Text('Pick a color!'),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: initialColor,
          onColorChanged: (color) {
            localColor = color;
          },
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text('Apply'),
          onPressed: () {
            Navigator.of(context).pop();
            onColorChanged(localColor);
          },
        ),
      ],
    );
  }
}

class CrossingLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const p0_0 = Offset(0, 0);
    final p1_1 = Offset(size.width, size.height);
    final p1_0 = Offset(size.width, 0);
    final p0_1 = Offset(0, size.height);
    final paint = Paint()
      ..color = Colors.black.withAlpha(100)
      ..strokeWidth = 1;
    canvas.drawLine(p0_0, p1_1, paint);
    canvas.drawLine(p1_0, p0_1, paint);
  }

  @override
  bool shouldRepaint(CrossingLinesPainter oldDelegate) => false;
}
