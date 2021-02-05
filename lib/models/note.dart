import 'package:collection_ext/iterables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

export 'package:personal_area/services/notes_service.dart';

/// State enum for a note.
enum NoteState {
  unspecified,
  pinned,
  archived,
  deleted,
}

class Note {
  final String id;
  String title;
  String content;
  NoteState state;
  DateTime createdAt;
  DateTime modifiedAt;

  Note({
    this.id,
    this.title,
    this.content,
    this.state,
    this.createdAt,
    this.modifiedAt,
  });

  /// Serializes this note into a JSON object.
  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'state': stateValue,
    'createdAt': (createdAt ?? DateTime.now()).millisecondsSinceEpoch,
    'modifiedAt': (modifiedAt ?? DateTime.now()).millisecondsSinceEpoch,
  };

  Note copy({bool updateTimestamp = false}) => Note(
    id: this.id,
    title: this.title,
    content: this.content,
    state: this.state,
    createdAt: this.createdAt,
    modifiedAt: this.modifiedAt,
  );

  /// Transforms the Firestore query [snapshot] into a list of [Note] instances.
  static List<Note> fromQuery(QuerySnapshot snapshot) => snapshot != null ? snapshot.toNotes() : [];

  /// Returns an numeric form of the state
  int get stateValue => (state ?? NoteState.unspecified).index;

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Note &&
      o.id == id &&
      o.title == title &&
      o.content == content &&
      o.state == state &&
      o.createdAt == createdAt &&
      o.modifiedAt == modifiedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      content.hashCode ^
      state.hashCode ^
      createdAt.hashCode ^
      modifiedAt.hashCode;
  }

  Note updateWith({
    String id,
    String title,
    String content,
    NoteState state,
    bool updateTimestamp = true,
  }) {
    if (title != null) this.title = title;
    if (content != null) this.content = content;
    if (state != null) this.state = state;
    if (updateTimestamp) modifiedAt = DateTime.now();
    return this;
  }

  @override
  String toString() {
    return 'Note(id: $id, title: $title, content: $content, state: $state, createdAt: $createdAt, modifiedAt: $modifiedAt)';
  }
}

/// Add note related methods to [QuerySnapshot].
extension NoteQuery on QuerySnapshot {
  /// Transforms the query result into a list of notes.
  List<Note> toNotes() => docs
    .map((d) => d.toNote())
    .nonNull
    .asList();
}

/// Add note related methods to [QuerySnapshot].
extension NoteDocument on DocumentSnapshot {
  /// Transforms the query result into a list of notes.
  Note toNote() => exists
    ? Note(
      id: id,
      title: data()['title'],
      content: data()['content'],
      state: NoteState.values[data()['state'] ?? 0],
      createdAt: DateTime.fromMillisecondsSinceEpoch(data()['createdAt'] ?? 0),
      modifiedAt: DateTime.fromMillisecondsSinceEpoch(data()['modifiedAt']) ?? DateTime.fromMillisecondsSinceEpoch(data()['createdAt']) ?? 0,
    )
    : null;
}