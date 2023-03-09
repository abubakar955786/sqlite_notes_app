import 'package:flutter/material.dart';
import 'package:sqlite_notes_app/db_helper.dart';

import 'add_notes.dart';
import 'edit_screen.dart';
import 'model.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {

  String search = "";
  bool isSearch = false;
  TextEditingController searchController = TextEditingController();


  DBHelper? dbHelper;
  late Future<List<NotesModel>> notesList;
  getData(){
    notesList = dbHelper!.getNotesList();
  }

  @override
  void initState() {
    dbHelper = DBHelper();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isSearch == false?
      AppBar(
        centerTitle: true,
        title:const Text("SQLite Notes"),
        actions: [
          IconButton(onPressed: (){
            setState(() {isSearch = true;});},
              icon: const Icon(Icons.search))
        ],
      )
      : AppBar(
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
            leading: BackButton(
              onPressed: (){setState(() {isSearch = false;});},
            ),
            title: TextFormField(
              maxLines: 1,
              controller: searchController,
              decoration: const InputDecoration(
                hintText: "Search",
                border: InputBorder.none
              ),
              onChanged: (String value){
                search = value.toString();
                setState(() {});
              },
            ),
          ),
      
      body: FutureBuilder(
        future: notesList,
        builder: (context, AsyncSnapshot<List<NotesModel>> snapshot){
          if(snapshot.hasData){
            return  ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index){
                  if(searchController.text.isEmpty){
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(snapshot.data![index].id.toString()),
                        ),
                        title: Text(snapshot.data![index].title.toString()),
                        subtitle: Text(snapshot.data![index].description.toString()),

                        trailing: PopupMenuButton(
                            itemBuilder: (context)=> [
                              PopupMenuItem(child: ListTile(
                                leading: Icon(Icons.edit,color: Colors.green,),
                                title: Text("Edit"),
                                onTap: (){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>EditScreen(
                                    id: snapshot.data![index].id,
                                    title: snapshot.data![index].title.toString(),
                                    description: snapshot.data![index].description.toString(),
                                  )));
                                },
                              )),

                              PopupMenuItem(child: ListTile(
                                leading: Icon(Icons.delete_forever,color: Colors.redAccent,),
                                title: Text("Delete"),
                                onTap: (){
                                  setState(() {
                                    dbHelper!.delete(snapshot.data![index].id!);
                                    notesList = dbHelper!.getNotesList();
                                    snapshot.data!.remove(snapshot.data![index]);
                                    Navigator.pop(context);
                                  });
                                },
                              )),

                            ]),
                      ),
                    );
                  }else if(snapshot.data![index].title.toLowerCase().contains(searchController.text.toLowerCase())){
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(snapshot.data![index].id.toString()),
                        ),
                        title: Text(snapshot.data![index].title.toString()),
                        subtitle: Text(snapshot.data![index].description.toString()),

                        trailing: PopupMenuButton(
                            itemBuilder: (context)=> [
                              PopupMenuItem(child: ListTile(
                                leading: Icon(Icons.edit,color: Colors.green,),
                                title: Text("Edit"),
                                onTap: (){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>EditScreen(
                                    id: snapshot.data![index].id,
                                    title: snapshot.data![index].title.toString(),
                                    description: snapshot.data![index].description.toString(),
                                  )));
                                },
                              )),

                              PopupMenuItem(child: ListTile(
                                leading: Icon(Icons.delete_forever,color: Colors.redAccent,),
                                title: Text("Delete"),
                                onTap: (){
                                  setState(() {
                                    dbHelper!.delete(snapshot.data![index].id!);
                                    notesList = dbHelper!.getNotesList();
                                    snapshot.data!.remove(snapshot.data![index]);
                                    Navigator.pop(context);
                                  });
                                },
                              )),
                            ]),
                      ),
                    );
                  }else{

                  }
                });
          }else{}
          return const SizedBox();
        }
      ),


      floatingActionButton: FloatingActionButton(
          onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddNotes()));},
      child:const  Icon(Icons.add),),
    );
  }
}
