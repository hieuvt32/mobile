import 'package:flutter/material.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/config/frappe_palette.dart';
import 'package:frappe_app/model/config.dart';
import 'package:frappe_app/utils/frappe_icon.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/awesome_bar/awesome_bar_view.dart';
import 'package:frappe_app/views/custom_navbar_widget.dart';
import 'package:frappe_app/views/desk/desk_view.dart';
import 'package:frappe_app/views/home/home_child_view.dart';
import 'package:frappe_app/views/profile_view.dart';
import 'package:frappe_app/widgets/user_avatar.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  String? module;

  @override
  Widget build(BuildContext context) {
    // return PersistentTabView.custom(
    //   context,
    //   itemCount: 3,
    //   controller: _controller,
    //   screens: _buildScreens(),

    //   customWidget: CustomNavBarWidget(
    //     items: _navBarsItems(),
    //     onItemSelected: (index) {
    //       setState(() {
    //         _controller.index = index;
    //       });
    //     },
    //     selectedIndex: _controller.index,
    //   ),
    // );
    var view = CustomPersistentTabView.custom(
      context,
      controller: _controller,
      itemCount: _navBarsItems()
          .length, // This is required in case of custom style! Pass the number of items for the nav bar.
      screens: _buildScreens(),
      confineInSafeArea: true,
      handleAndroidBackButtonPress: true,
      customWidget: CustomNavBarWidget(
        // Your custom widget goes here
        items: _navBarsItems(),
        selectedIndex: 1,
        onItemSelected: (index) {
          setState(() {
            _controller.index =
                index; // NOTE: THIS IS CRITICAL!! Don't miss it!
          });
        },
      ),
      resizeToAvoidBottomInset: true,
      navBarHeight: 86,
    );
    return view;

    // PersistentTabView(
    //   context,
    //   controller: _controller,
    //   decoration: NavBarDecoration(boxShadow: [BoxShadow()]),
    //   screens: _buildScreens(),
    //   items: _navBarsItems(),
    //   navBarStyle: NavBarStyle.style13,
    //   backgroundColor: hexToColor('#007BFF'),
    //   navBarHeight: 75,
    // );
  }

  List<Widget> _buildScreens() {
    return [
      Awesombar(
        (String selectedModule) {
          setState(
            () {
              module = selectedModule;
              _controller.index = 0;
            },
          );
        },
      ),
      HomeChildView(),
      ProfileView(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        title: '',
        inactiveIcon: FrappeIcon(
          FrappeIcons.card_collection,
          color: FrappePalette.grey[500],
        ),
        icon: FrappeIcon(
          FrappeIcons.card_collection,
          size: 15,
        ),
        activeColorPrimary: FrappePalette.grey[800]!,
        inactiveColorPrimary: FrappePalette.grey[500],
        activeColorSecondary: FrappePalette.grey[800]!,
      ),
      PersistentBottomNavBarItem(
        title: '',
        icon: FrappeIcon(
          FrappeIcons.home_custom,
          size: 15,
        ),
        inactiveIcon: FrappeIcon(
          FrappeIcons.home_custom,
          size: 15,
          color: Colors.white,
        ),
        activeColorPrimary: FrappePalette.grey[800]!,
        inactiveColorPrimary: FrappePalette.grey[500],
      ),
      PersistentBottomNavBarItem(
        title: '',
        icon: FrappeIcon(
          FrappeIcons.vector,
          size: 15,
        ),
        activeColorPrimary: FrappePalette.grey[800]!,
        inactiveColorPrimary: FrappePalette.grey[500],
      ),
    ];
  }
}

// class CustomNavBarWidget extends StatelessWidget {
//   final int selectedIndex;
//   final List<PersistentBottomNavBarItem> items;
//   final ValueChanged<int> onItemSelected;

//   CustomNavBarWidget({
//     required this.selectedIndex,
//     required this.items,
//     required this.onItemSelected,
//   });

//   Widget _buildItem(PersistentBottomNavBarItem item, bool isSelected) {
//     return Container(
//       alignment: Alignment.center,
//       height: kBottomNavigationBarHeight,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Flexible(
//             child: IconTheme(
//               data: IconThemeData(
//                   size: 26.0,
//                   color: isSelected
//                       ? (item.activeColorSecondary == null
//                           ? item.activeColorPrimary
//                           : item.activeColorSecondary)
//                       : item.inactiveColorPrimary == null
//                           ? item.activeColorPrimary
//                           : item.inactiveColorPrimary),
//               child: isSelected ? item.icon : item.inactiveIcon ?? item.icon,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 5.0),
//             child: Material(
//               type: MaterialType.transparency,
//               child: FittedBox(
//                   child: Text(
//                 item.title!,
//                 style: TextStyle(
//                     color: isSelected
//                         ? (item.activeColorSecondary == null
//                             ? item.activeColorPrimary
//                             : item.activeColorSecondary)
//                         : item.inactiveColorPrimary,
//                     fontWeight: FontWeight.w400,
//                     fontSize: 12.0),
//               )),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: Container(
//         width: double.infinity,
//         height: kBottomNavigationBarHeight,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: items.map((item) {
//             int index = items.indexOf(item);
//             return TextButton(
//               style: ButtonStyle(
//                 overlayColor: MaterialStateProperty.all(Colors.transparent),
//               ),
//               onPressed: () {
//                 this.onItemSelected(index);
//               },
//               child: _buildItem(item, selectedIndex == index),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }
