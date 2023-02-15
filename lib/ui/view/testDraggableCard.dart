import 'package:flutter/physics.dart';
import 'package:flutter/material.dart';
import 'package:test2/core/manager.dart';
import 'dart:developer' as dev;

import 'package:test2/ui/actions/controller.dart';

import '../components/baseScaffold.dart';

class DraggableCard extends StatefulWidget {
  const DraggableCard({required this.child, super.key});

  final Widget child;

  @override
  State<DraggableCard> createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _animation;
  Alignment _dragAlignment = Alignment.center;

  void _runAnimation(Offset pixelsPerSecond, Size size) {
    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.center,
      ),
    );
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
    // _controller.reset();
    // _controller.forward();

    var show = _controller.isCompleted;
    print('tttt test $show');
  }

  @override
  void initState() {
    super.initState();
    print('ttttt print initState');
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _controller.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;
      });
    });
  }

  @override
  void dispose() {
    print('ttttt print dispose');
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('ttttt print build');
    Manager.getInst()?.setContext(context);
    var size = MediaQuery.of(context).size;
    return BaseScaffold(context).defaultScaffold(
        "Test Drag",
        Scaffold(
          appBar: BaseScaffold(context).defalutBar("Test Drag"),
          body: GestureDetector(
            onPanDown: (details) {
              _controller.stop();
              print('......>> onPanDown');
            },
            onPanUpdate: (details) {
              setState(() {
                _dragAlignment += Alignment(
                  details.delta.dx / (size.width / 2),
                  details.delta.dy / (size.height / 2),
                );
              });
            },
            onPanEnd: (details) {
              _runAnimation(details.velocity.pixelsPerSecond, size);
              print('......>> onPanEnd');
              // Future.delayed(Duration(milliseconds: 100))
              //     .then((value) => Pressed.gohome(context));
            },
            child: Align(
              alignment: _dragAlignment,
              child: Card(
                child: widget.child,
              ),
            ),
          ),
        ));

    return GestureDetector(
      onPanDown: (details) {
        _controller.stop();
        print('......>> onPanDown');
      },
      onPanUpdate: (details) {
        setState(() {
          _dragAlignment += Alignment(
            details.delta.dx / (size.width / 2),
            details.delta.dy / (size.height / 2),
          );
        });
      },
      onPanEnd: (details) {
        _runAnimation(details.velocity.pixelsPerSecond, size);
        print('......>> onPanEnd');
        // Future.delayed(Duration(milliseconds: 100))
        //     .then((value) => Pressed.gohome(context));
      },
      child: Align(
        alignment: _dragAlignment,
        child: Card(
          child: widget.child,
        ),
      ),
    );
  }

  Widget _buildView(context) {
    return Center(
      child: Text('MY LOG'),
    );
  }
}
