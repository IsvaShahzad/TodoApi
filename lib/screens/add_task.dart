import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:http/http.dart' as http;
import '../api/api_service.dart';
import '../api/constants.dart';
import '../api/user_model.dart';
import 'get_started.dart';

class AddListScreen extends StatefulWidget {
  @override
  final List<String> tasks;

  AddListScreen({required this.tasks,});

  _AddListScreenState createState() => _AddListScreenState();
}

class _AddListScreenState extends State<AddListScreen>
    with TickerProviderStateMixin {
  TextEditingController _taskController = TextEditingController();
  List<String> _tasks = [];
  List<int> _selectedTaskIndices = [];
  var _bottomNavIndex = 0;

  //default index of a first screen

  late AnimationController _fabAnimationController;
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> fabAnimation;
  late Animation<double> borderRadiusAnimation;
  late CurvedAnimation fabCurve;
  late CurvedAnimation borderRadiusCurve;
  late AnimationController _hideBottomBarAnimationController;

  _loadCheckedTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedTaskIndices = (prefs.getStringList('checkedTasks') ?? [])
          .map((e) => int.parse(e))
          .toList();
    });
  }

  _saveCheckedTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('checkedTasks',
        _selectedTaskIndices.map((index) => index.toString()).toList());
  }

  final iconList = <IconData>[
    Icons.home,
    Icons.grid_on_outlined,
  ];
  late List<UserModel>? _userModel = [];

  @override
  void initState() {
    super.initState();

    // Initialize borderRadiusAnimation
    borderRadiusAnimation = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    ).drive(
      Tween<double>(begin: 0, end: 1).chain(
        CurveTween(curve: Curves.fastOutSlowIn),
      ),
    );

    _fabAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _borderRadiusAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    fabCurve = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
    borderRadiusCurve = CurvedAnimation(
      parent: _borderRadiusAnimationController,
      curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );

    fabAnimation = Tween<double>(begin: 0, end: 1).animate(fabCurve);
    borderRadiusAnimation = Tween<double>(begin: 0, end: 1).animate(
      borderRadiusCurve,
    );

    _hideBottomBarAnimationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    Future.delayed(
      Duration(seconds: 1),
      () => _fabAnimationController.forward(),
    );
    Future.delayed(
      Duration(seconds: 1),
      () => _borderRadiusAnimationController.forward(),
    );
    _loadTasks();
    _loadTasks();
    _loadCheckedTasks();
    _getData(); // Load checked tasks from shared preferences
  }

  // void _getData() async {
  //   try {
  //     var response = await ApiService().getUsers();
  //
  //     // Check if the response is successful
  //     if (response != null) {
  //       print('API Response: $response');
  //
  //     } else {
  //       // Handle the case where the response is null
  //       print('API Response is null');
  //     }
  //
  //     // var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint);
  //     // var response = await http.get(url);
  //     // final jsonData = json.decode(str);
  //     // print('hello');
  //     // print(response);
  //   } catch (e) {
  //     // Handle API call errors
  //     print('Error fetching API data: $e');
  //   }
  // }

  void _getData() async {
    try {
      List<UserModel>? userModel = await ApiService().getUsers();

      if (userModel != null && userModel.isNotEmpty) {
        setState(() {
          _userModel = userModel;
        });
      } else {
        // Handle case where userModel is null or empty
        print('No data fetched from the API.');
      }
    } catch (e) {
      // Handle API call errors
      print('Error fetching API data: $e');
    }
  }


  Future<void> updateTask(String taskId, String newName) async {
    var url = Uri.parse('https://todolist-d01w.onrender.com/todos/update');
    var response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'id': taskId,
        'name': newName,
      }),
    );

    if (response.statusCode == 200) {
      print('Task updated successfully');
    } else {
      print('Failed to update task: ${response.reasonPhrase}');
    }
  }
  Future<void> deleteTask(String taskId) async {
    var request = http.Request(
      'DELETE',
      Uri.parse('https://todolist-d01w.onrender.com/todos/delete'),
    );
    request.headers.addAll(<String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
    request.body = jsonEncode({'id': taskId}); // Pass taskId dynamically

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification &&
        notification.metrics.axis == Axis.vertical) {
      switch (notification.direction) {
        case ScrollDirection.forward:
          _hideBottomBarAnimationController.reverse();
          _fabAnimationController.forward(from: 0);
          break;
        case ScrollDirection.reverse:
          _hideBottomBarAnimationController.forward();
          _fabAnimationController.reverse(from: 1);
          break;
        case ScrollDirection.idle:
          break;
      }
    }
    return false;
  }

  void _displayDeleteMotionToast() {
    MotionToast.delete(
      title: const Text(
        'Deleted',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: const Text('The task is deleted'),
      animationType: AnimationType.fromBottom,
      position: MotionToastPosition.top,
    ).show(context);
  }

  _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _tasks = prefs.getStringList('tasks') ?? [];
    });
  }

  _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('tasks', _tasks);
  }

  List<Color> borderColors = [
    Colors.blueGrey,
    Colors.amber,
    Colors.purple,
    Colors.cyan,
    Colors.teal,

    // Add more colors as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf2e8ff),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF99a9dd),

        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 27,
        ),

        onPressed: () async {
          final addedTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );

          // Check if a task was added
          if (addedTask != null) {
            // Add the task to the list
            setState(() {
              _tasks.add(addedTask);
              _saveTasks(); // Save the tasks
            });
          }
        },
        shape: CircleBorder(),
        elevation: 3, // Set the elevation to 0 to remove the shadow
