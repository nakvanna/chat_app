import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class CustomData extends StatefulWidget {
  CustomData({this.app});
  final FirebaseApp app;
  @override
  _CustomDataState createState() => _CustomDataState();
}

class _CustomDataState extends State<CustomData> {
  final referenceData = FirebaseDatabase.instance;
  final movieName = 'Movie Title';
  final movieNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ref = referenceData.reference();
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies that I loved'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                color: Colors.greenAccent,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Text(
                      movieName,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: movieNameController,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5,),
                    RaisedButton(
                      onPressed: (){
                        ref.child('movies')
                            .push()
                            .child(movieName)
                            .set(movieNameController.text)
                            .asStream();
                        movieNameController.text = '';
                        },
                      color: Colors.blue,
                      child: Text(
                        'Save',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
