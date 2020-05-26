import 'dart:io';

import 'package:chat/api/models/RandomUser.dart';
import 'package:chat/components/AddAttachmentOverlay.dart';
import 'package:chat/components/AnimatedReveal.dart';
import 'package:chat/components/ChatBubble.dart';
import 'package:chat/components/ContactProfile.dart';
import 'package:chat/components/DocumentMessage.dart';
import 'package:chat/components/LocationMessage.dart';
import 'package:date_format/date_format.dart';
import 'package:file_picker/file_picker.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:path/path.dart' as path;

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key key,
    @required this.user,
  }) : super(key: key);

  final RandomUser user;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  AnimationController _controller;
  TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  AnimationController _scaleController;
  bool enterIsSend = false;
  final FocusNode focusNode = FocusNode();

  List<Widget> messages = <Widget>[];

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _scaleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    focusNode.addListener(onFocusChange);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void initChat() {
    setState(() {
      this.messages.addAll([
        ChatBubble(
          animationController: _controller,
          message: 'Hi there!',
          time: '12:00',
          delivered: true,
          isNotMe: false,
        ),
        ChatBubble(
          animationController: _controller,
          message: 'How was the party last night 😎',
          time: '12:01',
          delivered: true,
          isNotMe: false,
          bubbleRadius: 0.0,
        ),
        ChatBubble(
          animationController: _controller,
          message: 'Nice! You missed a lot 😋',
          time: '12:00',
          delivered: true,
          isNotMe: true,
        ),
        ChatBubble(          
          animationController: _controller,
          message: 'Damn 🤨',
          time: '12:00',
          delivered: true,
          isNotMe: false,
        ),
      ]);
      _controller.forward();
    });
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide picker when keyboard appear
      setState(() {});
    }
  }

  Future<void> _openCamera({
    bool pickImage = true,
    ImageSource source = ImageSource.camera,
  }) async {
    File media;
    if (pickImage) {
      media = await ImagePicker.pickImage(source: source);
    } else {
      media = await ImagePicker.pickVideo(source: source);
    }

    debugPrint(media.path);
  }

  Future<void> _pickFile({
    FileType fileType = FileType.custom,
    List<String> extensions = const [
      'pdf',
      'txt',
      'rtf',
      'odt',
      'ods',
      'html',
      'htm',
      'xml',
      'doc',
      'docx',
      'csv',
      'xls',
      'xlsx',
      'ppt',
      'pptp',
      '7z',
      'rar',
      'zip',
      'vcf',
      'otf',
      'ttf',
      'psd',
    ],
  }) async {
    File file = await FilePicker.getFile(
      type: fileType,
      allowedExtensions: extensions,
    );

    if (file != null) {
      debugPrint('Path: ' + file.path);
      debugPrint('File extension: ' + path.extension(file.path));

      this.onSendMessage(
        null,
        customBubble: DocumentMessage(
          animationController: _controller,
          fileSize: filesize(file.lengthSync()),
          fileExtension: path.extension(file.path).replaceAll('.', ''),
          fileName: path.basename(file.path),
          filePath: file.path,
        ),
      );
    }
  }

  Future<void> _sendMyLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    final List<Address> _addresses = await Geocoder.local.findAddressesFromCoordinates(
      Coordinates(_locationData.latitude, _locationData.longitude),
    );

    this.onSendMessage(
      null,
      customBubble: LocationMessage(
        animationController: _controller,
        addressLine: _addresses[0].addressLine,
        onLocationTap: () => _onLocationTap(_addresses[0]),
      ),
    );
  }

  void _onLocationTap(Address locationInfo) {
    MapsLauncher.launchCoordinates(
      locationInfo.coordinates.latitude,
      locationInfo.coordinates.longitude,
      'Me',
    );
  }

  void _onAddAttachment(String selected) {
    switch (selected) {
      case 'camera':
        _openCamera();
        break;
      case 'gallery':
        _openCamera(source: ImageSource.gallery);
        break;
      case 'video':
        _openCamera(pickImage: false, source: ImageSource.gallery);
        break;
      case 'document':
        _pickFile();
        break;
      case 'audio':
        _pickFile(fileType: FileType.audio, extensions: null
            //extensions: ['aac', 'mid', 'midi', 'mp3', 'mpa', 'ogg', 'wav', 'wma'],
            );
        break;
      case 'location':
        _sendMyLocation();
        break;
      default:
    }
  }

  void _toggleAddAttachmentOverlay(BuildContext context) async {
    final String selected = await FloatingPanel.show<String>(
      origin: context,
      builder: (context) => const AddAttachmentOverlay(),
      alignment: const Alignment(-1.0, -3.0),
    );
    if (selected != null) {
      _onAddAttachment(selected);
    }
  }

  void onSendMessage(String content, {Widget customBubble}) {
    if (content?.trim() != '' || customBubble != null) {
      textEditingController.clear();
      if (textEditingController.text.isNotEmpty) {
        _scaleController.forward();
      } else {
        _scaleController.reverse();
      }

      final message = customBubble ??
          ChatBubble(
              animationController: _controller,
              delivered: false,
              message: content,
              isNotMe: false,
              time: formatDate(DateTime.now(), [HH, ':', nn]));

      setState(() {
        this.messages.add(message);
      });

      if (listScrollController.position.maxScrollExtent > listScrollController.position.minScrollExtent) {
        listScrollController.animateTo(listScrollController.position.maxScrollExtent + 5,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    }
  }

  void _viewContact() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactProfile(user: widget.user)),
    );
  }

  Widget buildHistory() {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          top: false,
          bottom: false,
          child: ListView.builder(
            itemBuilder: (context, index) => messages[index],
            itemCount: messages.length,
            controller: listScrollController,
          ),
        ),
      ),
    );
  }

  Widget buildTextField() {
    return SafeArea(
      top: false,
      bottom: false,
      child: FloatingPanelLauncher(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.5),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * .3),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 15, left: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(22)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          // Edit text
                          Flexible(
                            child: Container(
                              child: TextField(
                                onChanged: (val) {
                                  if (val.isNotEmpty) {
                                    _scaleController.forward();
                                  } else {
                                    _scaleController.reverse();
                                  }
                                },
                                onSubmitted:
                                    enterIsSend == true ? (val) => onSendMessage(textEditingController.text) : null,
                                style: const TextStyle(color: Colors.black, fontSize: 15.0, fontFamily: 'MuseoSans'),
                                controller: textEditingController,
                                maxLength: 500,
                                maxLengthEnforced: true,
                                maxLines: null,
                                keyboardType: enterIsSend ? TextInputType.text : TextInputType.multiline,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(left: 15, top: 10, bottom: 10, right: 0),
                                  counterText: '',
                                  border: InputBorder.none,
                                  hintText: 'Type a message',
                                  hintStyle: const TextStyle(color: Colors.grey),
                                ),
                                focusNode: focusNode,
                              ),
                            ),
                          ),

                          // Button send image
                          ClipOval(
                            child: Material(
                              borderRadius: BorderRadius.circular(100),
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 1.0),
                                child: Builder(
                                  builder: (context) => IconButton(
                                    icon: const Icon(Icons.attach_file),
                                    onPressed: () => _toggleAddAttachmentOverlay(context),
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              color: Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Button send message
            Flexible(
              flex: 0,
              fit: FlexFit.tight,
              child: Material(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                child: new Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(bottom: 17, right: 2),
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () => onSendMessage(this.textEditingController.text),
                    child: CircleAvatar(
                      radius: 23,
                      backgroundColor: Colors.white,
                      child: AnimatedBuilder(
                        animation: _scaleController,
                        builder: (BuildContext context, Widget child) {
                          if (textEditingController.text.isEmpty) {
                            return const Icon(Icons.mic);
                          } else {
                            return ScaleTransition(
                                scale: CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
                                child: const Icon(Icons.send));
                          }
                        },
                      ),
                    ),
                  ),
                ),
                color: Colors.transparent,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          title: ListTile(
              onTap: _viewContact,
              contentPadding: EdgeInsets.zero,
              leading: Hero(
                tag: widget.user.userID,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(widget.user.profilePic),
                    ),
                  ),
                ),
              ),
              title: Text(widget.user.username)),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              color: Colors.transparent,
              child: Column(
                children: <Widget>[buildHistory(), buildTextField()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
