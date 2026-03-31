import 'package:dinokino_tablet/models/movie.dart';
import 'package:dinokino_tablet/pages/movies_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RatingDialog extends StatefulWidget {
  const RatingDialog({super.key, required this.movie});
  final Movie movie;

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  double angle = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * .6,
      height: Get.height * .8,
      child: Dialog(
        backgroundColor: Colors.white70,
        child: BackdropFilter(
          filterConfig: ImageFilterConfig.blur(sigmaX: 4, sigmaY: 4),
          child: Column(
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
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    height: Get.height * .4,
                    width: 200,
                    child: Center(
                      child: Column(
                        spacing: 12,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/thumb_down.png"),
                          Text(
                            "No, not at all",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.grey,
                    height: Get.height * .4,
                    width: 200,
                    child: Draggable<String>(
                      feedback: Material(
                        child: SizedBox(
                          height: 250,
                          width: 130,
                          child: Transform.rotate(
                            angle: angle,
                            child: DinoCard(movie: widget.movie, onTap: () {}),
                          ),
                        ),
                      ),
                      onDragUpdate: (details) {
                        setState(() {
                          angle = details.delta.distance;
                        });
                      },
                      child: Material(
                        child: SizedBox(
                          height: 250,
                          width: 130,
                          child: DinoCard(movie: widget.movie, onTap: () {}),
                        ),
                      ),
                    ),
                  ),
                  DragTarget<String>(
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        height: Get.height * .4,
                        width: 200,
                        child: Center(
                          child: Column(
                            spacing: 12,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset("assets/images/thumb_up.png"),
                              Text(
                                "Yesm I loved it",
                                style: TextStyle(color: Colors.white),
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
                "Drag the thumbnail rate",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 60,
                width: 200,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.white54),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("Rate"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
