import 'package:flutter/material.dart';
import 'package:genesis_flutter/color.dart';
import 'package:genesis_flutter/trackers/YogaTracker/YogaTypesUI/Model/yoga_item.dart';
import 'package:genesis_flutter/trackers/YogaTracker/YogaTypesUI/yoga_detail_screen.dart';


class YogaTypes extends StatefulWidget {
  const YogaTypes({Key? key}) : super(key: key);

  @override
  State<YogaTypes> createState() => _YogaTypesState();
}

 class _YogaTypesState extends State<YogaTypes> {


   void initState() {
     super.initState();
     showDisclaimerDialog();
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yoga Types'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
       const Padding(
         padding: const EdgeInsets.all(8.0),
         child:  Text(
                'Do Yoga for \nHarmonious Pregnancy',
                style:TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                )
            ),
       ),
          SizedBox(height: 10),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: ListView.builder(
                itemCount: yoga_item.length,
                itemBuilder: (context, index) {
                  return YogaCardWidget(yogaCard: yoga_item[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }


   void showDisclaimerDialog()async {
     await Future.delayed(Duration.zero);
     showDialog(
       context: context,
       builder: (BuildContext context) {
         return AlertDialog(
           title: Text('Disclaimer'),
           content: SingleChildScrollView(
             child: Text(
               "Always prioritize comfort and listen to the body's signals during any yoga practice."
                   "It's advisable to consult with a healthcare provider or a qualified prenatal "
                   "yoga instructor to ensure it's safe for their specific health condition. ",
             ),
           ),
           actions: <Widget>[
             TextButton(
               onPressed: () {
                 Navigator.of(context).pop(); // Close the dialog
               },
               child: Text('I Understand'),
             ),
           ],
         );
       },
     );
   }

}



class YogaCardWidget extends StatelessWidget {
  final YogaItem yogaCard;

  const YogaCardWidget({Key? key, required this.yogaCard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => YogaDetailScreen(yogaCard: yogaCard),
          ),
        );

      },
      child: Card(
        elevation: 3,
        margin: EdgeInsets.all(10),
          child: Container(

            decoration: BoxDecoration(
                color: Colors.pink[100], // Set the background color of the container
              borderRadius: BorderRadius.circular(10.0), // Set the radius
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                    child: Image.asset(
                      yogaCard.image,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        yogaCard.yogaName,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        yogaCard.yogaDetail,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

      ),
    );
  }
}

