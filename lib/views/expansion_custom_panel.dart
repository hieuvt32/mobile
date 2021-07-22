import 'package:flutter/material.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'dart:math' as math;

import 'package:frappe_app/utils/frappe_icon.dart';

class ExpansionCustomPanel extends StatefulWidget {
  final Color backgroundBodyColor;
  final Color backgroundTitleColor;
  final Color backgroundIconColor;
  final List<ExpansionItem> items;
  final EdgeInsetsGeometry padding;
  ExpansionCustomPanel({
    required this.items,
    this.backgroundBodyColor = Colors.white,
    this.backgroundTitleColor = Colors.white,
    this.backgroundIconColor = Colors.transparent,
    this.padding = const EdgeInsets.all(0),
  });
  ExpansionCustomPanelState createState() => ExpansionCustomPanelState();
}

class ExpansionItem {
  bool isExpanded;
  final Widget Function(bool isExpanded) header;
  final List<Widget> body;
  Widget? iconpic;
  ExpansionItem(this.isExpanded, this.header, this.body, {this.iconpic});
}

class ExpansionCustomPanelState extends State<ExpansionCustomPanel> {
  Widget build(BuildContext context) {
    ListView listCriteria = ListView(
      // controller: scrollController,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: [
        Padding(
          padding: widget.padding,
          child: CustomExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                widget.items[index].isExpanded =
                    !widget.items[index].isExpanded;
              });
            },
            backgroundBodyColor: widget.backgroundBodyColor,
            backgroundTitleColor: widget.backgroundTitleColor,
            backgroundIconColor: widget.backgroundIconColor,
            // expandedHeaderPadding: EdgeInsets.all(0),
            children: widget.items.map((ExpansionItem item) {
              return ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return item.header(isExpanded);
                },
                isExpanded: item.isExpanded,
                body: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: widget.backgroundBodyColor,
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: item.body,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
    return listCriteria;
  }
}

const double _kPanelHeaderCollapsedHeight = 40.0;
const double _kPanelHeaderExpandedHeight = 64.0;

class CustomExpansionPanelList extends StatelessWidget {
  const CustomExpansionPanelList({
    Key? key,
    this.children: const <ExpansionPanel>[],
    this.expansionCallback,
    this.animationDuration: kThemeAnimationDuration,
    this.backgroundBodyColor = Colors.white,
    this.backgroundTitleColor = Colors.white,
    this.backgroundIconColor = Colors.transparent,
  })  : assert(children != null),
        assert(animationDuration != null),
        super(key: key);

  final Color backgroundIconColor;
  final List<ExpansionPanel> children;

  final ExpansionPanelCallback? expansionCallback;

  final Duration animationDuration;

  final Color backgroundBodyColor;
  final Color backgroundTitleColor;

  bool _isChildExpanded(int index) {
    return children[index].isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = <Widget>[];
    const EdgeInsets kExpandedEdgeInsets = const EdgeInsets.symmetric(
        vertical: _kPanelHeaderExpandedHeight - _kPanelHeaderCollapsedHeight);

    for (int index = 0; index < children.length; index += 1) {
      items.add(SizedBox(
        height: 10,
      ));

      // if (_isChildExpanded(index) && index != 0 && !_isChildExpanded(index - 1))
      //   items.add(new Divider(
      //     key: new _SaltedKey<BuildContext, int>(context, index * 2 - 1),
      //     height: 15.0,
      //     color: Colors.transparent,
      //   ));

      final Row header = new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            child: new ExpandCustomIcon(
              isExpanded: _isChildExpanded(index),
              padding: const EdgeInsets.fromLTRB(4, 7, 4, 7),
              color: this.backgroundIconColor,
              onPressed: (bool isExpanded) {
                if (expansionCallback != null)
                  expansionCallback!(index, isExpanded);
              },
            ),
          ),
          Expanded(
              child: new AnimatedContainer(
            duration: animationDuration,
            // curve: Curves.fastOutSlowIn,
            // margin: EdgeInsets.all(8),
            // margin: _isChildExpanded(index)
            //     ? kExpandedEdgeInsets
            //     : EdgeInsets.zero,
            child: new SizedBox(
              // height: _kPanelHeaderCollapsedHeight,
              child: children[index].headerBuilder(
                context,
                children[index].isExpanded,
              ),
            ),
          )),
        ],
      );

      double _radiusValue = 4.0;
      // _isChildExpanded(index) ? 8.0 : 0.0;
      items.add(
        new Container(
          key: new _SaltedKey<BuildContext, int>(context, index * 2),
          child: new Material(
            elevation: 2.0,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.all(
                  new Radius.circular(_radiusValue),
                ),
                side: BorderSide(
                    width: 1,
                    style: BorderStyle.solid,
                    color: Color.fromRGBO(
                      0,
                      114,
                      188,
                      0.3,
                    ))),
            child: new Column(
              children: <Widget>[
                Container(
                  child: header,
                  decoration: BoxDecoration(
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(_radiusValue)),
                    color: this.backgroundTitleColor,
                  ),
                ),
                new AnimatedCrossFade(
                  firstChild: new Container(height: 0.0),
                  secondChild: children[index].body,
                  firstCurve:
                      const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
                  secondCurve:
                      const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
                  sizeCurve: Curves.fastOutSlowIn,
                  crossFadeState: _isChildExpanded(index)
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: animationDuration,
                ),
              ],
            ),
          ),
        ),
      );

      // if (_isChildExpanded(index) && index != children.length - 1)
      //   items.add(new Divider(
      //     key: new _SaltedKey<BuildContext, int>(context, index * 2 + 1),
      //     height: 15.0,
      //   ));
    }

    return new Column(
      children: items,
    );
  }
}

