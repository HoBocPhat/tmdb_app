
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdb_app/model/list_info.dart';

import '../../../model/TV.dart';
import '../../../screen/detail_page.dart';

class RenderListHome extends StatefulWidget{
  List<ListInfo> list;

  RenderListHome({Key? key , required this.list}) : super(key: key);

  @override
  _RenderListHomeState createState() => _RenderListHomeState();
}

class _RenderListHomeState extends State<RenderListHome>{
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      child: ListView.builder(
        itemBuilder: (BuildContext context, index) {
          int progressColor;
          int trackColor;
          if (widget.list[index].vote! >= 6 && widget.list[index].vote! <= 10) {
            progressColor = 0xff21d07a;
            trackColor = 0xff204529;
          } else if (widget.list[index].vote! >= 4 &&
              widget.list[index].vote! <= 5.9) {
            progressColor = 0xffd2d531;
            trackColor = 0xff423d0f;
          } else {
            progressColor = 0xffdb2360;
            trackColor = 0xff571435;
          }
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DetailPage(id: widget.list[index].id, type: "tv")));
            },
            child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Stack(children: [
                          Shimmer.fromColors(
                              child: Container(
                                  height: 225,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(10)),
                                  child:
                                  const Center(child: Icon(Icons.image))),
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!),
                          Container(
                            height: 225,
                            width: 150,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                        'https://www.themoviedb.org/t/p/w440_and_h660_face${widget.list[index].posterPath}')),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ]),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 26, 12, 10),
                            child: SizedBox(
                              width: 120,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        widget.list[index].originalTitle!,
                                        style: Theme.of(context).textTheme.headline6),
                                    Text(
                                      widget.list[index].releaseDate!,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ]),
                            )),
                      ],
                    ),
                    Column(children: [
                      const SizedBox(height: 200),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: const Color(0xff081c22),
                              borderRadius: BorderRadius.circular(20)),
                          child: CircularPercentIndicator(
                            radius: 20.0,
                            lineWidth: 4.0,
                            percent: widget.list[index].vote! / 10,
                            backgroundColor: Color(trackColor),
                            center: Text("${widget.list[index].vote! * 10} %",
                                style: const TextStyle(
                                    fontSize: 9.6, color: Colors.white)),
                            progressColor: Color(progressColor),
                          ),
                        ),
                      )
                    ])
                  ],
                )),
          );
        },
        itemCount: widget.list.length,
        padding: const EdgeInsets.all(20.0),
        //shrinkWrap: true,
        scrollDirection: Axis.horizontal,
      ),
    );

  }
}
