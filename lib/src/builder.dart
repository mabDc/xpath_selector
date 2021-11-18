import 'package:html/dom.dart' as html;
import 'package:html/parser.dart' as html;
import 'package:xpath_for_xml/src/parser.dart';
import 'package:xml/xml.dart' as xml;

import '../xpath_for_xml.dart';
import 'execute.dart';
import 'model.dart';

/// Result of XPath
class XPathResult {
  XPathResult(this.elements, this.attrs);

  /// Get all nodes of query results
  final List<XPathNode> elements;

  /// Get all properties of query results
  final List<String?> attrs;

  /// Get the first node of query results
  XPathNode? get element => elements.isNotEmpty ? elements.first : null;

  /// Get the first valid property of the query result (not null)
  String? get attr => attrs.firstWhere((e) => e != null, orElse: () => null);
}

class XPath {
  /// Create XPath by html element
  XPath(this.root);

  final XPathNode root;

  /// Create XPath by html string
  factory XPath.html(String value) {
    final dom = html.parse(value).documentElement;
    if (dom == null) throw UnsupportedError('No html');
    return XPath(HtmlNodeTree(dom));
  }

  factory XPath.htmlElement(html.Element element) =>
      XPath(HtmlNodeTree(element));

  factory XPath.xml(String value) {
    final dom = xml.XmlDocument.parse(value);
    return XPath(XmlNodeTree(dom));
  }

  factory XPath.xmlElement(xml.XmlElement element) =>
      XPath(XmlNodeTree(element));

  /// query XPath
  XPathResult query(String xpath) {
    final result = <XPathNode>[];
    final resultAttrs = <String?>[];
    final selectorGroup = parseSelectGroup(xpath);
    for (final selector in selectorGroup) {
      final newResult = execute(selectorList: selector, element: root)
          .where((e) => !result.contains(e))
          .toList();
      result.addAll(newResult);
      resultAttrs.addAll(parseAttr(
        selectorList: selector,
        elements: newResult.toList(),
      ));
    }
    return XPathResult(result, resultAttrs);
  }
}
