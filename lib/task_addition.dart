import 'package:flutter/material.dart';
import 'package:to_do_list_app/Database/data_model.dart';
import 'package:to_do_list_app/home_screen.dart';
import 'Database/db_handler.dart';

class TaskAddition extends StatefulWidget {
  const TaskAddition({super.key});

  @override
  State<TaskAddition> createState() => _TaskAdditionState();
}

class _TaskAdditionState extends State<TaskAddition> {

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DBHelper? dbHelper ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
              children: [
                Image.asset('assets/todologo.png'),
                SizedBox(height: MediaQuery.sizeOf(context).height * .03,),
                const Text('Create Task', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                SizedBox(height: MediaQuery.sizeOf(context).height * .01,),
                const Text('You can always change your plan, but only if you have one.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.blueGrey),),
                SizedBox(height: MediaQuery.sizeOf(context).height * .03,),
                TextFormField(
                  controller: _titleController,
                  cursorColor: Colors.redAccent,
                  decoration: InputDecoration(
                    hintText: 'Create a title.',
                    labelText: 'Title',
                    prefixIcon: const Icon(Icons.title),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )
                  ),
                ),
                SizedBox(height: MediaQuery.sizeOf(context).height * .02,),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  cursorColor: Colors.redAccent,
                  decoration: InputDecoration(
                      hintText: 'Write the   description of the task.',
                      labelText: 'Description (Optional)',
                      prefixIcon: const Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                  ),
                ),
                SizedBox(height: MediaQuery.sizeOf(context).height * .1,),
                ElevatedButton(
                    onPressed: (){
                      dbHelper!.insert(
                          DataModel(
                              title: _titleController.text.toString(),
                              description: _descriptionController.text.toString(),
                              status: 'Pending'
                          )
                      ).then((value) {
                        Navigator.push(
                            context, MaterialPageRoute(
                            builder: (context) => const HomeScreen()
                        )
                        );
                      }).onError((error, stackTrace) {
                        debugPrint(error.toString());
                      });
                    },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
                  ),
                  child: const Text('CREATE', style: TextStyle(fontWeight: FontWeight.w700),),
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
