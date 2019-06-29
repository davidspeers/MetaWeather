import 'package:flutter/material.dart';
import '../models/post.dart';
import 'toasts.dart';
import 'package:connectivity/connectivity.dart';

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
                return Column(
                  children: <Widget>[
                    ListTile(
                        title: Text(
                          '${mutablePosts[position].date}',
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
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      blueGreyToast("No Internet Connection");
    } else {
      mutablePosts =  await fetchPosts();
      setState(() {});
      blueGreyToast("Forecast Updated");
    }


  }
}