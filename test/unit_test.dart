// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:github/helper/dependency.dart';
import 'package:github/model/git_data_model.dart';
import 'package:github/services/api_service.dart';
import 'package:github/viewModel/main_view_model.dart';

class MockApi extends ApiService {
  @override
  Future<List<GitDataModel>> getGitData(int page) async => Future.value([
        GitDataModel(
          name: 'Akshay',
          language: 'Dart',
          description: 'Very Interesting language syntax',
          openIssuesCount: 0,
          watchersCount: 100,
        ),
        GitDataModel(
          name: 'Amit',
          language: 'Dart',
          description: 'Very Interesting language syntax',
          openIssuesCount: 1,
          watchersCount: 10,
        )
      ]);
}

void main() {
  setup();
  var mainVM = getIt<MainViewModel>();

  mainVM.api = MockApi();
  test('Given product list page load', () async {
    await mainVM.fetchGitData();
    expect(mainVM.gitData!.length, 2);

    expect(mainVM.gitData![0].name, 'Akshay');
    expect(mainVM.gitData![0].language, 'Dart');
    expect(mainVM.gitData![0].description, 'Very Interesting language syntax');
    expect(mainVM.gitData![0].openIssuesCount, 0);
    expect(mainVM.gitData![0].watchersCount, 100);

    // expect(mainVM.gitData![0].name, 'Amit');
    // expect(mainVM.gitData![0].language, 'Dart');
    // expect(mainVM.gitData![0].description, 'Very Interesting language syntax');
    // expect(mainVM.gitData![0].openIssuesCount, 1);
    // expect(mainVM.gitData![0].watchersCount, 10);
  });
}
