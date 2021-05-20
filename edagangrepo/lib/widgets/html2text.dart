import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/dom.dart' as dom;


Widget htmlText(String htmltxt) {
  return Html(
    data: htmltxt ?? "",
    defaultTextStyle: GoogleFonts.lato(textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
    linkStyle: const TextStyle(
      color: Colors.redAccent,
      decorationColor: Colors.redAccent,
      decoration: TextDecoration.underline,
    ),
    onLinkTap: (url) {
      print("Opening $url...");
    },
    onImageTap: (src) {
      print(src);
    },
    customRender: (node, children) {
      if (node is dom.Element) {
        switch (node.localName) {
          case "custom_tag":
            return Column(children: children);
        }
      }
      return null;
    },
    customTextAlign: (dom.Node node) {
      if (node is dom.Element) {
        switch (node.localName) {
          case "p":
            return TextAlign.left;
        }
      }
      return null;
    },
    customTextStyle: (dom.Node node, TextStyle baseStyle) {
      if (node is dom.Element) {
        switch (node.localName) {
          case "p":
            return baseStyle.merge(TextStyle(height: 1.2, fontSize: 15));
        }
      }
      return baseStyle;
    },
  );
}

Widget htmlText2(String htmltxt) {
  return Html(
    data: htmltxt ?? "",
    defaultTextStyle: GoogleFonts.lato(textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),),
    linkStyle: const TextStyle(
      color: Colors.redAccent,
      decorationColor: Colors.redAccent,
      decoration: TextDecoration.underline,
    ),
    onLinkTap: (url) {
      print("Opening $url...");
    },
    onImageTap: (src) {
      print(src);
    },
    customRender: (node, children) {
      if (node is dom.Element) {
        switch (node.localName) {
          case "custom_tag":
            return Column(children: children);
        }
      }
      return null;
    },
    customTextAlign: (dom.Node node) {
      if (node is dom.Element) {
        switch (node.localName) {
          case "p":
            return TextAlign.left;
        }
      }
      return null;
    },
    customTextStyle: (dom.Node node, TextStyle baseStyle) {
      if (node is dom.Element) {
        switch (node.localName) {
          case "p":
            return baseStyle.merge(TextStyle(height: 1.2, fontSize: 15));
        }
      }
      return baseStyle;
    },
  );
}