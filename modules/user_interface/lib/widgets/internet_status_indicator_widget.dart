import 'package:flutter/material.dart';

class InternetStatusIndicatorWidget extends StatelessWidget {
  final Stream<bool> stream;

  const InternetStatusIndicatorWidget({
    super.key,
    required this.stream,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: stream,
      initialData: false,
      builder: (context, snapshot) {
        print(
            ':::::::::::::::::::::::: snapshot ::::::::::::::::::::::::');
        print('Data: ${snapshot.data} '
            '\n connectionState: ${snapshot.connectionState}'
            '\n error: ${snapshot.error}'
            '\n hasData: ${snapshot.hasData}');
        print(
            ':::::::::::::::::::::::: snapshot ::::::::::::::::::::::::');


        final isConnected = snapshot.data ?? false;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isConnected ? Icons.wifi : Icons.wifi_off,
              color: isConnected ? Colors.green : Colors.redAccent,
              size: 18,
            ),
            const SizedBox(width: 6),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                isConnected ? 'Online' : 'Offline',
                key: ValueKey(isConnected),
                style: TextStyle(
                  fontSize: 10,
                  color: isConnected ? Colors.green : Colors.redAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
