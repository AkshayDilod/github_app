import 'dart:convert';

class GitDataModel {
  int? id;
  String? name;
  String? description;
  int? watchersCount;
  String? language;
  int? openIssuesCount;
  GitDataModel({
    this.name,
    this.description,
    this.watchersCount,
    this.language,
    this.openIssuesCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'watchers_count': watchersCount,
      'language': language,
      'open_issues_count': openIssuesCount,
    };
  }

  factory GitDataModel.fromMap(Map<String, dynamic> map) {
    return GitDataModel(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      watchersCount: map['watchers_count'] ?? '',
      language: map['language'] ?? '',
      openIssuesCount: map['open_issues_count'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GitDataModel.fromJson(String source) =>
      GitDataModel.fromMap(json.decode(source));
}
