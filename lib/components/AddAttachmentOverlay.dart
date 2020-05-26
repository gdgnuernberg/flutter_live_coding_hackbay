import 'package:chat/components/AnimatedReveal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:icon_shadow/icon_shadow.dart';

class AddAttachmentOverlay extends StatefulWidget {
  const AddAttachmentOverlay({
    Key key,
  }) : super(key: key);

  @override
  _AddAttachmentOverlayState createState() => _AddAttachmentOverlayState();
}

class _AddAttachmentOverlayState extends State<AddAttachmentOverlay> {
  final TextStyle textStyle = const TextStyle(
    fontFamily: 'MuseoSans',
    color: Colors.black,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;

    return SafeArea(
      top: false,
      bottom: false,
      left: false,
          child: Container(
        margin: const EdgeInsets.only(left: 20, right: 65.0, bottom: 2),
        width: MediaQuery.of(context).size.width,
        height: isLandscape ? 120 : 200,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Material(
          color: Colors.white,
          elevation: 2,
          borderRadius: BorderRadius.circular(20),
          child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: isLandscape ? 4 / 3 : 6 / 5,
            padding: const EdgeInsets.all(20),
            crossAxisCount: isLandscape ? 6 : 3,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () => Navigator.of(context).pop('camera'),
                child: AnimatedReveal(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade500,
                          shape: BoxShape.circle,
                        ),
                        child: IconShadowWidget(
                          const Icon(
                            Icons.camera,
                            color: Colors.white,
                          ),
                          shadowColor: Colors.black54,
                        ),
                      ),
                      Text(
                        'Camera',
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () => Navigator.of(context).pop('gallery'),
                child: AnimatedReveal(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade500,
                          shape: BoxShape.circle,
                        ),
                        child: IconShadowWidget(
                          const Icon(
                            Icons.panorama,
                            color: Colors.white,
                          ),
                          shadowColor: Colors.black54,
                        ),
                      ),
                      Text(
                        'Gallery',
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () => Navigator.of(context).pop('video'),
                child: AnimatedReveal(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.red.shade500,
                          shape: BoxShape.circle,
                        ),
                        child: IconShadowWidget(
                          const Icon(
                            Icons.movie,
                            color: Colors.white,
                          ),
                          shadowColor: Colors.black54,
                        ),
                      ),
                      Text(
                        'Video',
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () => Navigator.of(context).pop('document'),
                child: AnimatedReveal(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.7),
                          shape: BoxShape.circle,
                        ),
                        child: IconShadowWidget(
                          const Icon(
                            Icons.insert_drive_file,
                            color: Colors.white,
                          ),
                          shadowColor: Colors.black54,
                        ),
                      ),
                      Text(
                        'Document',
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () => Navigator.of(context).pop('audio'),
                child: AnimatedReveal(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade500,
                          shape: BoxShape.circle,
                        ),
                        child: IconShadowWidget(
                          const Icon(
                            Icons.headset,
                            color: Colors.white,
                          ),
                          shadowColor: Colors.black54,
                        ),
                      ),
                      Text(
                        'Audio',
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () => Navigator.of(context).pop('location'),
                child: AnimatedReveal(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.green.shade500,
                          shape: BoxShape.circle,
                        ),
                        child: IconShadowWidget(
                          const Icon(
                            Icons.location_on,
                            color: Colors.white,
                          ),
                          shadowColor: Colors.black54,
                        ),
                      ),
                      Text(
                        'My location',
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
