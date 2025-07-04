import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studio/domain/entities/image_entity.dart';

class FavoriteImageEntity {
  final String id;
  final String imageUrl;
  final ImageType imageType;
  final String userId;
  final DateTime addedAt;

  FavoriteImageEntity({
    required this.id,
    required this.imageUrl,
    required this.imageType,
    required this.userId,
    required this.addedAt,
  });

  // Convert to PageImageData for displaying in the app
  PageImageData toPageImageData() {
    return PageImageData(imageUrl, imageType);
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'imageType': imageType.toString(),
      'userId': userId,
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }

  // Create from Firestore document
  factory FavoriteImageEntity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FavoriteImageEntity(
      id: doc.id,
      imageUrl: data['imageUrl'] as String,
      imageType: data['imageType'].toString().contains('remote') 
          ? ImageType.remote 
          : ImageType.local,
      userId: data['userId'] as String,
      addedAt: (data['addedAt'] as Timestamp).toDate(),
    );
  }
}