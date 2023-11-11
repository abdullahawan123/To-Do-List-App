import 'package:flutter/material.dart';
import 'package:to_do_list_app/home_screen.dart';
import 'Database/data_model.dart';
import 'Database/db_handler.dart';

class EditScreen extends StatefulWidget {
  final int id ;
  final String title ;
  final String description ;
  const EditScreen({super.key, required this.id, required this.title, this.description = ''});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final titleController = TextEditingController() ;
  final descriptionController = TextEditingController() ;
  DBHelper dbHelper = DBHelper();
  late Future<List<DataModel>> dataList;

  Future<List<DataModel>> loadData() async {
    return dbHelper.read();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataList = loadData();
    titleController.text = widget.title ;
    descriptionController.text = widget.description ;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
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
                  const Text('Edit Task', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                  SizedBox(height: MediaQuery.sizeOf(context).height * .01,),
                  const Text('You can always change your plan, but only if you have one.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.blueGrey),),
                  SizedBox(height: MediaQuery.sizeOf(context).height * .03,),
                  TextFormField(
                    controller: titleController,
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
                    controller: descriptionController,
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
                      dbHelper.update(DataModel(
                        id: widget.id,
                        title: titleController.text,
                        description: descriptionController.text
                      )).then((value) {
                        dataList = dbHelper.read();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                      }).onError((error, stackTrace){
                        debugPrint('Error: ${error.toString()}');
                      });

                    },
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
                    ),
                    child: const Text('Update', style: TextStyle(fontWeight: FontWeight.w700),),
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
