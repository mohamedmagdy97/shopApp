import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/search/cubit/cubit.dart';
import 'package:shop_app/modules/search/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var searchController = TextEditingController();

    return BlocProvider(
      create: (BuildContext context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) => Scaffold(
          appBar: AppBar(),
          body: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  defaultFormField(
                    controller: searchController,
                    validator: (String val) {
                      if (val.isEmpty) {
                        return 'please enter text';
                      }
                      return null;
                    },
                    onSubmit: (String text) {
                      if (formKey.currentState.validate()) {
                        SearchCubit.get(context).searchData(text);
                      }
                    },
                    onChange: (String text) {
                      if (formKey.currentState.validate()) {
                        SearchCubit.get(context)
                            .searchData(text);
                      }
                    },
                    type: TextInputType.text,
                    pIcon: Icon(Icons.search),
                    label: 'Search',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (state is LoadingSearchState) LinearProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  // if(state is SuccessSearchState)
                  Expanded(
                    child: ConditionalBuilder(
                      condition: SearchCubit.get(context).searchModel != null,
                      builder: (context) => ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return
                              buildListProduct(
                                  SearchCubit.get(context)
                                      .searchModel
                                      .data
                                      .data[index],
                                  context,isOldPrice: false);
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 5,
                          );
                        },
                        itemCount: SearchCubit.get(context)
                            .searchModel
                            .data
                            .data
                            .length,
                      ),
                      fallback: (context) => Center(
                        child: Text('Search...'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
