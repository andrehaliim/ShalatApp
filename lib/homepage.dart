import 'package:flutter/material.dart';
import 'package:shalat_app/constant.dart';
import 'package:shalat_app/fetch.dart';
import 'package:shalat_app/model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<bool> muteStatus = [];
  @override
  Widget build(BuildContext context) {
    setConstantSize(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Shalat',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
              width: constantWidth,
              height: constantHeight * 0.9,
              child: FutureBuilder(
                  future: Future.wait([getShalatData()]),
                builder: (context, snapshot) {
                    if(snapshot.hasData){
                      ShalatModel data = snapshot.data![0];
                      List <String> shalat = [
                        'tanggal',
                        'imsak',
                        'subuh',
                        'terbit',
                        'dhuha',
                        'dzuhur',
                        'ashar',
                        'maghrib',
                        'isya',
                        'date',
                      ];
                      return ListView.builder(
                          itemCount: shalat.length,
                          itemBuilder: (BuildContext context, int index){
                            final fieldName = shalat[index];
                            String fieldValue = '';

                            switch (fieldName) {
                              case 'tanggal':
                                fieldValue = data.jadwal.tanggal;
                                break;
                              case 'imsak':
                                fieldValue = data.jadwal.imsak;
                                break;
                              case 'subuh':
                                fieldValue = data.jadwal.subuh;
                                break;
                              case 'terbit':
                                fieldValue = data.jadwal.terbit;
                                break;
                              case 'dhuha':
                                fieldValue = data.jadwal.dhuha;
                                break;
                              case 'dzuhur':
                                fieldValue = data.jadwal.dzuhur;
                                break;
                              case 'ashar':
                                fieldValue = data.jadwal.ashar;
                                break;
                              case 'maghrib':
                                fieldValue = data.jadwal.maghrib;
                                break;
                              case 'isya':
                                fieldValue = data.jadwal.isya;
                                break;
                              case 'date':
                                fieldValue = data.jadwal.date;
                                break;
                              default:
                                fieldValue = 'Unknown';
                                break;
                            }

                            if (muteStatus.isEmpty) {
                              muteStatus = List.generate(shalat.length, (index) => false);
                            }
                        return Card(
                          color: Colors.white,
                          shadowColor: Colors.black,
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Text(
                                  shalat[index],
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                                Spacer(),
                                Text(
                                  fieldValue,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                IconButton(
                                    onPressed: (){
                                      setState(() {
                                        muteStatus[index] = true;
                                      });
                                    },
                                    icon: Icon(
                                      muteStatus[index] == true ? Icons.volume_off : Icons.volume_up,
                                      color: Colors.black,
                                    ))
                              ],
                            ),
                          ),
                        );
                      });
                    }
                    else if (snapshot.hasError) {
                      return const Center(
                        child: Text('Failed to load data from API'),
                      );
                    } else {
                      return Center(
                          child: CircularProgressIndicator(
                          ));
                    }
                }
              ))),
      backgroundColor: Colors.grey[300],
    );
  }
}
