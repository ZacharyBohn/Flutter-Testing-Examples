# Flutter Testing Cookbook

### Purpose

The purpose of this REAMDME and this repo is give examples and explanations for the basics of Flutter tests.  In addition to this resource, there are several first party documents worth reading:
1. https://flutter.dev/docs/cookbook/testing/unit/introduction
2. https://flutter.dev/docs/cookbook/testing/widget/introduction
3. https://flutter.dev/docs/cookbook/testing/integration/introduction

***

### Basics

There are three types of tests to be performed in Flutter
  1. Widget tests - used to test individual widgets, in isolation
  2. Integration tests - used to ensure that features (consisting of several widgets / functions) work correctly together
  3. Unit tests - used to test a specific function / method / class that do not have widgets. Can use mockito package to test HTTP calls

***

### Getting Started

First add the following to your pubspec.yaml file.  This will allow you to import the widget testing package and the testing driver package (for integration testing).
```
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_driver:
    sdk: flutter
  test: any
```

The structure of your project should be mirrored between two folders, lib and test.  In the test folder, there should be a file to test each widget in lib. Additionally, there should be a test_driver folder under the tests folder; that will house the integration tests.

Your file structure should look like:
```
project_root /
	lib /
		main.dart
	test /
		main.dart
		test_driver /
```


***

### Running Tests

Use flutter test to run all tests within the test folder.  This command will recursively read all files, even in the sub-folders.  For a test to be run, it’s file name must end in “_test.dart”.  Alternatively, you can select the beaker icon in VS Code and click the play button.  This provides a UI for running tests and seeing if they have passed.

***

### Widget Tests - Basics


When testing a widget in Flutter, there are basically three parts of a test.
1. Adding widgets to the build area
2. Performing actions / changing data
3. Checking if the widget responded correctly

```dart
void main() {
  testWidgets(
    'Phone text field',
    (WidgetTester tester) async {
      // Add the widget to the build area
      await tester.pumpWidget(PhoneTextField());
      // Enter text into the widget
      await tester.enterText(find.byType(PhoneTextField), '9015550123');
      // Test to see if the given text on the screen
      expect(find.text('9015550123'), findsOneWidget);
    },
  );
}
```

***

### Widget Tests - Syntax

For widget tests, each widget in lib should have a corresponding file in the test folder.  Within this file, there should be a single main() function that will be used to run the tests.  Within the main() function, here is a list of functions that you can call:
```dart
void main() {
  // This is called once before ALL tests
  setUpAll(() {
    // testing code goes here
  });
  // This is called once before EVERY test
  setUp(() {
    // testing code goes here
  });
  // This is called once after ALL tests
  tearDownAll(() {
    // testing code goes here
  });
  // This is called once after EVERY test
  tearDown(() {
    // testing code goes here
  });
  // This is where you write an individual test
  // This should only be defined once inside main()
  testWidgets(
    'Test description',
    (WidgetTester tester) async {
      // testing code goes here
    },
  );
}
```

Additionally, you can call a group of tests from main if you would like to test multiple functionalities.
```dart
void main() {
  // This is used to run a group of tests
  group(
    'Test group description',
    (WidgetTester tester) async {
      // Call several testWidgets() here
      // Call the first test
      testWidgets(
        'Single test description',
        (WidgetTester tester) async {
          // testing code goes here
        });
      // Call a second test
      testWidgets(
        'Single test description',
        (WidgetTester tester) async {
          // testing code goes here
        });
    },
  );
}
```

***

Differences between pumps
```dart
void main() {
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
```


Notes on WidgetTester
  1. ```pumpWidget()``` - builds the parent widget in memory for testing
	 (Duration is required in ```pumpAndSettle()``` if the widget being tested uses ```Future.delayed()``` such as a splash screen)
  3. ```pumpAndSettle()``` - render all the frames of the widget that was passed into it

***

Ways to find widgets:
```dart
void main() {
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
```

***

### Expect and Matcher Finders

