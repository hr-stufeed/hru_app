import 'package:flutter/material.dart';
import 'package:hr_app/data/constants.dart';
import 'package:hr_app/widgets/routine.dart';
import 'package:hr_app/models/routine_provider.dart';

import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';

class RoutineListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: kPagePadding,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('루틴 리스트', style: kPageTitleStyle),
                  ],
                ),
                kSizedBoxBetweenItems,
                Expanded(
                  child: ReorderableColumn(
                    scrollController: ScrollController(),
                    enabled: true,
                    onReorder:
                        Provider.of<RoutineProvider>(context, listen: false)
                            .reorder,
                    draggingWidgetOpacity: 0,
                    onNoReorder: (int index) {
                      //this callback is optional
                      debugPrint(
                          '${DateTime.now().toString().substring(5, 22)} reorder cancelled. index:$index');
                    },
                    children:
                        Provider.of<RoutineProvider>(context, listen: true)
                            .routines
                            .map((routine) {
                      return Container(
                        key: UniqueKey(),
                        child: routine,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 30.0,
                  ),
                  backgroundColor: Colors.white,
                  onPressed: () => Navigator.pushNamed(
                    context,
                    'Routine_create_page',
                    arguments: ModifyArgument(isModify: false),
                  ),
                ),
                kSizedBoxBetweenItems,
              ],
            ),
          ],
        ),
      ),
    );
  }
}