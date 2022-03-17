import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notes/localnotification.dart';
import 'package:notes/notification.dart';
import 'package:notes/secondpage.dart';

//
Future<void> main() async {
  await init();

  runApp(const MyApp());
}

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Notifi(),
    );
  }
}

class Notifi extends StatefulWidget {
  const Notifi({Key? key}) : super(key: key);

  @override
  State<Notifi> createState() => _NotifiState();
}

class _NotifiState extends State<Notifi> {
  String t = "no title";
  String b = "no body";
  String d = "no data";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LocalN.init();
    final notification = FCM();
    notification.setNotification();
    notification.stremctrl.stream.listen(_changedata);
    notification.titlectrl.stream.listen(_changetitle);
    notification.bodyctrl.stream.listen(_changebody);
  }

  _changedata(String msg) => setState(() => d = msg);
  _changetitle(String msg) => setState(() => t = msg);
  _changebody(String msg) => setState(() => b = msg);

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Title= ${t}"),
            Text("body= ${b}"),
            Text("data= ${d}"),
            MaterialButton(
              onPressed: () {
                LocalN.showNotification(title: "t", body: "b", payload: "bbb");
                Navigator.push(
                    context, MaterialPageRoute(builder: (contex) => spage()));
              },
              child: Text("goto"),
            )
          ],
        ),
      ),
    );
  }
}

// class MyHome extends StatefulWidget {
//   const MyHome({Key? key}) : super(key: key);

//   @override
//   _MyHomeState createState() => _MyHomeState();
// }

// class _MyHomeState extends State<MyHome> {
//   List<Map<String, dynamic>> a = [];
//   TextEditingController name = TextEditingController();
//   TextEditingController email = TextEditingController();
//   String _selected = "All";

//   List<String> filter = ["All", "bhumit", "vivek", "vasu", "savan"];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF292D32),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           addAndUpdate();
//         },
//         child: Icon(Icons.add),
//       ),
//       appBar: AppBar(
//         actions: [
//           PopupMenuButton(
//             initialValue: _selected,
//             onSelected: (String value) {
//               setState(() {
//                 _selected = value;
//               });
//             },
//             itemBuilder: (context) {
//               return filter.map((e) {
//                 return PopupMenuItem(
//                   child: Text(e),
//                   value: e,
//                 );
//               }).toList();
//             },
//           )
//         ],
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
//         backgroundColor: Color(0xFF292D32),
//         shadowColor: Colors.black.withOpacity(0.5),
//         elevation: 20,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//             stream: FirebaseFirestore.instance.collection('notes').snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 final dataList = _selected == "All"
//                     ? snapshot.data!.docs
//                     : snapshot.data!.docs
//                         .where((element) => element["name"] == _selected)
//                         .toList();
//                 final length = dataList.length;
//                 if (length == 0) {
//                   return Center(
//                     child: Text("There is no data"),
//                   );
//                 } else {
//                   return ListView.builder(
//                       clipBehavior: Clip.none,
//                       itemCount: length,
//                       itemBuilder: (context, index) {
//                         final res = dataList[index];

//                         return Container(
//                           margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
//                           decoration: BoxDecoration(
//                             // gradient: LinearGradient(
//                             //     colors: [
//                             //       Color(0xFF292D32),
//                             //       Color.fromARGB(255, 38, 43, 48),
//                             //     ],
//                             //     transform: GradientRotation(-0.1),
//                             //     // tileMode: TileMode.repeated,
//                             //     begin: Alignment.topCenter,
//                             //     end: Alignment.bottomCenter,
//                             //     stops: [0.4, 1.0]),
//                             borderRadius: BorderRadius.circular(13),
//                             color: Color(0xFF292D32),
//                             boxShadow: [
//                               BoxShadow(
//                                   color: Colors.white.withOpacity(0.1),
//                                   offset: Offset(-5.0, -10.0),
//                                   blurRadius: 15.0,
//                                   spreadRadius: -2),
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.5),
//                                 offset: Offset(6.0, 9.0),
//                                 blurRadius: 10.0,
//                               ),
//                             ],
//                           ),
//                           child: ListTile(
//                             tileColor: Colors.transparent,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10)),
//                             style: ListTileStyle.list,
//                             // dense: true,
//                             title: Text(
//                               res["name"],
//                               style: TextStyle(
//                                   color: Colors.white.withOpacity(0.9),
//                                   letterSpacing: 1.5,
//                                   shadows: [
//                                     Shadow(
//                                       color: Colors.white.withOpacity(0.2),
//                                       blurRadius: 7,
//                                     )
//                                   ]),
//                             ),
//                             subtitle: Text(
//                               res["email"],
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                   color: Colors.white.withOpacity(0.4),
//                                   letterSpacing: 1.5,
//                                   shadows: [
//                                     Shadow(
//                                       color: Colors.white.withOpacity(0.2),
//                                       blurRadius: 7,
//                                     )
//                                   ]),
//                             ),
//                             trailing: Container(
//                               height: 70,
//                               width: 100,
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   IconButton(
//                                     onPressed: () {
//                                       name.text = res["name"];
//                                       email.text = res["email"];
//                                       addAndUpdate(id: res["id"]);
//                                     },
//                                     icon: Icon(
//                                       Icons.edit_note,
//                                       color: Colors.white.withOpacity(0.35),
//                                     ),
//                                   ),
//                                   IconButton(
//                                     onPressed: () {
//                                       FirebaseFirestore.instance
//                                           .collection("notes")
//                                           .doc(res["id"])
//                                           .delete();
//                                     },
//                                     icon: Icon(
//                                       Icons.delete,
//                                       color: Colors.white.withOpacity(0.35),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       });
//                 }
//               } else {
//                 return CircularProgressIndicator();
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   void addAndUpdate({String? id}) {
//     showDialog(
//         context: context,
//         builder: (contex) {
//           return Dialog(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//             backgroundColor: Color(0xFF292D32),
//             child: Container(
//               height: 300,
//               padding: EdgeInsets.all(10),
//               child: Form(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     TextField(
//                       controller: name,
//                       decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(20))),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     TextFormField(
//                       validator: (value) {
//                         String pattern =
//                             r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
//                             r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
//                             r"{0,253}[a-zA-Z0-9])?)*$";
//                         RegExp regex = RegExp(pattern);
//                         if (value == null ||
//                             value.isEmpty ||
//                             !regex.hasMatch(value))
//                           return 'Enter a valid email address';
//                         else
//                           return null;
//                       },
//                       controller: email,
//                       decoration: InputDecoration(border: OutlineInputBorder()),
//                     ),
//                     SizedBox(
//                       height: 50,
//                     ),
//                     MaterialButton(
//                       onPressed: () {
//                         if (id == null) {
//                           setState(() {
//                             final data = {
//                               "name": name.text,
//                               "email": email.text
//                             };
//                             DocumentReference doc = FirebaseFirestore.instance
//                                 .collection('notes')
//                                 .doc();
//                             doc.set({
//                               "name": name.text,
//                               "email": email.text,
//                               "id": doc.id
//                             });
//                           });
//                           email.clear();
//                           name.clear();
//                           Navigator.pop(contex);
//                         } else {
//                           DocumentReference doc = FirebaseFirestore.instance
//                               .collection('notes')
//                               .doc(id);
//                           doc.update({
//                             "name": name.text,
//                             "email": email.text,
//                             "id": doc.id
//                           }).then((value) => Navigator.pop(context));
//                         }
//                       },
//                       child: Text("Save"),
//                       color: Colors.blue,
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           );
//         });
//   }
// }
