---
layout: angular
title: "Component Testing: Basics (DRAFT)"
description: Techniques and practices for component testing of AngularDart apps.
sideNavGroup: advanced
prevpage:
  title: Testing
  url: /angular/guide/testing
nextpage:
  title: End-to-end Testing
  url: /angular/guide/testing/e2e
---
{% comment %}{% include_relative _topics-nav.md selectedOption="basics" %}{% endcomment %}

## _Pubspec_ configuration

Projects with component tests depend on the
[angular_test][] and [test][] packages. Because these packages are used
only during development, and not shipped with the app, they don't belong
under `dependencies` in the pubspec. Instead, `test` and `angular_test`
are under **`dev_dependencies`**, for example:

<?code-excerpt "toh-0/pubspec.yaml (dev_dependencies)" title?>
```
  dev_dependencies:
    angular_test: ^1.0.0-beta+2
    browser: ^0.10.0
    dart_to_js_script_rewriter: ^1.0.1
    test: ^0.12.21
```

The `pubspec.yaml` file should also include
the `reflection_remover` and `pub_serve` transformers.
Without these, `angular_test`-based tests won't run.

{% comment %}
TODO: add highlights of the key region once highlighting works again:
https://github.com/dart-lang/site-webdev/issues/374
{% endcomment %}

<?code-excerpt "toh-0/pubspec.yaml (transformers)" title?>
```
  transformers:
  - angular2:
      entry_points: web/main.dart
  - angular2/transform/reflection_remover:
      $include: test/**_test.dart
  - test/pub_serve:
      $include: test/**_test.dart
  - dart_to_js_script_rewriter
```

## API basics: _test_() and _expect_()

Write component tests using the [test][] package API.
For example, define tests using `test()` functions
containing `expect()` test assertions:

<?code-excerpt "toh-0/test/app_test.dart (default test)"?>
```
  test('Default greeting', () {
    expect(fixture.text, 'Hello Angular');
  });
```

Other [test][] package features, like [group()][], are also available for use in writing your component tests.

## Test fixture, setup and teardown

Component tests must explicitly define the **component under test** (CUT). You define the CUT by passing the component class name as a generic type argument to the [NgTestBed][] and [NgTestFixture][] classes:

<?code-excerpt "toh-0/test/app_test.dart (test bed and fixture)" title?>
```
  final testBed = new NgTestBed<AppComponent>();
  NgTestFixture<AppComponent> fixture;
```

You'll generally initialize the fixture in a `setUp()` function.
Since component tests are often asynchronous, the `tearDown()` function
generally disposes of any running tests
(before the next test group, if any, is executed). Here is an example:

<?code-excerpt "toh-0/test/app_test.dart (excerpt)" region="initial" title?>
```
  @Tags(const ['aot'])
  @TestOn('browser')

  /* . . . */
  @AngularEntrypoint()
  void main() {
    final testBed = new NgTestBed<AppComponent>();
    NgTestFixture<AppComponent> fixture;

    setUp(() async {
      fixture = await testBed.create();
    });

    tearDown(disposeAnyRunningTest);

    test('Default greeting', () {
      expect(fixture.text, 'Hello Angular');
    });
    /* . . . */
  }
```

Use [setUpAll()][] and [tearDownAll()][] for setup/teardown that should encompass all tests and be performed only once for the entire test suite.

[angular_test]: https://pub.dartlang.org/packages/angular_test
[group()]: https://pub.dartlang.org/packages/test#writing-tests
[group API]: {{site.api}}/test/latest/test/group.html
[NgTestBed]: {{site.api}}/angular_test/latest/angular_test/NgTestBed-class.html
[NgTestFixture]: {{site.api}}/angular_test/latest/angular_test/NgTestFixture-class.html
[setUpAll()]: {{site.api}}/test/latest/test/setUpAll.html
[tearDownAll()]: {{site.api}}/test/latest/test/tearDownAll.html
[test]: https://pub.dartlang.org/packages/test
