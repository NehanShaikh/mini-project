import 'dart:convert';
import 'dart:async';
import 'api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Biometric Attendance App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

// Login Screen
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HostLoginScreen()),
                );
              },
              child: Text('Login as Host'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClientLoginScreen()),
                );
              },
              child: Text('Login as Client'),
            ),
          ],
        ),
      ),
    );
  }
}

class HostLoginScreen extends StatefulWidget {
  @override
  _HostLoginScreenState createState() => _HostLoginScreenState();
}

class _HostLoginScreenState extends State<HostLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Host Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BluetoothPage(title: 'BluetoothPage')),
                    );
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Client Login Screen
class ClientLoginScreen extends StatefulWidget {
  @override
  _ClientLoginScreenState createState() => _ClientLoginScreenState();
}

class _ClientLoginScreenState extends State<ClientLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Client Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ClientDashboardScreen()),
                    );
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({super.key, required this.title});

  final String title;

  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  final List<BluetoothDevice> _devicesList = [];
  BluetoothDevice? _connectedDevice;
  final List<BluetoothService> _services = [];

  void _addDeviceToList(BluetoothDevice device) {
    if (!_devicesList.contains(device)) {
      setState(() {
        _devicesList.add(device);
      });
    }
  }

  Future<void> _checkPermissions() async {
    var locationStatus = await Permission.locationWhenInUse.status;
    var bluetoothStatus = await Permission.bluetoothScan.status;

    if (locationStatus.isDenied || bluetoothStatus.isDenied) {
      await [
        Permission.locationWhenInUse,
        Permission.bluetoothScan,
        Permission.bluetooth,
        Permission.bluetoothConnect
      ].request();
    }

    if (locationStatus.isPermanentlyDenied ||
        bluetoothStatus.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> _startScan() async {
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
    FlutterBluePlus.scanResults.listen((results) {
      for (var result in results) {
        _addDeviceToList(result.device);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _checkPermissions().then((_) => _startScan());
  }

  ListView _buildDeviceListView() {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: _devicesList.map((device) {
        return ListTile(
          title: Text(device.name.isNotEmpty ? device.name : 'Unknown Device'),
          subtitle: Text(device.id.toString()),
          trailing: ElevatedButton(
            child: const Text('Allow'),
            onPressed: () async {
              try {
                await device.connect();
                setState(() {
                  _connectedDevice = device;
                });
                _services.addAll(await device.discoverServices());
              } catch (e) {
                if (e is PlatformException && e.code != 'already_connected') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.message}')),
                  );
                }
              }
            },
          ),
        );
      }).toList(),
    );
  }

  ListView _buildConnectedDeviceView() {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: _services.map((service) {
        return ExpansionTile(
          title: Text(service.uuid.toString()),
          children: service.characteristics.map((characteristic) {
            return ListTile(
              title: Text(characteristic.uuid.toString()),
              subtitle: Text('Properties: ${characteristic.properties}'),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _devicesList.clear();
              });
              _startScan();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _connectedDevice == null
                ? _buildDeviceListView()
                : _buildConnectedDeviceView(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HostDashboardScreen(),
                  ),
                );
              },
              child: const Text('Host Dashboard'),
            ),
          ),
        ],
      ),
    );
  }
}

