import 'dart:convert';

import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


class Data extends StatefulWidget {
  @override
  _DataState createState() => _DataState();
}

class _DataState extends State<Data> {
  DatabaseReference _dataref;


  @override
  void initState() {
    final FirebaseDatabase database = FirebaseDatabase.instance;
    _dataref = database.reference().child("data");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Tab(
          child: Text("Data from database"),
        ),
        _crearListado(context),
    ]);
  }

  Widget _crearListado(BuildContext context) {
    return Flexible(child: FirebaseAnimatedList(
        query: _dataref,
        itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
          var id = snapshot.value["end_device_ids"]["device_id"].toString();
          var humedad = snapshot.value["uplink_message"]["decoded_payload"]["humedad"].toString();
          var temperatura = snapshot.value["uplink_message"]["decoded_payload"]["temperatura"].toString();
          var fecha = snapshot.value["received_at"].toString();
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.blueGrey[50],
              borderRadius: BorderRadius.circular(5),
            ),
            child: ListTile(
              title: Text("ID: " + id,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Humedad: "+humedad +"\n"
                + "Temperatura: " + temperatura
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Fecha: " + fecha.split("T")[0]),
                  Text("Hora: " + fecha.split(".")[0].split("T")[1]),
                ],
              )
            ),
          );
        }
      ),
    );
  }
}
