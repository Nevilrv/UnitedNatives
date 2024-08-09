import 'package:cached_network_image/cached_network_image.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:flutter/material.dart';
import 'blog_container.dart';

class BlogPage1 extends StatefulWidget {
  const BlogPage1({super.key});

  @override
  State<BlogPage1> createState() => _BlogPage1State();
}

class _BlogPage1State extends State<BlogPage1> {
  Stream? blogsStream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Translate.of(context)!.translate('Research and Information'),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleMedium?.color,
              fontSize: 24),
        ),
      ),
      body: const ContainerBlogPage(
        hintText: '',
      ),
    );
  }
}

class BlogsTile extends StatelessWidget {
  final String imgUrl, title, description, authorName;
  const BlogsTile(
      {super.key,
      required this.imgUrl,
      required this.title,
      required this.description,
      required this.authorName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 150,
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CachedNetworkImage(
              imageUrl: imgUrl,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: 170,
            decoration: BoxDecoration(
                color: Colors.black45.withOpacity(0.3),
                borderRadius: BorderRadius.circular(6)),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 27, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  description,
                  style: const TextStyle(
                      fontSize: 19, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(authorName)
              ],
            ),
          )
        ],
      ),
    );
  }
}
