class Size {
  final int value;
  const Size._(this.value);

  static const Size XXL = Size._(96);
  static const Size XL = Size._(64);
  static const Size LG = Size._(48);
}

//text variant

//text size

class HeadingSize {
  final int value;
  const HeadingSize._(this.value);

  static const HeadingSize h1 = HeadingSize._(48);
  static const HeadingSize h2 = HeadingSize._(32);
  static const HeadingSize h3 = HeadingSize._(24);
  static const HeadingSize h4 = HeadingSize._(20);
  static const HeadingSize h5 = HeadingSize._(16);
  static const HeadingSize h6 = HeadingSize._(14);
}
