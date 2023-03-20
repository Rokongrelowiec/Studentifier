import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final AppBar appBar;
  final bool isBackIcon;
  final IconData backIcon;
  final VoidCallback? backFunction;
  final List<Widget>? actionsList;

  AppBarWidget({
    super.key,
    required this.title,
    required this.appBar,
    this.isBackIcon = true,
    this.backIcon = Icons.arrow_back_ios_rounded,
    this.backFunction,
    this.actionsList,
  });

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height * 0.01;
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).textTheme.headline1?.color,
          fontSize: sizeHeight * 3,
        ),
      ),
      iconTheme: Theme.of(context).iconTheme,
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.orangeAccent, Colors.deepOrangeAccent])),
      ),
      centerTitle: true,
      leading: isBackIcon
          ? IconButton(
              onPressed: backFunction,
              icon: Icon(
                backIcon,
                color: Theme.of(context).iconTheme.color,
                size: sizeHeight * 4,
              ),
            )
          : null,
      actions: actionsList,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
