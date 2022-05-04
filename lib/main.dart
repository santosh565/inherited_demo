import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
        routes: {
          '/contact': (BuildContext context) => const NewContactView(),
        });
  }
}

class Contact {
  final String name;
  final String id;

  Contact({required this.name}) : id = const Uuid().v4();
}

class ContactBook extends ValueNotifier<List<Contact>> {
  ContactBook._sharedInstance() : super([]);
  static final ContactBook _shared = ContactBook._sharedInstance();
  factory ContactBook() => _shared;

  // int get length => value.length;

  void addContact({required Contact contact}) {
    value.add(contact);
    // final contacts = value;
    // contacts.add(contact);
    // value = contacts;
    notifyListeners();
  }

  void removeContact({required Contact contact}) {
    final contacts = value;
    if (contacts.contains(contact)) {
      value.remove(contact);
      // contacts.remove(contact);
      notifyListeners();
    }
  }

  // Contact? contact({required int atIndex}) =>
  //     value.length > atIndex ? value[atIndex] : null;
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Book"),
      ),
      body: ValueListenableBuilder(
        valueListenable: ContactBook(),
        builder: (context, value, child) {
          final contacts = value as List<Contact>;
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: ((context, index) {
              final contact = contacts[index];
              return Dismissible(
                onDismissed: (_) => contacts.remove(contact),
                // ContactBook().removeContact(contact: contact),
                key: Key(contact.id),
                child: Card(
                  child: ListTile(
                    title: Text(contact.name),
                  ),
                ),
              );
            }),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/contact');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NewContactView extends StatefulWidget {
  const NewContactView({Key? key}) : super(key: key);

  @override
  State<NewContactView> createState() => _NewContactViewState();
}

class _NewContactViewState extends State<NewContactView> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Contact"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Enter a new contact name',
            ),
          ),
          TextButton(
              onPressed: () {
                final contact = Contact(name: _nameController.text);
                ContactBook().addContact(contact: contact);
                Navigator.pop(context);
              },
              child: const Text('Add Contact')),
        ],
      ),
    );
  }
}
