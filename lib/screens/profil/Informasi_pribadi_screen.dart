import 'package:flutter/material.dart';

class InformasiPribadiScreen extends StatefulWidget {
  const InformasiPribadiScreen({Key? key}) : super(key: key);

  @override
  _InformasiPribadiScreenState createState() => _InformasiPribadiScreenState();
}

class _InformasiPribadiScreenState extends State<InformasiPribadiScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Informasi Pribadi")),
      body: Center(child: Text("Selamat Datang Mbak Mas")),
    );
  }
}
