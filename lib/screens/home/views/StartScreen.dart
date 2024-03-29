import 'package:flutter/material.dart';
import 'package:youtube_flutter_sample/models/Video.dart';
import 'package:youtube_flutter_sample/services/ApiYoutube.dart';

class StartScreen extends StatefulWidget {
  final String _search;
  StartScreen(this._search);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {

  Future<List<Video>>_listVideos(String text) async {
    ApiYoutube apiYoutube = ApiYoutube();
    return await apiYoutube.search(text);
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<Video>>(
      future: _listVideos(widget._search),
      builder: (context, snapshot) {
        switch (snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            if( snapshot.hasData){
              return ListView.separated(
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: false,
                  itemBuilder: (context, index){

                    List<Video> videos = snapshot.data;
                    Video video = videos[index];

                    return Column(
                      children: [
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(video.image)
                              )
                          ),
                        ),
                        ListTile(
                          title: Text(video.title),
                          subtitle: Text(video.chanel),
                        )
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                    height: 2,
                    color: Colors.grey,
                  ),
                  itemCount: snapshot.data.length
              );
            } else {
              return Center(
                child: Text("Nenhum dado a ser exibido"),
              );
            }
            break;
        }
        return Text("Nenhum dado a ser exibido");
      },
    );
  }
}
