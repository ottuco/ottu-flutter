import 'package:flutter/material.dart';
import 'package:ottu_flutter_checkout/ottu_flutter_checkout.dart' show NestedWrapperWidget;

class MerchantNestedWidget extends StatefulWidget {
  const MerchantNestedWidget({super.key});

  @override
  State<MerchantNestedWidget> createState() => _MerchantNestedWidgetState();
}

class _MerchantNestedWidgetState extends State<MerchantNestedWidget> {
  bool _wantsExtraDiscount = false;

  @override
  Widget build(BuildContext context) {
    return NestedWrapperWidget(
      child: Container(
        color: Colors.black12,
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'I am a Flutter nested Widget inside a Native View and inside Flutter!',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 24,),
              CheckboxListTile(
                value: _wantsExtraDiscount,
                onChanged: (value) {
                  setState(() => _wantsExtraDiscount = value ?? false);
                },
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('Do you want extra discount?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
