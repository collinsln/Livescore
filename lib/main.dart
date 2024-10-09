import 'package:flutter/material.dart';
import 'livematch.dart';
import 'matchbydate.dart';
import 'standings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Live Football App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(), // Set the home to HomeScreen widget
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Track the current index of the BottomNavigationBar

  final List<Widget> _pages = [
    LiveMatchScreen(), // Default page
    StandingsScreen(),
    MatchByDate(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index; // Update the current index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Football App'),
      ),
      body: _pages[_currentIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv),
            label: 'Live Scores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_chart),
            label: 'Standings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Matches by Date',
          ),
        ],
        currentIndex: _currentIndex, // Current index of the BottomNavigationBar
        onTap: _onItemTapped, // Function to call when an item is tapped
      ),
    );
  }
}
