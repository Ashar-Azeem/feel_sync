part of 'chats_bloc.dart';

class ChatsState extends Equatable {
  final List<Chat> chats;
  final List<Chat> searchedChat;
  final Searching searching;
  final SearchingState searchingState;
  final Chat? chat;
  final FindingChatStatus findingChatStatus;
  const ChatsState(
      {this.findingChatStatus = FindingChatStatus.done,
      this.chat,
      this.searchingState = SearchingState.done,
      this.searching = Searching.no,
      this.searchedChat = const [],
      this.chats = const []});

  ChatsState copyWith(
      {List<Chat>? chats,
      List<Chat>? searchedChat,
      Searching? searching,
      SearchingState? searchingState,
      Chat? chat1,
      FindingChatStatus? findingChatStatus}) {
    return ChatsState(
        chats: chats ?? this.chats,
        searchedChat: searchedChat ?? this.searchedChat,
        searching: searching ?? this.searching,
        searchingState: searchingState ?? this.searchingState,
        chat: chat1,
        findingChatStatus: findingChatStatus ?? this.findingChatStatus);
  }

  @override
  List<Object?> get props =>
      [chats, searchedChat, searching, searchingState, chat, findingChatStatus];
}

enum Searching { yes, no }

enum FindingChatStatus { loading, done }

enum SearchingState { loading, done }
