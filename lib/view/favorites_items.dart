import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netwrok/Cubit/home_cubit.dart';
import 'package:netwrok/Cubit/home_cubit_state.dart';
import 'package:netwrok/Widget/home_screen/build_list_view.dart';
import 'package:netwrok/view/details_Screen.dart';

class FavoritesItemsScreen extends StatelessWidget {
  const FavoritesItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color.fromRGBO(47, 70, 109, 60),
          body: HomeCubit.get(context).product == null
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: HomeCubit.get(context).favProduct!.isEmpty
                      ? Center(child: Text("Not Favorites items selected",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 30),))
                      : ListView.separated(
                          itemBuilder: (context, index) {
                            return Container(
                              height: 100,
                              clipBehavior: Clip.antiAlias,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                        offset: Offset(0, 5), blurRadius: 8)
                                  ]),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image(
                                      image: NetworkImage(
                                          "${HomeCubit.get(context).favProduct![index].image}"),
                                      fit: BoxFit.fill,
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${HomeCubit.get(context).favProduct![index].title}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        HomeCubit.get(context)
                                            .changeFavoriteIcon(
                                                product: HomeCubit.get(context)
                                                    .favProduct![index]);
                                        // cubit.getProducts();
                                      },
                                      icon: HomeCubit.get(context)
                                              .favProduct![index]
                                              .isFavorite
                                          ? Icon(Icons.favorite)
                                          : Icon(Icons.favorite_border))
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 5,
                              ),
                          itemCount: HomeCubit.get(context).favProduct!.length),
                ),
        );
      },
    );
  }
}
