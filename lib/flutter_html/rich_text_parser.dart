// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:html/dom.dart' as dom;

typedef CustomRender = Widget Function(dom.Node node, List<Widget> children);
typedef CustomTextStyle = TextStyle Function(
  dom.Node node,
  TextStyle baseStyle,
);
typedef CustomTextAlign = TextAlign Function(dom.Element elem);
typedef CustomEdgeInsets = EdgeInsets Function(dom.Node node);
typedef OnLinkTap = void Function(String url);
typedef OnImageTap = void Function(String source);

const offsetTagsFontSizeFactor = 0.7; //The ratio of the parent font for each of the offset tags: sup or sub

class LinkTextSpan extends TextSpan {
  // Beware!
  //
  // This class is only safe because the TapGestureRecognizer is not
  // given a deadline and therefore never allocates any resources.
  //
  // In any other situation -- setting a deadline, using any of the less trivial
  // recognizers, etc -- you would have to manage the gesture recognizer's
  // lifetime and call dispose() when the TextSpan was no longer being rendered.
  //
  // Since TextSpan itself is @immutable, this means that you would have to
  // manage the recognizer from outside the TextSpan, e.g. in the State of a
  // stateful widget that then hands the recognizer to the TextSpan.
  final String? url;

  LinkTextSpan(
      {TextStyle? style,
      this.url,
      String? text,
      OnLinkTap? onLinkTap,
      List<TextSpan>? children})
      : super(
          style: style,
          text: text,
          children: children ?? <TextSpan>[],
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              onLinkTap?.call(url!);
            },
        );
}

class LinkBlock extends Container {
  // final String url;
  // final EdgeInsets padding;
  // final EdgeInsets margin;
  // final OnLinkTap onLinkTap;
  final List<Widget>? children;

  LinkBlock({super.key,
    String? url,
    EdgeInsets? padding,
    EdgeInsets? margin,
    OnLinkTap? onLinkTap,
    this.children,
  }) : super(
          padding: padding,
          margin: margin,
          child: GestureDetector(
            onTap: () {
              onLinkTap!(url!);
            },
            child: Column(
              children: children!,
            ),
          ),
        );
}

class BlockText extends StatelessWidget {
  final RichText child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Decoration? decoration;
  final bool shrinkToFit;

  const BlockText({super.key,
    required this.child,
    required this.shrinkToFit,
    this.padding,
    this.margin,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: shrinkToFit ? null : double.infinity,
      padding: padding,
      margin: margin,
      decoration: decoration,
      child: child,
    );
  }
}

class ParseContext {
  List<Widget>? rootWidgetList; // the widgetList accumulator
  dynamic parentElement; // the parent spans accumulator
  int indentLevel = 0;
  int listCount = 0;
  String listChar = '•';
  String? blockType; // blockType can be 'p', 'div', 'ul', 'ol', 'blockquote'
  bool condenseWhitespace = true;
  bool spansOnly = false;
  bool inBlock = false;
  TextStyle? childStyle;

  ParseContext({
    this.rootWidgetList,
    this.parentElement,
    this.indentLevel = 0,
    this.listCount = 0,
    this.listChar = '•',
    this.blockType,
    this.condenseWhitespace = true,
    this.spansOnly = false,
    this.inBlock = false,
    this.childStyle,
  }) {
    childStyle = childStyle ?? const TextStyle();
  }

  ParseContext.fromContext(ParseContext parseContext) {
    rootWidgetList = parseContext.rootWidgetList;
    parentElement = parseContext.parentElement;
    indentLevel = parseContext.indentLevel;
    listCount = parseContext.listCount;
    listChar = parseContext.listChar;
    blockType = parseContext.blockType;
    condenseWhitespace = parseContext.condenseWhitespace;
    spansOnly = parseContext.spansOnly;
    inBlock = parseContext.inBlock;
    childStyle = parseContext.childStyle ?? const TextStyle();
  }
}
