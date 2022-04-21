import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tab_controller_sandbox/tab_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends HookWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentTab = useState(Fruit.orange);
    final tabs = useState(Fruit.values);

    final tabController = useTabs(
      tabs: tabs.value,
      tab: currentTab.value,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('TabController Sandbox'),
        actions: [
          IconButton(
            onPressed: () => currentTab.value = pickNext(
              tabs.value,
              currentTab.value,
            ),
            icon: const Icon(Icons.navigate_next),
          ),
          IconButton(
            onPressed: () {
              while (true) {
                final newTabs = pickRandom(Fruit.values);
                if (newTabs.isNotEmpty) {
                  tabs.value = newTabs;
                  break;
                }
              }
            },
            icon: const Icon(Icons.shuffle),
          ),
        ],
        bottom: TabBar(
          controller: tabController,
          tabs: [
            for (final fruit in tabs.value)
              Tab(
                key: ValueKey(fruit),
                text: fruit.toString(),
              ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          for (final fruit in tabs.value)
            Center(
              key: ValueKey(fruit),
              child: Text(
                fruit.toString(),
              ),
            ),
        ],
      ),
    );
  }
}

enum Fruit { apple, bananer, cherry, orange, onion }

T pickNext<T>(List<T> items, T current) =>
    items[(items.indexOf(current) + 1) % items.length];

final random = Random();
List<T> pickRandom<T>(List<T> items) =>
    items.where((_) => random.nextBool()).toList();
