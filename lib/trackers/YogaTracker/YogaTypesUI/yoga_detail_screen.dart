import 'package:flutter/material.dart';
import 'package:genesis_flutter/trackers/YogaTracker/YogaPoseDetection/Views/PoseDetectorView.dart';
import 'package:genesis_flutter/trackers/YogaTracker/YogaTypesUI/Model/yoga_item.dart';

class YogaDetailScreen extends StatefulWidget {
  final YogaItem yogaCard;

  const YogaDetailScreen({Key? key, required this.yogaCard}) : super(key: key);

  @override
  State<YogaDetailScreen> createState() => _YogaDetailScreenState();
}

class _YogaDetailScreenState extends State<YogaDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 14.0, top: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 225,
                  child: Text(
                    widget.yogaCard.yogaName,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.pink[100],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.yogaCard.trimName + " Months",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    widget.yogaCard.image,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),

                          Text(
                            widget.yogaCard.yogaDetail,
                            style: TextStyle(fontSize: 18),
                          ),

                          SizedBox(height: 10,),

                          Text(
                            "How to do ${widget.yogaCard.yogaName} ?",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.yogaCard.yogaSteps.length,
                              itemBuilder: (context, index) {
                                return Text(
                                  '${index + 1}. ${widget.yogaCard
                                      .yogaSteps[index]}',
                                  style: TextStyle(fontSize: 14),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 20,),

                          Text(
                            "Benefits of ${widget.yogaCard.yogaName} ?",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.yogaCard.benefits.length,
                              itemBuilder: (context, index) {
                                return Text(
                                  '${index + 1}. ${widget.yogaCard
                                      .benefits[index]}',
                                  style: TextStyle(fontSize: 14),
                                );
                              },
                            ),
                          ),

                          SizedBox(height: 100),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: InkResponse(
        child: PoseDetectCamera('Pose Detection', PoseDetectorView()),
      ),
    );
  }
}



class PoseDetectCamera extends StatelessWidget {
  final String _label;
  final Widget _viewPage;
  final bool featureCompleted;

  const PoseDetectCamera(this._label, this._viewPage,
      {this.featureCompleted = true});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!featureCompleted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
              const Text('This feature has not been implemented yet')));
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => _viewPage));
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          elevation: 3,
          margin: EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              color:
                  Colors.pink[100], // Set the background color of the container
              borderRadius: BorderRadius.circular(10.0), // Set the radius
            ),
            height: 80,
            width: 80,
            child: Center(
              child: Icon(
                Icons.camera,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}



