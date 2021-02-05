import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:personal_area/generated/l10n.dart';
import 'package:personal_area/models/note.dart';
import 'package:personal_area/pages/auth-page.dart';

part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit() : super(NotesInitial());

  logOut(context) async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => AuthPage()),
            (Route<dynamic> route) => false);
  }

  goToPage(context, page) {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return page;
        },
      fullscreenDialog: true
    ));
  }

  showRemoveDialog(context, Note note, User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).doYouWantToDeleteThisNote),
          actions: [
            ElevatedButton(onPressed: () {
              Navigator.pop(context);
            }, child: Text(S.of(context).cancel)),
            ElevatedButton(onPressed: () async {
              await note.removeFromFireStore(user.uid);
              Navigator.pop(context);
            }, child: Text(S.of(context).yes))
          ],
        );
      },
    );
  }
}
