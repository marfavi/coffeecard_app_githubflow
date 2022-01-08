import 'package:coffeecard/model/account/register_user.dart';
import 'package:coffeecard/persistence/repositories/account_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AccountRepository repository;

  RegisterBloc({required this.repository}) : super(const RegisterState()) {
    on<AddEmail>((event, emit) async {
      emit(state.copyWith(email: event.email));
    });
    on<AddPasscode>((event, emit) async {
      emit(state.copyWith(passcode: event.passcode));
    });
    on<RemoveEmail>((event, emit) async {
      emit(const RegisterState());
    });
    on<RemovePasscode>((event, emit) async {
      emit(RegisterState(email: state.email));
    });
    on<AddName>((event, emit) async {
      emit(state.copyWith(loading: true));
      final register = RegisterUser(event.name, state.email!, state.passcode!);
      try {
        await repository.register(register);
        // TODO: Handle success
        emit(state.copyWith(name: event.name));
      } on UnauthorizedError catch (error) {
        // TODO: Handle error
        print('Error on register: ${error.message}');
      } finally {
        emit(state.copyWith(loading: false));
      }
    });
    on<RegisterEvent>((event, emit) {
      print('RegisterBloc: ${event.runtimeType}');
    });
  }
}