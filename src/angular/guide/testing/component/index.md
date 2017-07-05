---
layout: angular
title: Component Testing (DRAFT)
sideNavGroup: advanced
prevpage:
  title: Testing
  url: /angular/guide/testing
nextpage:
  title: End-to-end Testing
  url: /angular/guide/testing/e2e
toc: false
---
{% comment %}
TODO(chalin): extend the scope of this page to include unit testing of services?
{% endcomment %}
{% include_relative _page-top-toc.md %}

This part of the [Testing](/angular/guide/testing) how-to guide covers
**[component testing][testing]** of AngularDart apps using the
**[angular_test][]** package.  It assumes that you are familiar with
[Dart testing][] in general, and the API of the [test package][] in
particular.

The [angular_test][] package is suitable for testing:

- A single component, or
- A small group of related components

It is not meant to test an entire app. For that, you'll write
[end-to-end tests](/angular/guide/testing/e2e).

<div class="alert is-important" markdown="1">
[angular_test][] will report errors if you attempt to test an
app root component with an associated [router](/angular/guide/router). See the
[Routing components](#link-TBD) section for details.
</div>

{% comment %}
## Component testing topics

{% include_relative _toc.md %}
{% endcomment %}

[angular_test]: https://pub.dartlang.org/packages/angular_test
[Dart testing]: https://www.dartlang.org/guides/testing
[testing]: https://en.wikipedia.org/wiki/Software_testing#Component_interface_testing
[test package]: https://pub.dartlang.org/packages/test
