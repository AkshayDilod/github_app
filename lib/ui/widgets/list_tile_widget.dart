import 'package:flutter/material.dart';

class ListTileWidget extends StatelessWidget {
  final String name;
  final String description;
  final String language;
  final String openIssuesCount;
  final String watcherCount;

  const ListTileWidget({
    Key? key,
    required this.name,
    required this.description,
    required this.language,
    required this.openIssuesCount,
    required this.watcherCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * .15,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        leading: const Icon(
          Icons.book,
          size: 65,
          color: Colors.black,
        ),
        title: Text(
          name,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.headline6
              ?.copyWith(fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            Text(description,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: theme.textTheme.subtitle2?.copyWith(
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                ListTileBottomIconAndText(
                  icon: Icons.code,
                  text: language,
                ),
                const SizedBox(
                  width: 10,
                ),
                ListTileBottomIconAndText(
                  icon: Icons.bug_report,
                  text: openIssuesCount,
                ),
                const SizedBox(
                  width: 10,
                ),
                ListTileBottomIconAndText(
                  icon: Icons.face,
                  text: watcherCount,
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}

class ListTileBottomIconAndText extends StatelessWidget {
  final IconData icon;
  final String text;
  const ListTileBottomIconAndText({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.black,
          size: 24,
        ),
        const SizedBox(
          width: 6,
        ),
        Text(text,
            style: theme.textTheme.subtitle1?.copyWith(
              color: Colors.black45,
              fontWeight: FontWeight.bold,
            )),
      ],
    );
  }
}
