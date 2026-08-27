import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'api_service.dart';

void main() {
  runApp(const ContactApp());
}

class ContactApp extends StatelessWidget {
  const ContactApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact CRUD API',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          surface: Colors.white, // White background as requested
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<String> _pageTitles = [
    'Add Contacts',
    'Get Contacts',
    'Update Contacts',
    'Delete Contacts',
  ];

  final List<Widget> _pages = [
    const AddContactPage(),
    const GetContactsPage(),
    const UpdateContactPage(),
    const DeleteContactPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pageTitles[_selectedIndex],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: GNav(
            backgroundColor: Colors.white,
            color: Colors.purple,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.purple,
            gap: 8,
            padding: const EdgeInsets.all(12),
            tabs: const [
              GButton(icon: Icons.person_add, text: 'Add'),
              GButton(icon: Icons.list_alt, text: 'Get'),
              GButton(icon: Icons.edit, text: 'Update'),
              GButton(icon: Icons.delete, text: 'Delete'),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}

// --- Shared Terminal Widget ---
class TerminalBox extends StatelessWidget {
  final String output;
  const TerminalBox({super.key, required this.output});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.purple, width: 2),
        ),
        child: SingleChildScrollView(
          child: Text(
            output.isEmpty ? "Waiting for request..." : output,
            style: const TextStyle(
              color: Colors.greenAccent,
              fontFamily: 'monospace',
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

// --- Page 1: Add Contact ---
class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _nameController = TextEditingController(
    text: 'tester',
  );
  final TextEditingController _phoneController = TextEditingController(
    text: '1234567890',
  );
  final TextEditingController _addressController = TextEditingController(
    text: 'BBSR',
  );
  final TextEditingController _fathersNameController = TextEditingController(
    text: 'test',
  );
  String _terminalOutput = "";

  void _sendRequest() async {
    setState(() => _terminalOutput += "\n> Sending ADD request...\n");
    final result = await _apiService.addContact(
      name: _nameController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      fathersName: _fathersNameController.text,
    );
    setState(() => _terminalOutput += "$result\n");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              prefixIcon: Icon(Icons.person, color: Colors.purple),
            ),
          ),
          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone',
              prefixIcon: Icon(Icons.phone, color: Colors.purple),
            ),
          ),
          TextField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: 'Address',
              prefixIcon: Icon(Icons.home, color: Colors.purple),
            ),
          ),
          TextField(
            controller: _fathersNameController,
            decoration: const InputDecoration(
              labelText: 'Father\'s Name',
              prefixIcon: Icon(Icons.escalator_warning, color: Colors.purple),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _sendRequest,
            icon: const Icon(Icons.send),
            label: const Text('Send Request'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
            ),
          ),
          TerminalBox(output: _terminalOutput),
        ],
      ),
    );
  }
}

// --- Page 2: Get Contacts ---
class GetContactsPage extends StatefulWidget {
  const GetContactsPage({super.key});

  @override
  State<GetContactsPage> createState() => _GetContactsPageState();
}

class _GetContactsPageState extends State<GetContactsPage> {
  final ApiService _apiService = ApiService();
  String _terminalOutput = "";

  void _sendRequest() async {
    setState(() => _terminalOutput += "\n> Sending GET request...\n");
    final result = await _apiService.getContacts();
    setState(() => _terminalOutput += "$result\n");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Fetch all contacts from the server.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _sendRequest,
            icon: const Icon(Icons.download),
            label: const Text('Send Request'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
            ),
          ),
          TerminalBox(output: _terminalOutput),
        ],
      ),
    );
  }
}

// --- Page 3: Update Contact ---
class UpdateContactPage extends StatefulWidget {
  const UpdateContactPage({super.key});

  @override
  State<UpdateContactPage> createState() => _UpdateContactPageState();
}

class _UpdateContactPageState extends State<UpdateContactPage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _idController = TextEditingController(text: '1');
  final TextEditingController _nameController = TextEditingController(
    text: 'Chintu Dash',
  );
  final TextEditingController _phoneController = TextEditingController(
    text: '9999999999',
  );
  final TextEditingController _addressController = TextEditingController(
    text: 'BBSR New',
  );
  final TextEditingController _fathersNameController = TextEditingController(
    text: 'N/A',
  );
  String _terminalOutput = "";

  void _sendRequest() async {
    setState(() => _terminalOutput += "\n> Sending UPDATE request...\n");
    final result = await _apiService.updateContact(
      id: _idController.text,
      name: _nameController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      fathersName: _fathersNameController.text,
    );
    setState(() => _terminalOutput += "$result\n");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _idController,
            decoration: const InputDecoration(
              labelText: 'Contact ID',
              prefixIcon: Icon(Icons.badge, color: Colors.purple),
            ),
          ),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              prefixIcon: Icon(Icons.person, color: Colors.purple),
            ),
          ),
          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone',
              prefixIcon: Icon(Icons.phone, color: Colors.purple),
            ),
          ),
          TextField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: 'Address',
              prefixIcon: Icon(Icons.home, color: Colors.purple),
            ),
          ),
          TextField(
            controller: _fathersNameController,
            decoration: const InputDecoration(
              labelText: 'Father\'s Name',
              prefixIcon: Icon(Icons.escalator_warning, color: Colors.purple),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _sendRequest,
            icon: const Icon(Icons.send),
            label: const Text('Send Request'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
            ),
          ),
          TerminalBox(output: _terminalOutput),
        ],
      ),
    );
  }
}

// --- Page 4: Delete Contact ---
class DeleteContactPage extends StatefulWidget {
  const DeleteContactPage({super.key});

  @override
  State<DeleteContactPage> createState() => _DeleteContactPageState();
}

class _DeleteContactPageState extends State<DeleteContactPage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _idController = TextEditingController(text: '1');
  String _terminalOutput = "";

  void _sendRequest() async {
    setState(() => _terminalOutput += "\n> Sending DELETE request...\n");
    final result = await _apiService.deleteContact(id: _idController.text);
    setState(() => _terminalOutput += "$result\n");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _idController,
            decoration: const InputDecoration(
              labelText: 'Contact ID',
              prefixIcon: Icon(Icons.delete_outline, color: Colors.purple),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _sendRequest,
            icon: const Icon(Icons.send),
            label: const Text('Send Request'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
            ),
          ),
          TerminalBox(output: _terminalOutput),
        ],
      ),
    );
  }
}
