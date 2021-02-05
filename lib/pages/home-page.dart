import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:personal_area/cubit/notes_cubit.dart';
import 'package:personal_area/models/note.dart';
import 'package:personal_area/pages/add-note-dialog.dart';
import 'package:intl/intl.dart';
import 'package:personal_area/pages/edit-note-dialog.dart';

class HomePage extends StatefulWidget {
 final User currentUser;
  HomePage({
    Key key, 
    @required this.currentUser, 
  }) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotesCubit(),
      child: BlocBuilder<NotesCubit, NotesState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.currentUser.displayName),
              brightness: Brightness.dark,
              actions: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.currentUser.photoURL),
                  radius: 22,
                ),
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () => context.read<NotesCubit>().logOut(context)
                ),
              ],
            ),
            body: StreamBuilder<List<Note>>(
              stream: createNoteStream(widget.currentUser),
              builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
                if(snapshot.connectionState == ConnectionState.active) {
                  return NotesList(user: widget.currentUser, notes: snapshot.data);
                } else if(snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else return Container();
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => context.read<NotesCubit>()
                .goToPage(context, new AddNoteDialog(uid: widget.currentUser.uid)),
              child: Icon(Icons.add),
            ),
          );
        }
      )
    );
  }
}

class NotesList extends StatelessWidget {
  final User user;
  final List<Note> notes;

  const NotesList({
    Key key, 
    @required this.user, 
    @required this.notes
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StaggeredGridView.countBuilder(
      padding: const EdgeInsets.all(8.0),
      primary: false,
      crossAxisCount: 4,
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 10.0,
      itemCount: notes?.length ?? 0,
      itemBuilder: (context, index) {
        DateTime modifiedAt = notes[index].modifiedAt;
        return InkWell(
          onTap: () => context.read<NotesCubit>().goToPage(context, new EditNoteDialog(
            note: notes[index], uid: user.uid,
          )),
          onLongPress: () => context.read<NotesCubit>().showRemoveDialog(
            context, notes[index], user
          ),
          child: Container(
            decoration: new BoxDecoration(
              color: Colors.teal[100],
              borderRadius: new BorderRadius.all(Radius.circular(10.0)),
            ),
            padding: const EdgeInsets.all(14.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (notes[index].title.isNotEmpty)
                  Text(
                    notes[index].title ?? '',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                if (notes[index].title.isNotEmpty)
                  SizedBox(height: 8),
                if (notes[index].content.isNotEmpty)
                  Text(
                    notes[index].content ?? '',
                    style: TextStyle(fontSize: 14),
                  ),
                if (notes[index].content.isNotEmpty)
                  SizedBox(height: 8),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    new DateFormat(
                      modifiedAt.isSameDay(DateTime.now()) ? "HH:mm" : "dd.MM.yyyy"
                    ).format(modifiedAt),
                    style: TextStyle(fontSize: 11),
                  ),
                )
              ],
            ),
          )
        );
      },
      staggeredTileBuilder: (index) => new StaggeredTile.fit(2),
    );
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDay(DateTime other) {
    return this.year == other.year && this.month == other.month
      && this.day == other.day;
  }
}
