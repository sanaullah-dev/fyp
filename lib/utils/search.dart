import 'package:flutter/material.dart';

class Search extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return <Widget>[
      IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            query = "";
          })
    ];
    throw UnimplementedError();
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        });
    // TODO: implement buildLeading
    throw UnimplementedError();
  }

  late String selectedResult;
  @override
  Widget buildResults(BuildContext context) {
    return Container(child: Center(child: Text(selectedResult)));
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  List<String> recentList = ["text 2", "text 3"];
  final List<String> listExample;
  Search(this.listExample);
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestionList = [];
    query.isEmpty
        ? suggestionList = recentList
        : suggestionList.addAll(listExample.where(
            (element) => element.contains(query),
          ));
    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (contex, index) {
          return ListTile(
              title: Text(suggestionList[index]),
              onTap: () {
                selectedResult = suggestionList[index];
                showResults(context);
              });
        });
    // TODO: implement buildSuggestions
    throw UnimplementedError();
  }
}
