import 'package:flutter/material.dart';
import 'package:genesis_flutter/news/NewsService.dart';


class NewsScreen extends StatefulWidget {
  // final String apiKey;
  // const NewsScreen({required this.apiKey});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsService newsService = NewsService();
// 6G1T-6MVX-DGX0-T4E4
  late Future<List<Article>> futureArticles;

  @override
  void initState() {
    super.initState();
    futureArticles = newsService.getTopHeadlines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
      ),
      body: FutureBuilder<List<Article>>(
        future: futureArticles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Container(
                  child: Column(
                    children: [
                      Image.network(snapshot.data![index].image),
                      ListTile(
                        title: Text(snapshot.data![index].title),
                        subtitle: Text(snapshot.data![index].description),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}