class _SaltedKey<S, V> extends LocalKey {
  const _SaltedKey(this.salt, this.value);

  final S salt;
  final V value;

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final _SaltedKey<S, V> typedOther = other;
    return salt == typedOther.salt && value == typedOther.value;
  }

  @override
  int get hashCode => hashValues(runtimeType, salt, value);

  @override
  String toString() {
    final String saltString = S == String ? '<\'$salt\'>' : '<$salt>';
    final String valueString = V == String ? '<\'$value\'>' : '<$value>';
    return '[$saltString $valueString]';
  }
}

class ExpandCustomIcon extends StatefulWidget {
  /// Creates an [ExpandCustomIcon] with the given padding, and a callback that is
  /// triggered when the icon is pressed.
  const ExpandCustomIcon({
    Key? key,
    this.isExpanded = false,
    this.size = 24.0,
    required this.onPressed,
    this.padding = const EdgeInsets.all(8.0),
    this.color,
    this.disabledColor,
    this.expandedColor,
  })  : assert(isExpanded != null),
        assert(size != null),
        assert(padding != null),
        super(key: key);

  /// Whether the icon is in an expanded state.
  ///
  /// Rebuilding the widget with a different [isExpanded] value will trigger
  /// the animation, but will not trigger the [onPressed] callback.
  final bool isExpanded;

  /// The size of the icon.
  ///
  /// This property must not be null. It defaults to 24.0.
  final double size;

  /// The callback triggered when the icon is pressed and the state changes
  /// between expanded and collapsed. The value passed to the current state.
  ///
  /// If this is set to null, the button will be disabled.
  final ValueChanged<bool>? onPressed;

  /// The padding around the icon. The entire padded icon will react to input
  /// gestures.
  ///
  /// This property must not be null. It defaults to 8.0 padding on all sides.
  final EdgeInsetsGeometry padding;

  /// The color of the icon.
  ///
  /// Defaults to [Colors.black54] when the theme's
  /// [ThemeData.brightness] is [Brightness.light] and to
  /// [Colors.white60] when it is [Brightness.dark]. This adheres to the
  /// Material Design specifications for [icons](https://material.io/design/iconography/system-icons.html#color)
  /// and for [dark theme](https://material.io/design/color/dark-theme.html#ui-application)
  final Color? color;

  /// The color of the icon when it is disabled,
  /// i.e. if [onPressed] is null.
  ///
  /// Defaults to [Colors.black38] when the theme's
  /// [ThemeData.brightness] is [Brightness.light] and to
  /// [Colors.white38] when it is [Brightness.dark]. This adheres to the
  /// Material Design specifications for [icons](https://material.io/design/iconography/system-icons.html#color)
  /// and for [dark theme](https://material.io/design/color/dark-theme.html#ui-application)
  final Color? disabledColor;

  /// The color of the icon when the icon is expanded.
  ///
  /// Defaults to [Colors.black54] when the theme's
  /// [ThemeData.brightness] is [Brightness.light] and to
  /// [Colors.white] when it is [Brightness.dark]. This adheres to the
  /// Material Design specifications for [icons](https://material.io/design/iconography/system-icons.html#color)
  /// and for [dark theme](https://material.io/design/color/dark-theme.html#ui-application)
  final Color? expandedColor;

  @override
  _ExpandCustomIconState createState() => _ExpandCustomIconState();
}

class _ExpandCustomIconState extends State<ExpandCustomIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconTurns;

  static final Animatable<double> _iconTurnTween =
      Tween<double>(begin: 0.75, end: 1)
          .chain(CurveTween(curve: Curves.fastOutSlowIn));

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: kThemeAnimationDuration, vsync: this);
    _iconTurns = _controller.drive(_iconTurnTween);
    // If the widget is initially expanded, rotate the icon without animating it.
    if (widget.isExpanded) {
      _controller.value = math.pi;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ExpandCustomIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  void _handlePressed() {
    widget.onPressed?.call(widget.isExpanded);
  }

  /// Default icon colors and opacities for when [Theme.brightness] is set to
  /// [Brightness.light] are based on the
  /// [Material Design system icon specifications](https://material.io/design/iconography/system-icons.html#color).
  /// Icon colors and opacities for [Brightness.dark] are based on the
  /// [Material Design dark theme specifications](https://material.io/design/color/dark-theme.html#ui-application)
  Color get _iconColor {
    if (widget.isExpanded && widget.expandedColor != null) {
      return widget.expandedColor!;
    }

    if (widget.color != null) {
      return widget.color!;
    }

    switch (Theme.of(context).brightness) {
      case Brightness.light:
        return Colors.black54;
      case Brightness.dark:
        return Colors.white60;
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final String onTapHint = widget.isExpanded
        ? localizations.expandedIconTapHint
        : localizations.collapsedIconTapHint;

    return Semantics(
      onTapHint: widget.onPressed == null ? null : onTapHint,
      child: IconButton(
        padding: widget.padding,
        iconSize: widget.size,
        color: _iconColor,
        disabledColor: widget.disabledColor,
        onPressed: widget.onPressed == null ? null : _handlePressed,
        icon: RotationTransition(
          turns: _iconTurns,
          child: Container(
            decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.all(Radius.circular(4))),
            child: const FrappeIcon(
              FrappeIcons.arrow_caret_forward,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
