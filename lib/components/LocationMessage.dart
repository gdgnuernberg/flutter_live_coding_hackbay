import 'package:auto_size_text/auto_size_text.dart';
import 'package:chat/components/ChatBubble.dart';
import 'package:flutter/material.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:intl/intl.dart';

class LocationMessage extends StatelessWidget {
  const LocationMessage({
    Key key,
    @required this.animationController,
    @required this.addressLine,
    @required this.onLocationTap,
  }) : super(key: key);

  final AnimationController animationController;
  final String addressLine;
  final VoidCallback onLocationTap;

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      animationController: this.animationController,
      delivered: false,
      customContent: Container(
        constraints: const BoxConstraints(
          maxHeight: 150,
          maxWidth: 250,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          image: const DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/img/location/maps_background.png'),
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: LinearGradient(
                  stops: [0.0, 1.0],
                  begin: Alignment.bottomCenter,
                  end: const Alignment(0.0, 0.4),
                  colors: [
                    Colors.black,
                    Colors.transparent.withOpacity(0.01),
                  ],
                ),
              ),
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(5),
              child: AutoSizeText(
                this.addressLine,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MuseoSans',
                ),
              ),
            ),
            Positioned.fill(
              child: IconButton(
                onPressed: this.onLocationTap,
                icon: IconShadowWidget(
                  Icon(
                    Icons.location_on,
                    size: 50,
                    color: Theme.of(context).accentColor,
                  ),
                  shadowColor: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
      isNotMe: false,
      time: DateFormat('HH:mm').format(DateTime.now()).toString(),
    );
  }
}
