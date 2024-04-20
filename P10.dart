import 'package:flutter/material.dart';

class SQLHelper {
  static List<Map<String, dynamic>> _journals = [
    {'id': 1, 'title': 'Journal 1', 'description': 'Description for Journal 1'},
    {'id': 2, 'title': 'Journal 2', 'description': 'Description for Journal 2'},
    {'id': 3, 'title': 'Journal 3', 'description': 'Description for Journal 3'},
  ];

  static Future<List<Map<String, dynamic>>> getItems() async {
    // Simulate a delay to simulate fetching data from a real database
    await Future.delayed(const Duration(milliseconds: 500));
    return _journals;
  }

  static Future<int> createItem(String title, String description) async {
    final newItem = {
      'id': _journals.length + 1,
      'title': title,
      'description': description,
    };
    _journals.add(newItem);
    // Simulate a delay to simulate database operation
    await Future.delayed(const Duration(milliseconds: 300));
    return newItem['id'] as int; // Explicitly cast to int
  }

  static Future<void> updateItem(int id, String title, String description) async {
    final index = _journals.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      _journals[index]['title'] = title;
      _journals[index]['description'] = description;
    }
    // Simulate a delay to simulate database operation
    await Future.delayed(const Duration(milliseconds: 300));
  }

  static Future<void> deleteItem(int id) async {
    _journals.removeWhere((item) => item['id'] == id);
    // Simulate a delay to simulate database operation
    await Future.delayed(const Duration(milliseconds: 300));
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SQLITE',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _journals = [];
  bool _isLoading = true;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals(); // Loading the diary when the app starts
  }

  void _showForm(int? id) async {
    if (id != null) {
      final existingJournal = _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['description'];
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 120,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(hintText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (id == null) {
                  await _addItem();
                } else {
                  await _updateItem(id);
                }
                _titleController.text = '';
                _descriptionController.text = '';
                Navigator.of(context).pop();
                _refreshJournals();
              },
              child: Text(id == null ? 'Create New' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addItem() async {
    await SQLHelper.createItem(_titleController.text, _descriptionController.text);
    _refreshJournals();
  }

  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(id, _titleController.text, _descriptionController.text);
    _refreshJournals();
  }

  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Successfully deleted a journal!'),
      ),
    );
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQL'),
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: _journals.length,
        itemBuilder: (context, index) => Card(
          color: Colors.orange[200],
          margin: const EdgeInsets.all(15),
          child: ListTile(
            title: Text(_journals[index]['title']),
            subtitle: Text(_journals[index]['description']),
            trailing: SizedBox(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showForm(_journals[index]['id']),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteItem(_journals[index]['id']),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
