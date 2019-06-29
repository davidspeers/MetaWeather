import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'models/post.dart';
import 'components/posts_list_view.dart';
import 'utils/constants.dart';

class HomePage extends StatefulWidget {
  final String title;

  HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Widget body = Center(child: CircularProgressIndicator());

  void initState() {
    super.initState();
    /// This function is executed one time, after the initial layout is built.
    /// This approach was required instead of a FutureBuilder because using a
    /// FutureBuilder was calling the fetchPosts method multiple times upon startup.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      List<Post> posts = await fetchPosts(BELFAST_WOE_ID);
      setState(() {
        body = PostsListView(posts: posts);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: body
    );
  }
}