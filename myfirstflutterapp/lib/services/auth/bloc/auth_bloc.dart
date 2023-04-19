import 'package:bloc/bloc.dart';
import 'package:myfirstflutterapp/services/auth/auth_provider.dart';
import 'package:myfirstflutterapp/services/auth/bloc/auth_event.dart';
import 'package:myfirstflutterapp/services/auth/bloc/auth_state.dart';
import 'package:myfirstflutterapp/views/verify_email_view.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateUninitialized()) {
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });
    on<AuthEventRegister>((event, emit) async {
      try {
        await provider.createUser(email: event.email, password: event.password);
        await provider.sendEmailVerification();
        emit(const AuthStateNeedsVerification());
      } on Exception catch (e) {
        emit(AuthStateRegistering(e));
      }
    });
    on<AuthEventInitialize>(
      (event, emit) async {
        await provider.initializeApp();
        final user = provider.currentUser;
        if (user == null) {
          emit(const AuthStateLoggedOut(null, false));
        } else if (!user.isEmailVerified) {
          emit(const AuthStateNeedsVerification());
        } else {
          emit(AuthStateLoggedIn(user));
        }
      },
    );
    on<AuthEventLogin>(
      (event, emit) async {
        emit(const AuthStateLoggedOut(null, true));
        final email = event.email;
        final password = event.password;
        try {
          final user = await provider.logIn(email: email, password: password);
          if (!user.isEmailVerified) {
            emit(const AuthStateLoggedOut(null, false));
            emit(const AuthStateNeedsVerification());
          } else {
            emit(const AuthStateLoggedOut(null, false));
            emit(AuthStateLoggedIn(user));
          }
          emit(AuthStateLoggedIn(user));
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(e, false));
        }
      },
    );
    on<AuthEventLogout>(
      (event, emit) async {
        try {
          await provider.logOut();
          emit(const AuthStateLoggedOut(null, false));
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(e, false));
        }
      },
    );
    on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateRegistering(null));
    });
  }
}
