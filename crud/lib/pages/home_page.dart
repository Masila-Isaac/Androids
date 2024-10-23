import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/pages/services/firestore.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // Firestore service
  final FirestoreService firestoreService = FirestoreService();

  // Text controller
  final TextEditingController textController = TextEditingController();

  // Function to open dialog box for adding or editing text
  void openNoteBox(String? docID) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: docID == null ? "Enter note" : "Edit note",
                ),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      // Add new note or update existing note
                      if (docID == null) {
                        firestoreService.addNote(textController.text);
                      } else {
                        firestoreService.updateNote(docID, textController.text);
                      }
                      // Clear the text controller
                      textController.clear();
                      // Close the box
                      Navigator.pop(context);
                    },
                    child: Text(docID == null ? "Add" : "Update"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notes")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openNoteBox(null); // Pass null for new notes
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: firestoreService.getNotesStream(),
          builder: (context, snapshot) {
            // If we have data, get all documents
            if (snapshot.hasData) {
              List<DocumentSnapshot> notesList = snapshot.data!.docs;

              // Display a list
              return ListView.builder(
                itemCount: notesList.length,
                itemBuilder: (context, index) {
                  // Getting individual document
                  DocumentSnapshot document = notesList[index];

                  // Getting notes from each document
                  Map<String, dynamic>? data =
                      document.data() as Map<String, dynamic>?;
                  String notesText = data?['note'] ?? 'No note available';
                  String docID = document.id; // Get the document ID

                  // Display as a list tile
                  return ListTile(
                    title: Text(notesText),
                    trailing: IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () => openNoteBox(docID), // Open for editing
                    ),
                  );
                },
              );
            }

            // Handle the case where there is no data
            if (!snapshot.hasData) {
              return const Center(child: Text("No notes available"));
            }

            // Handle errors
            if (snapshot.hasError) {
              return const Center(child: Text("Error loading notes"));
            }

            // Show loading indicator while waiting for data
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
