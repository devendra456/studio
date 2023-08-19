import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:studio/presentation/on_boarding/views/studio_grid_tile.dart';

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
            builderDelegate: PagedChildBuilderDelegate<String>(
              itemBuilder: (context, item, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RouteName.imageViewer,arguments: item);
                  },
                  child: Hero(
                    tag: item,
                    child: StudioImageTile(
                      url: item,
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
