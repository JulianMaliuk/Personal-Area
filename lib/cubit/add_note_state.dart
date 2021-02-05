part of 'add_note_cubit.dart';

@immutable
abstract class AddNoteState {
  const AddNoteState();
}

class AddNoteInitial extends AddNoteState {
  const AddNoteInitial();
}

class AddNoteSaved extends AddNoteState {
  const AddNoteSaved();
}