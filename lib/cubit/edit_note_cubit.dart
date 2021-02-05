import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_area/generated/l10n.dart';
import 'package:personal_area/models/note.dart';

part 'edit_note_state.dart';

class EditNoteCubit extends Cubit<EditNoteState> {
  final Note note;
  Note _originNote;
  EditNoteCubit(this.note) : super(EditNoteInitial()) {
    controllerTitle.text = note.title;
    controllerContent.text = note.content;
    _originNote = note?.copy() ?? Note();
  }

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

  bool get _isDirty => note != _originNote;

  saveNote(context, uid) async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      note.updateWith(
        title: controllerTitle.text,
        content: controllerContent.text,
      );
      if(_isDirty && note.id != null) {
        note.saveToFireStore(uid);
      }
      Navigator.pop(context);
    }
  }
}