---
layout: angular
title: "Component Testing: Page Objects (DRAFT)"
description: Techniques and practices for component testing of AngularDart apps.
sideNavGroup: advanced
prevpage:
  title: Testing
  url: /angular/guide/testing
nextpage:
  title: End-to-end Testing
  url: /angular/guide/testing/e2e
pageloaderObjectsApi: https://www.dartdocs.org/documentation/pageloader/latest/pageloader.objects
---
{% include_relative _page-top-toc.md %}

As components and their templates become more complex, you'll want to
[separate concerns][] and isolate testing code from the detailed HTML
encoding of page elements in templates.

You can achieve this separation by creating **[page object][]** (PO) classes
having APIs written in terms of _application-specific concepts_, such as
"title", "hero id", and "hero name". A PO class encapsulates details about:

- HTML element access, for example, whether a hero name is contained in a
  heading element or a `<div>`
- Type conversions, for example, from `String` to `int`, as you'd need to
  do for a hero id

## Imports

The [angular_test][] package recognizes page objects implemented from
the [pageloader][] package. For any page object class that you
implement, include these imports:

<?code-excerpt "toh-2/test/app_po.dart (imports)" title?>
```
  import 'dart:async';

  import 'package:pageloader/objects.dart';
```

## Running example {% comment %}Running examples?{% endcomment %}

As a running example, this page uses the [Hero Editor][toh-pt1] and [Heroes List][toh-pt2] apps from parts 1 and 2 of the [tutorial][], respectively.

You'll first see POs and tests for the [tutorial][]'s simple [Hero Editor][toh-pt1]. Before proceeding, review the [final code][] of the [tutorial part 1][toh-pt1], taking note of the app component template:

[final code]: /angular/tutorial/toh-pt1#the-road-youve-travelled

<?code-excerpt "toh-1/lib/app_component.dart (template)" title?>
```
  template: '''
    <h1>{!{title}!}</h1>
    <h2>{!{hero.name}!} details!</h2>
    <div><label>id: </label>{!{hero.id}!}</div>
    <div>
      <label>name: </label>
      <input [(ngModel)]="hero.name" placeholder="name">
    </div>''',
```

You can use a single page object for an entire app when it is as simple
as the Hero Editor. You might test the in-page title using such a page object as
follows:

<?code-excerpt "toh-1/test/app_test.dart (title)" title?>
```
  test('title', () async {
    expect(await appPO.title, 'Tour of Heroes');
  });
```

## PO field annotation basics {#po-annotations}

The [pageloader][] package allows you to declaratively identify HTML
template elements, by annotating PO class fields. 
During test execution, the package binds such fields to the
DOM element(s) specified by the annotation. For example,
an initial version of `AppPO` might look like this:

[pageloader]: https://pub.dartlang.org/packages/pageloader

<?code-excerpt "toh-1/test/app_test.dart (AppPO initial)" title?>
```
  class AppPO {
    @ByTagName('h1')
    PageLoaderElement _title;
    /* . . . */
    Future<String> get title => _title.visibleText;
    /* . . . */
  }
```

