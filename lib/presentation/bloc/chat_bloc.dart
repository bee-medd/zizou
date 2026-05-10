import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../core/gemini_service.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendMessageEvent extends ChatEvent {
  final String message;
  SendMessageEvent(this.message);

  @override
  List<Object?> get props => [message];
}

abstract class ChatState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}
class ChatLoading extends ChatState {}
class ChatResponse extends ChatState {
  final String response;
  ChatResponse(this.response);

  @override
  List<Object?> get props => [response];
}
class ChatError extends ChatState {
  final String error;
  ChatError(this.error);

  @override
  List<Object?> get props => [error];
}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GeminiService geminiService;

  ChatBloc(this.geminiService) : super(ChatInitial()) {
    on<SendMessageEvent>((event, emit) async {
      emit(ChatLoading());
      try {
        final response = await geminiService.chatWithContext(event.message);
        emit(ChatResponse(response));
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });
  }
}
