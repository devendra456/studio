import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:studio/application/core/di.dart';
import 'package:studio/application/core/show_message.dart';
import 'package:studio/application/favorites/favorites_service.dart';
import 'package:studio/application/routes/route_names.dart';
import 'package:studio/domain/entities/favorite_image_entity.dart';
import 'package:studio/presentation/on_boarding/views/studio_grid_tile.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesService _favoritesService = getIt.get<FavoritesService>();
  List<FavoriteImageEntity> _favorites = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _isUserLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _isUserLoggedIn = _favoritesService.isUserLoggedIn;
    if (_isUserLoggedIn) {
      _loadFavorites();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _favoritesService.getFavorites();

    result.fold(
      (failure) {
        log("$_errorMessage");
        setState(() {
          _errorMessage = failure.message;
          _isLoading = false;
        });
      },
      (favorites) {
        setState(() {
          _favorites = favorites;
          _isLoading = false;
        });
      },
    );
  }

  Future<void> _removeFromFavorites(FavoriteImageEntity favorite) async {
    final result = await _favoritesService.removeFromFavorites(
      favorite.imageUrl,
    );

    result.fold(
      (failure) {
        ShowMessage.show(context, failure.message);
      },
      (success) {
        if (success) {
          setState(() {
            _favorites.removeWhere(
              (item) => item.imageUrl == favorite.imageUrl,
            );
          });
          ShowMessage.show(context, 'Removed from favorites');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        actions: [
          if (_isUserLoggedIn)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadFavorites,
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (!_isUserLoggedIn) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Please log in to view your favorites'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, RouteName.login);
              },
              child: const Text('Log In'),
            ),
          ],
        ),
      );
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text(_errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadFavorites,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (_favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite_border, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('No favorite images yet'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, RouteName.home);
              },
              child: const Text('Browse Images'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFavorites,
      child: MasonryGridView.builder(
        gridDelegate: const SliverSimpleGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 180,
        ),
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        padding: const EdgeInsets.all(8),
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          final favorite = _favorites[index];
          return Dismissible(
            key: Key(favorite.id),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) async {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Remove from Favorites?"),
                    content: const Text(
                      "Are you sure you want to remove this image from your favorites?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text("Remove"),
                      ),
                    ],
                  );
                },
              );
            },
            onDismissed: (direction) {
              _removeFromFavorites(favorite);
            },
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  RouteName.imageViewer,
                  arguments: favorite.toPageImageData(),
                );
              },
              child: Stack(
                children: [
                  Card(
                    elevation: 2,
                    margin: const EdgeInsets.all(4),
                    child: Hero(
                      tag: favorite.imageUrl,
                      child: StudioImageTile(
                        imageEntity: favorite.toPageImageData(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 18,
                    ),
                    onPressed: () async{
                      final result = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Remove from Favorites?"),
                            content: const Text(
                              "Are you sure you want to remove this image from your favorites?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text("Remove"),
                              ),
                            ],
                          );
                        },
                      );
                      if(result == true) {
                        _removeFromFavorites(favorite);
                      }
                    },
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
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
