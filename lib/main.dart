import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:office_app/employee_list.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const EmployeeLoginApp());
}

class EmployeeLoginApp extends StatelessWidget {
  const EmployeeLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Employee Login App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool isLoading = true;
  TextEditingController _nameController =
      TextEditingController(); // Controller for the name TextField

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);
    _controller = CameraController(frontCamera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
    isLoading = false;
    setState(() {});
  }

  void _takePhoto() async {
    // try {
    //   await _initializeControllerFuture; // Wait for camera initialization

    //   final path = join(
    //     (await getTemporaryDirectory()).path,
    //     '${DateTime.now()}.png',
    //   );

    //   await _controller.takePicture();

    //   // Process the captured photo (e.g., save to database, display on UI)
    //   print('Photo saved at $path');
    // } catch (e) {
    //   print('Error taking photo: $e');
    // }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _drawer(context),
      appBar: AppBar(
        title: const Text('Employee Login'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      // width: 300,
                      height: 500,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: FutureBuilder<void>(
                        future: _initializeControllerFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return CameraPreview(_controller);
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Enter your name',
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _takePhoto,
                      icon: Icon(Icons.camera),
                      label: const Text('Take Photo'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

Drawer _drawer(BuildContext context) {
  return Drawer(
    child: Container(
      color: Colors.blueGrey[900], // Background color of the drawer
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueGrey[800], // Header background color
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  // Replace with your logo or user icon
                  child: Icon(
                    Icons.person,
                    color: Colors.blueGrey[900],
                    size: 50,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Admin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard, color: Colors.white),
            title: Text('Admin Panel', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmployeeListScreen()),
              );
            },
          ),
          // Add more list tiles for additional drawer items
        ],
      ),
    ),
  );
}
