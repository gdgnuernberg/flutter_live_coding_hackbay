import 'package:auto_size_text/auto_size_text.dart';
import 'package:chat/components/ChatBubble.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

class DocumentMessage extends StatelessWidget {
  const DocumentMessage({
    Key key,
    @required this.animationController,
    @required this.fileSize,
    @required this.fileName,
    @required this.fileExtension,
    @required this.filePath,
  }) : super(key: key);

  final AnimationController animationController;
  final String fileSize;
  final String fileName;
  final String fileExtension;
  final String filePath;

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      animationController: this.animationController,
      delivered: false,
      customContent: Container(
        width: 100,
        height: 80,
        child: InkWell(
          onTap: () => {
            OpenFile.open(filePath)
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.insert_drive_file,
                        color: Colors.red.shade800,
                        size: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          fileExtension.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontFamily: 'MuseoSans',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: AutoSizeText(
                      fileName,
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'MuseoSans',
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    fileSize,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'MuseoSans',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      isNotMe: false,
      time: DateFormat('HH:mm').format(DateTime.now()).toString(),
    );
  }
}
