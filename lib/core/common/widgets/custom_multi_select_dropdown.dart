import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_sizer.dart';

class CustomMultiSelectDropdown extends StatelessWidget {
  final String? label;
  final String hintText;
  final List<String> items;
  final RxList<String> selectedValues;
  final Function(List<String>) onChanged;
  final double borderRadius;
  final double height;

  const CustomMultiSelectDropdown({
    super.key,
    this.label,
    required this.hintText,
    required this.items,
    required this.selectedValues,
    required this.onChanged,
    this.borderRadius = 8,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
        ],
        GestureDetector(
          onTap: () => _showMultiSelect(context),
          child: Container(
            constraints: BoxConstraints(minHeight: height),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: const Color(0xffE7EAF2)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Obx(() {
                    if (selectedValues.isEmpty) {
                      return Text(
                        hintText,
                        style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                      );
                    }
                    return Wrap(
                      spacing: 8.w,
                      runSpacing: 4.h,
                      children: selectedValues.map((value) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppColors.primary),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                value,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              GestureDetector(
                                onTap: () {
                                  selectedValues.remove(value);
                                  onChanged(selectedValues);
                                },
                                child: Icon(
                                  Icons.close,
                                  size: 14.sp,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showMultiSelect(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return _MultiSelectDialog(
          items: items,
          initialSelectedValues: selectedValues.toList(),
          onConfirm: (values) {
            selectedValues.assignAll(values);
            onChanged(selectedValues);
          },
        );
      },
    );
  }
}

class _MultiSelectDialog extends StatefulWidget {
  final List<String> items;
  final List<String> initialSelectedValues;
  final Function(List<String>) onConfirm;

  const _MultiSelectDialog({
    required this.items,
    required this.initialSelectedValues,
    required this.onConfirm,
  });

  @override
  State<_MultiSelectDialog> createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<_MultiSelectDialog> {
  late List<String> _selectedValues;

  @override
  void initState() {
    super.initState();
    _selectedValues = List.from(widget.initialSelectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Personalities'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.items.map((item) {
            final isSelected = _selectedValues.contains(item);
            return CheckboxListTile(
              title: Text(item),
              value: isSelected,
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    _selectedValues.add(item);
                  } else {
                    _selectedValues.remove(item);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onConfirm(_selectedValues);
            Navigator.pop(context);
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
/// example
// Obx(
// () => CustomMultiSelectDropdown(
// hintText: AppText.yourPetBehaviour.tr,
// items: controller.personalities,
// selectedValues: controller.selectedPersonalities,
// onChanged: (values) => controller.setPersonalities(values),
// borderRadius: 12.r,
// height: 52.h,
// ),
// ),