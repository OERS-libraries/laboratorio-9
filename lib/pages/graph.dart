import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_database/firebase_database.dart';

class Chart extends StatefulWidget {

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<Registro> _data;
  List<charts.Series<Registro,String>> _chardata;
  DatabaseReference _dataref;

  void _makeData(){
    _chardata.add(
      charts.Series(
        domainFn: (Registro registro,_) => registro.fecha + " "+ registro.hora,
        measureFn: (Registro registro,_) => registro.temperatura,
        id: 'Registros',
        data: _data,

      )
    );
  }

  @override
  void initState(){
    final FirebaseDatabase database = FirebaseDatabase.instance;
    _dataref = database.reference().child("data");
    _data = new List<Registro>();
    _chardata = new List<charts.Series<Registro, String>>();
    _makeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(context){
    return StreamBuilder<Event>(
        stream: _dataref.onValue,
        builder: (context,snapshot){
          print(snapshot.data);
          if(!snapshot.hasData){
            return LinearProgressIndicator();
          }else{
            List<Registro> registros = <Registro>[];
            Map data = snapshot.data.snapshot.value;
            for(Map childata in data.values){
              var fecha = childata["received_at"].toString();
              var temperatura = childata["uplink_message"]["decoded_payload"]["temperatura"].toString();
              var humedad = childata["uplink_message"]["decoded_payload"]["humedad"].toString();
              registros.add(Registro(fecha,temperatura,humedad
              ));
            }
            return _builChart(context,registros);
          }
        }
    );
  }

  Widget _builChart(BuildContext context, List<Registro> registros){
    _data = registros;
    _makeData();
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Text("Diagrama de barras de temperaturas"),
                SizedBox(height: 10.0),
                Expanded(
                    child: charts.BarChart(_chardata,
                    animate: true,
                    animationDuration: Duration(seconds: 1),
                      vertical: false,
                    ),
                )
              ],
            ),
          ),
        ),
    );
  }
}

class Registro{
  String fecha;
  String hora;
  double temperatura;
  double humedad;

  Registro(fecha,temperatura,humedad){
    print(humedad.runtimeType);

    this.fecha = fecha.split("T")[0];
    this.hora = fecha.split(".")[0].split("T")[1];
    this.temperatura = double.parse(temperatura);
    this.humedad = double.parse(humedad);
  }

  Registro.fromMap(Map<dynamic,dynamic> map)
    :assert(map["received_at"]!=null),
  assert(map["uplink_message"]["decoded_payload"]["humedad"]!=null),
  assert(map["uplink_message"]["decoded_payload"]["temperatura"]!=null),
    fecha = map["received_at"],
    temperatura = double.parse(map["uplink_message"]["decoded_payload"]["temperatura"]),
    humedad = double.parse(map["uplink_message"]["decoded_payload"]["humedad"]);
}


