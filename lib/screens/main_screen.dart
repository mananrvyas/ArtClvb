import 'package:flutter/material.dart';
import '../models/artwork.dart';

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
    artworks = [
      ArtWork(
        id: '1',
        title: 'The Starry Night',
        artist: 'Vincent van Gogh',
        imageUrl: "assets/images/1.jpeg",
        description: 'The Starry Night is an oil on canvas painting by Dutch '
            'Post-Impressionist painter Vincent van Gogh. Painted in June 1889, '
            'it depicts the view from the east-facing window of his asylum room '
            'at Saint-Rémy-de-Provence, just before sunrise, with the addition '
            'of an ideal village.',
        price: 1000,
      ),
      ArtWork(
        id: '2',
        title: 'The Scream',
        artist: 'Edvard Munch',
        imageUrl: "assets/images/2.jpeg",
        description: 'The Scream is the popular name given to a composition '
            'created by Norwegian Expressionist artist Edvard Munch in 1893. '
            'The original German title given by Munch to his work was Der '
            'Schrei der Natur, and the Norwegian title is Skrik.',
        price: 2000,
      ),
      ArtWork(
        id: '3',
        title: 'The Persistence of Memory',
        artist: 'Salvador Dalí',
        imageUrl: "assets/images/3.jpeg",
        description: 'The Persistence of Memory is a 1931 painting by artist '
            'Salvador Dalí and one of the most recognizable works of Surrealism. '
            'First shown at the Julien Levy Gallery in 1932, since 1934 the '
            'painting has been in the collection of the Museum of Modern Art '
            'in New York City, which received it from an anonymous donor.',
        price: 3000,
      ),
      ArtWork(
        id: '4',
        title: 'The Last Supper',
        artist: 'Leonardo da Vinci',
        imageUrl: "assets/images/4.jpeg",
        description: 'The Last Supper is a late 15th-century mural painting by '
            'Italian artist Leonardo da Vinci housed by the refectory of the '
            'Convent of Santa Maria delle Grazie in Milan, Italy. It is one of '
            'the Western world\'s most recognizable paintings.',
        price: 4000,
      ),
      ArtWork(
        id: '5',
        title: 'The Birth of Venus',
        artist: 'Sandro Botticelli',
        imageUrl: "assets/images/5.jpeg",
        description: 'The Birth of Venus is a painting by the Italian artist'
            ' Sandro Botticelli, probably made in the mid 1480s. It depicts '
            'the goddess Venus arriving at the shore after her birth, when she '
            'had emerged from the sea fully-grown.',
        price: 5000,
      ),
      ArtWork(
        id: '6',
        title: 'The Creation of Adam',
        artist: 'Michelangelo',
        imageUrl: "assets/images/6.jpeg",
        description: 'The Creation of Adam is a fresco painting by Italian artist'
            ' Michelangelo, which forms part of the Sistine Chapel\'s ceiling, '
            'painted c. 1508–1512. It illustrates the Biblical creation narrative'
            ' from the Book of Genesis in which God gives life to Adam',
        price: 6000,
      ),
      ArtWork(
        id: '7',
        title: 'The Night Watch',
        artist: 'Rembrandt',
        imageUrl: "assets/images/7.jpeg",
        description:
        'The Night Watch is a 1642 painting by Rembrandt van Rijn. It is in the'
            ' collection of the Amsterdam Museum but is prominently displayed '
            'in the Rijksmuseum as the best-known painting in its collection.'
            ' The Night Watch is one of the most famous Dutch Golden Age '
            'paintings.',
        price: 7000,
      ),
    ];

    displayedArtworks = artworks;
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