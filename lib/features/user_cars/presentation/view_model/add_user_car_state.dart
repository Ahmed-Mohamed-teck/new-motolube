abstract class AddUserCarState {}

class AddUserCarInitial extends AddUserCarState {}

class AddUserCarLoading extends AddUserCarState {}

class AddUserCarSuccess extends AddUserCarState {}

class AddUserCarError extends AddUserCarState {
  final String message;

  AddUserCarError(this.message);
}