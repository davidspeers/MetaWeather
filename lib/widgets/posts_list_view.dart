import 'package:flutter/material.dart';
import '../models/post.dart';

class PostsListView extends StatefulWidget {
  final List<Post> posts;

  PostsListView({Key key, this.posts}) : super(key: key);

  @override
  _PostsListViewState createState() => _PostsListViewState();
}

class _PostsListViewState extends State<PostsListView> {
  @override
  Widget build(BuildContext context) {
    return Container(
          child: ListView.builder(
              itemCount: widget.posts.length,
              padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
              itemBuilder: (context, position) {
                return Column(
                  children: <Widget>[
                    ListTile(
                        title: Text(
                          '${widget.posts[position].date}',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.blueGrey,
                          ),
                        ),
                        subtitle: Text(
                          '${widget.posts[position].weatherStateName}',
                          style: new TextStyle(
                            fontSize: 18.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        leading: Image.asset('assets/images/${widget.posts[position].weatherStateAbbr}.png')
                    ),
                    Divider(height: 5.0),
                  ],
                );
              }),
    );
  }
}