import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:Todo_app/component.dart';
import '../view_model/cubit/cubit.dart';
import '../view_model/cubit/state.dart';

// 1. create database
// 2. create tables
// 3. open database
// 4. insert to database
// 5. get from database
// 6. update in database
// 7. delete from database

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context)
  {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if(state is AppInsertDatabaseState)
          {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            body: ConditionalBuilder(

              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),

            floatingActionButton: FloatingActionButton(
              splashColor: Colors.amber,
              onPressed: () {
                if (cubit.isBottomSheetShown)
                {
                  if (formKey.currentState!.validate())
                  {
                    cubit.insertToDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                    );
                  }
                } else
                  {
                  scaffoldKey.currentState!.showBottomSheet(
                        (context) => Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(
                            20.0,
                          ),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormField(
                                  controller: titleController,
                                  type: TextInputType.text,
                                  validate: (value){ if(value!.isEmpty) {return'It cant be empty here here';} return null; },
                                  label: 'Task Title',
                                  prefix: Icons.title,
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                defaultFormField(
                                  controller: timeController,
                                  type: TextInputType.datetime,
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      timeController.text = value!.format(context).toString();
                                      print(value.format(context));
                                    });
                                  },
                                  validate: (value){ if(value!.isEmpty) {return'It cant be empty here here';} return null; },
                                  label: 'Task Time',
                                  prefix: Icons.watch_later_outlined,
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                defaultFormField(
                                  controller: dateController,
                                  type: TextInputType.datetime,
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2023-05-03'),
                                    ).then((value) {
                                      dateController.text = DateFormat.yMMMd().format(value!).toString();
                                    });
                                  },
                                  validate: (value){ if(value!.isEmpty) {return'It cant be empty here here';} return null; },

                                  label: 'Task Date',
                                  prefix: Icons.calendar_today,
                                ),
                              ],
                            ),
                          ),
                        ),
                        elevation: 20.0,
                      ).closed.then((value)
                  {
                    cubit.changeBottomSheetState(
                      isShow: false,
                      icon: Icons.edit,
                    );
                  });
                  cubit.changeBottomSheetState(
                    isShow: true,
                    icon: Icons.add,
                  );
                }
              },
              child: Icon(
                cubit.fabIcon,
              ),
            ),

              bottomNavigationBar: BottomNavigationBar(
              unselectedItemColor:Colors.black ,
              selectedItemColor: Colors.teal,
              type: BottomNavigationBarType.shifting,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index); },
              items: [

              BottomNavigationBarItem(
                icon: Icon(Icons.menu,),
                label: 'Tasks',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.check_circle_outline,
                ),
                label: 'Done',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.archive_outlined,
                ),
                label: 'Archived',
              ),
            ],
          ),
              // GNav(
              //   gap:7,
              //   color: Colors.blueGrey, // unselected icon color
              //   activeColor: Colors.teal, // selected icon and text color
              //   iconSize: 25, // tab button icon size
              //   tabBackgroundColor: Colors.teal.withOpacity(0.2), // selected tab background color
              //   selectedIndex: cubit.currentIndex,
              //   onTabChange: (index)
              //   {
              //       cubit.changeIndex(index);
              //       },
              //   tabs: [
              //
              //     GButton(
              //       icon:Icons.menu,
              //     text: 'Tasks',
              //     ),
              //     GButton(
              //       icon:Icons.check_circle_outline_outlined,
              //       text: 'done',
              //     ),
              //     GButton(
              //       icon:Icons.archive,
              //       text: 'archive',
              //     )
              //
              //   ],
              //
              // )

          );
        },
      ),
    );
  }
}