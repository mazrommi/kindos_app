import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Catatan Kinerja Harian Dosen', style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold), ),
        centerTitle: true,
      ),
      body:Center(
        child: Text('Belum ada catatan kinerja ya',style: TextStyle(fontSize: 22),),
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            //arahkan ke halaman tambah catatan
            },
            child: Icon(Icons.add),
    ),
    );
}
}
