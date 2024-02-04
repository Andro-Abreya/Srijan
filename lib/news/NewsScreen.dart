import 'package:flutter/material.dart';
import 'package:genesis_flutter/news/NewsService.dart';
import 'package:url_launcher/url_launcher.dart';



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

 _launchURL(url_1) async {
   final Uri url = Uri.parse('$url_1');
   if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
    }
}

  @override
  void initState() {
    super.initState();
    futureArticles = newsService.getTopHeadlines();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Article>>(
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
                  margin: EdgeInsets.all(10),
                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),color: Colors.black12,),
                   
                  child: InkWell(
                    
                    onTap: (){
                      _launchURL(snapshot.data![index].url);
                    },
                    child: Container(
                     
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                              width: double.infinity,
                              child: Image.network(snapshot.data![index].image,fit: BoxFit.fill,)),
                          ),
                          SizedBox(height: 5,),
                          Text(snapshot.data![index].title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                          ListTile(
                          
                            subtitle: Text(snapshot.data![index].description),
                          ),
                          Text('Click to read more')
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      );
  }
}