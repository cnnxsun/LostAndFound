import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    show
        CameraPosition,
        GoogleMap,
        GoogleMapController,
        InfoWindow,
        LatLng,
        Marker,
        MarkerId;
import 'package:location/location.dart';
import 'homepage.dart';
import 'package:project1/chat.dart';
import 'package:project1/profile.dart';
import 'package:project1/dot_navigation_bar.dart';

enum _SelectedTab { Home, AddPost, Chat, Profile } // Nav bar

Future<bool> requestLocationPermission() async {
  Location location = Location();
  PermissionStatus permissionStatus = await location.hasPermission();
  if (permissionStatus == PermissionStatus.denied) {
    permissionStatus = await location.requestPermission();
  }
  return permissionStatus == PermissionStatus.granted;
}

Future<LocationData?> getCurrentLocation() async {
  Location location = Location();
  bool hasPermission = await requestLocationPermission();
  if (hasPermission) {
    return await location.getLocation();
  } else {
    return null;
  }
}

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({Key? key}) : super(key: key);

  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  var _selectedTab = _SelectedTab.AddPost; // Nav bar
  void _handleIndexChanged(int i) {
    // Nav bar
    setState(() {
      _selectedTab = _SelectedTab.values[i];
      if (_selectedTab == _SelectedTab.Home) {
        // Navigate to Profile
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else if (_selectedTab == _SelectedTab.Profile) {
        // Navigate to Profile
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FormPage()),
        );
      } else if (_selectedTab == _SelectedTab.Chat) {
        // Navigate to Profile
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Chat()),
        );
      } else if (_selectedTab == _SelectedTab.AddPost) {
        // Navigate to Profile
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GoogleMapPage()),
        );
      }
    });
  }

  final Map<String, Marker> _markers = {};

  LocationData? currentLocation;
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
  }

  // Load current location
  void _loadCurrentLocation() async {
    currentLocation = await getCurrentLocation();

    if (currentLocation != null) {
      setState(() {
        _markers.clear();
        _markers["currentLocation"] = Marker(
          markerId: MarkerId("currentLocation"),
          position: LatLng(
            currentLocation!.latitude!,
            currentLocation!.longitude!,
          ),
          infoWindow: InfoWindow(
            title: "Your Location",
            snippet: "Current location",
          ),
        );
      });
    }
  }

  final LatLng _center = const LatLng(45.521563, -122.677433);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (controller) {
                mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 14,
              ),
              markers: Set<Marker>.of(_markers.values),
            ),
      bottomNavigationBar: SizedBox(
        // Nav bar
        height: 160,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: DotNavigationBar(
            margin: const EdgeInsets.only(left: 30, right: 30),
            currentIndex: _SelectedTab.values.indexOf(_selectedTab),
            dotIndicatorColor: const Color.fromARGB(255, 250, 86, 114),
            unselectedItemColor: Colors.grey[300],
            splashBorderRadius: 50,
            //enableFloatingNavBar: false,
            onTap: _handleIndexChanged,
            items: [
              /// Home
              DotNavigationBarItem(
                icon: const Icon(Icons.home),
                selectedColor: const Color.fromARGB(255, 250, 86, 114),
              ),

              /// Likes
              DotNavigationBarItem(
                icon: const Icon(Icons.add_circle),
                selectedColor: const Color.fromARGB(255, 250, 86, 114),
              ),

              /// Search
              DotNavigationBarItem(
                icon: const Icon(Icons.chat),
                selectedColor: const Color.fromARGB(255, 250, 86, 114),
              ),

              /// Profile
              DotNavigationBarItem(
                icon: const Icon(Icons.person),
                selectedColor: const Color.fromARGB(255, 250, 86, 114),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
