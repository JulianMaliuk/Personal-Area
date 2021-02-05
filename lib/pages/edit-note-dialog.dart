
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_area/cubit/edit_note_cubit.dart';
import 'package:personal_area/generated/l10n.dart';
import 'package:personal_area/models/note.dart';

class EditNoteDialog extends StatelessWidget {
  final Note note;
  final String uid;
  const EditNoteDialog({
    Key key, 
    @required this.note, 
    @required this.uid
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditNoteCubit(note),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: new AppBar(
              title: Text(S.of(context).editNote),
              brightness: Brightness.dark,
              actions: [
                new FlatButton(
                  onPressed: () => context.read<EditNoteCubit>().saveNote(context, uid),
                  child: Row(children: [
                    new Text(S.of(context).save,
                    style: Theme
                        .of(context).textTheme.subtitle1
                        .copyWith(color: Colors.white)
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.check, color: Colors.white),
                  ])
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: context.select((EditNoteCubit cubit) => cubit.formKey),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: context.select((EditNoteCubit cubit) => cubit.controllerTitle),
                        decoration: new InputDecoration(
                          labelText: S.of(context).title,
                          errorMaxLines: 2,
                          suffixStyle: const TextStyle(color: Colors.green)
                        ),
                        validator: (value) => context.read<EditNoteCubit>().titleValidator(value),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: context.select((EditNoteCubit cubit) => cubit.controllerContent),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: new InputDecoration(
                          labelText: S.of(context).content,
                          errorMaxLines: 2,
                          suffixStyle: const TextStyle(color: Colors.green)
                        ),
                        validator: (value) => context.read<EditNoteCubit>().contentValidator(value),
                      ) 
                    ]
                  )
                )
              ),
            ),
          );
        }
      ),
    );
  }
}