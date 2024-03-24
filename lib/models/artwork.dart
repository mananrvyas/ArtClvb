// Dummy Data till we use Firebase
// moved in lib because flutter wasn't able to detect the path
import 'package:cloud_firestore/cloud_firestore.dart';

class ArtWork {
  final String id;
  final String title;
  final String artist;
  final String imageUrl;
  final String description;
  final double price;
  bool isFavourite;

  ArtWork({
    required this.id,
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.description,
    required this.price,
    this.isFavourite = false,
  });

  // set isFavourite(bool value) {
  //   isFavourite = value;
  // }
  // get isFavourite {
  //   return isFavourite;
  // }

factory ArtWork.fromDocument(DocumentSnapshot doc) {
    return ArtWork(
      id: doc.id,
      title: doc['title'],
      artist: doc['artist'],
      imageUrl: doc['imageUrl'],
      description: doc['description'],
      price: doc['price'].toDouble(),
      isFavourite: doc['isFavourite'] ?? false,
    );
  }
}