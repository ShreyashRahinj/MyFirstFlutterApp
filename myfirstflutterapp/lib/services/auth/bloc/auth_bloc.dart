import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:myfirstflutterapp/services/auth/auth_provider.dart';
import 'package:myfirstflutterapp/services/auth/bloc/auth_event.dart';
import 'package:myfirstflutterapp/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });
    on<AuthEventReadData>((event, emit) async {
      try {
        emit(const AuthStateReadingData(exception: null, isLoading: true));
        final String stringData = await rootBundle.loadString(event.fileName);
        final List<dynamic> json = jsonDecode(stringData);
        final List<String> jsonStringData = json.cast<String>();
      } on Exception catch (e) {
        emit(AuthStateReadingData(exception: e, isLoading: false));
      }
    });
    on<AuthEventRegister>((event, emit) async {
      try {
        await provider.createUser(email: event.email, password: event.password);
        await provider.sendEmailVerification();
        emit(const AuthStateNeedsVerification(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateRegistering(exception: e, isLoading: false));
      }
    });
    on<AuthEventInitialize>(
      (event, emit) async {
        await provider.initializeApp();
        final user = provider.currentUser;
        if (user == null) {
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
        } else if (!user.isEmailVerified) {
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          emit(AuthStateLoggedIn(user: user, isLoading: false));
        }
      },
    );
    on<AuthEventLogin>(
      (event, emit) async {
        emit(const AuthStateLoggedOut(
            exception: null, isLoading: true, loadingText: 'Logging in'));
        final email = event.email;
        final password = event.password;
        try {
          final user = await provider.logIn(email: email, password: password);
          if (!user.isEmailVerified) {
            emit(const AuthStateLoggedOut(exception: null, isLoading: false));
            emit(const AuthStateNeedsVerification(isLoading: false));
          } else {
            emit(const AuthStateLoggedOut(exception: null, isLoading: false));
            emit(AuthStateLoggedIn(user: user, isLoading: false));
          }
          emit(AuthStateLoggedIn(user: user, isLoading: false));
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(exception: e, isLoading: false));
        }
      },
    );
    on<AuthEventLogout>(
      (event, emit) async {
        try {
          await provider.logOut();
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(exception: e, isLoading: false));
        }
      },
    );
    on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateRegistering(exception: null, isLoading: false));
    });
    on<AuthEventForgotPassword>((event, emit) async {
      emit(const AuthStateForgotPassword(
        exception: null,
        hasSentEmail: false,
        isLoading: false,
      ));
      final email = event.email;
      if (email == null) {
        return;
      }
      emit(const AuthStateForgotPassword(
        exception: null,
        hasSentEmail: false,
        isLoading: true,
      ));
      Exception? exception;
      bool didSentEmail;
      try {
        await provider.sendPasswordReset(toEmail: email);
        exception = null;
        didSentEmail = true;
      } on Exception catch (e) {
        exception = e;
        didSentEmail = false;
      }
      emit(AuthStateForgotPassword(
        exception: exception,
        hasSentEmail: didSentEmail,
        isLoading: false,
      ));
    });
  }
}
