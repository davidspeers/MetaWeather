import 'package:flutter/material.dart';
import 'dart:io';
import '../models/post.dart';
import 'toasts.dart';

class PostsListView extends StatefulWidget {
  final List<Post> posts;

  PostsListView({Key key, this.posts}) : super(key: key);

  @override
  _PostsListViewState createState() => _PostsListViewState();
}

class _PostsListViewState extends State<PostsListView> {
  List<Post> mutablePosts; // need to be mutable for pull to refresh

  @override
  void initState() {
    super.initState();
    mutablePosts = widget.posts;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefreshIndicator(
          child: ListView.builder(
              itemCount: mutablePosts.length,
              padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
              itemBuilder: (context, position) {
                String titleText = '${mutablePosts[position].date}';
                if (position == 0) titleText += " (Today)";
                if (position == 1) titleText += " (Tomorrow)";

                return Column(
                  children: <Widget>[
                    ListTile(
                        title: Text(
                          titleText,
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.blueGrey,
                          ),
                        ),
                        subtitle: Text(
                          '${mutablePosts[position].weatherStateName}',
                          style: new TextStyle(
                            fontSize: 18.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        leading: Image.asset('assets/images/${mutablePosts[position].weatherStateAbbr}.png')
                    ),
                    Divider(height: 5.0),
                  ],
                );
              }),
          onRefresh: _refresh
      )
    );
  }

  Future<void> _refresh() async {
    try {
      mutablePosts =  await fetchPosts();
      // only redraw widget if data is available
      if (mutablePosts.isNotEmpty) {
        setState(() {});
        blueGreyToast("Forecast Updated");
      } else {
        blueGreyToast("No Internet Connection");
      }
    } on SocketException catch (_) {
      blueGreyToast("MetaWeather Server Error");
    } catch (e) {
      blueGreyToast("${e.runtimeType} Error");
    }
  }

}