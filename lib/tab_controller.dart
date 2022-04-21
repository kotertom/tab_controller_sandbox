import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

TabController useTabController({
  required int length,
  int? index,
  TickerProvider? vsync,
  TabController? controller,
  bool animate = true,
}) {
  final localVsync = useSingleTickerProvider(keys: [length, vsync]);
  final localController = useMemoized(
    () => TabController(
      length: length,
      initialIndex: (index ?? 0).clamp(0, length - 1),
      vsync: vsync ?? localVsync,
    ),
    [length, vsync],
  );

  final effectiveController = controller ?? localController;

  useEffect(() {
    if (index == null) {
      return;
    }

    final clampedIndex = index.clamp(0, length - 1);

    if (animate) {
      effectiveController.animateTo(clampedIndex);
    } else {
      effectiveController.index = clampedIndex;
    }
  }, [length, index]);

  return effectiveController;
}

TabController useTabs<T>({
  required List<T> tabs,
  T? tab,
  TabController? controller,
  TickerProvider? vsync,
  bool animate = true,
}) {
  return useTabController(
    length: tabs.length,
    index: tab == null ? null : tabs.indexOf(tab),
    vsync: vsync,
    controller: controller,
    animate: animate,
  );
}
