import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:feel_sync/Models/Chat.dart';
import 'package:feel_sync/Models/user.dart';
import 'package:feel_sync/Services/CRUD.dart';
part 'messages_event.dart';
part 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  Timer? _timer;
  late StreamSubscription _stateSubscription;
  MessagesBloc() : super(const MessagesState()) {
    on<SeenChecker>(seenChecker);
    on<InitChat>(initChat);
    on<DisposeSeen>(disposeSeen);
  }

  void initChat(InitChat event, Emitter<MessagesState> emit) {
    if (event.ownerUser.userId == event.chat.user1UserId) {
      emit(state.copyWith(receiverNumber: 2, chat: event.chat));
    } else {
      emit(state.copyWith(receiverNumber: 1, chat: event.chat));
    }
  }

  void seenChecker(SeenChecker event, Emitter<MessagesState> emit) {
    _stateSubscription = stream.listen((newstate) {
      if (newstate.chat!.chatId != null) {
        _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
          await Crud().getChatById(state.chat!).then((chat) {
            if (state.receiverNumber == 1) {
              emit(state.copyWith(chat: chat, seen: state.chat!.user1Seen));
            } else {
              emit(state.copyWith(chat: chat, seen: state.chat!.user2Seen));
            }
          });
        });
      }
    });
  }

  void disposeSeen(DisposeSeen event, Emitter<MessagesState> emit) {
    _timer!.cancel();
    _stateSubscription.cancel();
    emit(state.copyWith(seen: false));
  }
}
