import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged; // Callback for search input
  final VoidCallback onSearch; // Callback for search button press

  const SearchBar({super.key, required this.onChanged, required this.onSearch});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.clear(); // Ensure the controller starts empty
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Ensure enough space for the TextField
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Search for foods...',
                hintStyle: TextStyle(color: Colors.grey), // Explicit hint text style
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: Colors.grey),
              ),
              onChanged: widget.onChanged, // Call the parent widget's callback
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: widget.onSearch, // Call the parent widget's callback
          ),
        ],
      ),
    );
  }
}
