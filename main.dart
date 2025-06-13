// pubspec.yaml dependencies needed:
// flutter:
//   sdk: flutter
// google_maps_flutter: ^2.5.0
// geolocator: ^10.1.0
// http: ^1.1.0
// shared_preferences: ^2.2.2
// url_launcher: ^6.2.1

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(TransportApp());
}

class TransportApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rutas de Transporte',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  _checkAuthStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    await Future.delayed(Duration(seconds: 2));

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_bus, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Rutas de Transporte',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[400]!, Colors.blue[800]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.directions_bus, size: 120, color: Colors.white),
              SizedBox(height: 30),
              Text(
                'Bienvenido a Rutas',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Encuentra tu ruta y sigue tu transporte',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              SizedBox(height: 60),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue[800],
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Iniciar Sesión',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white, width: 2),
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Registrarse',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  _login() async {
    setState(() {
      _isLoading = true;
    });

    // Simulación de login
    await Future.delayed(Duration(seconds: 2));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userEmail', _emailController.text);

    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar Sesión'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Iniciar Sesión', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Las contraseñas no coinciden')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulación de registro
    await Future.delayed(Duration(seconds: 2));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userEmail', _emailController.text);
    await prefs.setString('userName', _nameController.text);

    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrarse'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre completo',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirmar contraseña',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Registrarse', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [MapScreen(), RoutesScreen(), DriversScreen(), ProfileScreen()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.blue[800],
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapa'),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus),
            label: 'Rutas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Choferes',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  Position? _currentPosition;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<Bus> _buses = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _generateMockBuses();
    _startRealTimeUpdates();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });
  }

  _generateMockBuses() {
    _buses = [
      Bus(
        id: '001',
        route: 'Ruta 1 - Centro',
        lat: 22.7709,
        lng: -102.5833,
        passengers: 12,
        capacity: 40,
      ),
      Bus(
        id: '002',
        route: 'Ruta 2 - Norte',
        lat: 22.7759,
        lng: -102.5883,
        passengers: 8,
        capacity: 40,
      ),
      Bus(
        id: '003',
        route: 'Ruta 3 - Sur',
        lat: 22.7659,
        lng: -102.5783,
        passengers: 25,
        capacity: 40,
      ),
    ];
    _updateMarkers();
  }

  _updateMarkers() {
    Set<Marker> markers = {};

    // Marcador de ubicación actual
    if (_currentPosition != null) {
      markers.add(
        Marker(
          markerId: MarkerId('current_location'),
          position: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          infoWindow: InfoWindow(title: 'Mi ubicación'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    // Marcadores de autobuses
    for (Bus bus in _buses) {
      markers.add(
        Marker(
          markerId: MarkerId(bus.id),
          position: LatLng(bus.lat, bus.lng),
          infoWindow: InfoWindow(
            title: bus.route,
            snippet: 'Pasajeros: ${bus.passengers}/${bus.capacity}',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          onTap: () => _showBusDetails(bus),
        ),
      );
    }

    setState(() {
      _markers = markers;
    });
  }

  _showBusDetails(Bus bus) {
    double distance = 0;
    int eta = 0;

    if (_currentPosition != null) {
      distance =
          Geolocator.distanceBetween(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            bus.lat,
            bus.lng,
          ) /
          1000; // Convert to km
      eta = (distance * 3).round(); // Estimate 3 minutes per km
    }

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bus.route,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.people, color: Colors.blue),
                SizedBox(width: 8),
                Text('Pasajeros: ${bus.passengers}/${bus.capacity}'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.red),
                SizedBox(width: 8),
                Text('Distancia: ${distance.toStringAsFixed(1)} km'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.green),
                SizedBox(width: 8),
                Text('Tiempo estimado: $eta min'),
              ],
            ),
            SizedBox(height: 20),
            LinearProgressIndicator(
              value: bus.passengers / bus.capacity,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                bus.passengers / bus.capacity > 0.8 ? Colors.red : Colors.green,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Ocupación: ${((bus.passengers / bus.capacity) * 100).toStringAsFixed(0)}%',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  _startRealTimeUpdates() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      // Simulate bus movement
      for (Bus bus in _buses) {
        bus.lat += (Random().nextDouble() - 0.5) * 0.001;
        bus.lng += (Random().nextDouble() - 0.5) * 0.001;
        bus.passengers = Random().nextInt(40);
      }
      _updateMarkers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa de Rutas'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              if (_currentPosition != null && _controller != null) {
                _controller!.animateCamera(
                  CameraUpdate.newLatLng(
                    LatLng(
                      _currentPosition!.latitude,
                      _currentPosition!.longitude,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _currentPosition!.latitude,
                  _currentPosition!.longitude,
                ),
                zoom: 14,
              ),
              markers: _markers,
              polylines: _polylines,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
            ),
    );
  }
}

class RoutesScreen extends StatelessWidget {
  final List<Route> routes = [
    Route(
      id: '1',
      name: 'Ruta 1 - Centro',
      color: Colors.red,
      stops: ['Plaza Principal', 'Mercado', 'Hospital', 'Universidad'],
      activeTime: '5:00 AM - 10:00 PM',
      frequency: '15 min',
    ),
    Route(
      id: '2',
      name: 'Ruta 2 - Norte',
      color: Colors.blue,
      stops: ['Terminal Norte', 'Colonia Norte', 'Centro Comercial', 'Parque'],
      activeTime: '6:00 AM - 9:00 PM',
      frequency: '20 min',
    ),
    Route(
      id: '3',
      name: 'Ruta 3 - Sur',
      color: Colors.green,
      stops: ['Zona Industrial', 'Fraccionamiento Sur', 'Centro', 'Terminal'],
      activeTime: '5:30 AM - 9:30 PM',
      frequency: '18 min',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rutas Disponibles'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: routes.length,
        itemBuilder: (context, index) {
          final route = routes[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            child: ExpansionTile(
              leading: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: route.color,
                  shape: BoxShape.circle,
                ),
              ),
              title: Text(
                route.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Frecuencia: ${route.frequency}'),
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Horario: ${route.activeTime}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Paradas:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...route.stops
                          .map(
                            (stop) => Padding(
                              padding: EdgeInsets.only(left: 16, top: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 6,
                                    color: route.color,
                                  ),
                                  SizedBox(width: 8),
                                  Text(stop),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DriversScreen extends StatelessWidget {
  final List<Driver> drivers = [
    Driver(
      id: '1',
      name: 'Juan Pérez',
      phone: '+52 492 123 4567',
      route: 'Ruta 1 - Centro',
      rating: 4.8,
      busNumber: '001',
    ),
    Driver(
      id: '2',
      name: 'María González',
      phone: '+52 492 234 5678',
      route: 'Ruta 2 - Norte',
      rating: 4.9,
      busNumber: '002',
    ),
    Driver(
      id: '3',
      name: 'Carlos Rodríguez',
      phone: '+52 492 345 6789',
      route: 'Ruta 3 - Sur',
      rating: 4.7,
      busNumber: '003',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contactos de Choferes'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: drivers.length,
        itemBuilder: (context, index) {
          final driver = drivers[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue[800],
                child: Text(
                  driver.name.split(' ').map((n) => n[0]).join(''),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                driver.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(driver.route),
                  Text('Autobús: ${driver.busNumber}'),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(' ${driver.rating}'),
                    ],
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.phone, color: Colors.green),
                onPressed: () => _launchPhone(driver.phone),
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }

  _launchPhone(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue[800],
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              'Usuario',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuración'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Ayuda'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Acerca de'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('Cerrar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}

// Data Models
class Bus {
  String id;
  String route;
  double lat;
  double lng;
  int passengers;
  int capacity;

  Bus({
    required this.id,
    required this.route,
    required this.lat,
    required this.lng,
    required this.passengers,
    required this.capacity,
  });
}

class Route {
  String id;
  String name;
  Color color;
  List<String> stops;
  String activeTime;
  String frequency;

  Route({
    required this.id,
    required this.name,
    required this.color,
    required this.stops,
    required this.activeTime,
    required this.frequency,
  });
}

class Driver {
  String id;
  String name;
  String phone;
  String route;
  double rating;
  String busNumber;

  Driver({
    required this.id,
    required this.name,
    required this.phone,
    required this.route,
    required this.rating,
    required this.busNumber,
  });
}
