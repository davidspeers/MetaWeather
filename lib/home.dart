import 'package:flutter/material.dart';
import 'models/post.dart';
import 'widgets/posts_list_view.dart';

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
        future: fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? PostsListView(posts: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}