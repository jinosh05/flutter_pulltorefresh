import 'package:material_ui/material_ui.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      headerBuilder: () => const MaterialClassicHeader(),
      footerBuilder: () => const ClassicFooter(),
      child: MaterialApp(title: 'Pull to Refresh Demo', home: const HomePage()),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RefreshController _controller = RefreshController(
    initialRefresh: false,
  );
  final List<int> _items = List<int>.generate(20, (i) => i);

  void _onRefresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      setState(() {
        _items.insert(0, _items.length);
      });
    }
    _controller.refreshCompleted();
  }

  void _onLoading() async {
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      setState(() {
        _items.addAll(List<int>.generate(10, (i) => _items.length + i));
      });
    }
    _controller.loadComplete();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pull to Refresh Demo')),
      body: SmartRefresher(
        controller: _controller,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (context, index) {
            return ListTile(title: Text('Item ${_items[index]}'));
          },
        ),
      ),
    );
  }
}
