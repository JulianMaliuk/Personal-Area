
part of 'notes_cubit.dart';

@immutable
abstract class NotesState {
  const NotesState();
}

class NotesInitial extends NotesState {
  const NotesInitial();
}

class NotesLoading extends NotesState {
  const NotesLoading();
}

class NavigateToAuthPage extends NotesState {
  const NavigateToAuthPage();
}

class NotesLoaded extends NotesState {
  final Note notes;
  const NotesLoaded(this.notes);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is NotesLoaded && o.notes == notes;
  }

  @override
  int get hashCode => notes.hashCode;
}

class NotesError extends NotesState {
  final String message;
  const NotesError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is NotesError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
