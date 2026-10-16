import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
      ),
      home: const TodoPage(),
    );
  }
}

// Stateful widget karena isi list dan counter bisa berubah
class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  // Controller untuk membaca dan mengosongkan isi TextField
  final TextEditingController _controller = TextEditingController();

  // Data list to-do
  final List<String> _todos = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTodo() {
    final text = _controller.text.trim();

    // Validasi: input tidak boleh kosong
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi to-do terlebih dahulu!')),
      );
      return;
    }

    setState(() {
      _todos.add(text); // tambah ke list (count otomatis ikut berubah)
    });

    _controller.clear(); // value di form hilang setelah tombol ditekan
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Form input + tombol tambah
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        labelText: 'Tambah kegiatan',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _addTodo(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addTodo,
                    child: const Text('Tambah'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Counter jumlah to-do
              Text(
                'Jumlah to-do: ${_todos.length}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // List to-do
              Expanded(
                child: _todos.isEmpty
                    ? const Center(child: Text('Belum ada to-do'))
                    : ListView.separated(
                        itemCount: _todos.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Text('${index + 1}'),
                            title: Text(_todos[index]),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}