import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:studio/application/auth/auth_service.dart';
import 'package:studio/application/core/di.dart';
import 'package:studio/application/core/show_message.dart';
import 'package:studio/domain/entities/image_entity.dart';
import 'package:studio/presentation/on_boarding/views/studio_grid_tile.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../application/routes/route_names.dart';
import '../bloc/on_boarding_bloc.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final AuthService _authService = getIt<AuthService>();
  bool _isLoading = false;

  Future<void> _signOut() async {
    setState(() {
      _isLoading = true;
    });

    final result = await _authService.signOut();

    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
        });
        ShowMessage.show(context, failure.message);
      },
      (_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pushReplacementNamed(context, RouteName.login);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnBoardingBloc, OnBoardingState>(
      builder: (context, state) {
        final bloc = context.read<OnBoardingBloc>();
        return Scaffold(
          appBar: AppBar(
            title: const Text("Studio"),
            actions: [
              if (kIsWeb)
                IconButton(
                  onPressed: () async {
                    const url =
                        "https://drive.google.com/file/d/1FN3pOiFz8DCnvwVv49tsL9FWIwK81JTY/view?usp=sharing";
                    if (await canLaunchUrlString(url)) {
                      await launchUrlString(url);
                    }
                  },
                  icon: const Icon(Icons.android_outlined),
                ),
              if (kIsWeb)
                IconButton(
                  onPressed: () async {
                    const url =
                        "https://drive.google.com/file/d/1Nt3FQoeFWPLA4lvqU9kE6wL6WqzVo6BI/view?usp=sharing";
                    if (await canLaunchUrlString(url)) {
                      await launchUrlString(url);
                    }
                  },
                  icon: const Icon(Icons.desktop_windows_outlined),
                ),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, RouteName.favorites);
                },
                icon: const Icon(Icons.favorite),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, RouteName.setting);
                },
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
          drawer: _buildDrawer(),
          floatingActionButton: FloatingActionButton(
            onPressed: bloc.onPageRefresh,
            child: const Icon(Icons.refresh),
          ),
          body: PagedGridView(
            pagingController: bloc.pagingController,
            padding: const EdgeInsets.all(16),
            builderDelegate: PagedChildBuilderDelegate<PageImageData>(
              itemBuilder: (context, item, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RouteName.imageViewer,
                      arguments: item,
                    );
                  },
                  child: Hero(
                    tag: item.url,
                    child: StudioImageTile(imageEntity: item),
                  ),
                );
              },
            ),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 180,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawer() {
    final displayName = _authService.getUserDisplayName() ?? 'User';
    final email = _authService.getUserEmail() ?? '';
    // final photoUrl = _authService.getUserPhotoUrl();

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(displayName),
            accountEmail: Text(email),
            currentAccountPicture: const CircleAvatar(child: Icon(Icons.person, size: 40)),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('My Favorites'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushNamed(context, RouteName.favorites);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushNamed(context, RouteName.setting);
            },
          ),
          const Divider(),
          ListTile(
            leading: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: _isLoading ? null : _signOut,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Studio v1.0.0',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
