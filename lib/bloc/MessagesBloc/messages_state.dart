part of 'messages_bloc.dart';

class MessagesState extends Equatable {
  final Chat? chat;
  final bool seen;
  final int receiverNumber;
  final bool sendMessageLoading;
  const MessagesState({
    this.sendMessageLoading = false,
    this.receiverNumber = 2,
    this.chat,
    this.seen = false,
  });

  MessagesState copyWith({
    Chat? chat,
    bool? seen,
    int? receiverNumber,
    bool? sendMessageLoading,
  }) {
    return MessagesState(
      chat: chat ?? this.chat,
      seen: seen ?? this.seen,
      receiverNumber: receiverNumber ?? this.receiverNumber,
      sendMessageLoading: sendMessageLoading ?? this.sendMessageLoading,
    );
  }

  @override
  List<Object?> get props => [
        chat,
        seen,
        receiverNumber,
        sendMessageLoading,
      ];
}
