part of 'chats_bloc.dart';

class ChatsState extends Equatable {
  final List<Chat> chats;
  final List<Chat> searchedChat;
  final Searching searching;
  final SearchingState searchingState;
  const ChatsState(
      {this.searchingState = SearchingState.done,
      this.searching = Searching.no,
      this.searchedChat = const [],
      this.chats = const []});

  ChatsState copyWith(
      {List<Chat>? chats,
      List<Chat>? searchedChat,
      Searching? searching,
      SearchingState? searchingState}) {
    return ChatsState(
      chats: chats ?? this.chats,
      searchedChat: searchedChat ?? this.searchedChat,
      searching: searching ?? this.searching,
      searchingState: searchingState ?? this.searchingState,
    );
  }

  @override
  List<Object> get props => [chats, searchedChat, searching, searchingState];
}

enum Searching { yes, no }

enum SearchingState { loading, done }
