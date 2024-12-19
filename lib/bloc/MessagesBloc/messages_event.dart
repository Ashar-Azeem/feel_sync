part of 'messages_bloc.dart';

abstract class MessagesEvent extends Equatable {
  const MessagesEvent();

  @override
  List<Object> get props => [];
}

class SeenChecker extends MessagesEvent {}

class SeenChanged extends MessagesEvent {
  final Chat chat;
  final bool seen;

  const SeenChanged({required this.chat, required this.seen});
}

class InitChat extends MessagesEvent {
  final Chat chat;
  final User ownerUser;

  const InitChat({required this.ownerUser, required this.chat});
}

class DisposeSeen extends MessagesEvent {}

class SendMessage extends MessagesEvent {
  final String messageText;
  final TextEditingController controller;

  const SendMessage({required this.controller, required this.messageText});
}

class MessageSeenAction extends MessagesEvent {}
