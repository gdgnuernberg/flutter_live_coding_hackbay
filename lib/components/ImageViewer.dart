import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatefulWidget {
  final String networkURL;
  final String imageURL;
  final String heroTag;
  final String fileURL;
  final Uint8List imageBytes;

  ImageViewer({Key key, this.imageURL, this.networkURL, this.fileURL, this.heroTag, this.imageBytes}) : super(key: key);

  @override
  ImageViewerState createState() => ImageViewerState();
}

class ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: <Widget>[
      PhotoView(
        heroAttributes: PhotoViewHeroAttributes(
          tag: widget.heroTag != null ? widget.heroTag : null,
        ),
        minScale: PhotoViewComputedScale.contained,
        imageProvider: widget.imageURL != null
            ? AssetImage(widget.imageURL)
            : widget.imageBytes != null
                ? MemoryImage(widget.imageBytes)
                : widget.fileURL != null ? FileImage(new File(widget.fileURL)) : NetworkImage(widget.networkURL),
        loadingBuilder: (context, event) => Center(child: CircularProgressIndicator()),
      ),
      Positioned(
          top: 0,
          left: 0,
          child: SafeArea(
              child: Material(
            elevation: 0,
            child: BackButton(
              color: Colors.white,
            ),
            color: Colors.transparent,
          )))
    ]);
  }
}
