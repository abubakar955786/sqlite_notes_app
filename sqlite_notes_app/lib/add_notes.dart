import 'package:flutter/material.dart';
import 'package:sqlite_notes_app/db_helper.dart';
import 'package:sqlite_notes_app/model.dart';
import 'package:sqlite_notes_app/notes_screen.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({Key? key}) : super(key: key);

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();


  DBHelper? dbHelper;
  late Future<List<NotesModel>> notesList;

  @override
  void initState() {
    dbHelper = DBHelper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Add Notes"),
      ),

      body: Column(
        children: [
          Container(
            height: 300,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 50,horizontal: 30),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.brown, width: 3),
              borderRadius: BorderRadius.circular(15)
            ),
            child: Column(
              children: [
                TextFormField(
                  maxLines: 1,
                  controller: titleController,
                  style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 25),
                  decoration: const InputDecoration(
                    hintText: "Title",
                    border: InputBorder.none
                  ),
                ),
                TextFormField(
                  maxLines: 7,
                  controller: descriptionController,
                  decoration: const InputDecoration(
                      hintText: "Description",
                      border: InputBorder.none
                  ),
                )
              ],
            ),
          ),
          
          InkWell(
            onTap: (){
              dbHelper!.insert(NotesModel(
                  title: titleController.text.toString(),
                  description: descriptionController.text.toString())).then((value){
                    setState(() {
                      notesList = dbHelper!.getNotesList();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const NotesScreen()));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Notes Added"), backgroundColor: Colors.green,));
                    });
              }).onError((error, stackTrace){
                ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text("Error"), backgroundColor: Colors.redAccent,));
              });
            },
            child: Container(
              height: 50,
              margin: const  EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.brown,
                borderRadius: BorderRadius.circular(15)
              ),
              child: const Center(child: Text("Save",style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),),
            ),
          )
        ],
      ),
    );
  }
}
