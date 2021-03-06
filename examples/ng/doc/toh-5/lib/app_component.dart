// #docplaster
// #docregion
import 'package:angular2/angular2.dart';
// #docregion import-router
import 'package:angular2/router.dart';
// #enddocregion import-router

import 'src/dashboard_component.dart';
import 'src/hero_detail_component.dart';
import 'src/hero_service.dart';
import 'src/heroes_component.dart';

@Component(
    selector: 'my-app',
    // #docregion template, template-v3
    template: '''
      <h1>{{title}}</h1>
      <nav>
        <a [routerLink]="['Dashboard']">Dashboard</a>
        <a [routerLink]="['Heroes']">Heroes</a>
      </nav>
      <router-outlet></router-outlet>''',
    // #enddocregion template, template-v3
    // #docregion styleUrls
    styleUrls: const ['app_component.css'],
    // #enddocregion styleUrls
    // #docregion directives-and-providers
    directives: const [ROUTER_DIRECTIVES],
    providers: const [HeroService, ROUTER_PROVIDERS])
// #enddocregion directives-and-providers
// #docregion heroes, routes
@RouteConfig(const [
  // #enddocregion heroes
  // #docregion dashboard
  const Route(
      path: '/dashboard',
      name: 'Dashboard',
      component: DashboardComponent,
      useAsDefault: true),
  // #enddocregion dashboard
  // #docregion hero-detail
  const Route(
      path: '/detail/:id', name: 'HeroDetail', component: HeroDetailComponent),
  // #enddocregion hero-detail
  // #docregion heroes
  const Route(path: '/heroes', name: 'Heroes', component: HeroesComponent)
])
// #enddocregion heroes, routes
class AppComponent {
  String title = 'Tour of Heroes';
}
