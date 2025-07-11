import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:schoolapp/app/app_custom_widget/common_text.dart';
import 'package:schoolapp/app/app_custom_widget/custom_apptextform_field.dart';
import 'package:schoolapp/app/core/util/app_color.dart';
import 'package:schoolapp/app/core/util/custom_color.dart';
import 'package:schoolapp/app/core/util/sizer_constant.dart';

class commonDropdownListview<T extends GetxController> extends StatelessWidget {
  final T controller;
  final List<dynamic> Function(T controller) getList;
  final List<dynamic>? Function(T controller)? getSearchList;
  final List<String> Function(T controller) getSelectedIds;
  final Function(T controller, String id, dynamic item) onToggle;

  const commonDropdownListview({
    super.key,
    required this.controller,
    required this.getList,
    this.getSearchList,
    required this.getSelectedIds,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(
      init: controller,
      builder: (ctrl) {
        final searchList = getSearchList?.call(ctrl);
        final dataList = searchList != null ? searchList : getList(ctrl);
        final selectedIds = getSelectedIds(ctrl);

        return Container(
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(10),
          ),
          height: getDynamicHeight(size: 0.395),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: getDynamicHeight(size: 0.015)),
            child: Column(
              children: [
                const SizedBox(height: 10),
                AppText(
                  text: 'Select Surgery',
                  fontSize: Sizes.px16,
                  fontWeight: FontWeight.w600,
                  fontColor: AppColor.black,
                ),
                const SizedBox(height: 15),
                AppTextField(
                  hintText: 'Enter surgery name',
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  onChanged: (text) {
                    if (controller is dynamic) {
                      try {
                        (controller as dynamic).searchOperationName(text.trim());
                      } catch (_) {}
                    }
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: dataList == null
                      ? Center(child: AppText(text: "No data found for selected surgeon"))
                      : dataList.isEmpty
                          ? Center(child: AppText(text: "No data found"))
                          : ListView.builder(
                              padding: EdgeInsets.only(bottom: Sizes.crossLength * 0.020),
                              itemCount: dataList.length,
                              itemBuilder: (_, index) {
                                final item = dataList[index];
                                final name = item.name ?? '';
                                final value = item.value?.toString() ?? '';

                                final isSelected = selectedIds.contains(value);

                                return GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => onToggle(ctrl, value, item),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Expanded(child: AppText(text: name)),
                                          const SizedBox(width: 10),
                                          isSelected
                                              ? GestureDetector(
                                                  onTap: () {
                                                    FocusScope.of(context).unfocus();
                                                    onToggle(ctrl, value, item);
                                                  },
                                                  child: const Icon(
                                                    Icons.cancel_outlined,
                                                    color: ConstColor.buttonColor,
                                                  ),
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                      index != dataList.length - 1 ? const SizedBox(height: 15) : const SizedBox(),
                                      index != dataList.length - 1
                                          ? const Divider(
                                              thickness: 1,
                                              height: 1,
                                              color: ConstColor.greyACACAC,
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
