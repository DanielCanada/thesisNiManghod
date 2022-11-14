import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pill_case_timer_app/models/containerModel.dart';
import 'package:pill_case_timer_app/pages/container_page/container_box.dart';

class ContainerPage extends StatefulWidget {
  final String docID;
  const ContainerPage({Key? key, required this.docID}) : super(key: key);

  @override
  State<ContainerPage> createState() => _ContainerPageState();
}

class _ContainerPageState extends State<ContainerPage> {
  // padding constants
  final double horizontalPadding = 40;
  final double verticalPadding = 25;
  bool showContainerMenu = false;

  // list of smart devices
  List medContainers = [
    // [ smartDeviceName, iconPath , powerStatus ]
    ["Med 01", "assets/tablet_02.json", true],
    ["Med 02", "assets/med_bottle_01.json", false],
    ["Med 03", "assets/med_logo.json", false],
    ["Med 04", "assets/pills01.json", false],
  ];

  // power button switched
  void powerSwitchChanged(bool value, int index) {
    setState(() {
      medContainers[index][2] = value;
    });
  }

  // create to firebase
  Future createContainers(int count) async {
    final docContainer = FirebaseFirestore.instance
        .collection("devices")
        .doc(widget.docID)
        .collection("containers")
        .doc();

    final newContainer = ContainerModel(
        containerNum: count + 1,
        containerID: docContainer.id,
        medCategory: '',
        medName: medContainers[count][0],
        isActive: medContainers[count][2]);

    final json = newContainer.toJson();

    await docContainer.set(json);
  }

  Widget deviceNotActivated() {
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    double newheight = height - padding.top - padding.bottom;
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: newheight / 4),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: GestureDetector(
                  onTap: () {
                    var collection =
                        FirebaseFirestore.instance.collection('users');
                    collection
                        .doc(widget
                            .docID) // <-- Doc ID where data should be updated.
                        .update({'deviceActivated': true}) // <-- Updated data
                        .then((_) => debugPrint('Device Activated'))
                        .catchError(
                            (error) => debugPrint('Activation failed: $error'));

                    // create containers upon activation
                    for (var i = 0; i < 4; i++) {
                      createContainers(i);
                    }

                    setState(() {
                      showContainerMenu = true;
                    });
                  },
                  child: Container(
                      width: 150.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                          color:
                              Colors.lightBlueAccent.shade200.withOpacity(0.5)),
                      child: Center(
                          child: Text(
                        "Activate Device",
                        style: GoogleFonts.bebasNeue(fontSize: 24),
                      ))),
                ))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            // welcome home
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   "Available Containers,",
                  //   style: TextStyle(fontSize: 20, color: Colors.grey.shade800),
                  // ),
                  Text(
                    'Device Containers',
                    style: GoogleFonts.bebasNeue(fontSize: 50),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 5),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Divider(
                thickness: 1,
                color: Color.fromARGB(255, 204, 204, 204),
              ),
            ),

            const SizedBox(height: 15),

            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.docID)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  showContainerMenu = snapshot.data!["deviceActivated"];
                  return // smart devices grid
                      Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Text(
                      "Medicines",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  );
                } else {
                  return const Center(child: Text("Loading..."));
                }
              },
            ),

            const SizedBox(height: 10),

            // grid
            showContainerMenu == true
                ? StreamBuilder<List<ContainerModel>>(
                    stream: FirebaseFirestore.instance
                        .collection('devices')
                        .doc(widget.docID)
                        .collection("containers")
                        .orderBy("containerNum", descending: false)
                        .snapshots()
                        .map((snapshot) => snapshot.docs
                            .map((doc) => ContainerModel.fromJson(doc.data()))
                            .toList()),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Container();
                      }
                      if (snapshot.hasData) {
                        List<ContainerModel> userContainers = snapshot.data!;
                        return Expanded(
                          child: GridView(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1 / 1.23,
                            ),
                            children: userContainers
                                .map((ContainerModel container) => ContainerBox(
                                      containerName: container.medName,
                                      iconPath: medContainers[
                                          container.containerNum - 1][1],
                                      powerOn: container.isActive,
                                      onChanged: (value) {
                                        setState(() {
                                          var collection = FirebaseFirestore
                                              .instance
                                              .collection('devices');
                                          collection
                                              .doc(widget.docID)
                                              .collection("containers")
                                              .doc(container.containerID)
                                              .update({
                                                'isActive': value
                                              }) // <-- Updated data
                                              .then((_) => debugPrint(
                                                  'Device Activated'))
                                              .catchError((error) => debugPrint(
                                                  'Activation failed: $error'));
                                        });
                                      },
                                    ))
                                .toList(),
                          ),
                        );
                      }

                      return Center(
                          child: Lottie.asset("assets/loading02.json"));
                    })
                : deviceNotActivated(),
          ],
        ),
      ),
    );
  }
}


// // grid
//             Expanded(
//               child: GridView.builder(
//                 itemCount: 4,
//                 physics: const NeverScrollableScrollPhysics(),
//                 padding: const EdgeInsets.symmetric(horizontal: 25),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   childAspectRatio: 1 / 1.23,
//                 ),
//                 itemBuilder: (context, index) {
//                   return ContainerBox(
//                     containerName: medContainers[index][0],
//                     iconPath: medContainers[index][1],
//                     powerOn: medContainers[index][2],
//                     onChanged: (value) => powerSwitchChanged(value, index),
//                   );
//                 },
//               ),
//             )