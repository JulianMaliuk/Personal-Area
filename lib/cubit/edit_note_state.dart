part of 'edit_note_cubit.dart';

@immutable
abstract class EditNoteState {
  const EditNoteState();
}

class EditNoteInitial extends EditNoteState {
  const EditNoteInitial();
}

class EditNoteSaved extends EditNoteState {
  const EditNoteSaved();
}