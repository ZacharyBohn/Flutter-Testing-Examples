import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn_flutter_testing/components/app_text.dart';
import 'package:learn_flutter_testing/providers/some_provider.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Provider value is accessible', (WidgetTester tester) async {
    final previousCheck = Provider.debugCheckInvalidValueType;
    Provider.debugCheckInvalidValueType = <T>(T value) {
      if (value is SomeProvider) return;
      previousCheck!<T>(value);
    };
    String testString = 'something else';
    await tester.pumpWidget(
      Provider<SomeProvider>(
        create: (context) => SomeProvider(testString),
        child: MaterialApp(
          home: AppText(),
        ),
      ),
    );

    expect(find.byType(AppText), findsOneWidget);
    expect(find.text(testString), findsOneWidget);
  });
}

//write out different pumps, finds, what expect really does
//demonstrate the material ancestory widget, qualifiers find stuff
//manipulating widgets, navigation

void main2() {
  testWidgets(
    'Widget test pump usage and syntax',
    (WidgetTester tester) async {
      // Adds a Text widget to the build area
      await tester.pumpWidget(Text('some text'));
      // Calls the build methods for the widgets in the build area
      // And waits for all animations to finish
      await tester.pumpAndSettle();
      // Calls the build methods for the widgets in the build area
      // Then waits 5 seconds
      await tester.pump(Duration(seconds: 5));
    },
  );
}

void main3() {
  testWidgets(
    'Widget test finder usage and syntax',
    (WidgetTester tester) async {
      // Adds a Text widget to the build area
      await tester.pumpWidget(Text('some text'));

      // Gets all widgets of the given type
      find.byType(Text);

      // Gets the specified widget
      // Note: this will fail since it is a different instance
      // of Text than what was pumped into the build area
      find.byWidget(Text('some text'));

      // In order to successfully find by widget you must
      Text text = Text('some text');
      await tester.pumpWidget(text);
      // Now this will succeed since it is the same widget instance
      find.byWidget(text);

      // Gets the widget with the given key
      GlobalKey key = GlobalKey();
      await tester.pumpWidget(Text('some text', key: key));
      find.byKey(key);

      // Gets all widgets that matched the given function
      find.byWidgetPredicate(
          (widget) => widget is Text && widget.data == 'some text');
    },
  );
}