// Set the shape to CircleBorder() for a circular button
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive ? Colors.grey[600] : Colors.grey[600];
          IconData iconData;

          // Define the icon and label based on the index
          switch (index) {
            case 0:
              iconData = Icons.home;
              break;
            case 1:
              iconData = Icons.task;
              break;
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  iconList[index],
                  size: 24,
                  color: color,
                ),
                onPressed: () {
                  setState(() {
                    _bottomNavIndex = index;
                  });

                  // Handle navigation based on the index
                  if (index == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ImageWithTextDemo(tasks: _tasks)),
                    );
                    // Navigate to the home screen
                    // Implement your navigation logic here
                  } else if (index == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddTaskScreen()),
                    );
                  }

                  // Implement your navigation logic here
                  else if (index == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddTaskScreen()),
                    );
                  }
                },
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
              )
            ],
          );
        },
        activeIndex: _bottomNavIndex,
        notchAndCornersAnimation: borderRadiusAnimation,
        splashSpeedInMilliseconds: 300,
        notchSmoothness: NotchSmoothness.defaultEdge,
        gapLocation: GapLocation.center,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        hideAnimationController: _hideBottomBarAnimationController,
        shadow: BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 1,
          spreadRadius: 0.2,
        ),
      ),

      body:
            Stack(
              children: [
                // Image container positioned at the top
                Container(
                  height: 290.0, // Adjust the height as needed
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/gig.jpeg'), // Replace with your image path
                      fit: BoxFit.cover, // Adjust the fit as needed
                    ),
                  ),
                ),



            Padding(
              padding: EdgeInsets.only(top: 250),
              child: Expanded(
                child: _userModel == null || _userModel!.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    :
                ListView.builder(
                  itemCount: _userModel!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Column(
                        children: _userModel![index].data.map((datum) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: borderColors[index % borderColors.length], // Apply color based on index
                                  width: 5, // Adjust the width as needed
                                ),
                              ),
                            ),
                            child: ListTile(

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              tileColor: Colors.white,
                              leading: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      // Show confirmation dialog
                                      bool confirmDelete = await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Confirm Deletion',style: TextStyle(fontFamily: 'Montserrat'),),
                                            content: Text('Are you sure you want to delete this task?',style: TextStyle(fontFamily: 'Montserrat'),),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(false); // Cancel
                                                },
                                                child: Text('Cancel',style: TextStyle(fontFamily: 'Montserrat'),),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(true); // Confirm
                                                },
                                                child: Text('Delete',style: TextStyle(fontFamily: 'Montserrat'),),
                                              ),
                                            ],
                                          );
                                        },
                                      );

                                      // Delete the task if confirmed
                                      if (confirmDelete == true) {
                                        deleteTask(datum.id);
                                        setState(() {
                                          _userModel!.removeAt(index);
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Task deleted successfully',style: TextStyle(fontFamily: 'Montserrat'),)),
                                        );
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.purple),
                                    onPressed: () async {
                                      String? newName = await showDialog(
                                        context: context,
                                        builder: (context) {
                                          TextEditingController controller = TextEditingController(text: datum.name);
                                          return AlertDialog(
                                            title: Text('Edit Task',style: TextStyle(fontFamily: 'Montserrat'),),
                                            content: TextField(
                                              controller: controller,
                                              decoration: InputDecoration(
                                                labelText: 'Task Name',
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(); // Cancel
                                                },
                                                child: Text('Cancel',style: TextStyle(fontFamily: 'Montserrat'),),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(controller.text); // Save
                                                },
                                                child: Text('Save',style: TextStyle(fontFamily: 'Montserrat'),),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      if (newName != null) {
                                        setState(() {
                                          datum.name = newName;
                                        });
                                        await updateTask(datum.id, newName);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Task updated successfully')),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                              // title: Text("Task ID: ${datum.id}"),
                              // subtitle: Text("Task Name: ${datum.name}"),

                              title: Text("${datum.name}", style: TextStyle(fontFamily: 'Montserrat',fontSize: 14),),
                              // subtitle: Text("Task Name: ${datum.name}"),
                              // Add more properties as needed
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                )
              ),
            )
          ],
        ),


      // body: NotificationListener<ScrollNotification>(
      //   onNotification: onScrollNotification,
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.stretch,
      //     children: <Widget>[
      //       Stack(
      //         children: [
      //           Container(
      //             height: 240, // Set the height of the image container
      //             decoration: BoxDecoration(
      //               image: DecorationImage(
      //                 image: AssetImage(
      //                   'assets/images/blue1.jfif', // Replace with your image path
      //                 ),
      //                 fit: BoxFit.cover, // Adjust the fit as needed
      //               ),
      //             ),
      //           ),
      //
      //         ],
      //       ),
      //       Container(
      //         child: Expanded(
      //           child: _tasks.isEmpty
      //               ? Center(
      //                   child: Text(
      //                     'Add new tasks!',
      //                     style: TextStyle(
      //                         fontSize: 22.0, color: Colors.grey[600]),
      //                   ),
      //                 )
      //               : Padding(
      //                   padding: EdgeInsets.only(top: 20),
      //                   child: Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Expanded(
      //                         child: ListView.builder(
      //                           itemCount: _tasks.length,
      //                           itemBuilder: (context, index) {
      //                             // Calculate the index to select the border color from the list
      //                             int colorIndex = index % borderColors.length;
      //                             Color borderColor = borderColors[colorIndex];
      //                             return Dismissible(
      //                                 key: Key(_tasks[index]),
      //                                 onDismissed: (direction) {
      //                                   setState(() {
      //                                     _tasks.removeAt(index);
      //                                     _saveTasks();
      //                                   });
      //                                   _displayDeleteMotionToast();
      //                                 },
      //                                 background: Container(color: Colors.red),
      //                                 secondaryBackground: Container(
      //                                   color: Colors.red,
      //                                   child: Row(
      //                                     mainAxisAlignment:
      //                                         MainAxisAlignment.end,
      //                                     children: <Widget>[
      //                                       Padding(
      //                                         padding:
      //                                             EdgeInsets.only(right: 20.0),
      //                                         child: Icon(
      //                                           Icons.delete,
      //                                           color: Colors.white,
      //                                         ),
      //                                       ),
      //                                     ],
      //                                   ),
      //                                 ),
      //                                 child: Card(
      //                                   color: Colors.white,
      //                                   elevation: 2,
      //                                   margin: EdgeInsets.symmetric(
      //                                     vertical: 8.0,
      //                                     horizontal: 18.0,
      //                                   ),
      //                                   shape: RoundedRectangleBorder(
      //                                     borderRadius:
      //                                         BorderRadius.circular(0.0),
      //                                   ),
      //                                   child: Container(
      //                                     decoration: BoxDecoration(
      //                                       border: Border(
      //                                         left: BorderSide(
      //                                           color:
      //                                               borderColor, // Select the border color
      //                                           width: 5.0,
      //                                         ),
      //                                       ),
      //                                     ),
      //                                     child: ListTile(
      //                                       contentPadding:
      //                                           EdgeInsets.symmetric(
      //                                         vertical: 1.0,
      //                                         horizontal: 8.0,
      //                                       ),
      //                                       leading: Checkbox(
      //                                         value: _selectedTaskIndices
      //                                             .contains(index),
      //                                         visualDensity:
      //                                             VisualDensity.compact,
      //                                         shape: CircleBorder(),
      //                                         activeColor: Colors
      //                                             .lightGreen, // Set the color when checked
      //                                         onChanged: (bool? value) {
      //                                           setState(() {
      //                                             if (value != null && value) {
      //                                               _selectedTaskIndices
      //                                                   .add(index);
      //                                             } else {
      //                                               _selectedTaskIndices
      //                                                   .remove(index);
      //                                             }
      //                                             _saveCheckedTasks(); // Save checked tasks to shared preferences
      //                                           });
      //                                         },
      //                                       ),
      //                                       title: Text(
      //                                         _tasks[index],
      //                                         style: TextStyle(
      //                                           fontSize: 15.0,
      //                                           decoration: _selectedTaskIndices
      //                                                   .contains(index)
      //                                               ? TextDecoration
      //                                                   .lineThrough // Add line-through decoration for checked tasks
      //                                               : null,
      //                                         ),
      //                                       ),
      //                                       trailing: Row(
      //                                         mainAxisSize: MainAxisSize.min,
      //                                         children: [
      //                                           IconButton(
      //                                             icon: Icon(
      //                                               Icons.edit,
      //                                               color: Colors.green[700],
      //                                               size: 21,
      //                                             ),
      //                                             onPressed: () {},
      //                                           ),
      //                                         ],
      //                                       ),
      //                                     ),
      //                                   ),
      //                                 ));
      //                           },
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController _taskController = TextEditingController();

  bool onClicked = false;

  // Future<void> deleteTask(String taskId) async {
  //   var request = http.Request(
  //       'DELETE', Uri.parse('http://3.87.63.210:4000/todos/delete'));
  //   request.headers.addAll(<String, String>{
  //     'Content-Type': 'application/json; charset=UTF-8',
  //   });
  //   request.body = jsonEncode({'id': taskId}); // Pass taskId dynamically
  //
  //   http.StreamedResponse response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     print(await response.stream.bytesToString());
  //   } else {
  //     print(response.reasonPhrase);
  //   }
  // }

  Future<void> postData(String name, String description, bool completed) async {
    try {
      var url = Uri.parse(
          'https://todolist-d01w.onrender.com/todos/add'); // Assuming tasksEndpoint is where you want to send the data
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'name': name,
          'description': description,
          'completed': completed,
          // Add more fields as needed
        }),
      );

      if (response.statusCode == 200) {
        print('Success: ${response.body}');
      } else {
        print('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _displaySuccessMotionToast() {
    MotionToast toast = MotionToast.success(
      title: const Text(
        'Task added',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      description: const Text(
        'Task has been added!',
        style: TextStyle(fontSize: 12),
      ),
      layoutOrientation: ToastOrientation.ltr,
      animationType: AnimationType.fromLeft,
      dismissable: true,
      displaySideBar: false,
    );
    toast.show(context);
    Future.delayed(const Duration(seconds: 8)).then((value) {});
  }

  void _displayErrorMotionToast() {
    MotionToast.error(
      title: const Text(
        'Error',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: const Text('Please enter your task'),
      position: MotionToastPosition.bottom,
      barrierColor: Colors.black.withOpacity(0.3),
      width: 300,
      height: 80,
      dismissable: false,
      displaySideBar: false,
      displayBorder: false,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf2e8ff),
        body: Padding(
            padding: EdgeInsets.only(top: 80),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Padding(padding: EdgeInsets.symmetric(horizontal: 30),
                  //     child: Text('Add Task,', style: TextStyle(fontSize: 27,
                  //         fontWeight: FontWeight.bold,
                  //         fontFamily: 'Montserrat'),)),

                  Container(
                    height: 238,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/imageadd.png"),
                              // fit: BoxFit.cover,

                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
              // Padding(
              //   padding: EdgeInsets.only(top: 50),
              //   child: Container(
              //     height: 110,
              //     padding: EdgeInsets.symmetric(horizontal: 10),
              //     decoration: BoxDecoration(
              //
              //       gradient: LinearGradient(
              //         begin: Alignment.topCenter,
              //         end: Alignment.bottomCenter,
              //         colors: [Color(0xffADD8E6), Color(0xffFFB6C1)],
              //       ),
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.grey.withOpacity(0.3),
              //           blurRadius: 5,
              //           offset: Offset(0, 3),
              //         ),
              //       ],
              //     ),
              //     // child: HorizontalCalendar(
              //     //   date: DateTime.now(),
              //     //   initialDate: DateTime.now(),
              //     //   textColor: Colors.white,
              //     //   backgroundColor: Colors.transparent,
              //     //   selectedColor: Colors.transparent,
              //     //   showMonth: false,
              //     //   locale: Localizations.localeOf(context),
              //     //   onDateSelected: (date) {
              //     //     // Handle date selection
              //     //   },
              //     // ),
              //   ),
              // ),


              Padding(
                padding: EdgeInsets.all(16.0),

                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            child: TextFormField(
                              controller: _taskController,

                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter Task',
                                hintStyle: TextStyle(fontSize: 13, color: Colors.grey, fontFamily: 'Montserrat'),
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                RegExp regex = RegExp(
                                    r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$');
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter your Email ';
                                } else if (!regex.hasMatch(value)) {
                                  return 'Enter according to format';
                                }
                                return null;
                              },
                            ),
                          ),
                         
                          // Container(
                          //   child: TextFormField(
                          //     style: TextStyle(
                          //       fontSize: 13,
                          //       color: Colors.black,
                          //       fontWeight: FontWeight.w600,
                          //     ),
                          //     decoration: InputDecoration(
                          //       hintText: 'Enter Date',
                          //       hintStyle: TextStyle(fontSize: 13, color: Colors.grey, fontFamily: 'Montserrat'),
                          //       filled: true,
                          //       fillColor: Colors.grey[100],
                          //       border: OutlineInputBorder(
                          //         borderRadius: BorderRadius.zero,
                          //         borderSide: BorderSide.none,
                          //       ),
                          //     ),
                          //     textInputAction: TextInputAction.next,
                          //     validator: (value) {
                          //       RegExp regex = RegExp(
                          //           r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$');
                          //       if (value == null || value.isEmpty) {
                          //         return 'Please Enter your Email ';
                          //       } else if (!regex.hasMatch(value)) {
                          //         return 'Enter according to format';
                          //       }
                          //       return null;
                          //     },
                          //   ),
                          // ),


                          SizedBox(height: 20.0),

                          ElevatedButton(
                            onPressed: () async {
                              if (_taskController.text.isNotEmpty) {
                                _displaySuccessMotionToast();
                                // Close the screen and return the task
                                Navigator.pop(
                                    context, _taskController.text);
                                // deleteTask('65d35abb87e4fd730ed745b7');
                                postData(
                                  _taskController
                                      .text, // Pass the task name
                                  "", // Provide the description (modify as needed)
                                  false, // Set the completed status (modify as needed)
                                );
                                // deleteTask("65d3517087e4fd730ed7459c");
                              } else {
                                // Display error message
                                _displayErrorMotionToast();
                              }

                              setState(() {
                                onClicked = true;
                              });
                              await Future.delayed(
                                  const Duration(milliseconds: 300));
                              setState(() {
                                onClicked = false;
                              });
                            },
                            child: Text('Add Task',style: TextStyle(fontFamily: 'Montserrat'),),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF99a9dd), // Button color
                              onPrimary: Colors.white, // Text color
                              minimumSize: const Size(20, 50),
                              maximumSize: const Size(20, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0), // Make borders square
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
            ])));
  }
}
