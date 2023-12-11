import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(const MainApp());
}


class MainApp extends StatelessWidget {
  const MainApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Album View with API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const HomeScreen(),
    );
  }
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<dynamic> albums;
  late List<dynamic> selectedAlbumPhotos;

  @override
  void initState() {
    super.initState();
    getAlbums();
  }

  Future<void> getAlbums() async {
    var url = Uri.parse("https://jsonplaceholder.typicode.com/albums");
    var response = await http.get(url);

    setState(() {
      albums = json.decode(response.body);
    });
  }

  Future<void> getPhotosForAlbum(int albumId) async {
    var url = Uri.parse("https://jsonplaceholder.typicode.com/photos?albumId=$albumId");
    var response = await http.get(url);

    setState(() {
      selectedAlbumPhotos = json.decode(response.body);
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Albums"),
        backgroundColor: Colors.blue,
      ),
      body: albums != null
          ? GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: albums.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              getPhotosForAlbum(albums[index]["id"]);
            },
            child: Card(
              elevation: 2.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Expanded(
                    child: Icon(Icons.photo_album),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      albums[index]["title"],
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}