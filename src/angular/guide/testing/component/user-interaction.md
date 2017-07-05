---
layout: angular
title: "Component Testing: User interaction (DRAFT)"
description: Techniques and practices for component testing of AngularDart apps.
sideNavGroup: advanced
prevpage:
  title: Testing
  url: /angular/guide/testing
nextpage:
  title: End-to-end Testing
  url: /angular/guide/testing/e2e
---
{% include_relative _page-top-toc.md %}

[Some comment about simulating user interaction through page objects.]
[Maybe this should go back into the po page?]

## Test component updates (_to be continued_)

Most components are dynamic, supporting interactions with the user as
well as other components. To test a component's behavior under such
situations, use the `NgTestFixture.update()` method.

### Hero name update test

You'll need to interact with the fixture's app component instance to test
changing the hero's name. Use the `NgTestFixture.update()` method for
this. The type of the update method's argument is `AppComponent`; this
corresponds to the generic parameter type used in the declaration of
`fixture`.

<?code-excerpt "toh-1/test/app_test.dart (update name)" title?>
```
  const nameSuffix = 'X';

  test('update hero name', () async {
    await appPO.type(nameSuffix);
    expect(await appPO.heroId, windstormData['id']);
    expect(await appPO.heroName, windstormData['name'] + nameSuffix);
  });
```

Enhance the app page object class so that it accesses the template's
`<input>` element. Then define a `type()` method by delegation to the bound
input element:

<?code-excerpt "toh-1/test/app_test.dart (AppPO input)" title?>
```
  class AppPO {
  /* . . . */
    @ByTagName('input')
    PageLoaderElement _input;
    /* . . . */
    Future type(String s) => _input.type(s);
  }
```