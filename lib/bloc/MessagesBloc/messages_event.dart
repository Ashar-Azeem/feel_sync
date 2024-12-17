part of 'messages_bloc.dart';

abstract class MessagesEvent extends Equatable {
  const MessagesEvent();

  @override
  List<Object> get props => [];
}

class SeenChecker extends MessagesEvent {}

class InitChat extends MessagesEvent {
  final Chat chat;
  final User ownerUser;

  const InitChat({required this.ownerUser, required this.chat});
}

class DisposeSeen extends MessagesEvent {}

class SendMessage extends MessagesEvent {
  final String messageText;
  final EmotionDetectionManager edm;

  const SendMessage({required this.edm, required this.messageText});
}
