import 'package:flutter/material.dart';
import 'models/post.dart';
import 'components/posts_list_view.dart';
import 'utils/constants.dart';

class HomePage extends StatelessWidget {
  final String title;

  HomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Post>>(
        future: fetchPosts(BELFAST_WOE_ID),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? PostsListView(posts: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}