// MIT License
//
// Copyright (c) 2020 Simon Lightfoot
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show BoxHitTestResult, FollowerLayer, RenderProxyBox;

void main() => runApp(RevealApp());

class RevealApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _contentFocus = FocusNode();

  @override
  void dispose() {
    _contentFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavigationBar(
        title: 'Popup Panel Example',
      ),
      body: SizedBox.expand(
        child: Column(
          children: [
            Expanded(
              child: Focus(
                focusNode: _contentFocus,
                child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () => _contentFocus.requestFocus(),
                      title: Text('Item $index'),
                    );
                  },
                  itemCount: 200,
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(height: 1.0, color: Colors.grey);
                  },
                ),
              ),
            ),
            SendMessagePanel(),
          ],
        ),
      ),
    );
  }
}

class NavigationBar extends StatelessWidget implements PreferredSizeWidget {
  const NavigationBar({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return FloatingPanelLauncher(
      child: AppBar(
        title: Text(title),
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                onPressed: () async {
                  final selected = await NavPanel.show(context);
                  if (selected != null) {
                    print('User selected: $selected');
                  }
                },
                icon: Icon(Icons.more),
              );
            },
          ),
        ],
      ),
    );
  }
}

class NavPanel extends StatelessWidget {
  static Future<String> show(BuildContext origin) {
    return FloatingPanel.show(
      origin: origin,
      builder: (_) => NavPanel(),
      // FIXME: Alignment is all screwy
      alignment: Alignment(-0.25, -0.95),
    );
  }

  const NavPanel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightGreen.shade900,
        borderRadius: BorderRadius.circular(12.0),
      ),
      width: 300.0,
      height: 300.0,
    );
  }
}

class SendMessagePanel extends StatefulWidget {
  @override
  _SendMessagePanelState createState() => _SendMessagePanelState();
}

