import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:shalat_app/constant.dart';
import 'package:shalat_app/fetch.dart';
import 'package:shalat_app/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<bool> muteStatus = [];
  String selectedCityId = "";
  String selectedCityName = "";
  List<Map<String, String>> cityOptions = [];

  @override
  void initState() {
    super.initState();
    fetchApiData();
    loadSelectedCity();
  }

  Future<void> loadSelectedCity() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCityId = prefs.getString('saveCityId') ?? '';
    final savedCityName = prefs.getString('saveCityName') ?? '';
    setState(() {
      selectedCityId = savedCityId;
      selectedCityName = savedCityName;
    });
  }

  Future<void> saveSelectedCity(String cityId, String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saveCityId', cityId);
    await prefs.setString('saveCityName', cityName);
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
                padding: EdgeInsets.all(20),
                child: DropdownSearch<String>(
                  popupProps: PopupProps.menu(
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.search),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                      style: TextStyle(fontSize: 15),
                      padding: EdgeInsets.all(10)
                    ),
                    itemBuilder: (context, String select, bool isSelected){
                      return Container(
                        margin: EdgeInsets.only(left: 10),
                        padding: EdgeInsets.all(5),
                          child: Text(select, style: TextStyle(fontSize: 15),));
                  },
                    showSearchBox: true,
                    showSelectedItems: true,
                    menuProps: MenuProps(
                      borderRadius: BorderRadius.circular(10),
                      elevation: 0,
                      backgroundColor: Colors.white,
                    )
                  ),
                  items: cityOptions.map<String>((Map<String, String> option) {
                    return option['lokasi']!;
                  }).toList(),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    baseStyle: TextStyle(fontSize: 15),
                    textAlignVertical: TextAlignVertical.center,
                    dropdownSearchDecoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  onChanged: (selectedValue) {
                    final selectedOption = cityOptions.firstWhere(
                          (option) => option['lokasi'] == selectedValue,
                      orElse: () => Map<String, String>(),
                    );
                    setState(() {
                      selectedCityId = selectedOption['id']!;
                      selectedCityName = selectedOption['lokasi']!;
                    });
                    saveSelectedCity(selectedCityId, selectedCityName);
                  },
                  selectedItem: selectedCityName == '' ? 'Pilih Lokasi' : selectedCityName,
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                  width: constantWidth,
                  height: constantHeight * 0.75,
                  child: selectedCityId != '' ? FutureBuilder(
                      future: Future.wait([getShalatData(selectedCityId)]),
                    builder: (context, snapshot) {
                        if(snapshot.hasData){
                          ShalatModel data = snapshot.data![0];
                          List <String> shalat = [
                            'Imsak',
                            'Fajar',
                            'Sunrise',
                            'Dhuha',
                            'Dhuhr',
                            'Asar',
                            'Maghrib',
                            'Isha',
                          ];
                          return ListView.builder(
                              itemCount: shalat.length,
                              itemBuilder: (BuildContext context, int index){
                                final fieldName = shalat[index];
                                String fieldValue = '';
                                switch (fieldName) {
                                  case 'Imsak':
                                    fieldValue = data.jadwal.imsak;
                                    break;
                                  case 'Fajar':
                                    fieldValue = data.jadwal.subuh;
                                    break;
                                  case 'Sunrise':
                                    fieldValue = data.jadwal.terbit;
                                    break;
                                  case 'Dhuha':
                                    fieldValue = data.jadwal.dhuha;
                                    break;
                                  case 'Dhuhr':
                                    fieldValue = data.jadwal.dzuhur;
                                    break;
                                  case 'Asar':
                                    fieldValue = data.jadwal.ashar;
                                    break;
                                  case 'Maghrib':
                                    fieldValue = data.jadwal.maghrib;
                                    break;
                                  case 'Isha':
                                    fieldValue = data.jadwal.isya;
                                    break;
                                  default:
                                    fieldValue = 'Unknown';
                                    break;
                                }

                                if (muteStatus.isEmpty) {
                                  muteStatus = List.generate(shalat.length, (index) => false);
                                }
                            return Card(
                              color: Colors.amberAccent,
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
                                            muteStatus[index] = !muteStatus[index];
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
