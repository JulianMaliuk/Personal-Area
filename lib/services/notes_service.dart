import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_area/models/note.dart';

extension NoteDocument on DocumentSnapshot {
  Note toNote() => exists
    ? Note(
      id: id,
      title: data()['title'],
      content: data()['content'],
      state: NoteState.values[data()['state'] ?? 0],
      createdAt: DateTime.fromMillisecondsSinceEpoch(data()['createdAt'] ?? 0),
      modifiedAt: DateTime.fromMillisecondsSinceEpoch(data()['modifiedAt'] ?? 0),
    )
    : null;
}

extension NoteStore on Note {
  /// Save this note in FireStore.
  ///
  /// If this's a new note, a FireStore document will be created automatically.
  Future<dynamic> saveToFireStore(String uid) async {
    final col = notesCollection(uid);
    return id == null
      ? col.add(toJson())
      : col.doc(id).update(toJson());
  }

  Future<dynamic> removeFromFireStore(String uid) async {
    final col = notesCollection(uid);
    return col.doc(id).delete();
  }

  Future<void> updateState(NoteState state, String uid) async => id == null
    ? updateWith(state: state) // new note
    : updateNoteState(state, id, uid);
}

Stream<List<Note>> createNoteStream(User user) {
  final collection = notesCollection(user?.uid);
  return collection.orderBy('createdAt', descending: true)
    .snapshots()
    .handleError((e) => debugPrint('query notes failed: $e'))
    .map((snapshot) => Note.fromQuery(snapshot));
}

/// Returns reference to the notes collection of the user [uid].
CollectionReference notesCollection(String uid) => FirebaseFirestore.instance.collection('notes-$uid');

/// Returns reference to the given note [id] of the user [uid].
DocumentReference noteDocument(String id, String uid) => notesCollection(uid).doc(id);

/// Update a note to the [state], using information in the [command].
Future<void> updateNoteState(NoteState state, String id, String uid) =>
  updateNote({'state': state?.index ?? 0}, id, uid);

/// Update a note [id] of user [uid] with properties [data].
Future<void> updateNote(Map<String, dynamic> data, String id, String uid) =>
  noteDocument(id, uid).update(data);

class NetworkException implements Exception {}
