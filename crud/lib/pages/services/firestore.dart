import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');

  // Add note to Firestore
  Future<void> addNote(String note) {
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
    });
  }

  // Read notes from the database and return a stream of documents
  Stream<QuerySnapshot> getNotesStream() {
    return notes.orderBy('timestamp', descending: true).snapshots();
  }

  //update: update notes given a doc id
  Future<void> updateNote(String docID, String NewNote) async {
    'note';
    NewNote;
    'timestamp';
    Timestamp.now();
  }
}
