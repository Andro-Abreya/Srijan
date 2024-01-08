import 'package:flutter/material.dart';

class YogaItem {
  int id;
  final String image, yogaName;
  final String yogaDetail;
  final List<String> yogaSteps;
  final List<String> benefits;
  String trimName;


  YogaItem({
    required this.id,
    required this.image,
    required this.yogaName,
    required this.yogaDetail,
    required this.yogaSteps,
    required this.benefits,
    required this.trimName
  });


}



List<YogaItem> yoga_item = [
  YogaItem(
    id:1,
    image: "assets/images/marjariasana.png" ,
    yogaName: "Marjariasana ",
    yogaDetail: " Marjariasana stretches the neck and shoulders, alleviating stiffness. "
        "Keeps the spine flexible. Helps to overall tone up the structures in the female reproductive system"
    "increase neck and shoulder flexibility.",
    yogaSteps:["Get on all fours, like a cat. Shoulder over wrists and hips over knees, with your weight evenly distributed along with your hands and knees.",
                "Start with a neutral spine. Focus on a point in front of you.",
                "Inhale and expand the belly toward the floor. Raise your chin and tilt your head backward toward the spine.",
                "Point the tailbone up as you stretch like a cat.",
                "Then exhale and pull the belly button in, towards the spine. The chin should rest on the chest and direct your vision toward the nose.",
                "Complete as many rounds as you’d like, working toward a fluid movement that stretches and relaxes your spine."
              ],
    benefits:["help to overall tone up the structures in the female reproductive system",
              "increase neck and shoulder flexibility.",
              " reduce headaches as it may increase blood flow to the head.",
              " increase digestive functions, thereby reducing physiological stimuli and bringing about relaxation",
              " reduce obesity in women. "
    ],
    trimName: "1-3",
  ),
  YogaItem(
    id: 2,
    image: "assets/images/trikonasana.png" ,
    yogaName: "Trikonasana",
    yogaDetail: "The trikona-asana is an excellent posture to do early in your routine. "
        "The muscles of the thighs and calves as well as the hamstrings  are stretched. ",

      yogaSteps:["Stand straight with your legs apart. The distance between your legs should be a little more than the span of your shoulders.",
        "Inhale. Raise your right hand straight above your head. The right arm should be parallel to the right ear. ",
        "Exhale. Bend your torso at the waist, to your left side.",
        "Simultaneously, slide your left arm down along your left leg till your fingers are at your ankle.",
        "Hold the pose with your knees and elbows straight. Hold the position for 30 seconds.",
        "Inhale. Straighten yourself and stand erect. Repeat the posture on the other side."
      ],
    benefits: ["Strengthens the back and spine",
              "Opens the chest/shoulders",
              "Stretches the hips/hamstrings/pelvic area",
              "Improves digestion/prevents constipation",
              "Tones pelvic floor/encourages deep breathing"
    ],
    trimName: "1-3"

  ),
  YogaItem(
    id: 3,
    image: "assets/images/badhakasan.png" ,
    yogaName: "Badhakonasana",
    yogaDetail: "The posture is named “Badhakonasana” because of the way "
        "it is carried out – both the feet tucked close to the groin, "
        "clasped tightly with the hands as though tied or bound together"
        " in a particular angle.",

      yogaSteps:["Get on all fours, like a cat. Shoulder over wrists and hips over knees, with your weight evenly distributed along with your hands and knees.",
        "Start with a neutral spine. Focus on a point in front of you.",
        "Inhale and expand the belly toward the floor. Raise your chin and tilt your head backward toward the spine.",
        "Point the tailbone up as you stretch like a cat.",
        "Then exhale and pull the belly button in, towards the spine. The chin should rest on the chest and direct your vision toward the nose.",
        "Complete as many rounds as you’d like, working toward a fluid movement that stretches and relaxes your spine."
      ],
      benefits: ["Strengthens the back and spine",
        "Opens the chest/shoulders",
        "Stretches the hips/hamstrings/pelvic area",
        "Improves digestion/prevents constipation",
        "Tones pelvic floor/encourages deep breathing"
      ],
    trimName: "1-8"

  ),
  YogaItem(
    id: 4,
    image: "assets/images/savasana.png" ,
    yogaName: "Shavasana",
    yogaDetail: "Relaxes the body and repairs cells. This helps self-healing which is vital, as pregnant women should avoid taking pills."
      "Relieves stress.",

      yogaSteps:["Get on all fours, like a cat. Shoulder over wrists and hips over knees, with your weight evenly distributed along with your hands and knees.",
        "Start with a neutral spine. Focus on a point in front of you.",
        "Inhale and expand the belly toward the floor. Raise your chin and tilt your head backward toward the spine.",
        "Point the tailbone up as you stretch like a cat.",
        "Then exhale and pull the belly button in, towards the spine. The chin should rest on the chest and direct your vision toward the nose.",
        "Complete as many rounds as you’d like, working toward a fluid movement that stretches and relaxes your spine."
      ],
      benefits: ["Strengthens the back and spine",
        "Opens the chest/shoulders",
        "Stretches the hips/hamstrings/pelvic area",
        "Improves digestion/prevents constipation",
        "Tones pelvic floor/encourages deep breathing"
      ],
    trimName: "1-7"

  ),
  YogaItem(
    id: 5,
    image: "assets/images/yoganidra.png" ,
    yogaName: "Yoga Nidra",
    yogaDetail: "Nidra or sleep is one of the four major sources "
        "of energy which include food, sleep, breath and meditation. "
        "Sleep revitalizes our whole body and refreshes our mind.",

      yogaSteps:["Get on all fours, like a cat. Shoulder over wrists and hips over knees, with your weight evenly distributed along with your hands and knees.",
        "Start with a neutral spine. Focus on a point in front of you.",
        "Inhale and expand the belly toward the floor. Raise your chin and tilt your head backward toward the spine.",
        "Point the tailbone up as you stretch like a cat.",
        "Then exhale and pull the belly button in, towards the spine. The chin should rest on the chest and direct your vision toward the nose.",
        "Complete as many rounds as you’d like, working toward a fluid movement that stretches and relaxes your spine."
      ],
      benefits: ["Strengthens the back and spine",
        "Opens the chest/shoulders",
        "Stretches the hips/hamstrings/pelvic area",
        "Improves digestion/prevents constipation",
        "Tones pelvic floor/encourages deep breathing"
      ],
    trimName:"1-8"
  ),
  YogaItem(
    id: 6,
    image: "assets/images/nadi.png" ,
    yogaName: "Nadi Shodhan Pyanayama",
    yogaDetail: "After practicing these yoga moves "
        "and pranayamas, follow up with a session of meditation. "
        "It will help you relax deeply. Calms and relaxes the mind.",

      yogaSteps:["Get on all fours, like a cat. Shoulder over wrists and hips over knees, with your weight evenly distributed along with your hands and knees.",
        "Start with a neutral spine. Focus on a point in front of you.",
        "Inhale and expand the belly toward the floor. Raise your chin and tilt your head backward toward the spine.",
        "Point the tailbone up as you stretch like a cat.",
        "Then exhale and pull the belly button in, towards the spine. The chin should rest on the chest and direct your vision toward the nose.",
        "Complete as many rounds as you’d like, working toward a fluid movement that stretches and relaxes your spine."
      ],
      benefits: ["Strengthens the back and spine",
        "Opens the chest/shoulders",
        "Stretches the hips/hamstrings/pelvic area",
        "Improves digestion/prevents constipation",
        "Tones pelvic floor/encourages deep breathing"
      ],
    trimName: "1-8"
  ),

];

