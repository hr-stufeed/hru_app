import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hr_app/models/routine_model.dart';
import 'package:hr_app/models/workout_model.dart';
import 'package:hr_app/widgets/routine.dart';
import 'package:intl/intl.dart';
import 'package:hr_app/data/constants.dart';

class RoutineProvider with ChangeNotifier {
  //앱 전체에서 접근 가능한 전역 루틴리스트
  List<Routine> _routines = [];

  RoutineProvider() {
    load();
  }

  int get routineCount {
    return _routines.length;
  }

  UnmodifiableListView get routines => UnmodifiableListView(_routines);

  void add(String text, Color color, List<String> days) async {
    var _box = await Hive.openBox<RoutineModel>('routines');
    // 현재 시간에 따른 키를 생성한다.
    var key = DateFormat('yyMMddhhmmss').format(DateTime.now());
    // 박스에 키와 함께 삽입한다.
    _box.put(
      key,
      RoutineModel(
        name: text,
        color: color.value,
        days: days,
        workoutModelList: [],
      ),
    );
    // 동일하게 routine list에도 키와 함께 삽입한다.
    final routine = Routine(
      autoKey: key,
      name: text,
      color: color,
      days: days,
      workoutModelList: [],
    );
    _routines.add(routine);

    print('키들 : ${_box.keys}');

    notifyListeners();
  }

  Routine copy(int n) {
    try {
      return Routine(
        autoKey: _routines[n].autoKey,
        name: _routines[n].name,
        color: _routines[n].color,
        isListUp: false,
        workoutModelList: _routines[n].workoutModelList,
        days: _routines[n].days,
      );
    } catch (e) {
      print('copy error:$e');
      return kErrorRoutine;
    }
  }

  void modify(String autoKey, String text, Color color, List<String> days,
      List<WorkoutModel> workoutModelList) async {
    var _box = await Hive.openBox<RoutineModel>('routines');
    // 루틴 표지의 수정하기를 누르면 key를 전달받고 _box의 RoutineModel에 정보를 덮어 씌운다.
    _box.put(
        autoKey,
        RoutineModel(
            name: text,
            color: color.value,
            days: days,
            workoutModelList: workoutModelList));
    // 역시 key를 기준으로 _routines의 요소도 덮어씌운다.
    for (int i = 0; i < _routines.length; i++) {
      if (_routines[i].autoKey == autoKey)
        _routines[i] = Routine(
          autoKey: autoKey,
          name: text,
          color: color,
          days: days,
          workoutModelList: workoutModelList,
        );
      ;
    }
    notifyListeners();
  }

  Routine find(String autoKey) {
    return _routines.where((routine) => routine.autoKey == autoKey).toList()[0];
  }

  void saveWorkout(String autoKey, List<WorkoutModel> workoutList) async {
    var _box = await Hive.openBox<RoutineModel>('routines');
    _box.put(
      autoKey,
      RoutineModel(
        name: _box.get(autoKey).name,
        color: _box.get(autoKey).color,
        days: _box.get(autoKey).days,
        workoutModelList: workoutList,
      ),
    );
    print(_box.get(autoKey).workoutModelList);
    notifyListeners();
  }

  void delete(String n) async {
    var _box = await Hive.openBox<RoutineModel>('routines');
    // 삭제 시 _routines에서는 키를 탐색하여 삭제한다.
    for (int i = 0; i < _routines.length; i++) {
      if (_routines[i].autoKey == n) _routines.removeAt(i);
    }
    // 박스는 그냥 키를 바로 대입하여 삭제한다.
    _box.delete(n);

    print('delete $n');
    notifyListeners();
  }

  void load() async {
    var _box = await Hive.openBox<RoutineModel>('routines');
    try {
      for (int index = 0; index < _box.length; index++) {
        String autoKey = _box.keyAt(index);
        _routines.add(Routine(
          autoKey: autoKey, // 로딩시에도 박스에서 키를 가져와 다시 부여한다.
          name: _box.get(autoKey).name,
          color: Color(_box.get(autoKey).color),
          days: _box.get(autoKey).days,
          workoutModelList: _box.get(autoKey).workoutModelList,
        ));
        print('name : ${_box.get(autoKey).name}');
        print('autoKey : ${_routines[0].autoKey}');
        _box.get(autoKey).workoutModelList.forEach((element) {
          print('workouts : ${element.name}');
        });
      }

      notifyListeners();
    } catch (e) {}
  }

  void clear() async {
    var _box = await Hive.openBox<RoutineModel>('routines');
    _box.clear();

    print('clear ${_box.length}');
  }

  void reorder(int oldIndex, int newIndex) async {
    Routine moveRoutine = _routines.removeAt(oldIndex);
    _routines.insert(newIndex, moveRoutine);
    print(_routines[0].name);
    notifyListeners();
  }
}