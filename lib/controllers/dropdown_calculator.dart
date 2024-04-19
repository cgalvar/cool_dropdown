import 'dart:math';

import 'package:cool_dropdown/enums/dropdown_align.dart';
import 'package:cool_dropdown/enums/dropdown_triangle_align.dart';
import 'package:cool_dropdown/enums/selected_item_align.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:cool_dropdown/options/dropdown_triangle_options.dart';
import 'package:cool_dropdown/options/dropdown_item_options.dart';
import 'package:cool_dropdown/options/dropdown_options.dart';
import 'package:flutter/widgets.dart';

class DropdownCalculator<T> {
  final List<CoolDropdownItem<T>> dropdownList;
  final BuildContext bodyContext;
  final GlobalKey resultKey;
  final DropdownOptions dropdownOptions;
  final DropdownItemOptions dropdownItemOptions;
  final DropdownTriangleOptions dropdownTriangleOptions;

  final _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  bool _isTriangleDown = false;
  bool get isArrowDown => _isTriangleDown;

  double? _calcDropdownHeight;
  double _resultWidth = 0;

  double get dropdownWidth => dropdownOptions.width ?? _resultWidth;
  double get dropdownHeight =>
      _calcDropdownHeight ?? min(dropdownOptions.height, _totalHeight);

  double get _totalHeight {
    return (dropdownItemOptions.height * dropdownList.length) +
        (dropdownOptions.gap.betweenItems * (dropdownList.length - 1)) +
        dropdownOptions.gap.top +
        dropdownOptions.gap.bottom +
        dropdownTriangleOptions.height +
        dropdownOptions.borderSide.width * 2;
  }

  DropdownCalculator({
    required this.dropdownList,
    required this.bodyContext,
    required this.resultKey,
    required this.dropdownOptions,
    required this.dropdownItemOptions,
    required this.dropdownTriangleOptions,
  });

  Size getLogicalScreenSize(BuildContext context) {
    final view = View.of(context);
    final physicalSize = view.physicalSize;
    final pixelRatio = view.devicePixelRatio;
    return Size(physicalSize.width / pixelRatio, physicalSize.height / pixelRatio);
  }

  Offset setOffset() {

    final screenSize = getLogicalScreenSize(bodyContext);

    final resultBox = resultKey.currentContext?.findRenderObject() as RenderBox;
    final resultGlobalOffset = resultBox.localToGlobal(Offset.zero);
    _resultWidth = resultBox.size.width;

    final MediaQueryData mediaQueryData = MediaQuery.of(bodyContext);

    // Calculate the position relative to the MediaQuery-defined area (considering padding)
    final Offset resultOffset = resultGlobalOffset.copyWith(
      dy: resultGlobalOffset.dy - (screenSize.height - mediaQueryData.size.height),
    );

    return Offset(
      _setOffsetDx(resultBox: resultBox, resultOffset: resultOffset),
      _setOffsetDy(resultBox: resultBox, resultOffset: resultOffset),
    );
  }

  double _setOffsetDx({
    required RenderBox resultBox,
    required Offset resultOffset,
  }) {
    switch (dropdownOptions.align) {
      case DropdownAlign.left:
        return resultOffset.dx + dropdownOptions.left;
      case DropdownAlign.right:
        return resultOffset.dx +
            resultBox.size.width -
            dropdownWidth +
            dropdownOptions.left;
      case DropdownAlign.center:
        return resultOffset.dx +
            (resultBox.size.width - dropdownWidth) * 0.5 +
            dropdownOptions.left;
    }
  }

  double _setOffsetDy({
    required RenderBox resultBox,
    required Offset resultOffset,
  }) {
    final screenHeight = MediaQuery.of(bodyContext).size.height;
    final resultOffsetCenterDy = resultOffset.dy + resultBox.size.height * 0.5;

    _isTriangleDown = resultOffsetCenterDy > screenHeight * 0.5;

    /// set dropdown height not to overflow screen
    if (_isTriangleDown) {
      if (resultOffset.dy - dropdownOptions.height < 0) {
        _calcDropdownHeight = resultOffset.dy -
            (dropdownOptions.top + dropdownOptions.gap.betweenDropdownAndEdge);
        return dropdownOptions.gap.betweenDropdownAndEdge;
      }

      /// shrinkwrap
      return resultOffset.dy - dropdownHeight - dropdownOptions.top;
    } else {
      if (resultOffset.dy + resultBox.size.height + dropdownOptions.height >
          screenHeight) {
        _calcDropdownHeight = screenHeight -
            (resultOffset.dy +
                resultBox.size.height +
                dropdownOptions.top +
                dropdownOptions.gap.betweenDropdownAndEdge);
      }
      return resultOffset.dy + resultBox.size.height + dropdownOptions.top;
    }
  }

  double get calcArrowAlignmentDx {
    switch (dropdownTriangleOptions.align) {
      case DropdownTriangleAlign.left:
        if (_isTriangleDown) {
          return _arrowLeftCenterDx(dropdownOptions.borderRadius.topLeft.x);
        } else {
          return _arrowLeftCenterDx(dropdownOptions.borderRadius.bottomLeft.x);
        }
      case DropdownTriangleAlign.right:
        if (_isTriangleDown) {
          return _arrowRightCenterDx(dropdownOptions.borderRadius.topRight.x);
        } else {
          return _arrowRightCenterDx(
              dropdownOptions.borderRadius.bottomRight.x);
        }
      case DropdownTriangleAlign.center:
        return 0;
    }
  }

  double _arrowLeftCenterDx(double radius) {
    return (((radius + dropdownTriangleOptions.width * 0.5) +
                dropdownTriangleOptions.left) /
            dropdownWidth) -
        1;
  }

  double _arrowRightCenterDx(double radius) {
    return ((dropdownWidth - radius - dropdownTriangleOptions.width * 0.5) +
            dropdownTriangleOptions.left) /
        dropdownWidth;
  }

  double _setSelectedItemPosition() {
    switch (dropdownOptions.selectedItemAlign) {
      case SelectedItemAlign.start:
        return 0;
      case SelectedItemAlign.center:
        return dropdownHeight * 0.5 -
            dropdownItemOptions.height * 0.5 -
            dropdownOptions.borderSide.width -
            dropdownOptions.gap.betweenItems -
            dropdownTriangleOptions.height * 0.5;
      case SelectedItemAlign.end:
        return dropdownHeight -
            dropdownItemOptions.height -
            dropdownOptions.borderSide.width -
            dropdownOptions.gap.betweenItems -
            dropdownOptions.gap.bottom -
            dropdownTriangleOptions.height;
    }
  }

  void setScrollPosition(int currentIndex) {
    final selectedItemOffset = _setSelectedItemPosition();
    double scrollPosition = (dropdownItemOptions.height * currentIndex) +
        (dropdownOptions.gap.betweenItems * currentIndex) -
        selectedItemOffset;
    final overScrollPosition = scrollController.position.maxScrollExtent;
    if (overScrollPosition < scrollPosition) {
      scrollPosition = overScrollPosition;
    } else if (scrollPosition < 0) {
      scrollPosition = 0;
    }
    if (_totalHeight < dropdownHeight) {
      scrollPosition = 0;
    }
    scrollController.animateTo(scrollPosition,
        duration: dropdownOptions.duration, curve: dropdownOptions.curve);
  }

  void dispose() {
    _scrollController.dispose();
  }
}
