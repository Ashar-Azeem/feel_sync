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
    on<DisposeChatSelected>(disposeChat);
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
      emit(state.copyWith(chat1: filteredChats[0]));
    } else {
      await Crud().getChat(event.ownerUser, event.otherUser).then((chat) async {
        if (chat != null) {
          emit(state.copyWith(
              chat1: chat, findingChatStatus: FindingChatStatus.done));
        } else {
          Chat demoChat = Chat(
              chatId: null,
              user1UserId: event.ownerUser.userId,
              user1UserName: event.ownerUser.userName,
              user1FCMToken: event.ownerUser.token,
              user1ProfileLoc: event.ownerUser.profileLocation,
              user2UserId: event.otherUser.userId,
              user2UserName: event.otherUser.userName,
              user2FCMToken: event.otherUser.token,
              user2ProfileLoc: event.otherUser.profileLocation,
              user1Seen: true,
              user2Seen: false,
              compatibility: 0,
              user1Emotions: const {
                'Sadness': 0,
                'Joy': 0,
                'Love': 0,
                'Anger': 0,
                'Fear': 0
              },
              user2Emotions: const {
                'Sadness': 0,
                'Joy': 0,
                'Love': 0,
                'Anger': 0,
                'Fear': 0
              },
              lastMessage: '',
              lastMessageDateTime: DateTime.now());
          emit(state.copyWith(
              findingChatStatus: FindingChatStatus.done, chat1: demoChat));
        }
      });
    }
  }

  void disposeChat(DisposeChatSelected event, Emitter<ChatsState> emit) {
    emit(state.copyWith(chat1: null));
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
