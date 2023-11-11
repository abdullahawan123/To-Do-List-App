import 'package:flutter/material.dart';
import 'package:to_do_list_app/Database/data_model.dart';
import 'package:to_do_list_app/Database/db_handler.dart';
import 'package:to_do_list_app/edit_task.dart';
import 'package:to_do_list_app/task_addition.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper dbHelper = DBHelper();
  late Future<List<DataModel>> dataList;

  Future<void> _updateTaskStatus(int taskId, String status) async {
    await dbHelper.updatedStatus(taskId, status);
    dataList = dbHelper.read();
  }

  @override
  void initState() {
    super.initState();
    dataList = loadData();
  }

  Future<List<DataModel>> loadData() async {
    return dbHelper.read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          FutureBuilder(
            future: dataList,
            builder: (context, AsyncSnapshot<List<DataModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  reverse: true,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
                        Navigator.push(
                            context, MaterialPageRoute(
                            builder: (context) => EditScreen(
                              id: snapshot.data![index].id!,
                              title: snapshot.data![index].title,
                              description: snapshot.data![index].description,
                            )));
                      },
                      child: Dismissible(
                        key: ValueKey<int>(snapshot.data![index].id!),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          child: const Icon(Icons.delete),
                        ),
                        onDismissed: (DismissDirection dismissDirection){
                          dbHelper.delete(snapshot.data![index].id!);
                          dataList = dbHelper.read();
                          snapshot.data!.remove(snapshot.data![index]);
                          setState(() {});
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(snapshot.data![index].title),
                            subtitle: Text(snapshot.data![index].description),
                            trailing: InkWell(
                              onTap: (){
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Status'),
                                      content: const Text('Choose status:'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            _updateTaskStatus(snapshot.data![index].id!, 'Active');
                                            setState(() {});
                                            Navigator.pop(context, 'Active');

                                          },
                                          child: const Text('Active'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _updateTaskStatus(snapshot.data![index].id!, 'Completed');
                                            setState(() {});
                                            Navigator.pop(context, 'Completed');

                                          },
                                          child: const Text('Completed'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                                child: Text(
                                    snapshot.data![index].status
                                )),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Stack(
                  children: [
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(Colors.white70.withOpacity(.5), BlendMode.lighten),
                      child: Image.asset('assets/background1.jpg', fit: BoxFit.fill, width: double.infinity, height: double.infinity),
                    ),
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.task_alt_rounded, size: 80, color: Colors.redAccent,),
                          SizedBox(height: 5,),
                          Text('No Task! ', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const TaskAddition()));
        },
        child: const Icon(Icons.add_task_outlined, color: Colors.red,),
      ),
    );
  }
}
