import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_cubit.dart';
import '../bloc/home_state.dart';
import '../models/random_user_list_res.dart';
import '../services/log_service.dart';
import '../views/item_of_random_user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeCubit homeCubit;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    homeCubit = BlocProvider.of<HomeCubit>(context);
    homeCubit.onLoadRandomUserListEvent();

    scrollController.addListener((){
      if(scrollController.position.maxScrollExtent <= scrollController.offset){
        LogService.i(homeCubit.currentPage.toString());
        homeCubit.onLoadRandomUserListEvent();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(232, 232, 232, 1),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Random User - SetState"),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (previous, current){
          return current is HomeRandomUserListState;
        },
        builder: (context, state){
          if(state is HomeErrorState){
            return viewOfError(state.errorMessage);
          }
          if(state is HomeRandomUserListState){
            return viewOfRandomUserList(state.userList);
          }

          return viewOfLoading();
        },
      ),
    );
  }

  Widget viewOfLoading(){
    return Center(
      child:  CircularProgressIndicator(),
    );
  }

  Widget viewOfError(String errorMessage){
    return Center(
      child:  Text(errorMessage),
    );
  }

  Widget viewOfRandomUserList(List<RandomUser> userList){
    return ListView.builder(
      controller:  scrollController,
      itemCount: userList.length,
      itemBuilder: (context, index){
        return itemOfRendomUser(userList[index], index);
      },
    );
  }
}