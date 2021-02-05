
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_area/cubit/add_note_cubit.dart';
import 'package:personal_area/generated/l10n.dart';

class AddNoteDialog extends StatefulWidget {
  final String uid;
  const AddNoteDialog({Key key, @required this.uid}) : super(key: key);

  @override
  AddNoteDialogState createState() => new AddNoteDialogState();
}

class AddNoteDialogState extends State<AddNoteDialog> {
  
  @override
  Widget build(BuildContext context) {
    return new BlocProvider(
      create: (context) => AddNoteCubit(),
      child: Builder(builder: (context) => Scaffold(
        appBar: new AppBar(
          title: Text(S.of(context).newNote),
          brightness: Brightness.dark,
          actions: [
            new FlatButton(
              onPressed: () => context.read<AddNoteCubit>().saveNote(context, widget.uid),
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
              key: context.select((AddNoteCubit cubit) => cubit.formKey),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: context.select((AddNoteCubit cubit) => cubit.controllerTitle),
                    decoration: new InputDecoration(
                      labelText: S.of(context).title,
                      errorMaxLines: 2,
                      suffixStyle: const TextStyle(color: Colors.green)
                    ),
                    validator: (value) => context.read<AddNoteCubit>().titleValidator(value),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: context.select((AddNoteCubit cubit) => cubit.controllerContent),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: new InputDecoration(
                      labelText: S.of(context).content,
                      errorMaxLines: 2,
                      suffixStyle: const TextStyle(color: Colors.green)
                    ),
                    validator: (value) => context.read<AddNoteCubit>().contentValidator(value),
                  ) 
                ]
              )
            )
          ),
        ),
      ))
    );
  }
}