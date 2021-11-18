abstract class XPathNode {
  String? get text;

  XPathNode? get parentNode;

  List<XPathNode> get childrenNode;

  Map<String, String> get attributes;
}

abstract class XPathElement extends XPathNode {
  String? get name;

  XPathElement? get parent;

  List<XPathElement> get children;

  XPathElement? get nextElementSibling;

  XPathElement? get previousElementSibling;
}