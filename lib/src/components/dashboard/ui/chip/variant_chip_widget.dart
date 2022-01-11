import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/booking_details_response.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';

class VariantChips extends StatefulWidget {
   List<Variant> variant;

  final Function(String) onOptionSelected;

  VariantChips({Key key, this.onOptionSelected, this.variant}) : super(key: key);

  @override
  _VariantChipsState createState() => _VariantChipsState();
}

class _VariantChipsState extends State<VariantChips> {
  // List<String> options = ['500g', '1Kg','2Kg','3Kg'];
  String _value = "";

  @override
  Widget build(BuildContext context) {
    print("variant ${widget.variant}");
    return Wrap(
      spacing: AppConstants.extraSmallSize,
      children: List<Widget>.generate(
        widget.variant.length, (int index) {
          return ChoiceChip(backgroundColor:  AppTheme.borderNotFocusedColor,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                 '${widget.variant[index].weight}${widget.variant[index].unitType}',
                  style: widget.variant[index] == _value
                      ? AppTheme.theme.textTheme.subtitle2.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: AppTheme.backgroundColor)
                      : AppTheme.theme.textTheme.subtitle2.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: AppTheme.subHeadingTextColor),
                ),
              ],
            ),
            selected: _value == widget.variant[index],
            selectedColor: AppTheme.primaryColor,
            onSelected: (bool selected) {
              if (_value == widget.variant[index]) return;
              setState(() {
                _value = selected ? widget.variant[index].toString() : null;
                widget.onOptionSelected(_value);
              });
            },
          );
        },
      ).toList(),
    );
  }
}
