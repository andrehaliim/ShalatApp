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
  String selectedValue = "";
  String displayCity = "";
  List<Map<String, String>> cityOptions = [];

  @override
  void initState() {
    super.initState();
    fetchApiData(); // Call the function from api_service.dart
  }

  Future<void> fetchApiData() async {
    final fetchedOptions = await getCityList();

    setState(() {
      cityOptions = fetchedOptions;
    });
  }

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
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                width: constantWidth,
                height: constantHeight * 0.15,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Shadow color
                      spreadRadius: 2, // Spread radius of the shadow
                      blurRadius: 4,   // Blur radius of the shadow
                      offset: Offset(0, 2), // Offset of the shadow
                    ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: false,
                    child: DropdownButton<String>(
                      iconSize: 30,
                      icon: (null),
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                      hint: displayCity == '' ? Text('select') : Text(displayCity),
                      onChanged: (newValue) {
                        final selectedOption =  cityOptions.firstWhere((option) => option['id'] == newValue);
                        setState(() {
                          selectedValue = newValue!;
                          displayCity = selectedOption['lokasi']!;
                        });
                      },
                      items: cityOptions.map<DropdownMenuItem<String>>((Map<String, String> option) {
                        return DropdownMenuItem<String>(
                          value: option['id']!,
                          child: Text(option['lokasi']!),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                  width: constantWidth,
                  height: constantHeight * 0.75,
                  child: selectedValue != '' ? FutureBuilder(
                      future: Future.wait([getShalatData(selectedValue)]),
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
                              color: Colors.green,
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
                  ) : Center(child: CircularProgressIndicator(),)) ,
            ],
          )),
      backgroundColor: Colors.grey[300],
    );
  }
}
