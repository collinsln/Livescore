import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'match_model.dart';

class LiveMatchScreen extends StatefulWidget {
  @override
  _LiveMatchScreenState createState() => _LiveMatchScreenState();
}

class _LiveMatchScreenState extends State<LiveMatchScreen> {
  final String apiUrl =
      'https://football.sportdevs.com/matches-live'; // Replace with your API URL
  final String bearerToken =
      'wQgT6JN1m0OMfo6kTqbE6g'; // Replace with your Bearer token

  // To hold the list of matches
  List<MatchModel> matches = [];

  // Function to fetch data from the API
  Future<void> fetchMatches() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization':
              'Bearer $bearerToken', // Add the Bearer token to the headers
          'Content-Type': 'application/json', // Set content type if needed
        },
      );

      if (response.statusCode == 200) {
        // Parse the response body
        final List<dynamic> data = json.decode(response.body);

        // Update the state with the fetched data
        setState(() {
          matches = MatchModel.fromJsonList(data);
        });
      } else {
        throw Exception('Failed to load matches');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch the matches when the screen loads
    fetchMatches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Matches'),
        centerTitle: true,
        backgroundColor: Colors.green[700], // Change app bar color
      ),
      body: matches.isEmpty
          ? Center(child: CircularProgressIndicator()) // Loading indicator
          : ListView.builder(
              itemCount: matches.length,
              itemBuilder: (context, index) {
                final match = matches[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Home Team
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              match.homeTeamName,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Score: ${match.homeTeamScore}'),
                          ],
                        ),
                        // Match Status
                        Column(
                          children: [
                            Text(
                              match.status,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              '${match.time} remaining',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        // Away Team
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              match.awayTeamName,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Score: ${match.awayTeamScore}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
