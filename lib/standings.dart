import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'standings_model.dart';

class StandingsScreen extends StatefulWidget {
  @override
  _StandingsScreenState createState() => _StandingsScreenState();
}

class _StandingsScreenState extends State<StandingsScreen> {
  List<Standing> standings = [];

  @override
  void initState() {
    super.initState();
    fetchStandings();
  }

  Future<void> fetchStandings() async {
    const url = 'https://football.sportdevs.com/standings';
    const token = 'wQgT6JN1m0OMfo6kTqbE6g';

    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('standingsData');

      if (cachedData != null) {
        // Load from cache if available
        List<dynamic> jsonResponse = jsonDecode(cachedData);
        standings =
            jsonResponse.map((data) => Standing.fromJson(data)).toList();
        setState(() {});
      }

      // Fetch fresh data from the API
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        standings =
            jsonResponse.map((data) => Standing.fromJson(data)).toList();

        // Cache the fresh data
        await prefs.setString('standingsData', response.body);

        setState(() {});
      } else {
        print('Failed to load standings with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _navigateToDetails(BuildContext context, Standing standing) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StandingDetailsScreen(standing: standing),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leagues'),
      ),
      body: standings.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: standings.length,
              itemBuilder: (context, index) {
                final standing = standings[index];
                return ListTile(
                  title: Text(standing.name),
                  onTap: () => _navigateToDetails(context, standing),
                );
              },
            ),
    );
  }
}

class StandingDetailsScreen extends StatelessWidget {
  final Standing standing;

  const StandingDetailsScreen({Key? key, required this.standing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(standing.name),
      ),
      body: ListView.builder(
        itemCount: standing.competitors.length,
        itemBuilder: (context, competitorIndex) {
          final competitor = standing.competitors[competitorIndex];
          return ListTile(
            title: Text(competitor.teamName),
            subtitle: Text(
              'Wins: ${competitor.wins}, Draws: ${competitor.draws}, Losses: ${competitor.losses}, Position: ${competitor.position}',
            ),
          );
        },
      ),
    );
  }
}
