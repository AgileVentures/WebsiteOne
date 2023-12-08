# paranoia Changelog

## 2.6.1

* [#535](https://github.com/rubysherpas/paranoia/pull/535) Allow to skip updating paranoia_destroy_attributes for records while really_destroy!
  [Anton Bogdanov](https://github.com/kortirso)

## 2.6.0

* [#512](https://github.com/rubysherpas/paranoia/pull/512) Quote table names; Mysql 8 has keywords that might match table names which cause an exception.
* [#476](https://github.com/rubysherpas/paranoia/pull/476) Fix syntax error in documentation.
* [#485](https://github.com/rubysherpas/paranoia/pull/485) Rollback transaction if destroy aborted.
* [#522](https://github.com/rubysherpas/paranoia/pull/522) Add failing tests for association with abort on destroy.
* [#513](https://github.com/rubysherpas/paranoia/pull/513) Fix create callback called on destroy.

## 2.5.3

* [#532](https://github.com/rubysherpas/paranoia/pull/532) Fix: correct bug when sentinel_value is not a timestamp
  [Hassanin Ahmed](https://github.com/sas1ni69)
* [#531](https://github.com/rubysherpas/paranoia/pull/531) Added test case to reproduce bug introduce in v2.5.1
  [Sherif Elkassaby](https://github.com/sherif-nedap)
* [#529](https://github.com/rubysherpas/paranoia/pull/529) Fix: Do not define a RSpec matcher when RSpec isn't present
  [Sebastian Welther](https://github.com/swelther)

## 2.5.2

* [#526](https://github.com/rubysherpas/paranoia/pull/526) Do not include tests files in packaged gem

  [Jason Fleetwood-Boldt](https://github.com/jasonfb)
* [#492](https://github.com/rubysherpas/paranoia/pull/492) Warn if acts_as_paranoid is called more than once on the same model

  [Ignatius Reza](https://github.com/ignatiusreza)

## 2.5.1

* [#481](https://github.com/rubysherpas/paranoia/pull/481) Replaces hard coded `deleted_at` with `paranoia_column`.

  [Hassanin Ahmed](https://github.com/sas1ni69)

## 2.5.0

 * [#516](https://github.com/rubysherpas/paranoia/pull/516) Add support for ActiveRecord 7.0, drop support for EOL Ruby < 2.5 and Rails < 5.1
    adding support for Rails 7

   [Mathieu Jobin](https://github.com/mathieujobin)
 * [#515](https://github.com/rubysherpas/paranoia/pull/515) Switch from Travis CI to GitHub Actions

   [Shinichi Maeshima](https://github.com/willnet)

## 2.4.3

* [#503](https://github.com/rubysherpas/paranoia/pull/503) Bump activerecord dependency for Rails 6.1

  [Jörg Schiller](https://github.com/joergschiller)

* [#483](https://github.com/rubysherpas/paranoia/pull/483) Update JRuby version to 9.2.8.0 + remove EOL Ruby 2.2

  [Uwe Kubosch](https://github.com/donv)

* [#482](https://github.com/rubysherpas/paranoia/pull/482) Fix after_commit for Rails 6

  [Ashwin Hegde](https://github.com/hashwin)

## 2.4.2

* [#470](https://github.com/rubysherpas/paranoia/pull/470) Add support for ActiveRecord 6.0

  [Anton Kolodii](https://github.com/iggant), [Jared Norman](https://github.com/jarednorman)

## 2.4.1

* [#435](https://github.com/rubysherpas/paranoia/pull/435) Monkeypatch activerecord relations to work with rails 5.2.0

  [Bartosz Bonisławski (@bbonislawski)](https://github.com/bbonislawski)

## 2.4.0

* [#423](https://github.com/rubysherpas/paranoia/pull/423) Add `paranoia_destroy` and `paranoia_delete` aliases

  [John Hawthorn (@jhawthorn)](https://github.com/jhawthorn)

* [#408](https://github.com/rubysherpas/paranoia/pull/408) Fix instance variable `@_disable_counter_cache` not initialized warning.

  [Akira Matsuda (@amatsuda)](https://github.com/amatsuda)

* [#412](https://github.com/rubysherpas/paranoia/pull/412) Fix `really_destroy!` behavior with `sentinel_value`

  [Steve Rice (@steverice)](https://github.com/steverice)

## 2.3.1

* [#397](https://github.com/rubysherpas/paranoia/pull/397) Bump active record max version to support 5.1 final

## 2.3.0 (2017-04-14)

* [#393](https://github.com/rubysherpas/paranoia/pull/393) Drop support for Rails 4.1 and begin supporting Rails 5.1.

  [Miklós Fazekas (@mfazekas)](https://github.com/mfazekas)

* [#391](https://github.com/rubysherpas/paranoia/pull/391) Use Contributor Covenant Version 1.4

  [Ben A. Morgan (@BenMorganIO)](https://github.com/BenMorganIO)

* [#390](https://github.com/rubysherpas/paranoia/pull/390) Fix counter cache with double destroy, really_destroy, and restore

  [Chris Oliver (@excid3)](https://github.com/excid3)

* [#389](https://github.com/rubysherpas/paranoia/pull/389) Added association not soft destroyed validator

  _Fixes [#380](https://github.com/rubysherpas/paranoia/issues/380)_

  [Edward Poot (@edwardmp)](https://github.com/edwardmp)

* [#383](https://github.com/rubysherpas/paranoia/pull/383) Add recovery window feature

  _Fixes [#359](https://github.com/rubysherpas/paranoia/issues/359)_

  [Andrzej Piątyszek (@konto-andrzeja)](https://github.com/konto-andrzeja)


## 2.2.1 (2017-02-15)

* [#371](https://github.com/rubysherpas/paranoia/pull/371) Use ActiveSupport.on_load to correctly re-open ActiveRecord::Base

  _Fixes [#335](https://github.com/rubysherpas/paranoia/issues/335) and [#381](https://github.com/rubysherpas/paranoia/issues/381)._

  [Iaan Krynauw (@iaankrynauw)](https://github.com/iaankrynauw)

* [#377](https://github.com/rubysherpas/paranoia/pull/377) Touch record on paranoia-destroy.

  _Fixes [#296](https://github.com/rubysherpas/paranoia/issues/296)._

  [René (@rbr)](https://github.com/rbr)

* [#379](https://github.com/rubysherpas/paranoia/pull/379) Fixes a problem of ambiguous table names when using only_deleted method.

  _Fixes [#26](https://github.com/rubysherpas/paranoia/issues/26) and [#27](https://github.com/rubysherpas/paranoia/pull/27)._

  [Thomas Romera (@Erowlin)](https://github.com/Erowlin)

## 2.2.0 (2016-10-21)

* Ruby 2.0 or greater is required
* Rails 5.0.0.beta1.1 support [@pigeonworks](https://github.com/pigeonworks) [@halostatue](https://github.com/halostatue) and [@gagalago](https://github.com/gagalago)
* Previously `#really_destroyed?` may have been defined on non-paranoid models, it is now only available on paranoid models, use regular `#destroyed?` instead.

## 2.1.5 (2016-01-06)

* Ruby 2.3 support

## 2.1.4

## 2.1.3

## 2.1.2

## 2.1.1

## 2.1.0 (2015-01-23)

### Major changes

* `#destroyed?` is no longer overridden. Use `#paranoia_destroyed?` for the existing behaviour. [Washington Luiz](https://github.com/huoxito)
* `#persisted?` is no longer overridden.
* ActiveRecord 4.0 no longer has `#destroy!` as an alias for `#really_destroy!`.
* `#destroy` will now raise an exception if called on a readonly record.
* `#destroy` on a hard deleted record is now a successful noop.
* `#destroy` on a new record will set deleted_at (previously this raised an error)
* `#destroy` and `#delete` always return self when successful.

### Bug Fixes

* Calling `#destroy` twice will not hard-delete records. Use `#really_destroy!` if this is desired.
* Fix errors on non-paranoid has_one dependent associations

## 2.0.5 (2015-01-22)

### Bug fixes

* Fix restoring polymorphic has_one relationships [#189](https://github.com/radar/paranoia/pull/189) [#174](https://github.com/radar/paranoia/issues/174) [Patrick Koperwas](https://github.com/PatKoperwas)
* Fix errors when restoring a model with a has_one against a non-paranoid model. [#168](https://github.com/radar/paranoia/pull/168) [Shreyas Agarwal](https://github.com/shreyas123)
* Fix rspec 2 compatibility [#197](https://github.com/radar/paranoia/pull/197) [Emil Sågfors](https://github.com/lime)
* Fix some deprecation warnings on rails 4.2 [Sergey Alekseev](https://github.com/sergey-alekseev)

## 2.0.4 (2014-12-02)

### Features
* Add paranoia_scope as named version of default_scope [#184](https://github.com/radar/paranoia/pull/184) [Jozsef Nyitrai](https://github.com/nyjt)


### Bug Fixes
* Fix initialization problems when missing table or no database connection [#186](https://github.com/radar/paranoia/issues/186)
* Fix broken restore of has_one associations [#185](https://github.com/radar/paranoia/issues/185) [#171](https://github.com/radar/paranoia/pull/171) [Martin Sereinig](https://github.com/srecnig)
