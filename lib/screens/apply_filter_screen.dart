import 'package:ev_spot_flutter/utils/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ev_spot_flutter/main.dart';


class ApplyFilterScreen extends StatefulWidget {
  const ApplyFilterScreen({Key? key}) : super(key: key);

  @override
  State<ApplyFilterScreen> createState() => _ApplyFilterScreenState();
}

class _ApplyFilterScreenState extends State<ApplyFilterScreen> {
  late List<AmenitiesCB> amenitiesCB;
  late Map<String, bool> selectedAmenities;
  late List<ConnectionType> connectionItem;
  late Map<String, bool> selectedConnections;
  late List<SpeedCB> speedCB;
  late Map<String, bool> selectedSpeeds;

  @override
  void initState() {
    super.initState();

    amenitiesCB = [
      AmenitiesCB(amenitiesCBTitle: 'Washroom', amenityKey: 'washroom'),
      AmenitiesCB(amenitiesCBTitle: 'Foods', amenityKey: 'foods'),
      AmenitiesCB(amenitiesCBTitle: 'Shopping', amenityKey: 'shopping'),
      AmenitiesCB(amenitiesCBTitle: 'Pharmacy', amenityKey: 'pharmacy'),
      AmenitiesCB(amenitiesCBTitle: 'Wifi', amenityKey: 'wifi'),
    ];
    selectedAmenities = {};

    connectionItem = [
      ConnectionType(connectionItemTitle: 'J-1772'),
      ConnectionType(connectionItemTitle: 'Tesla'),
      ConnectionType(connectionItemTitle: 'Mennekes'),
      ConnectionType(connectionItemTitle: 'CCS2'),
      ConnectionType(connectionItemTitle: 'Chandemo'),
      ConnectionType(connectionItemTitle: 'CCS2 2'),
    ];
    selectedConnections = {};

    speedCB = [
      SpeedCB(speedCBTitle: 'Standard (3.7 kw)'),
      SpeedCB(speedCBTitle: 'Semi fast (3.7 - 20 kw)'),
      SpeedCB(speedCBTitle: 'Fast (20 - 43 kw)'),
      SpeedCB(speedCBTitle: 'Ultra Fast ( > 43 kw )'),
    ];
    selectedSpeeds = {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Filters', style: TextStyle(fontSize: 18)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextButton(
              onPressed: () {
                applyFilters();
              },
              child: Text('APPLY', style: TextStyle(color: Colors.blue, fontSize: 18)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Amenities', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 25,
                children: List.generate(amenitiesCB.length, (index) {
                  AmenitiesCB amenitiesData = amenitiesCB[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        amenitiesData.isAmenitiesChecked = !amenitiesData.isAmenitiesChecked;
                        selectedAmenities[amenitiesData.amenityKey!] = amenitiesData.isAmenitiesChecked;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 4 - 20,
                      child: Column(
                        children: [
                          Image.asset('assets/icons/${amenitiesData.amenitiesCBTitle!.toLowerCase()}.png', height: 40, width: 40),
                          SizedBox(height: 6),
                          Text(
                            "${amenitiesData.amenitiesCBTitle}",
                            style: TextStyle(
                              fontSize: 14,
                              color: amenitiesData.isAmenitiesChecked ? Colors.blue : Colors.black,
                              fontWeight: amenitiesData.isAmenitiesChecked ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 32),
              Text('Connection Types', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 25,
                children: List.generate(connectionItem.length, (index) {
                  ConnectionType connectionData = connectionItem[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        connectionData.isConnectionTypeChecked = !connectionData.isConnectionTypeChecked;
                        selectedConnections[connectionData.connectionItemTitle!] = connectionData.isConnectionTypeChecked;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 4 - 20,
                      child: Column(
                        children: [
                          Image.asset(connectionTypeImg[index], height: 70, width: 100, fit: BoxFit.cover),
                          SizedBox(height: 6),
                          Text(
                            "${connectionData.connectionItemTitle}",
                            style: TextStyle(
                              fontSize: 14,
                              color: connectionData.isConnectionTypeChecked ? Colors.blue : Colors.black,
                              fontWeight: connectionData.isConnectionTypeChecked ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 32),
              Text('Charging Speeds', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 25,
                children: List.generate(speedCB.length, (index) {
                  SpeedCB speedData = speedCB[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        speedData.isSpeedChecked = !speedData.isSpeedChecked;
                        selectedSpeeds[speedData.speedCBTitle!] = speedData.isSpeedChecked;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 4 - 20,
                      child: Column(
                        children: [
                           Image.asset(
                                      icons[index],
                                      height: 40,
                                      width: 40,
                                      fit: BoxFit.contain,
                                      color: appStore.isDarkMode ? Colors.white : Colors.black,
                                    ),
                          SizedBox(height: 6),
                          Text(
                            "${speedData.speedCBTitle}",
                            style: TextStyle(
                              fontSize: 14,
                              color: speedData.isSpeedChecked ? Colors.blue : Colors.black,
                              fontWeight: speedData.isSpeedChecked ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void applyFilters() async {
    // Perform database operation with Supabase
    final responseAmenities = await supabase.from('amenities').upsert([
      selectedAmenities
    ]);

    final responseConnections = await supabase.from('connectiontypes').upsert([
      selectedConnections
    ]);

    final responseSpeeds = await supabase.from('chargingspeed').upsert([
      selectedSpeeds
    ]);

    if (newMethod(responseAmenities) == null && newMethod(responseConnections) == null && newMethod(responseSpeeds) == null) {
      Fluttertoast.showToast(
        msg: 'Filters applied successfully',
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 16,
        backgroundColor: Colors.black,
      );
    } else {
      // Handle error
      print('Error applying filters: ${responseAmenities.error}, ${responseConnections.error}, ${responseSpeeds.error}');
      Fluttertoast.showToast(
        msg: 'Error applying filters',
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 16,
        backgroundColor: Colors.black,
      );
    }
  }

  newMethod(response) {}
}

class AmenitiesCB {
  String? amenitiesCBTitle;
  String? amenityKey;
  bool isAmenitiesChecked = false;

  AmenitiesCB({required this.amenitiesCBTitle, required this.amenityKey});
}

class ConnectionType {
  String? connectionItemTitle;
  bool isConnectionTypeChecked = false;

  ConnectionType({required this.connectionItemTitle});
}

class SpeedCB {
  String? speedCBTitle;
  bool isSpeedChecked = false;

  SpeedCB({required this.speedCBTitle});
}
