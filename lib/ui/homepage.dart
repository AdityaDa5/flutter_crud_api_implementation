import 'package:crud_api_implementation/models/contact_model.dart';
import 'package:crud_api_implementation/network/api_service.dart';
import 'package:crud_api_implementation/ui/colors/app_colors.dart';
import 'package:crud_api_implementation/ui/widgets/contact_card.dart';
import 'package:crud_api_implementation/ui/widgets/contact_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactHomeScreen extends StatefulWidget {
  const ContactHomeScreen({Key? key}) : super(key: key);

  @override
  State<ContactHomeScreen> createState() => _ContactHomeScreenState();
}

class _ContactHomeScreenState extends State<ContactHomeScreen> {
  final ApiService _apiService = ApiService();

  List<Contact> _contacts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchContacts();
    });
  }

  Future<void> _fetchContacts() async {
    setState(() => _isLoading = true);
    try {
      final contacts = await _apiService.getContacts();
      setState(() {
        _contacts = contacts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar("Failed to load contacts", isError: true);
    }
  }

  void _showSnackBar(
    String message, {
    bool isError = false,
    bool isDelete = false,
  }) {
    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).clearSnackBars();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: const TextStyle(color: Colors.white)),
          backgroundColor: (isError)
              ? AppColors.errorAndAction
              : AppColors.success,
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }

  void _openAddContactDialog() {
    showDialog(
      context: context,
      builder: (context) => ContactFormDialog(
        onSubmit: (name, phone, address, fathersName) async {
          _showLoadingDialog();
          try {
            await _apiService.addContact(
              name: name,
              phone: phone,
              address: address,
              fathersName: fathersName,
            );
            Navigator.pop(context);
            _showSnackBar("Contact Successfully Added");
            _fetchContacts();
          } catch (e) {
            Navigator.pop(context);
            _showSnackBar("Failed to add contact", isError: true);
          }
        },
      ),
    );
  }

  void _openEditContactDialog(Contact contact) {
    showDialog(
      context: context,
      builder: (context) => ContactFormDialog(
        contact: contact,
        onSubmit: (name, phone, address, fathersName) async {
          _showLoadingDialog();
          try {
            await _apiService.updateContact(
              id: contact.id!,
              name: name,
              phone: phone,
              address: address,
              fathersName: fathersName,
            );
            Navigator.pop(context);
            _showSnackBar("Contact Successfully Edited");
            _fetchContacts();
          } catch (e) {
            Navigator.pop(context);
            _showSnackBar("Failed to edit contact", isError: true);
          }
        },
      ),
    );
  }

  Future<void> _deleteContact(String id) async {
    _showLoadingDialog();
    try {
      await _apiService.deleteContact(id: id);
      Navigator.pop(context);
      _showSnackBar("Contact Successfully Deleted", isDelete: true);
      _fetchContacts();
    } catch (e) {
      Navigator.pop(context);
      _showSnackBar("Failed to delete contact", isError: true);
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Contacts',
          style: GoogleFonts.poppins(
            color: AppColors.primary,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _contacts.isEmpty
          ? const Center(child: Text("No contacts found. Add one!"))
          : RefreshIndicator(
              onRefresh: _fetchContacts,
              child: ListView.builder(
                itemCount: _contacts.length,
                padding: const EdgeInsets.only(top: 8, bottom: 80),
                itemBuilder: (context, index) {
                  final contact = _contacts[index];
                  return ContactCard(
                    contact: contact,
                    index: index,
                    onEdit: () => _openEditContactDialog(contact),
                    onDelete: () => _deleteContact(contact.id!),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddContactDialog,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
