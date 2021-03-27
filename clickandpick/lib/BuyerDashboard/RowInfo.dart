import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RowInfo extends StatelessWidget {
  final String location;
  final String image_path;
  final String title;
  final double width;
  final Function func;

  const RowInfo({
    Key key,
    @required this.width,
    @required this.title,
    this.location,
    @required this.image_path,
    @required this.func,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        func();
      },
      child: Container(
        width: width,
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 15,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl:
                    // the 4th image URL
                    image_path,
                imageBuilder: (context, imageProvider) => Container(
                  width: width / 8,
                  height: width / 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: width / 19,
                    ),
                  ),
                  location == null
                      ? Container()
                      : Text(
                          location.length > 31
                              ? location.substring(0, 30) + '...'
                              : location,
                          style: TextStyle(
                            fontSize: width / 28,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
