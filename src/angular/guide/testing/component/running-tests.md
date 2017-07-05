---
layout: angular
title: Running Component Tests (DRAFT)
description: Running component tests
sideNavGroup: advanced
prevpage:
  title: Component Testing
  url: /angular/guide/testing/component
nextpage:
  title: End-to-end Testing
  url: /angular/guide/testing/e2e
toc: false
---
{% include_relative _page-top-toc.md %}

Whether you've just started the [tutorial](/angular/tutorial), or
finished the [Get Started](/guides/get-started) page,
you are ready to run your first tests!
If you haven't worked through these projects recently, don't worry. 
You can follow along by first setting up the
tutorial's [Starter App](/angular/tutorial/toh-pt0).

{% comment %}TODO: derive the test code from quickstart instead ...?{% endcomment %}

The [tutorial](/angular/tutorial)'s [Starter App](/angular/tutorial/toh-pt0)
includes a few basic tests for its `AppComponent` in the following test file:

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

If you've used modern testing frameworks, then you'll recognize
elements such as the [test fixture][], setup, and teardown functions.

The file contains a test named "Default greeting" that checks whether
the app component template generates the text "Hello Angular".

<?code-excerpt "toh-0/test/app_test.dart (default test)"?>
```
  test('Default greeting', () {
    expect(fixture.text, 'Hello Angular');
  });
```

To run tests, open a terminal, and from the project root issue the following
command:

<?code-excerpt class="code-shell"?>
```sh
  pub run angular_test --test-arg=--tags=aot --test-arg=--platform=dartium
```

The test framework runs code transformers, launches [pub serve][], loads
the test file, and runs tests:

<?code-excerpt class="code-shell"?>
```nocode
  The pub serve output is at .../angular_test_pub_serve_output.log
  Finished AoT compilation. Running tests...
  00:00 +0: loading test/app_test.dart
  00:01 +0: loading test/app_test.dart
  00:02 +0: loading test/app_test.dart
  00:03 +0: loading test/app_test.dart
  00:03 +0: test/app_test.dart: Default greeting
  00:03 +1: test/app_test.dart: Default greeting
  00:03 +1: test/app_test.dart: Greet world
  00:03 +2: test/app_test.dart: Greet world
  00:03 +2: test/app_test.dart: Greet world HTML
  00:03 +3: test/app_test.dart: Greet world HTML
  00:03 +3: All tests passed!
```

[pub serve]: /angular/guide/setup#running-the-app
[test fixture]: https://github.com/junit-team/junit4/wiki/test-fixtures
