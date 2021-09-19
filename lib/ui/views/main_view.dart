import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:wifi_iot/wifi_iot.dart';
import '../../viewModel/main_view_model.dart';
import '../../constants.dart';
import 'package:provider/provider.dart';

import '../widgets/list_tile_widget.dart';

class MainView extends StatelessWidget {
  MainView({Key? key}) : super(key: key);

  final scrollController = ScrollController();
  int initLoad = 0;
  int initLocalLoad = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final read = context.read<MainViewModel>();
    final watch = context.watch<MainViewModel>();

    const circularProgressIndicator = CircularProgressIndicator(
      color: primaryColor,
    );
    if (watch.connectionStatus != ConnectivityResult.none &&
        watch.gitData!.isEmpty &&
        initLoad == 0) {
      WiFiForIoTPlugin.isEnabled().then((value) {
        read.initWifiIs(value);
      });
      read.initialDataLoading();
      initLoad = 1;
    } else if (watch.connectionStatus == ConnectivityResult.none &&
        watch.gitData!.isEmpty &&
        initLocalLoad == 0) {
      WiFiForIoTPlugin.isEnabled().then((value) {
        read.initWifiIs(value);
      });
      watch.initialLocalDataLoading();
      initLocalLoad = 1;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jake\'s Git'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          read.setWifiOnOff(!watch.isWifiEnable);
        },
        child: watch.isWifiEnable
            ? const Icon(Icons.wifi)
            : const Icon(Icons.wifi_off),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (read.connectionStatus == ConnectivityResult.none &&
              watch.gitData!.isEmpty &&
              watch.initialLoading == false)
            CheckInternet(
              text: noInternet,
              read: read,
            ),
          if (read.connectionStatus != ConnectivityResult.none &&
              watch.gitData!.isEmpty &&
              watch.isRefreshPressed == false)
            CheckInternet(
              text: internet,
              read: read,
            ),
          if (watch.initialLoading)
            const Align(
              alignment: Alignment.center,
              child: circularProgressIndicator,
            ),
          if (read.connectionStatus == ConnectivityResult.none &&
              watch.gitData!.isNotEmpty)
            Container(
              alignment: Alignment.center,
              child: Text(
                'No Internet Available',
                textAlign: TextAlign.center,
                style: theme.textTheme.subtitle1?.copyWith(color: Colors.white),
              ),
              width: double.infinity,
              height: 40,
              color: Colors.red,
            ),
          if (watch.gitData!.isNotEmpty)
            Expanded(
              child: NotificationListener(
                onNotification: (onScrollNotification) {
                  if (onScrollNotification is ScrollEndNotification) {
                    final before = onScrollNotification.metrics.extentBefore
                        .ceilToDouble();
                    var max = onScrollNotification.metrics.maxScrollExtent
                        .ceilToDouble();
                    final height = (size.height * .15) * 3.ceilToDouble();

                    if (max <= (before + height)) {
                      if (watch.connectionStatus != ConnectivityResult.none) {
                        read.onPageScroll(MainViewModel.page + 1);
                        if (watch.hasData == false) {
                          showSnackBar(context);
                        }
                        return true;
                      } else {
                        if ((watch.gitData!.isEmpty ||
                                watch.gitData!.isNotEmpty) &&
                            watch.hasLocalData) {
                          read.readLocalData(MainViewModel.offset);
                        }
                        if (watch.hasLocalData == false) {
                          showSnackBar(context);
                        }
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
                            itemCount: watch.gitData!.length,
                            itemBuilder: (context, index) {
                              return ListTileWidget(
                                openIssuesCount: watch
                                    .gitData![index].openIssuesCount
                                    .toString(),
                                language: watch.gitData![index].language!,
                                watcherCount: watch
                                    .gitData![index].watchersCount!
                                    .toString(),
                                description: watch.gitData![index].description!,
                                name: watch.gitData![index].name!,
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Divider(
                                height: 1,
                                thickness: 1,
                              );
                            }),
                      ),
                      if (watch.loading)
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

  void showSnackBar(context) {
    final snackBar = SnackBar(
      content: Text(
        'Has no more data left',
        style: Theme.of(context)
            .textTheme
            .bodyText1
            ?.copyWith(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class CheckInternet extends StatelessWidget {
  const CheckInternet({
    Key? key,
    required this.read,
    required this.text,
  }) : super(key: key);
  final MainViewModel read;
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
          const SizedBox(
            height: 15,
          ),
          // if (read.connectionStatus != ConnectivityResult.none)
          //   FloatingActionButton(
          //     child: const Icon(
          //       Icons.refresh,
          //       color: Colors.black,
          //     ),
          //     onPressed: read.connectionStatus != ConnectivityResult.none
          //         ? read.getDataONRefresh
          //         : null,
          //   )
        ],
      ),
    );
  }
}