```expect()``` is a function that serves as the ```assert``` but for testing.   It takes two values, and if they are unequal, then the test fails.  It will typically be found at the end of a test.  Notice the different finders such as ```findsOneWidget``` or ```findsNWidgets(n)``` which can be used to compare to how many results are returned from a finder (the first paramter given to ```expect()```).  ```MaterialApp()``` must be used above must widgets or they will fail to build.  Any failures in building widgets, will cause the test to fail.

```dart
void main() {
  testWidgets('Text widget', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Text('some text'),
    ));

    // There is only one widget like this, so this will pass
    expect(find.byType(Text), findsOneWidget);
    // The given text is on the screen so this will pass
    expect(find.text('some text'), findsOneWidget);
    // This will fail since no widgets have this key
    expect(find.byKey(GlobalKey()), findsWidgets);
    // This will pass, since it is searching for the exact instance
    // given to it.  The instances don't match between what was pumped
    // and what was given to find.byWidget().
    expect(find.byWidget(Text('some text')), findsNothing);
    // This will pass since there is 1 widget that is a Text widget and
    // has 'some text' as its data
    expect(
        find.byWidgetPredicate(
            (widget) => widget is Text && widget.data == 'some text'),
        findsNWidgets(1));
  });
}
```

***

### Manipulating Widgets During A Test

You can enter text into widgets, tap widgets, or perform other gestures on the screen in order to interact with widgets automatically during a test.

#### Enter Text Example

```dart
void main() {
  testWidgets('TextField test', (WidgetTester tester) async {
    // Both a MaterialApp and a Scaffold are necessary for the TextField
    // widget to build at all
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TextField(),
      ),
    ));

    // Enter the text into the TextField widget
    await tester.enterText(
        find.byType(TextField), 'Some text that will be entered');

    // Allow time for the animations to finish
    await tester.pumpAndSettle();

    // This will pass since the text was typed onto the screen
    expect(find.text('Some text that will be entered'), findsOneWidget);
  });
}
```

***

#### Tapping The Screen Example

```dart
vvoid main() {
  testWidgets('TextField test', (WidgetTester tester) async {
    int value = 0;

    await tester.pumpWidget(MaterialApp(
      home: FloatingActionButton(
        onPressed: () {
          value = 99;
        },
      ),
    ));

    // Tap the FloatingActionButton
    await tester.tap(find.byType(FloatingActionButton));

    // Allow time for the animations to finish
    await tester.pumpAndSettle();

    // This will pass if value was changed to 99
    expect(value, 99);
  });
}
```

***

### Testing While Using Providers

Normally, you would test a widget in isolation.  You provide input to the widget, it performs some action or displays something, then you test for that.  However, when providers are called from inside a widget, then you are unable to pass providers to the widget.  This makes writing tests difficult.  The way around this is in your test, to wrap your widget with a provider.  That way, when your widget checks its context, then the provider is available.  There is a weird bug that happens when testing providers; the solution to that bug is shown below.

```dart
void main() {
  testWidgets('Provider value is accessible', (WidgetTester tester) async {
    // Using a provider will universally fail any test.  The type of the provider
    // gets changed while testing, which causes a failure before the test even runs.
    // This gets around that by explicitly allowing a specific type of provider
    // to essentially be ignored.
    final previousCheck = Provider.debugCheckInvalidValueType;
    Provider.debugCheckInvalidValueType = <T>(T value) {
      // The exact provider that it being tested with should be
      // provided here.  Feel free to use multiple lines like this
      // if multiple providers are used.
      if (value is SomeProvider) return;
      previousCheck!<T>(value);
    };

    // Wrap the widget to be tested in a provider.
    // MultiProvider could also be used here
    await tester.pumpWidget(
      Provider<SomeProvider>(
        create: (context) => SomeProvider('Some Text'),
        child: MaterialApp(
          home: AppText(),
        ),
      ),
    );

    expect(find.byType(AppText), findsOneWidget);
    expect(find.text('Some Text'), findsOneWidget);
  });
}
```










