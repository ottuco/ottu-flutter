import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:ottu_flutter_checkout_sample/theme/theme_customization_screen_cubit.dart';
import 'package:ottu_flutter_checkout_sample/theme/theme_customization_state.dart';

class ThemeCustomizationScreen extends StatefulWidget {
  const ThemeCustomizationScreen({super.key});

  @override
  State<ThemeCustomizationScreen> createState() => _ThemeCustomizationScreenState();
}

class _ThemeCustomizationScreenState extends State<ThemeCustomizationScreen> {
  final amountEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = context.read<ThemeCustomizationScreenCubit>().state;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customize your Theme'),
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: BlocBuilder<ThemeCustomizationScreenCubit, ThemeCustomizationState>(
                  builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    _colorOptionItem(state),
                    Row(children: [const Text('Preload payload')]),
                    Row(children: [const Text('No forms of payment')]),
                    Row(children: [const Text('Google pay')]),
                    Row(children: [const Text('Redirect')]),
                    Row(children: [const Text('Flex methods')]),
                    const SizedBox(height: 16),
                    ElevatedButton(
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
                    const SizedBox(height: 16),
                  ],
                );
              }))

          /*const Center(
        child: Text(
          'This is the home page',
          style: TextStyle(fontSize: 24),
        ),
      ),*/
          ),
    );
  }

  InkWell _colorOptionItem(ThemeCustomizationState state) {
    final color = state.theme.titleText?.textColor?.color ?? Colors.black26;
    return InkWell(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('Show payment details'),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(1.0)),
          ),
        ),
      ]),
      onTap: () {
        final cubit = context.read<ThemeCustomizationScreenCubit>();
        showDialog(
          context: context,
          builder: (BuildContext context) {

            Color? localColor;

            return AlertDialog(
              title: const Text('Pick a color!'),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: color,
                  onColorChanged: (color) {
                    localColor = color;
                  },
                ),
                // Use Material color picker:
                //
                // child: MaterialPicker(
                //   pickerColor: pickerColor,
                //   onColorChanged: changeColor,
                //   showLabel: true, // only on portrait mode
                // ),
                //
                // Use Block color picker:
                //
                // child: BlockPicker(
                //   pickerColor: currentColor,
                //   onColorChanged: changeColor,
                // ),
                //
                // child: MultipleChoiceBlockPicker(
                //   pickerColors: currentColors,
                //   onColorsChanged: changeColors,
                // ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('Apply'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if(localColor != null) {
                      cubit.onThemeChanged(localColor!);
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
