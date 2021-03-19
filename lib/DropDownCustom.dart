import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropDownCustom extends StatefulWidget {
  DropDownCustom({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DropDownCustomState createState() => _DropDownCustomState();
}

class _DropDownCustomState extends State<DropDownCustom> {
  bool isDropdownOpend = false;
  GlobalKey actionKey;
  double height, width, xPostion, yPostion;
  OverlayEntry overlayEntry;
  @override
  void initState() {
    actionKey = LabeledGlobalKey(widget.title);
    super.initState();
  }

  OverlayEntry createFlotingDropDown() {
    return OverlayEntry(builder: (context) {
      return Positioned(
          left: xPostion,
          width: width,
          top: yPostion,
          height: height * 6 + height,
          child: DropDown(itemHeight: height));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: actionKey,
      onTap: () {
        setState(() {
          findDropDownData();
          if (isDropdownOpend) {
            overlayEntry.remove();
          } else {
            overlayEntry = createFlotingDropDown();
            Overlay.of(context).insert(overlayEntry);
          }
          isDropdownOpend = !isDropdownOpend;
        });
      },
      child: Container(
        child: Row(
          children: [Text(widget.title), Spacer(), Icon(Icons.arrow_drop_down)],
        ),
      ),
    );
  }

  void _incrementCounter() {}

  void findDropDownData() {
    RenderBox renderBox = actionKey.currentContext.findRenderObject();
    height = renderBox.size.height;
    width = renderBox.size.width;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    xPostion = offset.dx;
    yPostion = offset.dy;
    print("=height==${height}=");
    print("=height==${width}=");
    print("=height==${xPostion}=");
    print("=height==${yPostion}=");
  }
}

class DropDown extends StatelessWidget {
  final double itemHeight;
  const DropDown({Key, key, this.itemHeight}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
        ),
        Align(
          alignment: Alignment(-0.85, 0),
          child: ClipPath(
            clipper: ArrowClipper(),
            child: Container(
              decoration: BoxDecoration(color: Colors.red),
              height: 20,
              width: 20,
            ),
          ),
        ),
        Material(
            elevation: 0,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              height: itemHeight * 4,
              child: Column(
                children: [
                  DropDownItem.first(
                    text: "abc",
                    isselected: false,
                  ),
                  DropDownItem(
                    text: "abc",
                    isselected: false,
                  ),
                  DropDownItem.last(
                    text: "abc",
                    isselected: false,
                  ),
                ],
              ),
            ))
      ],
    );
  }
}

class DropDownItem extends StatelessWidget {
  final String text;
  final bool isselected;
  final bool isFirstItem;
  final bool isLastItem;
  DropDownItem(
      {Key,
      key,
      this.text,
      this.isselected = false,
      this.isFirstItem = false,
      this.isLastItem = false})
      : super(key: key);
  factory DropDownItem.first({String text, bool isselected}) {
    return DropDownItem(
        text: text,
        isselected: isselected,
        isFirstItem: true,
        isLastItem: false);
  }
  factory DropDownItem.last({String text, bool isselected}) {
    return DropDownItem(
        text: text,
        isselected: isselected,
        isFirstItem: false,
        isLastItem: true);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
              top: isFirstItem ? Radius.circular(5) : Radius.zero,
              bottom: isLastItem ? Radius.circular(5) : Radius.zero),
          color: Colors.red,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 12),
            )
          ],
        ));
  }
}

class ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
