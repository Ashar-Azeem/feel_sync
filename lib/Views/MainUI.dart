import 'package:feel_sync/Utilities/ReusableUI/CustomAvatar.dart';
import 'package:feel_sync/Services/AuthService.dart';
import 'package:feel_sync/Views/AnalysisView.dart';
import 'package:feel_sync/Views/MyChats.dart';
import 'package:feel_sync/Views/Profile.dart';
import 'package:feel_sync/Views/Users.dart';
import 'package:feel_sync/bloc/ExploreUsers/explore_users_bloc.dart';
import 'package:feel_sync/bloc/user/user_bloc.dart';
import 'package:feel_sync/bloc/user/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:sizer/sizer.dart';

class MainUI extends StatefulWidget {
  const MainUI({super.key});

  @override
  State<MainUI> createState() => _MainUIState();
}

class _MainUIState extends State<MainUI> {
  late UserBloc userBloc;
  late PersistentTabController _controller;

  @override
  void dispose() {
    userBloc.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    userBloc = UserBloc();
    _controller = PersistentTabController(initialIndex: 1);
  }

  List<Widget> _buildScreens() {
    return [
      const MyChatsView(),
      const UsersListView(),
      const Analysisview(),
      const ProfileView(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => userBloc),
        BlocProvider(create: (_) => ExploreUsersBloc())
      ],
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          final user = AuthService().getUser();
          if (user != null) {
            context.read<UserBloc>().add(FetchUser(userId: user.uid));
          }
          if (state.state == States.done) {
            return PersistentTabView(
              backgroundColor: const Color.fromARGB(255, 12, 15, 20),
              hideNavigationBarWhenKeyboardAppears: true,
              context,
              screens: _buildScreens(),
              controller: _controller,
              navBarStyle: NavBarStyle.style3,
              items: [
                PersistentBottomNavBarItem(
                  icon: const Icon(
                    Icons.message_rounded,
                  ),
                  activeColorPrimary: Colors.white,
                  activeColorSecondary: const Color.fromARGB(255, 8, 152, 204),
                  iconSize: 30,
                ),
                PersistentBottomNavBarItem(
                  icon: const Icon(
                    Icons.search_rounded,
                  ),
                  activeColorPrimary: Colors.white,
                  activeColorSecondary: const Color.fromARGB(255, 8, 152, 204),
                  iconSize: 30,
                ),
                PersistentBottomNavBarItem(
                  icon: const Icon(
                    Icons.bar_chart,
                  ),
                  activeColorPrimary: Colors.white,
                  activeColorSecondary: const Color.fromARGB(255, 8, 152, 204),
                  iconSize: 30,
                ),
                PersistentBottomNavBarItem(
                    activeColorPrimary: const Color.fromARGB(255, 8, 152, 204),
                    icon: BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 2.w),
                          child: CustomAvatar(
                            radius: 1.3.w,
                            url: state.user!.profileLocation,
                          ),
                        );
                      },
                    )),
              ],
            );
          } else if (state.state == States.error) {
            return const Scaffold(
                body: Center(
                    child:
                        Text("Something went wrong, please try again later")));
          } else {
            return const Scaffold(
                body: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
                strokeCap: StrokeCap.round,
              ),
            ));
          }
        },
      ),
    );
  }
}
