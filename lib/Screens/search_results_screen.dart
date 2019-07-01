import 'package:flutter/material.dart';
import 'package:fisheri/search_result_cell.dart';
import 'package:fisheri/result_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchResultsScreen extends StatelessWidget {
  SearchResultsScreen(this.searchResults);

  final List<ResultInfo> searchResults;

  // @override
  // Widget build(BuildContext context) {
  //   return Align(
  //       alignment: Alignment.center,
  //       child: ListView.separated(
  //         itemCount: searchResults.length,
  //         separatorBuilder: (BuildContext context, int index) => Divider(
  //               height: 1,
  //               color: Colors.grey[700],
  //             ),
  //         itemBuilder: (context, index) {
  //           final _lakeToString = searchResults[index].isLake ? "LAKE" : "SHOP";
  //           return SearchResultCell(
  //             imageURL: 'images/lake.jpg',
  //             title: '${searchResults[index].title}',
  //             venueType: _lakeToString,
  //             distance: '${searchResults[index].distance}',
  //             isOpen: searchResults[index].isOpen,
  //           );
  //         },
  //       ));
  // }

  // Widget _buildBody(BuildContext context) {
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: Firestore.instance.collection("venues_search").snapshots(),
  //     builder: (context, snapshot) {
  //       if (!snapshot.hasData) return LinearProgressIndicator();
  //       return _
  //     }
  // }

    @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: ListView.separated(
          itemCount: searchResults.length,
          separatorBuilder: (BuildContext context, int index) => Divider(
                height: 1,
                color: Colors.grey[700],
              ),
          itemBuilder: (context, index) {
            final _lakeToString = searchResults[index].isLake ? "LAKE" : "SHOP";
            return SearchResultCell(
              imageURL: 'images/lake.jpg',
              title: '${searchResults[index].title}',
              venueType: _lakeToString,
              distance: '${searchResults[index].distance}',
              isOpen: searchResults[index].isOpen,
            );
          },
        ));
  }
}
