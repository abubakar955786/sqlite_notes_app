import 'package:flutter/material.dart';
import 'package:sqlite_notes_app/db_helper.dart';
import 'package:sqlite_notes_app/model.dart';
import 'package:sqlite_notes_app/notes_screen.dart';

class EditScreen extends StatefulWidget {
  final String title, description;
  final int? id;
  const EditScreen({Key? key, required this.title, required this.description, this.id}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {

  late TextEditingController titleController = TextEditingController(text: widget.title);
  late TextEditingController descriptionController = TextEditingController(text: widget.description);


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
              dbHelper!.edit(NotesModel(
                id: widget.id,
                  title: titleController.text.toString(),
                  description: descriptionController.text.toString())).then((value){
                    notesList = dbHelper!.getNotesList();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Update Successfully"), backgroundColor: Colors.green,));
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const NotesScreen()));
              }).onError((error, stackTrace){
                print("Error");
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
