/*
TEST:

- What happens if we repeat Test2 but attach data a different key each time the widget rebuilds?
- What would then happen if we the widget rebuilds, say via setState?

RESULTS:

- Works as expected.
- Every time the widget rebuilds, new data is attached to the BuildContext. This accumilates, taking memory.
- onDetach is called multiple times for each key about a second after Page1 disposes.
- This demonstrates a potential issue with ContextStore if keys are not properly managed.
*/

import 'package:df_cleanup/df_cleanup.dart';

import 'package:flutter/material.dart';

class Test3 extends StatefulWidget {
  const Test3({super.key});

  @override
  State<Test3> createState() => _Test3State();
}

class _Test3State extends State<Test3> {
  int key = 0;

  @override
  Widget build(BuildContext context) {
    debugPrint('[Test] Rebuilding...');
    final message = ContextStore.of(context).attach<String>(
      'Hello World!',
      key: key++,
      onDetach: (data) {
        debugPrint('[Test] Detaching: $data');
      },
    );

    return Container(
      color: Colors.purple.shade200,
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          FilledButton(
            onPressed: () => setState(() {}),
            child: const Text('Call setState'),
          )
        ],
      ),
    );
  }
}
