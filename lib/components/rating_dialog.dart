import 'package:dinokino_tablet/components/dino_card.dart';
import 'package:dinokino_tablet/models/movie.dart';
import 'package:dinokino_tablet/providers/movie_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RatingDialog extends StatefulWidget {
  const RatingDialog({super.key, required this.movie});
  final Movie movie;

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  final MovieProvider provider = Get.find<MovieProvider>();
  double angle = 0;
  final ValueNotifier<double> dragAngle = ValueNotifier<double>(0);
  bool? likesRating;

  @override
  void initState() {
    super.initState();
    if (widget.movie.isLiked) {
      likesRating = true;
    }
    if (widget.movie.isDisliked) {
      likesRating = false;
    }
    setState(() {});
  }

  void _submitRating() {
    if (likesRating == null) {
      return;
    }

    provider.likedMovies.removeWhere(
      (movie) => movie.title == widget.movie.title,
    );
    provider.dislikedMovies.removeWhere(
      (movie) => movie.title == widget.movie.title,
    );

    if (likesRating == true) {
      provider.likedMovies.add(widget.movie);
    } else {
      provider.dislikedMovies.add(widget.movie);
    }

    Get.back();
  }

  @override
  void dispose() {
    dragAngle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * .6,
      height: Get.height * .8,
      child: Dialog(
        backgroundColor: const Color.fromARGB(179, 147, 145, 145),
        child: BackdropFilter(
          filterConfig: ImageFilterConfig.blur(sigmaX: 4, sigmaY: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  Text(
                    "Did you like the movie?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DragTarget<String>(
                    onWillAcceptWithDetails: (details) =>
                        details.data == 'rating',
                    onAcceptWithDetails: (_) {
                      setState(() {
                        likesRating = false;
                      });
                    },
                    builder: (context, candidateData, rejectedData) {
                      final isHovering = candidateData.isNotEmpty;
                      final isSelected = likesRating == false;

                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected || isHovering
                                ? Color(0xff00C8C4)
                                : Colors.white,
                            width: 2,
                          ),
                        ),
                        height: Get.height * .4,
                        width: 200,
                        child: Center(
                          child: Column(
                            spacing: 12,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Transform.rotate(
                                angle: isSelected || isHovering ? .5 : 0,
                                child: Image.asset(
                                  "assets/images/thumb_down.png",
                                  color: isSelected || isHovering
                                      ? Color(0xff00C8C4)
                                      : Colors.white,
                                ),
                              ),
                              Text(
                                "No, not at all",
                                style: TextStyle(
                                  color: isSelected || isHovering
                                      ? Color(0xff00C8C4)
                                      : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    height: Get.height * .4,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey.withAlpha(100),
                    ),
                    child: Draggable<String>(
                      data: 'rating',
                      childWhenDragging: Container(
                        height: 250,
                        width: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey.shade900.withAlpha(100),
                        ),
                      ),
                      feedback: MovingCard(
                        angleListenable: dragAngle,
                        widget: widget,
                      ),
                      onDragUpdate: (details) {
                        setState(() {
                          angle += details.delta.dx / Get.width * .5;
                        });
                        dragAngle.value = angle;
                      },
                      onDragEnd: (_) {
                        setState(() {
                          angle = 0;
                        });
                        dragAngle.value = 0;
                      },
                      child: Transform.rotate(
                        angle: angle,
                        child: Material(
                          color: Colors.transparent,
                          child: SizedBox(
                            height: 250,
                            width: 130,
                            child: DinoCard(movie: widget.movie, onTap: () {}),
                          ),
                        ),
                      ),
                    ),
                  ),
                  DragTarget<String>(
                    onWillAcceptWithDetails: (details) =>
                        details.data == 'rating',
                    onAcceptWithDetails: (_) {
                      setState(() {
                        likesRating = true;
                      });
                    },
                    builder: (context, candidateData, rejectedData) {
                      final isHovering = candidateData.isNotEmpty;
                      final isSelected = likesRating == true;

                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected || isHovering
                                ? Color(0xff00C8C4)
                                : Colors.white,
                            width: 2,
                          ),
                        ),
                        height: Get.height * .4,
                        width: 200,
                        child: Center(
                          child: Column(
                            spacing: 12,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Transform.rotate(
                                angle: isSelected || isHovering ? .5 : 0,
                                child: Image.asset(
                                  "assets/images/thumb_up.png",
                                  color: isSelected || isHovering
                                      ? Color(0xff00C8C4)
                                      : Colors.white,
                                ),
                              ),
                              Text(
                                "Yes, I loved it",
                                style: TextStyle(
                                  color: isSelected || isHovering
                                      ? Color(0xff00C8C4)
                                      : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Text(
                "Drag the thumbnail to rate",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 60,
                width: 200,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      likesRating == null ? Colors.white24 : Colors.white54,
                    ),
                  ),
                  onPressed: likesRating == null ? null : _submitRating,
                  child: Text("Rate", style: TextStyle(color: Colors.black)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MovingCard extends StatefulWidget {
  const MovingCard({
    super.key,
    required this.angleListenable,
    required this.widget,
  });

  final ValueListenable<double> angleListenable;
  final RatingDialog widget;

  @override
  State<MovingCard> createState() => _MovingCardState();
}

class _MovingCardState extends State<MovingCard> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: widget.angleListenable,
      builder: (context, angle, _) {
        return Transform.rotate(
          angle: angle,
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              height: 250,
              width: 130,
              child: DinoCard(movie: widget.widget.movie, onTap: () {}),
            ),
          ),
        );
      },
    );
  }
}
