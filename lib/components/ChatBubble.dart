import 'package:chat/components/ClipRThread.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final AnimationController animationController;
  final Widget customContent;
  final String media;
  final String message, time;
  final bool delivered;
  final bool isNotMe;
  final Color textColor;
  final String fontFamily;
  final double fontSize;
  final bool hideTimestamp;
  final double bubbleRadius;
  // controller to be initialized by parent
  // so that parent can have control over when to animate

  ChatBubble(
      {this.customContent,
      this.media,
      this.message,
      this.time,
      this.delivered,
      this.isNotMe,
      this.textColor,
      this.fontFamily,
      this.fontSize,
      this.hideTimestamp = false,
      this.bubbleRadius = 2.0,
      this.animationController})
      : super();

  @override
  Widget build(BuildContext context) {
    final txtFont = fontFamily != null ? fontFamily : 'MuseoSans';
    final txtSize = fontSize != null ? fontSize : 14.0;
    final txtColor = textColor != null ? textColor : Colors.black;
    final bg = isNotMe ? Colors.white : Colors.green.shade500;
    // final icon = delivered ? Icons.done_all : Icons.done;

    List<Widget> _buildTrailing() {
      List<Widget> list = [];

      if (!hideTimestamp)
        list.add(
          Text(
            time,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 10.0,
            ),
          ),
        );
      /* list.add(SizedBox(width: 3.0));
      if (!hdDelivered) {
        list.add(Icon(
          icon,
          size: 12.0,
          color: Colors.black,
        ));
      } */

      return list;
    }

    Widget child;

    if (isNotMe != true) {
      child = Container(
        margin: EdgeInsets.only(left: 3.0, top: 3.0, bottom: 3.0, right: bubbleRadius == 0.0 ? 6.0 : 3.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            _RightThread(
                r: bubbleRadius,
                textColor: txtColor,
                textFont: txtFont,
                textSize: txtSize,
                trailingWidget: _buildTrailing(),
                customContent: customContent,
                media: media,
                message: message,
                backgroundColor: bg,
                hideTimestamp: hideTimestamp),
          ],
        ),
      );
    } else {
      child = Container(
        margin: EdgeInsets.only(left: bubbleRadius == 0.0 ? 6.0 : 3.0, top: 3.0, bottom: 3.0, right: 3.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _LeftThread(
                r: bubbleRadius,
                textColor: txtColor,
                textFont: txtFont,
                textSize: txtSize,
                trailingWidget: _buildTrailing(),
                customContent: customContent,
                media: media,
                message: message,
                backgroundColor: bg,
                hideTimestamp: hideTimestamp),
          ],
        ),
      );
    }

    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
      ),
      child: child,
    );
  }
}

class _LeftThread extends StatelessWidget {
  final Widget customContent;
  final String media;
  final String message;
  final Color backgroundColor;
  final double r;
  final String textFont;
  final Color textColor;
  final double textSize;
  final bool hideTimestamp;
  final List<Widget> trailingWidget;

  _LeftThread(
      {this.customContent,
      this.media,
      this.message,
      this.trailingWidget,
      this.textColor,
      this.textFont,
      this.textSize,
      this.hideTimestamp,
      this.r = 2,
      this.backgroundColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ClipRThread(r),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: r == 0.0 ? const Radius.circular(5) : Radius.zero,
          topRight: const Radius.circular(5.0),
          bottomLeft: const Radius.circular(5.0),
          bottomRight: const Radius.circular(5.0),
        ),
        child: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
          padding: EdgeInsets.fromLTRB(8.0 + 2 * r, 8.0, 8.0, 8.0),
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(blurRadius: .5, spreadRadius: 1.0, color: Colors.black.withOpacity(.12))],
            color: backgroundColor,
          ),
          child: Stack(children: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: hideTimestamp ? 5.0 : 48.0),
                child: this.customContent ??
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (this.media != null)
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: const Radius.circular(5),
                              bottomLeft: const Radius.circular(5),
                              topRight: const Radius.circular(5),
                              bottomRight: const Radius.circular(5),
                            ),
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 250),
                              child: Image.network(this.media),
                            ),
                          ),
                        if (this.message != null)
                          Text(
                            this.message,
                            softWrap: true,
                            textAlign: TextAlign.left,
                            style: TextStyle(fontFamily: textFont, color: textColor, fontSize: textSize),
                          ),
                      ],
                    )),
            Positioned(
              bottom: 0.0,
              right: 0.0,
              child: Row(
                children: this.trailingWidget,
              ),
            )
          ]),
        ),
      ),
    );
  }
}

class _RightThread extends StatelessWidget {
  final Widget customContent;
  final String media;
  final String message;
  final Color backgroundColor;
  final double r;
  final String textFont;
  final Color textColor;
  final double textSize;
  final bool hideTimestamp;
  final List<Widget> trailingWidget;

  _RightThread(
      {this.customContent,
      this.media,
      this.message,
      this.trailingWidget,
      this.textColor,
      this.textFont,
      this.textSize,
      this.hideTimestamp = false,
      this.r = 2,
      this.backgroundColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    final clipped = ClipPath(
      clipper: ClipRThread(r),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: r == 0.0 ? const Radius.circular(5) : Radius.zero,
          topRight: const Radius.circular(5),
          bottomLeft: const Radius.circular(5.0),
          bottomRight: const Radius.circular(5.0),
        ),
        child: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
          padding: EdgeInsets.fromLTRB(8.0 + 2 * r, 8.0, 8.0, 8.0),
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(blurRadius: .5, spreadRadius: 1.0, color: Colors.black.withOpacity(.12))],
            color: backgroundColor,
          ),
          child: Transform(
            transform: Matrix4.diagonal3Values(-1.0, 1.0, 1.0),
            child: Stack(children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: hideTimestamp ? 5.0 : 48.0),
                  child: this.customContent ??
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          if (this.media != null)
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              ),
                              child: Container(
                                constraints: const BoxConstraints(maxWidth: 250),
                                child: Image.network(this.media),
                              ),
                            ),
                          if (this.message != null)
                            Text(
                              this.message,
                              softWrap: true,
                              textAlign: TextAlign.left,
                              style: TextStyle(fontFamily: textFont, color: textColor, fontSize: textSize),
                            ),
                        ],
                      )),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: Row(
                  children: this.trailingWidget,
                ),
              )
            ]),
            alignment: Alignment.center,
          ),
        ),
      ),
    );
    return Transform(
      transform: Matrix4.diagonal3Values(-1.0, 1.0, 1.0),
      child: clipped,
      alignment: Alignment.center,
    );
  }
}
