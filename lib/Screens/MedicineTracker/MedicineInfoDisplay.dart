import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:genesis_flutter/Medicine.dart';
import 'package:genesis_flutter/color.dart';
import 'package:genesis_flutter/global_bloc.dart';
import 'package:provider/provider.dart';

class MedicineInfoDisplay extends StatefulWidget {
  const MedicineInfoDisplay(this.medicine,{super.key});
  final Medicine medicine;

  @override
  State<MedicineInfoDisplay> createState() => _MedicineInfoDisplayState();
}

class _MedicineInfoDisplayState extends State<MedicineInfoDisplay> {

  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body:  Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            MainSection( medicine: widget.medicine),
            ExtendedSection(medicine: widget.medicine),
            Spacer(),
            SizedBox(
              width: 300,
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: myTealColor, shape: const StadiumBorder()),
                onPressed: () {
                  openAlertBox(context, _globalBloc);
                },
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Text(
                     "Delete",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
              SizedBox(height: 40,)
          ],
        ),
      ),
    );
  }



  openAlertBox(BuildContext context, GlobalBloc _globalBloc){
      return showDialog(context: context, builder: (context){
        return AlertDialog(
          shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              topLeft:  Radius.circular(10),
              topRight: Radius.circular(10),
             bottomRight:  Radius.circular(10)
            ),
          ),
          title: Text("Delete This Reminder ?",
          style: TextStyle(
            color: textCol,
            fontSize: 20,
          ),),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: Text("Cancel",
                style: TextStyle(
                  color: myTealColor
                ),)),
            TextButton(
                onPressed: (){
                  _globalBloc.removeMedicine(widget.medicine);
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                child: Text("Delete",
                  style: TextStyle(
                      color: pink1
                  ),))
          ],
        );
      });
  }
}

class MainSection extends StatelessWidget {
  const MainSection({Key? key, this.medicine}) : super(key: key);
  final Medicine? medicine;

  Hero makeIcon(){
    if(medicine?.medicineType =="syrup"){
      return Hero(
        tag: medicine!.medicineName!+medicine!.medicineType!,
        child: SvgPicture.asset('assets/icons/syrup_icon.svg',  color: pinkColor,
            height: 70),
      );
    }else if(medicine!.medicineType=="pills"){
      return Hero(
        tag: medicine!.medicineName!+medicine!.medicineType!,
        child: SvgPicture.asset('assets/icons/pills_icon.svg',  color: pinkColor,
            height: 70),
      );

    }else if(medicine!.medicineType =='tablet'){
      return Hero(
        tag: medicine!.medicineName!+medicine!.medicineType!,
        child: SvgPicture.asset('assets/icons/tablet_icon.svg',  color: pinkColor,
            height: 70),
      );

    }else if(medicine!.medicineType=='vaccine'){
      return Hero(
        tag: medicine!.medicineName!+medicine!.medicineType!,
        child: SvgPicture.asset('assets/icons/vacine_icon.svg',  color: pinkColor,
            height: 70),
      );

    }

    return Hero(
      tag: medicine!.medicineName!+medicine!.medicineType!,
      child: Icon(Icons.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return    Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
              makeIcon(),
              Column(
                children: [
                  Hero(
                    tag: medicine!.medicineName!,
                      child: MainInfoTab(fieldTitle: "Medicine Name", fieldInfo: medicine!.medicineName!)),
                  SizedBox(height: 8,),
                  MainInfoTab(fieldTitle: "Dosage", fieldInfo: medicine!.dosage==0?
                  "Not Specified":"${medicine!.dosage} mg")
                ],
              ),
      ],
    );
  }
}

class MainInfoTab extends StatelessWidget {
  const MainInfoTab({Key? key, required this.fieldTitle, required this.fieldInfo})
  :super(key:key);

  final String fieldTitle;
  final String fieldInfo;

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 70,
      width: 100,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fieldTitle,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12),
            ),
            SizedBox(height: 4,),
            Text(
              fieldInfo,
              style: TextStyle(
                  color: textCol,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class ExtendedSection extends StatelessWidget {
  const ExtendedSection({Key? key, this.medicine}) : super(key: key);
  final Medicine? medicine;

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: [
        ExtendedInfoTab(fieldTitle: "Medicine Type", fieldInfo: medicine!.medicineType! =='none'?"Not Specified":
        medicine!.medicineType!),
        ExtendedInfoTab(fieldTitle: "Dose Interval", fieldInfo: "Every ${medicine!.interval} hours | "
            "${medicine!.interval==24?"One time a day":"${(24/medicine!.interval!).floor()} times a day"} times a day"),
        ExtendedInfoTab(fieldTitle: "Start Time", fieldInfo: "${medicine!.startTime![0]}${medicine!.startTime![1]}:${medicine!.startTime![2]}${medicine!.startTime![3]}"),
      ],
    );
  }
}

class ExtendedInfoTab extends StatelessWidget {
  const ExtendedInfoTab({super.key, required this.fieldTitle, required this.fieldInfo});

  final String fieldTitle;
  final String fieldInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top:12.0, left: 4,),
            child: Text(fieldTitle,
                  style: TextStyle(
                    fontSize: 18 ,
                    color: textCol,
                  )),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(fieldInfo,
                style: TextStyle(
                  fontSize: 16,
                  color: myTealColor,
                )),
          ),

        ],
      ),
    );
  }
}


