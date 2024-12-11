import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:feel_sync/Models/Chat.dart';
import 'package:feel_sync/Models/user.dart';
import 'package:feel_sync/Services/CRUD.dart';
part 'chats_event.dart';
part 'chats_state.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  ChatsBloc() : super(const ChatsState()) {
    on<CacheChats>(cacheChats);
    on<FetchChat>(fetchChat);
  }

  void cacheChats(CacheChats event, Emitter<ChatsState> emit) {
    List<Chat> listOfChats = [];
    for (DocumentSnapshot d in event.snapshsot) {
      listOfChats.add(Chat.fromDocumentSnapshot(d));
    }

    if (utilityFunctions(listOfChats)) {
      emit(state.copyWith(chats: listOfChats));
    }
  }

  void fetchChat(FetchChat event, Emitter<ChatsState> emit) async {
    emit(state.copyWith(findingChatStatus: FindingChatStatus.loading));
    //First checking in the local cache
    List<Chat> filteredChats = state.chats.where((chat) {
      return ((chat.user1UserId == event.ownerUser.userId &&
              chat.user2UserId == event.otherUser.userId) ||
          (chat.user1UserId == event.otherUser.userId &&
              chat.user2UserId == event.ownerUser.userId));
    }).toList();
    if (filteredChats.isNotEmpty) {
      emit(state.copyWith(chat: filteredChats[0]));
    } else {
      await Crud().getChat(event.ownerUser, event.otherUser).then((chat) async {
        if (chat != null) {
          emit(state.copyWith(
              chat: chat, findingChatStatus: FindingChatStatus.done));
        } else {
          await Crud()
              .createChat(
                  ownerUser: event.ownerUser, otherUser: event.otherUser)
              .then((chat) {
            emit(state.copyWith(
                chat: chat, findingChatStatus: FindingChatStatus.done));
          });
        }
      });
    }
  }

//Utility Functions:
  bool utilityFunctions(List<Chat> newChatsList) {
    for (Chat chat in newChatsList) {
      if (!state.chats.contains(chat)) {
        return true;
      }
    }
    return false;
  }
}
