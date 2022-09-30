import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/booking_details_response.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';

class VariantChips extends StatefulWidget {
  List<Variant> variant;

  final Function(Variant) onOptionSelected;
  String variantID;

  VariantChips(
      {Key key, this.onOptionSelected, this.variant, this.variantID = ''})
      : super(key: key);

  @override
  _VariantChipsState createState() => _VariantChipsState();
}

class _VariantChipsState extends State<VariantChips> {
  List<Variant> variantList = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.variant.length; i++) {
      if ('${widget.variant[i].weight}${widget.variant[i].unitType}'
          .isNotEmpty) {
        variantList.add(widget.variant[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return variantList.isEmpty
        ? Container()
        : Wrap(
            spacing: AppConstants.extraSmallSize,
            children: List<Widget>.generate(
              variantList.length,
              (int index) {
                return ChoiceChip(
                  backgroundColor: AppTheme.borderNotFocusedColor,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${variantList[index].weight}${variantList[index].unitType}'
                                .isEmpty
                            ? '--'
                            : '${variantList[index].weight}${variantList[index].unitType}',
                        style: variantList[index].id == widget.variantID
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
                  selected: widget.variantID == variantList[index].id,
                  selectedColor: AppTheme.primaryColor,
                  onSelected: (bool selected) {
                    if (widget.variantID == variantList[index].id) return;
                    setState(() {
                      widget.variantID =
                          selected ? variantList[index].toString() : null;
                      widget.onOptionSelected(variantList[index]);
                    });
                  },
                );
              },
            ).toList(),
          );
  }
}
