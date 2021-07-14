import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glaucoma/core/constants/colors.dart';
import 'package:glaucoma/models/scan_history.dart';
import 'package:glaucoma/pages/history/history_page_controller.dart';

class HistoryPage extends GetView<HistoryPageController> {
  static const String _emptyListMessage = 'Looks like you\'ve\n never scanned this\npatient before, please,\nperform one scan\nat least!';
  static const String _errorMessage = 'We\'re having a\n trouble showing your\npatient scan history\n list! Please\n try refreshing\nthe page.';
  static const TextStyle _messageTextStyle = const TextStyle(color: textColor, fontWeight: FontWeight.w700, fontSize: 35);
  static const TextStyle _columnLabelTextStyle = const TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 15);
  static const TextStyle _cellValueTextStyle = const TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 13);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: highlight1Color,
      color: backgroundColor,
      onRefresh: () async => controller.loadHistory(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: controller.scaffoldKey,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          iconTheme: IconThemeData(color: textColor),
          title: Text('History', style: TextStyle(color: textColor, fontWeight: FontWeight.w700)),
        ),
        body: ObxValue<Rx<HistoryPageState>>(
          (Rx<HistoryPageState> rxState) {
            final HistoryPageState state = rxState.value;
            if (state == HistoryPageState.loading) {
              return Center(child: Theme(data: ThemeData(accentColor: textColor), child: CircularProgressIndicator()));
            } else if (state == HistoryPageState.loaded) {
              final List<ScanHistory> history = controller.history;
              if (history.isEmpty) {
                return Center(child: Text(_emptyListMessage, textAlign: TextAlign.center, style: _messageTextStyle));
              } else {
                return SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Eye', style: _columnLabelTextStyle)),
                        DataColumn(label: Text('Result', style: _columnLabelTextStyle)),
                        DataColumn(label: Text('Image', style: _columnLabelTextStyle)),
                        DataColumn(label: Text('Notes', style: _columnLabelTextStyle))
                      ],
                      rows: history.map<DataRow>(
                        (ScanHistory h) {
                          final String result = h.result == 0 ? 'Negative' : 'Positive';
                          return DataRow(
                            cells: <DataCell>[
                              DataCell(GestureDetector(onTap: () => controller.showHistoryOptions(context, h), child: Text(h.eye, style: _cellValueTextStyle))),
                              DataCell(GestureDetector(onTap: () => controller.showHistoryOptions(context, h), child: Text(result, style: _cellValueTextStyle))),
                              DataCell(
                                GestureDetector(
                                  onTap: () => controller.showHistoryOptions(context, h),
                                  child: Image.network(
                                    h.imageLink,
                                    width: 60,
                                    height: 60,
                                    loadingBuilder: (context, child, loadingProgress) => Image.asset('assets/placeholder.png', width: 60, height: 60),
                                    errorBuilder: (context, child, loadingProgress) => Image.asset('assets/placeholder.png', width: 60, height: 60),
                                  ),
                                ),
                              ),
                              DataCell(GestureDetector(onTap: () => controller.showHistoryOptions(context, h), child: Text(h.notes, style: _cellValueTextStyle))),
                            ],
                          );
                        },
                      ).toList(),
                    ),
                  ),
                );
              }
            } else {
              return Center(child: Text(_errorMessage, textAlign: TextAlign.center, style: _messageTextStyle));
            }
          },
          controller.state,
        ),
        floatingActionButton: ObxValue<Rx<HistoryPageState>>(
          (Rx<HistoryPageState> rxState) {
            final HistoryPageState state = rxState.value;
            if (state == HistoryPageState.loaded) {
              return ObxValue<RxBool>(
                (RxBool rxIsOpened) {
                  final bool isOpened = rxIsOpened.value;
                  return FloatingActionButton(
                    child: Icon(isOpened ? Icons.close : Icons.add, color: backgroundColor),
                    backgroundColor: highlight1Color,
                    onPressed: controller.openBottomSheet,
                  );
                },
                controller.isBottomSheetOpen,
              );
            } else {
              return SizedBox();
            }
          },
          controller.state,
        ),
      ),
    );
  }
}