// Host Dashboard
class HostDashboardScreen extends StatelessWidget {
  final List<Class> classes = [
    Class(name: 'ARM', attendanceRecords: ['2024-12-01', '2024-12-02']),
    Class(name: 'DBMS', attendanceRecords: ['2024-12-01']),
    Class(name: 'ML', attendanceRecords: ['2024-12-03']),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Host Dashboard'),
      ),
      body: ListView.builder(
        itemCount: classes.length,
        itemBuilder: (context, index) {
          final classItem = classes[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(classItem.name),
              subtitle:
                  Text('Attendance: ${classItem.attendanceRecords.join(", ")}'),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AttendancePageScreen(className: classItem.name),
                    ),
                  );
                },
                child: Text('View Attendance'),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Client Dashboard
class ClientDashboardScreen extends StatelessWidget {
  final List<String> availableSubjects = ['ARM', 'DBMS', 'ML'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Client Dashboard'),
      ),
      body: ListView.builder(
        itemCount: availableSubjects.length,
        itemBuilder: (context, index) {
          final subject = availableSubjects[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(subject),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FingerprintAttendanceScreen(subject: subject),
                    ),
                  );
                },
                child: Text('Log Attendance'),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Attendance Page Screen
class AttendancePageScreen extends StatelessWidget {
  final String className;
  final List<StudentAttendance> studentAttendanceRecords = [
    StudentAttendance(name: 'Nehan', date: '2024-12-01'),
    StudentAttendance(name: 'Theerthesh', date: '2024-12-02'),
    StudentAttendance(name: 'Hari', date: '2024-12-03'),
    StudentAttendance(name: 'Shreyas', date: '2024-12-03'),
    // Add more student attendance records as needed
  ];

  AttendancePageScreen({required this.className});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance for $className'),
      ),
      body: ListView.builder(
        itemCount: studentAttendanceRecords.length,
        itemBuilder: (context, index) {
          final attendance = studentAttendanceRecords[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(attendance.name),
              subtitle: Text('Date: ${attendance.date}'),
            ),
          );
        },
      ),
    );
  }
}

// Fingerprint Attendance Screen
class FingerprintAttendanceScreen extends StatefulWidget {
  final String subject;

  FingerprintAttendanceScreen({required this.subject});

  @override
  _FingerprintAttendanceScreenState createState() =>
      _FingerprintAttendanceScreenState();
}

class _FingerprintAttendanceScreenState
    extends State<FingerprintAttendanceScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isAuthenticated = false;

  Future<void> _authenticate() async {
    try {
      _isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to log attendance',
        options: AuthenticationOptions(
          biometricOnly: true,
        ),
      );

      if (_isAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Attendance logged for ${widget.subject}')),
        );

        // Example fingerprint ID to be sent
        String fingerprintId = 'some_fingerprint_id';
        await _checkFingerprintInDatabase(fingerprintId);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Authentication failed')),
        );
      }
    } on PlatformException catch (e) {
      print('Error: ${e.message}');
    }
  }

  Future<void> _checkFingerprintInDatabase(String fingerprintId) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.100/verify-fingerprint.php'),
        body: json.encode({'fingerprintId': fingerprintId}),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        final responseData = json.decode(response.body);
        if (responseData['exists']) {
          print('Fingerprint found in database');
        } else {
          print('Fingerprint not found in database');
        }
      } else {
        print('HTTP request failed with status code: ${response.statusCode}');
        throw Exception('Failed to verify fingerprint');
      }
    } catch (e) {
      print('Error in _checkFingerprintInDatabase: ${e.toString()}');
      throw Exception('An error occurred during fingerprint verification');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log Attendance for ${widget.subject}'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _authenticate,
          child: Text('Authenticate to Log Attendance'),
        ),
      ),
    );
  }
}

// Attendance Screen
class AttendanceScreen extends StatelessWidget {
  final Class classItem;

  AttendanceScreen({required this.classItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance for ${classItem.name}'),
      ),
      body: ListView.builder(
        itemCount: classItem.attendanceRecords.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Date: ${classItem.attendanceRecords[index]}'),
          );
        },
      ),
    );
  }
}

// Class and Attendance Record Models
class Class {
  final String name;
  final List<String> attendanceRecords;

  Class({required this.name, required this.attendanceRecords});
}

class StudentAttendance {
  final String name;
  final String date;

  StudentAttendance({required this.name, required this.date});
}

class AttendanceRecord {
  final String date;
  final String status;

  AttendanceRecord({required this.date, required this.status});
}
