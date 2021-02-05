import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_area/generated/l10n.dart';
import 'package:personal_area/models/note.dart';

part 'add_note_state.dart';

class AddNoteCubit extends Cubit<AddNoteState> {
  AddNoteCubit() : super(AddNoteInitial());

  TextEditingController controllerTitle = new TextEditingController();
  TextEditingController controllerContent = new TextEditingController();
  final formKey = GlobalKey<FormState>();

  titleValidator(value) {
    if (controllerTitle.text.isEmpty && controllerContent.text.isEmpty) {
      return S.current.theFieldTitleOrContentCannotBeEmpty;
    }
    return null;
  }

  contentValidator(value) {
    if (controllerContent.text.isEmpty && controllerTitle.text.isEmpty) {
      return S.current.theFieldTitleOrContentCannotBeEmpty;
    }
    return null;
  }

  saveNote(context, uid) async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      Note newNote = new Note(
        title: controllerTitle.text, 
        content: controllerContent.text, 
        state: NoteState.unspecified,
        createdAt: DateTime.now(),
        modifiedAt: DateTime.now(),
      );
      await newNote.saveToFireStore(uid);
      Navigator.pop(context);
    }
  }
}
