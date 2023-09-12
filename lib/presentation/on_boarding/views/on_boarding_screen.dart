import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:studio/domain/entities/image_entity.dart';
import 'package:studio/presentation/on_boarding/views/studio_grid_tile.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../application/routes/route_names.dart';
import '../bloc/on_boarding_bloc.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

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
                  Navigator.pushNamed(context, RouteName.setting);
                },
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
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
                    Navigator.pushNamed(context, RouteName.imageViewer,
                        arguments: item);
                  },
                  child: Hero(
                    tag: item.url,
                    child: StudioImageTile(
                      imageEntity: item,
                    ),
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
}
