import 'package:flutter/material.dart';

// //https://github.com/mayuriruparel/flutter_demo_apps
// //https://stackoverflow.com/questions/54482450/flutter-pass-a-future-list-to-a-searchdelegate/54482950
// //https://medium.com/flutter-community/implementing-auto-complete-search-list-a8dd192bd5f6

// class _SearchDemoSearchDelegate extends SearchDelegate<int> {
//   final List<int> _data = List<int>.generate(100001, (int i) => i).reversed.toList();
//   final List<int> _history = <int>[42607, 85604, 66374, 44, 174];

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       tooltip: 'Back',
//       icon: AnimatedIcon(
//         icon: AnimatedIcons.menu_arrow,
//         progress: transitionAnimation,
//       ),
//       onPressed: () {
//         close(context, null);
//       },
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {

//     final Iterable<int> suggestions = query.isEmpty
//         ? _history
//         : _data.where((int i) => '$i'.startsWith(query));

//     return _SuggestionList(
//       query: query,
//       suggestions: suggestions.map<String>((int i) => '$i').toList(),
//       onSelected: (String suggestion) {
//         query = suggestion;
//         showResults(context);
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     final int searched = int.tryParse(query);
//     if (searched == null || !_data.contains(searched)) {
//       return Center(
//         child: Text(
//           '"$query"\n is not a valid integer between 0 and 100,000.\nTry again.',
//           textAlign: TextAlign.center,
//         ),
//       );
//     }

//     return ListView(
//       children: <Widget>[
//         _ResultCard(
//           title: 'This integer',
//           integer: searched,
//           searchDelegate: this,
//         ),
//         _ResultCard(
//           title: 'Next integer',
//           integer: searched + 1,
//           searchDelegate: this,
//         ),
//         _ResultCard(
//           title: 'Previous integer',
//           integer: searched - 1,
//           searchDelegate: this,
//         ),
//       ],
//     );
//   }

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return <Widget>[
//       if (query.isEmpty)
//         IconButton(
//           tooltip: 'Voice Search',
//           icon: const Icon(Icons.mic),
//           onPressed: () {
//             query = 'TODO: implement voice input';
//           },
//         )
//       else
//         IconButton(
//           tooltip: 'Clear',
//           icon: const Icon(Icons.clear),
//           onPressed: () {
//             query = '';
//             showSuggestions(context);
//           },
//         ),
//     ];
//   }
// }

// class _ResultCard extends StatelessWidget {
//   const _ResultCard({this.integer, this.title, this.searchDelegate});

//   final int integer;
//   final String title;
//   final SearchDelegate<int> searchDelegate;

//   @override
//   Widget build(BuildContext context) {
//     final ThemeData theme = Theme.of(context);
//     return GestureDetector(
//       onTap: () {
//         searchDelegate.close(context, integer);
//       },
//       child: Card(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: <Widget>[
//               Text(title),
//               Text(
//                 '$integer',
//                 style: theme.textTheme.headline.copyWith(fontSize: 72.0),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _SuggestionList extends StatelessWidget {
//   const _SuggestionList({this.suggestions, this.query, this.onSelected});

//   final List<String> suggestions;
//   final String query;
//   final ValueChanged<String> onSelected;

//   @override
//   Widget build(BuildContext context) {
//     final ThemeData theme = Theme.of(context);
//     return ListView.builder(
//       itemCount: suggestions.length,
//       itemBuilder: (BuildContext context, int i) {
//         final String suggestion = suggestions[i];
//         return ListTile(
//           leading: query.isEmpty ? const Icon(Icons.history) : const Icon(null),
//           title: RichText(
//             text: TextSpan(
//               text: suggestion.substring(0, query.length),
//               style: theme.textTheme.subhead.copyWith(fontWeight: FontWeight.bold),
//               children: <TextSpan>[
//                 TextSpan(
//                   text: suggestion.substring(query.length),
//                   style: theme.textTheme.subhead,
//                 ),
//               ],
//             ),
//           ),
//           onTap: () {
//             onSelected(suggestion);
//           },
//         );
//       },
//     );
//   }
// }
class DataSearch extends SearchDelegate<String> {
  DataSearch(this.suggestions, this.controller);
  List<String> suggestions;
  final TextEditingController controller;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, "search result");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  //     ! CALLS SYNC FUNCTIONS WITHOUT AWAIT !

  @override
  Widget buildSuggestions(BuildContext context) {
    //DoctorsController.fetchAllDoctors();
    List<String> doctorsList = suggestions;
    final List<String> suggestionList = query.isEmpty
        ? doctorsList
        : doctorsList.where((element) => element.contains(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) {
        String sugText = suggestionList[index];
        return ListTile(
            onTap: () {
              print('allitsukbeee');
              print(sugText);
              controller.text = sugText;
            },
            leading: Icon(Icons.history),
            title: RichText(
              text: TextSpan(
                text: sugText.substring(0, sugText.indexOf(query)),
                style: TextStyle(color: Colors.grey),
                children: [
                  TextSpan(
                    text: sugText.substring(sugText.indexOf(query),
                        sugText.indexOf(query) + query.length),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: sugText.substring(
                        sugText.indexOf(query) + query.length, sugText.length),
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ));
      },
      itemCount: suggestionList.length,
    );
  }
}
