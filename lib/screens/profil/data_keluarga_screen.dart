import 'package:flutter/material.dart';

class DataKeluargaScreen extends StatefulWidget {
  const DataKeluargaScreen({Key? key}) : super(key: key);

  @override
  _DataKeluargaScreenState createState() => _DataKeluargaScreenState();
}

class _DataKeluargaScreenState extends State<DataKeluargaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Data Keluarga")),
      body: Center(child: Text("Anjay Emng kau punya keluarga")),
    );
  }
}
