import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studio/application/core/failure.dart';
import 'package:studio/domain/entities/favorite_image_entity.dart';
import 'package:studio/domain/entities/image_entity.dart';
import 'package:uuid/uuid.dart';

class FavoritesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _collectionName = 'favorites';
  
  // Get current user ID
  String? get _userId => _auth.currentUser?.uid;
  
  // Check if user is logged in
  bool get isUserLoggedIn => _userId != null;

  // Get favorites collection reference for current user
  CollectionReference<Map<String, dynamic>> get _favoritesCollection => 
      _firestore.collection(_collectionName);

  // Add image to favorites
  Future<Either<Failure, FavoriteImageEntity>> addToFavorites(PageImageData imageData) async {
    try {
      if (!isUserLoggedIn) {
        return Left(Failure(401, 'User not logged in'));
      }
      
      // Check if image is already in favorites
      final existingFavorite = await _favoritesCollection
          .where('userId', isEqualTo: _userId)
          .where('imageUrl', isEqualTo: imageData.url)
          .get();
      
      if (existingFavorite.docs.isNotEmpty) {
        // Image already in favorites, return the existing entity
        return Right(FavoriteImageEntity.fromFirestore(existingFavorite.docs.first));
      }
      
      // Create new favorite entity
      final id = const Uuid().v4();
      final favoriteImage = FavoriteImageEntity(
        id: id,
        imageUrl: imageData.url,
        imageType: imageData.imageType,
        userId: _userId!,
        addedAt: DateTime.now(),
      );
      
      // Save to Firestore
      await _favoritesCollection.doc(id).set(favoriteImage.toMap());
      
      return Right(favoriteImage);
    } catch (e) {
      return Left(Failure(500, 'Failed to add to favorites: ${e.toString()}'));
    }
  }
  
  // Remove image from favorites
  Future<Either<Failure, bool>> removeFromFavorites(String imageUrl) async {
    try {
      if (!isUserLoggedIn) {
        return Left(Failure(401, 'User not logged in'));
      }
      
      // Find the favorite document
      final querySnapshot = await _favoritesCollection
          .where('userId', isEqualTo: _userId)
          .where('imageUrl', isEqualTo: imageUrl)
          .get();
      
      if (querySnapshot.docs.isEmpty) {
        return const Right(false); // Image not in favorites
      }
      
      // Delete the document
      await _favoritesCollection.doc(querySnapshot.docs.first.id).delete();
      
      return const Right(true);
    } catch (e) {
      return Left(Failure(500, 'Failed to remove from favorites: ${e.toString()}'));
    }
  }
  
  // Check if an image is in favorites
  Future<Either<Failure, bool>> isImageFavorite(String imageUrl) async {
    try {
      if (!isUserLoggedIn) {
        return const Right(false); // Not logged in, so not favorite
      }
      
      final querySnapshot = await _favoritesCollection
          .where('userId', isEqualTo: _userId)
          .where('imageUrl', isEqualTo: imageUrl)
          .get();
      
      return Right(querySnapshot.docs.isNotEmpty);
    } catch (e) {
      return Left(Failure(500, 'Failed to check favorite status: ${e.toString()}'));
    }
  }
  
  // Get all favorite images for current user
  Future<Either<Failure, List<FavoriteImageEntity>>> getFavorites() async {
    try {
      if (!isUserLoggedIn) {
        return Left(Failure(401, 'User not logged in'));
      }
      
      final querySnapshot = await _favoritesCollection
          .where('userId', isEqualTo: _userId)
          .orderBy('addedAt', descending: true)
          .get();
      
      final favorites = querySnapshot.docs
          .map((doc) => FavoriteImageEntity.fromFirestore(doc))
          .toList();
      
      return Right(favorites);
    } catch (e) {
      print(e);


      return Left(Failure(500, 'Failed to get favorites: ${e.toString()}'));
    }
  }
}