import 'package:genesis_flutter/model/error.dart';
import 'package:genesis_flutter/model/medicine_type.dart';
import 'package:rxdart/rxdart.dart';

class NewEntryBloc{

  BehaviorSubject<MedicineType>? _selectedMedicineTypes$;
  ValueStream<MedicineType>? get selectedMedicineType =>
      _selectedMedicineTypes$!.stream;

  BehaviorSubject<int>? _selectedInterval$;
  ValueStream<int>? get selectedIntervals =>
      _selectedInterval$;

  BehaviorSubject<String>? _selectedTimeOfDay$;
  ValueStream<String>? get selectedTimeOfDay$ =>
      _selectedTimeOfDay$;

  BehaviorSubject<EntryError>? _errorState$;
  ValueStream<EntryError>? get errorState$ =>
      _errorState$;

  NewEntryBloc(){
    _selectedMedicineTypes$ =
        BehaviorSubject<MedicineType>.seeded(MedicineType.none);

    _selectedTimeOfDay$ = BehaviorSubject<String>.seeded('none');
    _selectedInterval$ = BehaviorSubject<int>.seeded(0);
    _errorState$ = BehaviorSubject<EntryError>();
  }


  void dispose (){

    _selectedMedicineTypes$?.close();
    _selectedTimeOfDay$!.close();
    _selectedInterval$!.close();
  }

  void submitError(EntryError error){
    _errorState$!.add(error);
  }

  void updateInterval (int interval){
    _selectedInterval$!.add(interval);
  }

  void updateTime(String time){
    _selectedTimeOfDay$!.add(time);
  }

  void updateSelectedMedicine(MedicineType type){
    MedicineType _tempType = _selectedMedicineTypes$!.value;
    if(type == _tempType){
      _selectedMedicineTypes$!.add(MedicineType.none);
    }else{
      _selectedMedicineTypes$!.add(type);
    }
  }


}