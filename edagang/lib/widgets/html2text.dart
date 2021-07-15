import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/image_render.dart';


Widget htmlText(String htmltxt) {
  return Html(
    data: htmltxt,
    customImageRenders: {
      networkSourceMatcher(domains: ["flutter.dev"]):
          (context, attributes, element) {
        return FlutterLogo(size: 36);
      },
      networkSourceMatcher(domains: ["mydomain.com"]): networkImageRender(
        headers: {"Custom-Header": "some-value"},
        altWidget: (alt) => Text(alt),
        loadingWidget: () => Text("Loading..."),
      ),
      // On relative paths starting with /wiki, prefix with a base url
          (attr, _) => attr["src"] != null && attr["src"].startsWith("/wiki"):
      networkImageRender(
          mapUrl: (url) => "https://upload.wikimedia.org" + url),
      // Custom placeholder image for broken links
      networkSourceMatcher(): networkImageRender(altWidget: (_) => FlutterLogo()),
    },
    onLinkTap: (url) {
      print("Opening $url...");
    },
    onImageTap: (src) {
      print(src);
    },
    onImageError: (exception, stackTrace) {
      print(exception);
    },
  );
}

Widget htmlText2(String htmltxt) {
  return Html(
    data: htmltxt,
    customImageRenders: {
      networkSourceMatcher(domains: ["flutter.dev"]):
          (context, attributes, element) {
        return FlutterLogo(size: 36);
      },
      networkSourceMatcher(domains: ["mydomain.com"]): networkImageRender(
        headers: {"Custom-Header": "some-value"},
        altWidget: (alt) => Text(alt),
        loadingWidget: () => Text("Loading..."),
      ),
      // On relative paths starting with /wiki, prefix with a base url
          (attr, _) => attr["src"] != null && attr["src"].startsWith("/wiki"):
      networkImageRender(
          mapUrl: (url) => "https://upload.wikimedia.org" + url),
      // Custom placeholder image for broken links
      networkSourceMatcher(): networkImageRender(altWidget: (_) => FlutterLogo()),
    },
    onLinkTap: (url) {
      print("Opening $url...");
    },
    onImageTap: (src) {
      print(src);
    },
    onImageError: (exception, stackTrace) {
      print(exception);
    },
  );
}
