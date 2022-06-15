import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_codigo5_movieapp/models/cast_model.dart';
import 'package:flutter_codigo5_movieapp/models/image_model.dart';
import 'package:flutter_codigo5_movieapp/models/movie_detail_model.dart';
import 'package:flutter_codigo5_movieapp/models/review_model.dart';
import 'package:flutter_codigo5_movieapp/pages/cast_detail_page.dart';
import 'package:flutter_codigo5_movieapp/pages/new_page.dart';
import 'package:flutter_codigo5_movieapp/services/api_service.dart';
import 'package:flutter_codigo5_movieapp/ui/general/colors.dart';
import 'package:flutter_codigo5_movieapp/ui/widgets/item_cast_widget.dart';
import 'package:flutter_codigo5_movieapp/ui/widgets/item_review_widget.dart';
import 'package:flutter_codigo5_movieapp/ui/widgets/loading_indicator_widget.dart';
import 'package:flutter_codigo5_movieapp/ui/widgets/title_description_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class MovieDetailPage extends StatefulWidget {
  int movieId;

  MovieDetailPage({
    required this.movieId,
  });

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  APIService _apiService = APIService();
  MovieDetailModel? movieDetailModel;
  bool isLoading = true;
  List<CastModel> castList = [];
  List<ReviewModel> reviews = [];
  List<ImageModel> images = [];
  int castId = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    movieDetailModel = await _apiService.getMovie(widget.movieId);
    castList = await _apiService.getCast(widget.movieId);
    reviews = await _apiService.getReviews(widget.movieId);
    images = await _apiService.getImages(widget.movieId);
    isLoading = false;
    setState(() {});
  }

  showDetailCast() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CastDetailPage(
          castId: castId,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBrandPrimaryColor,
      body: !isLoading
          ? CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: Text(
                    movieDetailModel!.originalTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  centerTitle: true,
                  expandedHeight: 200.0,
                  elevation: 0,
                  backgroundColor: kBrandPrimaryColor,
                  flexibleSpace: FlexibleSpaceBar(
                    // title: Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    //   child: Text(
                    //     "Diego jlkajsdkasd sadsadsad asdasdasdsad asdasds",
                    //     maxLines: 1,
                    //     style: TextStyle(
                    //       fontSize: 12.0,
                    //     ),
                    //   ),
                    // ),
                    // // titlePadding: EdgeInsets.symmetric(horizontal: 50.0),
                    // centerTitle: true,
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          "http://image.tmdb.org/t/p/w500${movieDetailModel!.backdropPath}",
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  kBrandPrimaryColor.withOpacity(1),
                                  kBrandPrimaryColor.withOpacity(0.0),
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  floating: false,
                  snap: false,
                  pinned: true,
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      // SizedBox(
                      //   width: 200,
                      //   height: 200,
                      //   child: PinchZoom(
                      //     child: Image.network('https://image.tmdb.org/t/p/w500/A3bsT0m1um6tvcmlIGxBwx9eAxn.jpg'),
                      //     resetDuration: const Duration(milliseconds: 100),
                      //     maxScale: 10,
                      //     onZoomStart: (){print('Start zooming');},
                      //     onZoomEnd: (){print('Stop zooming');},
                      //   ),
                      // ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14.0, vertical: 14.0),
                        child: Row(
                          children: [
                            Container(
                              height: 160,
                              width: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    "http://image.tmdb.org/t/p/w500${movieDetailModel!.posterPath}",
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 12.0,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.date_range,
                                        color: Colors.white54,
                                        size: 14.0,
                                      ),
                                      const SizedBox(
                                        width: 4.0,
                                      ),
                                      Text(
                                        movieDetailModel!.releaseDate
                                            .toString()
                                            .substring(0, 10),
                                        style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: 13.0),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 6.0,
                                  ),
                                  Text(
                                    movieDetailModel!.originalTitle,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 6.0,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.timer,
                                        color: Colors.white54,
                                        size: 14.0,
                                      ),
                                      const SizedBox(
                                        width: 4.0,
                                      ),
                                      Text(
                                        "${movieDetailModel!.runtime} min",
                                        style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: 13.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> NewPage()));
                        },
                        child: Text(
                          "New page",
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleDescriptionWidget(
                              title: "Overview",
                            ),
                            Text(
                              movieDetailModel!.overview,
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 14.0,
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 50.0,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  launchUrl(
                                      Uri.parse(movieDetailModel!.homepage));
                                },
                                icon: const Icon(
                                  Icons.link,
                                  color: kBrandPrimaryColor,
                                ),
                                label: const Text(
                                  "Home page",
                                  style: TextStyle(
                                    color: kBrandPrimaryColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: kBrandSecondaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            TitleDescriptionWidget(
                              title: "Genres",
                            ),
                            Wrap(
                              spacing: 8,
                              children: movieDetailModel!.genres
                                  .map(
                                    (e) => Chip(
                                      label: Text(
                                        e.name,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            TitleDescriptionWidget(
                              title: "Cast",
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              child: Row(
                                children: castList
                                    .map(
                                      (e) => GestureDetector(
                                        onTap: () {
                                          castId = e.id;
                                          showDetailCast();
                                        },
                                        child: ItemCastWidget(castModel: e),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TitleDescriptionWidget(
                              title: "Images",
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              childAspectRatio: 1.5,
                              padding: EdgeInsets.zero,
                              children: images
                                  .map(
                                    (e) => Image.network(
                                      "https://image.tmdb.org/t/p/w500${e.filePath}",
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TitleDescriptionWidget(
                              title: "Reviews",
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            ...reviews
                                .map(
                                  (e) => ItemReviewWidget(reviewModel: e),
                                )
                                .toList(),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const LoadingIndicatorWidget(),
    );
  }
}
