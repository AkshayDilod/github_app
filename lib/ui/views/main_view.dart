import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../../services/biomertric_service.dart';
import '../../viewModel/main_view_model.dart';
import '../../constants.dart';
import 'package:provider/provider.dart';

import '../widgets/list_tile_widget.dart';

class MainView extends StatelessWidget {
  MainView({Key? key}) : super(key: key);

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final mainVM = context.read<MainViewModel>();
    final watch = context.watch<MainViewModel>();
    final gitDataList = watch.gitData;
    final loading = watch.loading;
    final theme = Theme.of(context);
    const circularProgressIndicator = CircularProgressIndicator(
      color: primaryColor,
    );
    if (mainVM.connectionStatus == ConnectivityResult.none) {
      mainVM.getDBData();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jake\'s Git'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (mainVM.connectionStatus == ConnectivityResult.none &&
              gitDataList.isEmpty)
            CheckInternet(
              text: noInternet,
              mainVM: mainVM,
            ),
          if (watch.initialLoading)
            const Align(
              alignment: Alignment.center,
              child: circularProgressIndicator,
            ),
          if (mainVM.connectionStatus == ConnectivityResult.none &&
              gitDataList.isNotEmpty)
            Container(
              alignment: Alignment.center,
              child: Text(
                'No Internet Available',
                textAlign: TextAlign.center,
                style: theme.textTheme.subtitle1,
              ),
              width: double.infinity,
              height: 40,
              color: Colors.red,
            ),
          if (gitDataList.isNotEmpty)
            Expanded(
              child: NotificationListener(
                onNotification: (onScrollNotification) {
                  if (onScrollNotification is ScrollEndNotification) {
                    final before = onScrollNotification.metrics.extentBefore
                        .ceilToDouble();
                    var max = onScrollNotification.metrics.maxScrollExtent
                        .ceilToDouble();
                    final height = (size.height * .15) * 3.ceilToDouble();
                    if (mainVM.connectionStatus != ConnectivityResult.none) {
                      if (max <= (before + height)) {
                        mainVM.updatePage(MainViewModel.page + 1);
                        return true;
                      }
                    }
                  }
                  return false;
                },
                child: Scrollbar(
                  controller: scrollController,
                  hoverThickness: 40,
                  thickness: 10,
                  radius: const Radius.circular(10),
                  interactive: true,
                  isAlwaysShown: true,
                  showTrackOnHover: true,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                            controller: scrollController,
                            padding: const EdgeInsets.only(bottom: 10),
                            scrollDirection: Axis.vertical,
                            itemCount: gitDataList.length,
                            itemBuilder: (context, index) {
                              return ListTileWidget(
                                openIssuesCount: gitDataList[index]
                                    .openIssuesCount
                                    .toString(),
                                language: gitDataList[index].language!,
                                watcherCount: gitDataList[index]
                                    .watchersCount!
                                    .toString(),
                                description: gitDataList[index].description!,
                                name: gitDataList[index].name!,
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Divider(
                                height: 1,
                                thickness: 1,
                              );
                            }),
                      ),
                      if (loading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: circularProgressIndicator,
                        ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CheckInternet extends StatelessWidget {
  const CheckInternet({
    Key? key,
    required this.mainVM,
    required this.text,
  }) : super(key: key);
  final MainViewModel mainVM;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: theme.textTheme.subtitle1,
          ),
          if (mainVM.connectionStatus != ConnectivityResult.none)
            FloatingActionButton(
              child: const Icon(
                Icons.refresh,
                color: Colors.black,
              ),
              onPressed: mainVM.connectionStatus != ConnectivityResult.none
                  ? mainVM.getDataONRefresh
                  : null,
            )
        ],
      ),
    );
  }
}