At runtime, the `_h1` field is bound to the app component [template's
`<h1>` element](#toh-1libapp_componentdart-template) since the field was annotated
with [@ByTagName()][]. Other basic tags include:

- [@ByClass()]({{page.pageloaderObjectsApi}}/ByClass-class.html)
- [@ByCss()]({{page.pageloaderObjectsApi}}/ByCss-class.html)
- [@ById()]({{page.pageloaderObjectsApi}}/ById-class.html)
- [@FirstByCss()]({{page.pageloaderObjectsApi}}/FirstByCss-class.html)

[@ByTagName()]: {{page.pageloaderObjectsApi}}/ByTagName-class.html

The PO `title` field returns the heading element's text.
Access to page elements is **asynchronous**, which is why `title` is of type
[Future][], and the "title" test shown in the previous section is marked as `async`.

[Future]: {{site.dart_api}}/dart-async/Future-class.html

## PO initialization

Since most page objects are shared across tests, they are generally initialized
during setup using the fixture's `resolvePageObject()` method,
passing the PO type as argument:

<?code-excerpt "toh-1/test/app_test.dart (appPO setup)" title?>
```
  final testBed = new NgTestBed<AppComponent>();
  NgTestFixture<AppComponent> fixture;
  AppPO appPO;

  setUp(() async {
    fixture = await testBed.create();
    appPO = await fixture.resolvePageObject(AppPO);
  });
```

## Using POs in tests

When the [Hero Editor][toh-pt1] app loads, it displays 
data for a hero named _Windstorm_ having id 1. Here's how you might test
for this:

<?code-excerpt "toh-1/test/app_test.dart (hero)" title?>
```
  const windstormData = const <String, dynamic>{'id': 1, 'name': 'Windstorm'};

  test('initial hero properties', () async {
    expect(await appPO.heroId, windstormData['id']);
    expect(await appPO.heroName, windstormData['name']);
  });
```

After looking at the app component's [template](#toh-1libapp_componentdart-template),
you might define the PO `heroId` and `heroName` fields like this:

<?code-excerpt "toh-1/test/app_test.dart (AppPO hero)" title?>
```
  class AppPO {
  /* . . . */
    @FirstByCss('div')
    PageLoaderElement _id; // e.g. 'id: 1'

    @ByTagName('h2')
    PageLoaderElement _heroName; // e.g. 'Mr Freeze details!'
    /* . . . */
    Future<int> get heroId async {
      final idAsString = (await _id.visibleText).split(' ')[1];
      return int.parse(idAsString, onError: (_) => -1);
    }

    Future<String> get heroName async {
      final text = await _heroName.visibleText;
      return text.substring(0, text.lastIndexOf(' '));
    }
    /* . . . */
  }
```

The page object extracts the id from text that follows the "id:" label in
the first `<div>`, and the hero name from the `<h2>` text, dropping the
"details!" suffix.

## PO _List_ fields

The app from [part 2][toh-pt2] of the [tutorial][] displays a list of heros, generated using an `ngFor` applied to an `<li>` element:

<?code-excerpt "toh-2/lib/app_component_1.html (styled heroes)" region="heroes-styled"?>
```
  <h2>My Heroes</h2>
  <ul class="heroes">
    <li *ngFor="let hero of heroes">
      <span class="badge">{!{hero.id}!}</span> {!{hero.name}!}
    </li>
  </ul>
```

To define a PO field that collects all generated `<li>` elements, use the annotations introduced [earlier](#po-annotations), but declare the field to be of type `List<PageLoaderElement>`:

<?code-excerpt "toh-2/test/app_po.dart (_heroes)"?>
```
  @ByTagName('li')
  List<PageLoaderElement> _heroes;
```

When bound, the `_heroes` list will contain an element for each `<li>` element in the view. If the displayed heroes list is empty, then `_heroes` will be an empty list. That is, `List<PageLoaderElement>` PO fields are never `null`. 

You might render hero data (as a map) from the text of the `<li>` elements like this:

<?code-excerpt "toh-2/test/app_po.dart (heroes)" indent-by="0"?>
```
  Iterable<Future<Map>> get heroes =>
      _heroes.map((el) async => _heroDataFromLi(await el.visibleText));

/* . . . */
  Map<String, dynamic> _heroDataFromLi(String liText) {
    final matches = new RegExp((r'^(\d+) (.*)$')).firstMatch(liText);
    return _heroData(matches[1], matches[2]);
  }
```

## PO optional fields

{% comment %}TODO: link to user interaction section{% endcomment %}

Only once a hero is selected from the [Heroes List][toh-pt2], is the selected hero's details displayed from this template fragment:

<?code-excerpt "toh-2/lib/app_component_1.html (optional hero details)" region="ng-if"?>
```
  <div *ngIf="selectedHero != null">
    <h2>{!{selectedHero.name}!} details!</h2>
    <div><label>id: </label>{!{selectedHero.id}!}</div>
    <div>
      <label>name: </label>
      <input [(ngModel)]="selectedHero.name" placeholder="name">
    </div>
  </div>
```

To access optionally displayed page elements like the hero details use the [@optional][] annotation:

<?code-excerpt "toh-2/test/app_po.dart (hero detail heading)"?>
```
  @FirstByCss('div h2')
  @optional
  PageLoaderElement _heroDetailHeading; // e.g. 'Mr Freeze details!'
```

When no hero details are present in the view, then `_heroDetailHeading` will be `null`.

## More (_to be continued_)

[_to be continued_]

[angular_test]: https://pub.dartlang.org/packages/angular_test
[@optional]: {{page.pageloaderObjectsApi}}/optional-constant.html
[page object]: https://martinfowler.com/bliki/PageObject.html
[pageloader]: https://pub.dartlang.org/packages/pageloader
[separate concerns]: https://en.wikipedia.org/wiki/Separation_of_concerns
[toh-pt1]: /angular/tutorial/toh-pt1
[toh-pt2]: /angular/tutorial/toh-pt2
[tutorial]: /angular/tutorial
