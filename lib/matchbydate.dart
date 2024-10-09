import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'matchbydate-model.dart'; // Ensure this imports your MatchModel class
import 'package:intl/intl.dart'; // Import the intl package
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences package

class MatchByDate extends StatefulWidget {
  @override
  _MatchByDateState createState() => _MatchByDateState();
}

class _MatchByDateState extends State<MatchByDate> {
  List<Map<String, dynamic>> matchesByDate = [];
  List<Map<String, dynamic>> filteredMatches = [];
  String filter = "today"; // Default filter

  // Define constants for caching duration
  static const Duration todayCacheDuration = Duration(minutes: 10);
  static const Duration restOfDayCacheDuration =
      Duration(hours: 23, minutes: 50); // 24 hours - 10 minutes

  Future<void> fetchMatchesByDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Set up the correct date string based on the filter
    DateTime now = DateTime.now();
    DateTime targetDate;

    if (filter == "today") {
      targetDate = DateTime(now.year, now.month, now.day);
    } else if (filter == "tomorrow") {
      targetDate = DateTime(now.year, now.month, now.day + 1);
    } else {
      // yesterday
      targetDate = DateTime(now.year, now.month, now.day - 1);
    }

    // Format the date as YYYY-MM-DD for the API call
    String formattedDate = DateFormat('yyyy-MM-dd').format(targetDate);

    // Check cache
    String? cachedData = prefs.getString(formattedDate);
    int? cacheTimestamp = prefs.getInt('${formattedDate}_timestamp');

    // Check if cached data exists and if it's still valid
    bool isToday = filter == "today";
    if (cachedData != null && cacheTimestamp != null) {
      DateTime cachedAt = DateTime.fromMillisecondsSinceEpoch(cacheTimestamp);
      Duration cacheDuration =
          isToday ? todayCacheDuration : restOfDayCacheDuration;

      if (DateTime.now().difference(cachedAt) < cacheDuration) {
        // If cached data is still valid, use it
        print('Using cached data for date: $formattedDate');
        matchesByDate =
            List<Map<String, dynamic>>.from(json.decode(cachedData));
        filterMatches();
        return; // Exit the function
      }
    }

    // If no valid cached data, fetch from API
    final String apiUrl =
        'https://football.sportdevs.com/matches-by-date?date=eq.$formattedDate';
    final String bearerToken = 'wQgT6JN1m0OMfo6kTqbE6g';

    try {
      // Logging the request details
      print('Sending GET request to $apiUrl');
      print('Bearer Token: $bearerToken'); // Debug statement

      // Sending the request
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
      );

      // Log the response status and body for debugging
      print('Response Status Code: ${response.statusCode}'); // Debug statement
      print('Response Body: ${response.body}'); // Debug statement

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        matchesByDate = List<Map<String, dynamic>>.from(data);

        // Cache the fetched data and the timestamp
        await prefs.setString(formattedDate, json.encode(matchesByDate));
        await prefs.setInt('${formattedDate}_timestamp',
            DateTime.now().millisecondsSinceEpoch);
        print('Cached matches for date: $formattedDate');

        filterMatches(); // Filter matches after fetching
      } else {
        print(
            'Error: Failed to fetch matches. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data from API: $e');
    }
  }

  void filterMatches() {
    final DateTime now = DateTime.now();
    DateTime targetDate;

    // Set the target date based on the selected filter
    if (filter == "today") {
      targetDate = DateTime(now.year, now.month, now.day);
    } else if (filter == "tomorrow") {
      targetDate = DateTime(now.year, now.month, now.day + 1);
    } else {
      // yesterday
      targetDate = DateTime(now.year, now.month, now.day - 1);
    }

    print('Current filter: $filter'); // Debug statement
    print(
        'Target date for filtering: ${targetDate.toIso8601String()}'); // Debug statement

    // Filtering matches based on the target date
    filteredMatches = matchesByDate.where((matchDate) {
      DateTime matchDateObj = DateTime.parse(matchDate['date']);
      print(
          'Checking match date: ${matchDateObj.toIso8601String()}'); // Debug statement
      // Check if the match date is equal to the target date
      return matchDateObj.isAtSameMomentAs(targetDate);
    }).toList();

    // Debug the filtered results
    print(
        'Filtered matches: ${filteredMatches.length} matches found.'); // Debug statement
    for (var match in filteredMatches) {
      print(
          'Match Date: ${match['date']}, Matches: ${match['matches']}'); // Debug statement
    }

    // Notify the framework to rebuild the UI
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchMatchesByDate(); // Fetch today's matches by default
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matches by Date'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                filter = value; // Update the filter
                print('Selected filter: $filter'); // Debug statement
                fetchMatchesByDate(); // Re-fetch matches with the new date
              });
            },
            itemBuilder: (BuildContext context) {
              return {'today', 'tomorrow', 'yesterday'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice[0].toUpperCase() + choice.substring(1)),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Date filter buttons
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      filter = "today";
                      fetchMatchesByDate();
                    });
                  },
                  child: Text('Today'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      filter = "tomorrow";
                      fetchMatchesByDate();
                    });
                  },
                  child: Text('Tomorrow'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      filter = "yesterday";
                      fetchMatchesByDate();
                    });
                  },
                  child: Text('Yesterday'),
                ),
              ],
            ),
          ),
          // Match list
          Expanded(
            child: filteredMatches.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredMatches.length,
                    itemBuilder: (context, index) {
                      final matchDate = filteredMatches[index];
                      final date = matchDate['date'];
                      final matches = matchDate['matches'];

                      return Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                date,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.blueAccent),
                              ),
                              Divider(thickness: 1, color: Colors.grey[400]),
                              ...matches.map<Widget>((match) {
                                final matchData = MatchModel.fromJson(match);
                                return ListTile(
                                  title: Text(
                                      '${matchData.homeTeamName} vs ${matchData.awayTeamName}'),
                                  subtitle: Text(
                                      'Score: ${matchData.homeTeamScore} - ${matchData.awayTeamScore}\nStatus: ${matchData.statusType}\nLeague: ${matchData.leagueName}'),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
