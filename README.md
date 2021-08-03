# Flutter Testing Cookbook


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
Adding widgets to the build area
Performing actions / changing data
Checking if the widget responded correctly

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

Different ways to add widgets to the build area:
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
    a. Duration is required in ```pumpAndSettle()``` if the widget being tested uses ```Future.delayed()``` such as a splash screen
  2. ```pumpAndSettle()``` - render all the frames of the widget that was passed into it

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

