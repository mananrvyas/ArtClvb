import 'package:flutter/material.dart';
import '../models/artwork.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainScreen extends StatefulWidget {
  const MainScreen ({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  List<ArtWork> artworks = [];
  String searchQuery = '';
  List<ArtWork> displayedArtworks = [];
  @override
  void initState() {
    super.initState();

    fetchArtworks();

    print(artworks);
    // displayedArtworks = artworks;
  }

  void fetchArtworks() async {
    final snapshot = await FirebaseFirestore.instance.collection('artworks').get();
    final List<ArtWork> all_arts = snapshot.docs.map((doc) => ArtWork.fromDocument(doc)).toList();
    setState(() {
      this.artworks = all_arts;
      displayedArtworks = all_arts;
    });
  }

  void _searchArtwork(String query) {
    setState(() {
      displayedArtworks = artworks.where((artwork) {
        return artwork.title.toLowerCase().contains(query.toLowerCase()) ||
            artwork.artist.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _onAddArtwork() async {
    String title = 'Sample Title';
    String artist = 'Artist Name';
    String imageUrl = "assets/images/placeholder.png";
    String description = 'Description here';
    double? price = 0.0;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Artwork'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(hintText: 'Artwork Name'),
                  onChanged: (value) {
                    title = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Artist Name'),
                  onChanged: (value) {
                    artist = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Image URL'),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      print("lmao it empty");
                      imageUrl = 'assets/images/placeholder.png';
                    } else {
                      imageUrl = value;
                    }
                  },
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Description'),
                  onChanged: (value) {
                    description = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Price'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    price = double.tryParse(value);
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                setState(() {
                  artworks.add(
                    ArtWork(
                      id: DateTime.now().toString(), //meh
                      title: title,
                      artist: artist,
                      imageUrl: imageUrl,
                      description: description,
                      price: price ?? 0.0,
                      isFavourite: false,
                    ),
                  );
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Art Clvb'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  if (value.isEmpty) {
                    displayedArtworks = List.from(artworks);
                  }
                  else searchQuery = value;
                });
                _searchArtwork(value);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: displayedArtworks.length,
              itemBuilder: (context, index) {
                ArtWork artwork = displayedArtworks[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArtworkDetailsScreen(artwork: artwork),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                    height: 300,
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Positioned.fill(
                        child: artwork.imageUrl.startsWith('http')
                            ? Image.network(artwork.imageUrl, fit: BoxFit.cover)
                            : Image.asset(artwork.imageUrl, fit: BoxFit.cover),
                      ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: IconButton(
                            icon: Icon(
                              // if (artwork.isFavourite) Icons.favorite else Icons.favorite_border,
                              displayedArtworks[index].isFavourite ? Icons.favorite : Icons.favorite_border,
                              color: displayedArtworks[index].isFavourite ? Colors.red : Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                displayedArtworks[index].isFavourite = !displayedArtworks[index].isFavourite;
                                if (selectedIndex == 1) {
                                  displayedArtworks = artworks.where((artwork) => artwork.isFavourite).toList();
                                }
                              });
                            },
                          ),
                        ),
                        Positioned(
                          left: 16,
                          bottom: 50,
                          child: Text(
                            artwork.artist,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(0.0, 1.0),
                                  blurRadius: 6.0,
                                  color: Color.fromARGB(150, 0, 0, 0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          bottom: 16,
                          child: Text(
                            artwork.title,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(0.0, 1.0),
                                  blurRadius: 6.0,
                                  color: Color.fromARGB(150, 0, 0, 0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favourites'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
        ],
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
            if(index == 1) {
              displayedArtworks = artworks.where((artwork) => artwork.isFavourite).toList();
            }
            else if(index == 0) {
              displayedArtworks = artworks;
            }
            else {
              displayedArtworks = [];
            }
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddArtwork,
        tooltip: 'Add Artwork',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}


class ArtworkDetailsScreen extends StatelessWidget {

  final ArtWork artwork;

  const ArtworkDetailsScreen({Key? key, required this.artwork}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(artwork.title),
      ),
      body: ListView(
        children: [
          Image.asset(artwork.imageUrl),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              artwork.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              artwork.artist,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
            child: Text(
              'Price: \$${artwork.price}',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(artwork.description),
          ),
        ],
      ),
    );
  }
}