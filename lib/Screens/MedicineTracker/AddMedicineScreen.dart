import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genesis_flutter/Medicine.dart';
import 'package:genesis_flutter/Screens/MedicineTracker/MedicineDetail.dart';
import 'package:genesis_flutter/Screens/MedicineTracker/MedicineInfoDisplay.dart';
import 'package:genesis_flutter/global_bloc.dart';
import 'package:provider/provider.dart';

Color purple = const Color(0xFF514B6F);
Color textCol = const Color(0xFF393451);
Color pinkColor = const Color(0xFFEDA8CC);
Color myTealColor = const Color(0xFF40ABA6);
Color darkPink = const Color(0xFFD34389);
Color pink1 = const Color(0xFFFF69B4);
Color lightPink = const Color(0xFFFF69B4).withOpacity(0.8);
Color lightPurple = const Color(0xFFB2B2FF).withOpacity(0.8);

class AddMedicineScreen extends StatelessWidget {
  const AddMedicineScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left:20, top:20, bottom:10),
            child: const Text(
              'Worry less. \nLive healthier.',
              style:TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
              )


            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left:24.0,),
              child: Text(
                'Welcome to Daily Dose.',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),

          StreamBuilder<List<Medicine>>(
            stream: globalBloc.medicineList$,
            builder: (context, snapshot){
              return     Padding(
                padding: const EdgeInsets.only(top:10.0, left:12),
                child: Text(
                    snapshot.hasData?snapshot.data!.length.toString():'0',
                    style:const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    )
                ),
              );
            }),

          const Expanded(child: BottomContainer()),
          // SizedBox(height: 60,),



        ]
      ),
        floatingActionButton: InkResponse(
          onTap: (){
            Navigator.push(
              context, MaterialPageRoute(builder: (context)=>const MedicineDetails()),
            );
          },
          child: Padding(

            padding: const EdgeInsets.only(right:10, bottom:25),
            child: Card(
              color:purple,
              shape: const CircleBorder(),
              //shape: LargerRadiusCircleBorder(),
                elevation: 6.0, // Adjust the elevation for a larger visual effect,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                        Icons.add_outlined,
                    color: Colors.white,
                    size:50
                  ),
                ),
            ),
          ),
        ),

    );
  }
}

class BottomContainer extends StatelessWidget{
  const BottomContainer ({Key?key}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    return StreamBuilder(
        stream: globalBloc.medicineList$,
        builder: (context,snapshot) {

          if (!snapshot.hasData){
            return Container();
            } else if(snapshot.data!.isEmpty){
               return  Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'No Medicine ',
                          style: TextStyle(
                            color: pinkColor,
                            fontSize: 30,
                            fontWeight:FontWeight.w500,
                          ),
                        ),
                      );
          } else{

            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context,index){
                    return MedicineCard(medicine: snapshot.data![index]);

                  },
                ),
              );
          }
        },
    );

    // return MedicineCard();
  }

}

// class MedicineCard extends StatelessWidget {
//   const MedicineCard({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//
//     final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
//     return InkWell(
//       highlightColor: Colors.white ,
//       splashColor: Colors.grey,
//       onTap: (){
//         //detail activity
//
//         Navigator.push(context, MaterialPageRoute(builder: (context)=>MedicineInfoDisplay()));
//       },
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: GridView.builder(
//           scrollDirection: Axis.vertical,
//           shrinkWrap: true,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//           ),
//           itemCount: 4,
//           itemBuilder: (context,index){
//             return Container(
//               margin: EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: pinkColor,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Column(
//                 children: [
//                   SizedBox(height: 20,),
//                   SvgPicture.asset(
//                       'assets/icons/syrup_icon.svg',
//                       height:50),
//                   Text(
//                     "Calpol",
//                     overflow: TextOverflow.fade,
//                     textAlign: TextAlign.start,
//                     style: TextStyle(
//                         color: textCol,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     "Every 8 hours",
//                     overflow: TextOverflow.fade,
//                     textAlign: TextAlign.start,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 14,),
//                   ),
//                 ],
//               ),
//             );
//
//           },
//         ),
//       ),
//     );
//   }
// }

class MedicineCard extends StatelessWidget {
  const MedicineCard({super.key, required this.medicine});
  final Medicine medicine;

  Hero makeIcon(){
    if(medicine.medicineType =="syrup"){
      return Hero(
          tag: medicine.medicineName!+medicine.medicineType!,
          child: SvgPicture.asset('assets/icons/syrup_icon.svg', height:50),
      );
    }else if(medicine.medicineType=="pills"){
      return Hero(
        tag: medicine.medicineName!+medicine.medicineType!,
        child: SvgPicture.asset('assets/icons/pills_icon.svg', height:50),
      );

    }else if(medicine.medicineType =='tablet'){
      return Hero(
        tag: medicine.medicineName!+medicine.medicineType!,
        child: SvgPicture.asset('assets/icons/tablet_icon.svg', height:50),
      );

    }else if(medicine.medicineType=='vaccine'){
      return Hero(
        tag: medicine.medicineName!+medicine.medicineType!,
        child: SvgPicture.asset('assets/icons/vacine_icon.svg', height:50),
      );

    }

    return Hero(
      tag: medicine.medicineName!+medicine.medicineType!,
      child: const Icon(Icons.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.white ,
      splashColor: Colors.grey[200],
      onTap: (){
        //detail activity
       // Navigator.push(context, MaterialPageRoute(builder: (context)=>MedicineInfoDisplay()));

        Navigator.of(context).push(
          PageRouteBuilder<void>(
              pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation){
                return AnimatedBuilder(
                  animation: animation,
                  builder:(context, Widget? child){
                    return Opacity(
                        opacity: animation.value,
                    child: MedicineInfoDisplay(medicine));
                  }
                );
              },
            transitionDuration: const Duration(milliseconds: 500),
          )
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: pinkColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              const SizedBox(height: 20,),
              makeIcon(),
              Hero(
                tag: medicine.medicineName!,
                child: Text(
                  medicine.medicineName!,
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: textCol,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                medicine.interval ==1? "Every${medicine.interval} hour":
                "Every ${medicine.interval} hour",
                overflow: TextOverflow.fade,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

