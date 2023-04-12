import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netwrok/Cubit/home_cubit.dart';
import 'package:netwrok/Cubit/home_cubit_state.dart';

class BuildListView extends StatelessWidget {
  int? index;
  BuildListView({super.key, this.index});
  @override
  Widget build(BuildContext context) {
    var cubit = HomeCubit.get(context);
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image(
                image: NetworkImage(
                    "${HomeCubit.get(context).product![index!].image}"),
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
                "${HomeCubit.get(context).product![index!].title}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
                onPressed: () {
                  cubit
                      .changeFavoriteIcon(
                          product: HomeCubit.get(context).product![index!])
                      .then((value) {
                    cubit.insertData(HomeCubit.get(context).product![index!]);
                  }).catchError((onError) {
                    print("Error $onError");
                  });
                  // cubit.getProducts();
                },
                icon: HomeCubit.get(context).product![index!].isFavorite ==1
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_border))
          ],
        );
      },
    );
  }
}
