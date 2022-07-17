

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdb_app/model/detail_info.dart';

class RenderDetailContent extends StatelessWidget{
  DetailInfo detailInfo;
  int trackColor;
  int progressColor;

  RenderDetailContent({Key? key , required this.detailInfo, required this.progressColor,
  required this.trackColor}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              PopupMenuButton<String>(
                  onSelected: (value) {},
                  offset: const Offset(0, 25),
                  child: Row(
                    children: const [
                      Text("Overview",
                          style: TextStyle(fontSize: 16)),
                      Icon(Icons.arrow_drop_down_sharp)
                    ],
                  ),
                  itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                        child: Text("Main"), value: "main"),
                    const PopupMenuItem<String>(
                        child: Text("Alternative Titles"),
                        value: "alt_title"),
                    const PopupMenuItem<String>(
                        child: Text("Cast & Crew"),
                        value: "cast"),
                    const PopupMenuItem<String>(
                        child: Text("Episode Groups"),
                        value: "eps_gr"),
                    const PopupMenuItem<String>(
                        child: Text("Seasons"),
                        value: "season"),
                    const PopupMenuItem<String>(
                        child: Text("Translation"),
                        value: "trans"),
                    const PopupMenuItem<String>(
                        child: Text("Changes"),
                        value: "changes"),
                  ]),
              PopupMenuButton<String>(
                  onSelected: (value) {},
                  offset: const Offset(0, 25),
                  child: Row(
                    children: const [
                      Text("Media",
                          style: TextStyle(fontSize: 16)),
                      Icon(Icons.arrow_drop_down_sharp)
                    ],
                  ),
                  itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                        child: Text("Backdrops"),
                        value: "backdrop"),
                    const PopupMenuItem<String>(
                        child: Text("Logos"),
                        value: "logo"),
                    const PopupMenuItem<String>(
                        child: Text("Posters"),
                        value: "poster"),
                    const PopupMenuItem<String>(
                        child: Text("Videos"),
                        value: "video"),
                  ]),
              PopupMenuButton<String>(
                  onSelected: (value) {},
                  offset: const Offset(0, 25),
                  child: Row(
                    children: const [
                      Text("Fandom",
                          style: TextStyle(fontSize: 16)),
                      Icon(Icons.arrow_drop_down_sharp)
                    ],
                  ),
                  itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                        child: Text("Discussions"),
                        value: "discussion"),
                    const PopupMenuItem<String>(
                        child: Text("Reviews"),
                        value: "review"),
                  ]),
              PopupMenuButton<String>(
                  onSelected: (value) {},
                  offset: const Offset(0, 25),
                  child: Row(
                    children: const [
                      Text("Share",
                          style: TextStyle(fontSize: 16)),
                      Icon(Icons.arrow_drop_down_sharp)
                    ],
                  ),
                  itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                        child: Text("Share Link"),
                        value: "link"),
                    const PopupMenuItem<String>(
                        child: Text("Facebook"),
                        value: "Facebook"),
                    const PopupMenuItem<String>(
                        child: Text("Tweet"),
                        value: "tweet")
                  ]),
            ],
          ),
        ),
        Stack(
          children: [
            Shimmer.fromColors(
                child: const SizedBox(
                  height: 200,
                  child: Center(
                    child: Icon(Icons.image),
                  ),
                ),
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!),
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      'https://www.themoviedb.org/t/p/original/${detailInfo.backdropPath}'),
                ),
              ),
            ),
            Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        20, 30, 0, 20),
                    child: Container(
                      width: 92,
                      height: 140,
                      child: const Center(
                          child: Icon(Icons.image)),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black),
                          borderRadius:
                          BorderRadius.circular(6)),
                    ))),
            Padding(
                padding: const EdgeInsets.fromLTRB(
                    20, 30, 0, 20),
                child: Container(
                  width: 92,
                  height: 140,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            'https://www.themoviedb.org/t/p/original/${detailInfo.posterPath}'),
                      ),
                      borderRadius:
                      BorderRadius.circular(6)),
                ))
          ],
        ),
        Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 16, horizontal: 20),
            child: Center(
              child:
              RichText(
                text: TextSpan(
                    style: const TextStyle(
                        color: Colors.black),
                    children: [
                      TextSpan(
                          text:
                          "${detailInfo.originalTitle}",
                          style: const TextStyle(
                              fontSize: 23)),
                      TextSpan(
                          text:
                          "   (${detailInfo.releaseDate})",
                          style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12.8))
                    ]),
              ),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: const Color(0xff081c22),
                    borderRadius: BorderRadius.circular(25)),
                child:
                CircularPercentIndicator(
                  radius: 25.0,
                  lineWidth: 4.5,
                  percent: detailInfo.vote ?? 0 / 10,
                  backgroundColor: Color(trackColor),
                  center: Text(
                      "${detailInfo.vote ?? 0 * 10} %",
                      style: const TextStyle(
                          fontSize: 9.6,
                          color: Colors.white)),
                  progressColor: Color(progressColor),
                )
            ),
            const SizedBox(width: 13),
            const Text("User Score",
                style: TextStyle(fontWeight: FontWeight.w700))
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 20, horizontal: 0),
          child:
          Text("Runtime: ${detailInfo.runTime} minutes"),),
        Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child:  Text("${detailInfo.tagLine}",
                style: const TextStyle(
                    fontSize: 17.6,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic))
        ),
        const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Text("Overview",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20.8))),
        Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            child: Text("${detailInfo.overview}",
                style: const TextStyle(fontSize: 16))
        ),
      ],
    );
  }
}