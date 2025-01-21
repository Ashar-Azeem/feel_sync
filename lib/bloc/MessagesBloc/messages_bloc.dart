import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:feel_sync/EmotionDetector/EmotionDetectionManager.dart';
import 'package:feel_sync/Models/Chat.dart';
import 'package:feel_sync/Models/user.dart';
import 'package:feel_sync/Services/CRUD.dart';
part 'messages_event.dart';
part 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  late StreamSubscription _documentSubscription;
  MessagesBloc() : super(const MessagesState()) {
    on<ButtonVisibility>(buttonVisibility);
    on<SeenChecker>(onSeenChcker);
    on<SeenChanged>(
      (event, emit) {
        emit(state.copyWith(chat: event.chat, seen: event.seen));
      },
    );
    on<InitChat>(initChat);
    on<SendMessage>(sendMessage);
    on<DisposeSeen>(disposeSeen);
    on<MessageSeenAction>(messageSeenAction);
  }

  void buttonVisibility(ButtonVisibility event, Emitter<MessagesState> emit) {
    if (event.text.isEmpty && state.buttonVisibility) {
      emit(state.copyWith(buttonVisibility: false));
    } else if (event.text.isNotEmpty && !state.buttonVisibility) {
      emit(state.copyWith(buttonVisibility: true));
    }
  }

  void initChat(InitChat event, Emitter<MessagesState> emit) {
    if (event.ownerUser.userId == event.chat.user1UserId) {
      emit(state.copyWith(receiverNumber: 2, chat: event.chat));
    } else {
      emit(state.copyWith(receiverNumber: 1, chat: event.chat));
    }
  }

  void onSeenChcker(SeenChecker event, Emitter<MessagesState> emit) {
    _listenToDocument();
  }

  void _listenToDocument() {
    _documentSubscription = FirebaseFirestore.instance
        .collection('chats')
        .doc(state.chat!.chatId!)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        Chat chat = Chat.fromMap(snapshot.data()!, snapshot.id);
        if (state.receiverNumber == 1 && chat.user1Seen != state.seen) {
          add(SeenChanged(chat: chat, seen: chat.user1Seen));
        } else if (state.receiverNumber == 2 && chat.user2Seen != state.seen) {
          add(SeenChanged(chat: chat, seen: chat.user2Seen));
        }
      }
    }, onError: (error) {
      addError(error.toString());
    });
  }

  void seenChecker(SeenChecker event, Emitter<MessagesState> emit) async {
    if (state.chat!.chatId != null) {
      await Crud().getChatById(state.chat!).then((chat) {
        if (state.receiverNumber == 1) {
          emit(state.copyWith(chat: chat, seen: state.chat!.user1Seen));
        } else {
          emit(state.copyWith(chat: chat, seen: state.chat!.user2Seen));
        }
      });
    }
  }

  void sendMessage(SendMessage event, Emitter<MessagesState> emit) async {
    emit(state.copyWith(sendMessageLoading: true));
    final edm = EmotionDetectionManager();
    await edm.initialize();
    String emotionKey = await edm.detectEmotion(event.messageText);
    String senderId;
    String receiverId;

    if (state.receiverNumber == 1) {
      senderId = state.chat!.user2UserId;
      receiverId = state.chat!.user1UserId;
    } else {
      senderId = state.chat!.user1UserId;
      receiverId = state.chat!.user2UserId;
    }

    await Crud()
        .insertMessage(senderId, receiverId, state.chat!, event.messageText,
            DateTime.now(), emotionKey, state.receiverNumber)
        .then((chat) {
      emit(state.copyWith(
        chat: chat,
        sendMessageLoading: false,
      ));
    });
  }

  void messageSeenAction(
      MessageSeenAction event, Emitter<MessagesState> emit) async {
    await Crud().messageSeenUpdate(
        chatId: state.chat!.chatId!, receiverNumber: state.receiverNumber);
  }

  void disposeSeen(DisposeSeen event, Emitter<MessagesState> emit) {
    _documentSubscription.cancel();
    emit(state.copyWith(seen: false));
  }
}