class _SendMessagePanelState extends State<SendMessagePanel> {
  void _showAttachmentPanel(BuildContext context) async {
    final selected = await AttachmentPanel.show(context, null);
    if (selected != null) {
      print('User selected: $selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingPanelLauncher(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0.0, -4.0),
              blurRadius: 3.0,
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        child: Row(
          children: [
            Expanded(
              child: InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  fillColor: Colors.grey.shade300,
                  filled: true,
                  isDense: true,
                  suffixIcon: Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        onPressed: () => _showAttachmentPanel(context),
                        icon: const Icon(Icons.attach_file),
                      );
                    },
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}

class AttachmentPanel extends StatelessWidget {
  static Future show(BuildContext origin, Widget content) async {
    return FloatingPanel.show(
      origin: origin,
      builder: (_) => AttachmentPanel(child: content),
      alignment: const Alignment(-1.0, -3.0),
    );
  }

  const AttachmentPanel({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade900,
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AttachmentIconButton(index: 1),
                AttachmentIconButton(index: 2),
                AttachmentIconButton(index: 3),
                AttachmentIconButton(index: 4),
                AttachmentIconButton(index: 5),
              ],
            ),
            SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AttachmentIconButton(index: 6),
                AttachmentIconButton(index: 7),
                AttachmentIconButton(index: 8),
                AttachmentIconButton(index: 9),
                AttachmentIconButton(index: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AttachmentIconButton extends StatelessWidget {
  const AttachmentIconButton({
    Key key,
    @required this.index,
    this.icon = Icons.insert_drive_file,
  }) : super(key: key);

  final int index;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedReveal(
      child: IconTheme(
        data: theme.accentIconTheme,
        child: Material(
          shape: CircleBorder(),
          color: theme.accentColor,
          clipBehavior: Clip.antiAlias,
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(index),
            icon: Icon(icon),
          ),
        ),
      ),
    );
  }
}

/// ----- FLOATING PANEL -----

class FloatingPanelLauncher extends StatefulWidget {
  const FloatingPanelLauncher({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _FloatingPanelLauncherState createState() => _FloatingPanelLauncherState();
}

class _FloatingPanelLauncherState extends State<FloatingPanelLauncher> {
  final _link = LayerLink();

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: widget.child,
    );
  }
}

class FloatingPanel<T> extends StatefulWidget {
  static Future<T> show<T>({
    @required BuildContext origin,
    @required WidgetBuilder builder,
    @required Alignment alignment,
  }) {
    final launcher = origin.findAncestorStateOfType<_FloatingPanelLauncherState>();
    return Navigator.of(origin).push<T>(
      PageRouteBuilder<T>(
        opaque: false,
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (_, __, ___) {
          return FloatingPanel<T>(
            alignment: alignment,
            layerLink: launcher._link,
            origin: origin,
            builder: builder,
          );
        },
      ),
    );
  }

  const FloatingPanel({
    Key key,
    @required this.alignment,
    @required this.layerLink,
    @required this.origin,
    @required this.builder,
  }) : super(key: key);

  final Alignment alignment;
  final LayerLink layerLink;
  final BuildContext origin;
  final WidgetBuilder builder;

  @override
  _FloatingPanelState<T> createState() => _FloatingPanelState<T>();
}

class _FloatingPanelState<T> extends State<FloatingPanel> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(null),
      child: Align(
        alignment: Alignment.topLeft,
        child: AlignedTransformFollower(
          link: widget.layerLink,
          alignment: widget.alignment,
          child: GestureDetector(
            onTap: () {
              // Absorb's pointer events so they do reach our fake
              // barrier to dismiss our panel.
            },
            child: IntrinsicHeight(
              child: RevealTransition(
                origin: widget.origin,
                animation: CurvedAnimation(
                  parent: ModalRoute.of(context).animation,
                  curve: Curves.fastOutSlowIn,
                  reverseCurve: Curves.decelerate,
                ),
                child: Builder(
                  builder: widget.builder,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RevealTransition extends StatefulWidget {
  const RevealTransition({
    Key key,
    this.origin,
    this.animation,
    @required this.child,
  }) : super(key: key);

  final BuildContext origin;
  final Animation animation;
  final Widget child;

  @override
  _RevealTransitionState createState() => _RevealTransitionState();
}

class _RevealTransitionState extends State<RevealTransition> {
  Animation<double> get animation => widget.animation;

  Offset get offset {
    final box = context.findRenderObject() as RenderBox;
    final originBox = widget.origin.findRenderObject() as RenderBox;
    final originCenter = originBox.size.center(Offset.zero);
    return originBox.localToGlobal(originCenter) - box.localToGlobal(Offset.zero);
  }

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _RevealClipper(() => offset, animation),
      child: RepaintBoundary(
        child: widget.child,
      ),
    );
  }
}

class AnimatedReveal extends StatefulWidget {
  const AnimatedReveal({
    Key key,
    @required this.child,
    this.duration = const Duration(milliseconds: 450),
  }) : super(key: key);

  final Widget child;
  final Duration duration;

  @override
  _AnimatedRevealState createState() => _AnimatedRevealState();
}

class _AnimatedRevealState extends State<AnimatedReveal> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  _RevealTransitionState _transition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
  }

  @override
  void didUpdateWidget(AnimatedReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.duration = widget.duration;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _transition?.animation?.removeListener(_onAnimationChanged);
    _transition = context.findAncestorStateOfType<_RevealTransitionState>();
    _transition.animation.addListener(_onAnimationChanged);

    scheduleMicrotask(_onAnimationChanged);
  }

  void _onAnimationChanged() {
    final RenderBox box = context.findRenderObject();
    final origin = box.localToGlobal(box.size.center(Offset.zero), ancestor: _transition.context.findRenderObject());
    // FIXME: Distance calculation should be based on the
    // joint size of the popup area and the source offset.
    final size = _transition.context.size;
    final pos = _transition.offset;
    final distance = (pos - origin).distance;
    if (distance < pos.distance * _transition.animation.value) {
      if (_controller.status != AnimationStatus.forward) {
        _controller.forward();
      }
    } else {
      if (_controller.status != AnimationStatus.reverse) {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _transition.animation.removeListener(_onAnimationChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
        reverseCurve: Curves.elasticIn,
      ),
      child: widget.child,
    );
  }
}

class _RevealClipper extends CustomClipper<Path> {
  _RevealClipper(this.offset, this.animation) : super(reclip: animation);

  final ValueGetter<Offset> offset;
  final Animation<double> animation;

  @override
  Path getClip(Size size) {
    final _offset = offset();
    final _area = _offset + Offset(size.longestSide, size.longestSide);
    final radius = _area.distance * animation.value;
    final rect = Rect.fromCircle(center: _offset, radius: radius);
    return Path()..addOval(rect);
  }

  @override
  bool shouldReclip(_RevealClipper oldClipper) {
    return offset != oldClipper.offset;
  }
}

/// Exactly the same as CompositedTransformFollower
/// except we simplified it and added an alignment parameter.
class AlignedTransformFollower extends SingleChildRenderObjectWidget {
  const AlignedTransformFollower({
    Key key,
    @required this.link,
    this.alignment = Alignment.center,
    Widget child,
  })  : assert(link != null),
        assert(alignment != null),
        super(key: key, child: child);

  final LayerLink link;
  final Alignment alignment;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderAlignedTransformFollower(
      link: link,
      alignment: alignment,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderAlignedTransformFollower renderObject) {
    renderObject
      ..link = link
      ..alignment = alignment;
  }
}

class RenderAlignedTransformFollower extends RenderProxyBox {
  RenderAlignedTransformFollower({
    @required LayerLink link,
    Alignment alignment,
    RenderBox child,
  })  : assert(link != null),
        super(child) {
    _link = link;
    _alignment = alignment;
  }

  LayerLink _link;

  LayerLink get link => _link;

  set link(LayerLink value) {
    assert(value != null);
    if (_link == value) return;
    _link = value;
    markNeedsPaint();
  }

  Alignment _alignment;

  Alignment get alignment => _alignment;

  set alignment(Alignment value) {
    assert(value != null);
    if (_alignment == value) return;
    _alignment = value;
    markNeedsPaint();
  }

  @override
  bool get alwaysNeedsCompositing => true;

  @override
  FollowerLayer get layer => super.layer as FollowerLayer;

  @override
  void detach() {
    layer = null;
    super.detach();
  }

  @override
  bool hitTest(BoxHitTestResult result, {Offset position}) {
    if (link.leader == null) return false;
    return hitTestChildren(result, position: position);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) {
    return result.addWithPaintTransform(
      transform: getCurrentTransform(),
      position: position,
      hitTest: (BoxHitTestResult result, Offset position) {
        return super.hitTestChildren(result, position: position);
      },
    );
  }

  Matrix4 getCurrentTransform() {
    return layer?.getLastTransform() ?? Matrix4.identity();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final childOffset = child != null ? _alignment.alongSize(child.size) : Offset.zero;
    if (layer == null) {
      layer = FollowerLayer(
        link: link,
        showWhenUnlinked: false,
        linkedOffset: childOffset,
        unlinkedOffset: offset,
      );
    } else {
      layer
        ..link = link
        ..showWhenUnlinked = false
        ..linkedOffset = childOffset
        ..unlinkedOffset = offset;
    }
    context.pushLayer(
      layer,
      super.paint,
      Offset.zero,
      childPaintBounds: const Rect.fromLTRB(
        // We don't know where we'll end up, so we have no idea what our cull rect should be.
        double.negativeInfinity,
        double.negativeInfinity,
        double.infinity,
        double.infinity,
      ),
    );
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    transform.multiply(getCurrentTransform());
  }
}
