import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterState {
  CounterState(this.counter);
  int counter;
}

class InitialState extends CounterState {
  InitialState() : super(0);
}

abstract class BLoCEvents {}

class Increment extends BLoCEvents {}

class Reset extends BLoCEvents {}

class CounterBloCs extends Bloc<BLoCEvents, CounterState> {
  CounterBloCs() : super(InitialState()) {
    on<Increment>((event, emit) => emit(CounterState(state.counter + 1)));
    on<Reset>((event, emit) => emit(CounterState(0)));
  }

  @override
  void onChange(Change<CounterState> change) {
    print(change);
    super.onChange(change);
  }

  @override
  void onTransition(Transition<BLoCEvents, CounterState> transition) {
    print(transition);
    super.onTransition(transition);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print(error);
    super.onError(error, stackTrace);
  }

  @override
  void onEvent(BLoCEvents event) {
    print(event);
    super.onEvent(event);
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloCs(),
      child: const MaterialApp(
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CounterBloCs, CounterState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Enum State Cycling Demo.'),
          ),
          body: Center(
            child: DisplayState.values[state.counter].widget,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (state.counter == DisplayState.values.length - 1) {
                BlocProvider.of<CounterBloCs>(context).add(Reset());
                return;
              }
              BlocProvider.of<CounterBloCs>(context).add(Increment());
            },
            tooltip: 'Cycle',
            child: const Icon(Icons.change_circle),
          ),
        );
      },
    );
  }
}

enum DisplayState {
  green(widget: ColorContainer(color: Colors.green, size: 200)),
  red(widget: ColorContainer(color: Colors.red, size: 150)),
  blue(widget: ColorContainer(color: Colors.blue, size: 100)),
  yellow(widget: ColorContainer(color: Colors.yellow, size: 75)),
  purple(widget: ColorContainer(color: Colors.purple, size: 50)),
  orange(widget: ColorContainer(color: Colors.orange, size: 25));

  const DisplayState({required this.widget});
  final Widget widget;
}

class ColorContainer extends StatelessWidget {
  const ColorContainer({super.key, required this.color, required this.size});
  final Color color;
  final double size;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      width: size,
      height: size,
      color: color,
      child: BlocBuilder<CounterBloCs, CounterState>(
        builder: (context, state) => Center(
          child: Text('${state.counter}'),
        ),
      ),
    );
  }
}
