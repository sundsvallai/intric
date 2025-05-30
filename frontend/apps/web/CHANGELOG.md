# Changelog

## [1.13.3](https://github.com/inooLabs/intric-frontend/compare/intric/web@v1.13.2...intric/web@v1.13.3) (2025-02-11)


### Bug Fixes

* fix display of free space if used total exceeds quota ([3fbca93](https://github.com/inooLabs/intric-frontend/commit/3fbca93192067b5552dc08ae20a71d2dafcc9a3f))
* no longer adding "null" collection when adding a website in knowledge ([28d1b11](https://github.com/inooLabs/intric-frontend/commit/28d1b11a413c69d6896af6d42f3f7f998fc025f8))

## [1.13.2](https://github.com/inooLabs/intric-frontend/compare/intric/web@v1.13.1...intric/web@v1.13.2) (2025-02-06)


### Bug Fixes

* fix display edge cases in storage bar ([a02c4d7](https://github.com/inooLabs/intric-frontend/commit/a02c4d7d0452bc97320e1d6fb481283d65e82d6c))

## [1.13.1](https://github.com/inooLabs/intric-frontend/compare/intric/web@v1.13.0...intric/web@v1.13.1) (2025-02-05)


### Bug Fixes

* add feature flag to hide widgets from assistant settings ([cf29a8b](https://github.com/inooLabs/intric-frontend/commit/cf29a8bb3190c4522d1dab41602ca6ca00d78a83))

## [1.13.0](https://github.com/inooLabs/intric-frontend/compare/intric/web@v1.12.0...intric/web@v1.13.0) (2025-02-05)


### Features

* add setting for preferred completion model ([#148](https://github.com/inooLabs/intric-frontend/issues/148)) ([3484d90](https://github.com/inooLabs/intric-frontend/commit/3484d9015b893f1acabd25e63b9f60ba0ef752c0))
* add storage overview to admin and spaces ([#141](https://github.com/inooLabs/intric-frontend/issues/141)) ([3edab89](https://github.com/inooLabs/intric-frontend/commit/3edab89048370772186582553a74da227690eba5))
* allow manual trigger of website crawls ([#152](https://github.com/inooLabs/intric-frontend/issues/152)) ([b7fed64](https://github.com/inooLabs/intric-frontend/commit/b7fed64318e638fbf9e68b7475fd2323a5e3f669))


### Bug Fixes

* change naming of "preferred" to "default" model ([#150](https://github.com/inooLabs/intric-frontend/issues/150)) ([dfc62f2](https://github.com/inooLabs/intric-frontend/commit/dfc62f235d381af7a8ddb6378386ab42dfa5481b))
* get space roles from backend ([#151](https://github.com/inooLabs/intric-frontend/issues/151)) ([f227cd1](https://github.com/inooLabs/intric-frontend/commit/f227cd1b0d25f30a7c27eeca19a57b8bd7fd7dfa))
* move prompt description hints to right side and make them blue ([dfc62f2](https://github.com/inooLabs/intric-frontend/commit/dfc62f235d381af7a8ddb6378386ab42dfa5481b))

## [1.12.0](https://github.com/inooLabs/intric-frontend/compare/intric/web@v1.11.1...intric/web@v1.12.0) (2025-01-27)


### Features

* add new viewer role to spaces ([d504455](https://github.com/inooLabs/intric-frontend/commit/d5044556f88962c314bedcb2dc3ee61ff990d1d0))
* add publishing to apps and assistants ([#134](https://github.com/inooLabs/intric-frontend/issues/134)) ([d504455](https://github.com/inooLabs/intric-frontend/commit/d5044556f88962c314bedcb2dc3ee61ff990d1d0))


### Bug Fixes

* fix icon sizes for publishing context menu entries ([64896a2](https://github.com/inooLabs/intric-frontend/commit/64896a29e8d0cef5b32c6905db341c765af9bd84))
* improve display of inline references ([c392c4d](https://github.com/inooLabs/intric-frontend/commit/c392c4d3dec39d8f042e3154a71df0cb3fa091a9))

## [1.11.1](https://github.com/inooLabs/intric-frontend/compare/intric/web@v1.11.0...intric/web@v1.11.1) (2025-01-21)


### Miscellaneous Chores

* **intric/web:** Synchronize intric-frontend versions

## [1.11.0](https://github.com/inooLabs/intric-frontend/compare/intric/web@v1.10.0...intric/web@v1.11.0) (2025-01-17)


### Features

* add default assistant in personal space ([#140](https://github.com/inooLabs/intric-frontend/issues/140)) ([28ac2aa](https://github.com/inooLabs/intric-frontend/commit/28ac2aa65909c71031b6bbaf17633b8229d89a19))
* enable improved RAG and add inline references ([#138](https://github.com/inooLabs/intric-frontend/issues/138)) ([a66c906](https://github.com/inooLabs/intric-frontend/commit/a66c906315fd4004b12a0680772fe66d0f5468e5))
* new markdown rendering ([a66c906](https://github.com/inooLabs/intric-frontend/commit/a66c906315fd4004b12a0680772fe66d0f5468e5))


### Bug Fixes

* add link to switch between password / mg on legacy login page ([#139](https://github.com/inooLabs/intric-frontend/issues/139)) ([b730af0](https://github.com/inooLabs/intric-frontend/commit/b730af085fc78a57d7eee3b831876ececccf97d4))
* Change editor button wording from "Close" to "Done" ([2c5f34c](https://github.com/inooLabs/intric-frontend/commit/2c5f34c991a539ad3c23685f0d748cfa9f7b6c35))
* Do not discard changes when cancelling navigation on editor pages (INTRC-639) ([4b334de](https://github.com/inooLabs/intric-frontend/commit/4b334de3045e1eef28a511a3b0264157aa921a96))
* fix member role selector styling ([45db633](https://github.com/inooLabs/intric-frontend/commit/45db633cc6e72a51ab55408391384a6bbc519526))
* make knowledge filtering non case sensitive ([#142](https://github.com/inooLabs/intric-frontend/issues/142)) ([5352d90](https://github.com/inooLabs/intric-frontend/commit/5352d908a33e516d5683ab899d1202d146ba5346))
* use dynamic colour based on user email in account page ([6968d5c](https://github.com/inooLabs/intric-frontend/commit/6968d5c65e96d6b26f48d0f98bbe1ebc78ef48f1))

## [1.10.0](https://github.com/inooLabs/intric-frontend/compare/intric/web@v1.9.1...intric/web@v1.10.0) (2024-12-19)


### Features

* add automatic user provisioning ([#129](https://github.com/inooLabs/intric-frontend/issues/129)) ([663488b](https://github.com/inooLabs/intric-frontend/commit/663488bc6bc91c5cefada473acf292431c454965))
* add prompt history for apps ([#128](https://github.com/inooLabs/intric-frontend/issues/128)) ([390b88e](https://github.com/inooLabs/intric-frontend/commit/390b88e3cd5759ca583ae436fd4e74c1bdd60a10))
* add templates ([#117](https://github.com/inooLabs/intric-frontend/issues/117)) ([581b47b](https://github.com/inooLabs/intric-frontend/commit/581b47b1cb79d22eb362e3089d49b0c239507eaf))


### Bug Fixes

* Add categories for app templates ([24cbcb3](https://github.com/inooLabs/intric-frontend/commit/24cbcb39cab0ba2bd952f49769448b8e3ab26ca9))
* add spin animation to loading spinners ([76b76c8](https://github.com/inooLabs/intric-frontend/commit/76b76c8d4b42d598e281279d6e67f8aa9bdfcbb4))
* allow setting of display name for websites ([#133](https://github.com/inooLabs/intric-frontend/issues/133)) ([d47d9f3](https://github.com/inooLabs/intric-frontend/commit/d47d9f3882b85d04f51b39404c113316698513a0))
* fix attached file display in chat ([e61945e](https://github.com/inooLabs/intric-frontend/commit/e61945e6d0b44dffdd5f8ddaf84fed7d131a03c8))
* hide username/password if mobilityguard is configured ([#130](https://github.com/inooLabs/intric-frontend/issues/130)) ([b3a9d87](https://github.com/inooLabs/intric-frontend/commit/b3a9d870180879504622141dbe742b0b0a3c3d64))
* improve session attachment styling ([6486503](https://github.com/inooLabs/intric-frontend/commit/64865036956479fae0b38010d4a97237feb7aaac))
* make loading spinner spin again ([4455e7e](https://github.com/inooLabs/intric-frontend/commit/4455e7e262e9e86dbb0a934d83795d7738d18fac))
* **performance:** load assistant sessions and app runs asynchronously ([#131](https://github.com/inooLabs/intric-frontend/issues/131)) ([9350a22](https://github.com/inooLabs/intric-frontend/commit/9350a225e07bcee07d722a5b9079d34cb9d58a3a))
* **prompt history:** show description indicator and truncate user email ([80f8437](https://github.com/inooLabs/intric-frontend/commit/80f843715782295041bf606a34b8cca3b7457962))
* proper truncation of long names on edit pages ([d47d9f3](https://github.com/inooLabs/intric-frontend/commit/d47d9f3882b85d04f51b39404c113316698513a0))
* provide default theme if not found in local storage ([3bc04cf](https://github.com/inooLabs/intric-frontend/commit/3bc04cf983d23554a4114084b142380e869e195f))
* show email instead of user id when hovering member chip ([8f69a86](https://github.com/inooLabs/intric-frontend/commit/8f69a863b17e57895839791c06db79148ab7ce05))
* show error description when login fails ([b67ad2e](https://github.com/inooLabs/intric-frontend/commit/b67ad2e215fcb20668c44d81f804771376644cd9))
* show references collapsed by default ([30f89e7](https://github.com/inooLabs/intric-frontend/commit/30f89e7da1f182f0b61acab5b4f672cc63a0f968))
* show website url instead of website name in knowledge selector ([ca7b302](https://github.com/inooLabs/intric-frontend/commit/ca7b302fe9a87a1604c80d54e2e4a8bdb26fc16f))
* **template hints:** increase padding so hint text doesn't overlap with icon ([bed7ae6](https://github.com/inooLabs/intric-frontend/commit/bed7ae6cb9cabee96813749fdb71edd04c6d8077))

## [1.9.1](https://github.com/inooLabs/intric-frontend/compare/intric/web@v1.9.0...intric/web@v1.9.1) (2024-12-06)


### Bug Fixes

* add notice and request form for integrations ([0140e8f](https://github.com/inooLabs/intric-frontend/commit/0140e8f863b107cf83f18a4ef1ceb2c5e7f157f9))

## [1.9.0](https://github.com/inooLabs/intric-frontend/compare/intric/web@v1.8.0...intric/web@v1.9.0) (2024-12-05)


### Features

* add "dark" and "system" themes ([6a03018](https://github.com/inooLabs/intric-frontend/commit/6a03018206e2dd38901424fb5e9168ddb64e23db))
* add quick switcher for assistants and apps ([6a03018](https://github.com/inooLabs/intric-frontend/commit/6a03018206e2dd38901424fb5e9168ddb64e23db))
* add theme support ([#122](https://github.com/inooLabs/intric-frontend/issues/122)) ([6a03018](https://github.com/inooLabs/intric-frontend/commit/6a03018206e2dd38901424fb5e9168ddb64e23db))
* add websocket communications ([#101](https://github.com/inooLabs/intric-frontend/issues/101)) ([298ac8d](https://github.com/inooLabs/intric-frontend/commit/298ac8da4298b01d9c0f0cc23d78b781d324b746))
* allow users to leave feedback via feedback button ([#112](https://github.com/inooLabs/intric-frontend/issues/112)) ([df93e69](https://github.com/inooLabs/intric-frontend/commit/df93e6964f9c14be5f5e887b302aa4b505a410f4))
* attachments can now also be uploaded to assistants ([bf48580](https://github.com/inooLabs/intric-frontend/commit/bf4858017ed9313baa629609da17f251bb002488))
* new interface for editing assistants ([#107](https://github.com/inooLabs/intric-frontend/issues/107)) ([bf48580](https://github.com/inooLabs/intric-frontend/commit/bf4858017ed9313baa629609da17f251bb002488))


### Bug Fixes

* add background colours for pwa in dark mode ([d0af180](https://github.com/inooLabs/intric-frontend/commit/d0af18093b7eba57eba8608835464f8587c2f588))
* persist scroll position on dashboard ([6a03018](https://github.com/inooLabs/intric-frontend/commit/6a03018206e2dd38901424fb5e9168ddb64e23db))
* prevent websocket memory leak during hmr in local development ([d9543c7](https://github.com/inooLabs/intric-frontend/commit/d9543c7e6b9f158c23433441cc4cf0da352f0f18))
* rename "finish editing" to "close" in editor ([f55dbeb](https://github.com/inooLabs/intric-frontend/commit/f55dbebe58711e9fb909a31673a11481f01c827d))
* tabs are now displayed in the center of a page ([6a03018](https://github.com/inooLabs/intric-frontend/commit/6a03018206e2dd38901424fb5e9168ddb64e23db))
* truncate overflowing filenames in apps ([a45baa9](https://github.com/inooLabs/intric-frontend/commit/a45baa960dfab2fc666747471c93e45c56d3fc7d))
* websocket will only subscribe after it is opened ([6a03018](https://github.com/inooLabs/intric-frontend/commit/6a03018206e2dd38901424fb5e9168ddb64e23db))

## [1.8.0](https://github.com/inooLabs/intric-frontend/compare/intric/web@v1.7.0...intric/web@v1.8.0) (2024-10-25)


### Features

* add apps in intric (build-a-service) ([#98](https://github.com/inooLabs/intric-frontend/issues/98)) ([7e40f30](https://github.com/inooLabs/intric-frontend/commit/7e40f3053281613a24dbb89f83d6e7634752ac0b))

## [1.7.0](https://github.com/inooLabs/intric-frontend/compare/intric/web@v1.6.0...intric/web@v1.7.0) (2024-10-24)


### Features

* improved mobile dashboard ([#95](https://github.com/inooLabs/intric-frontend/issues/95)) ([2747efc](https://github.com/inooLabs/intric-frontend/commit/2747efc05451304c85dc7f242bfd7a9ed4514540))

## [1.6.0](https://github.com/inooLabs/intric-frontend/compare/intric/web@v1.5.0...intric/web@v1.6.0) (2024-10-18)


### Features

* add temperature to api service settings ([a637e7a](https://github.com/inooLabs/intric-frontend/commit/a637e7a4acbedfe36ac77d08e876caad754b895d))


### Bug Fixes

* redirect to requested page after login ([#90](https://github.com/inooLabs/intric-frontend/issues/90)) ([db54894](https://github.com/inooLabs/intric-frontend/commit/db54894d748d489e83904d4f66568019bc3900b4))
* revert name change "API services" back to "Services" ([b0fb57b](https://github.com/inooLabs/intric-frontend/commit/b0fb57b0ecef12d006167824a17a524215874ee2))

## [1.5.0](https://github.com/inooLabs/intric-frontend/compare/intric/web@v1.4.0...intric/web@v1.5.0) (2024-10-09)


### Features

* add Input.Color component ([#79](https://github.com/inooLabs/intric-frontend/issues/79)) ([b6feba6](https://github.com/inooLabs/intric-frontend/commit/b6feba65730d4a37b1f95e235d953a99a23a082e))
* add pagination to chat history ([#85](https://github.com/inooLabs/intric-frontend/issues/85)) ([4b7b09e](https://github.com/inooLabs/intric-frontend/commit/4b7b09ea348a7c4c8268fd730b444bd86e59fd6f))
* add prompt versioning ([#83](https://github.com/inooLabs/intric-frontend/issues/83)) ([7ab5e3c](https://github.com/inooLabs/intric-frontend/commit/7ab5e3ce18a45c3d3bc10a5a7e62c5570dae07c6))
* old services are now called "API services" ([4b8cd33](https://github.com/inooLabs/intric-frontend/commit/4b8cd333832e7e520b6faebdc68d4e46999fab76))


### Bug Fixes

* add fallback when not able to get user info from IAM ([a169f31](https://github.com/inooLabs/intric-frontend/commit/a169f3127b7d762c0a0a961989b0036e9ef3d97b))
* add required label to Input.TextArea ([b6feba6](https://github.com/inooLabs/intric-frontend/commit/b6feba65730d4a37b1f95e235d953a99a23a082e))
* bump default page size to 100 ([d9df1b2](https://github.com/inooLabs/intric-frontend/commit/d9df1b23c479d271f23aa72245ed21d1e9d45e58))
* fix a crash when assistant's name is an empty string ([d40c9be](https://github.com/inooLabs/intric-frontend/commit/d40c9be3e14b300517083af1f7063ce28193d203))
* fixes a bug when updating an api service schema through the ui ([d0834d5](https://github.com/inooLabs/intric-frontend/commit/d0834d5735324c014fee11c88f42fe4d9b2cfd0c))
* permissions check when showing edit button on space list ([2ce0ee8](https://github.com/inooLabs/intric-frontend/commit/2ce0ee8bf0f4e8bd6ca66bc678d39c36a66851ce))
* prevent chat view from jumping once scrollbar becomes visible ([0b74d55](https://github.com/inooLabs/intric-frontend/commit/0b74d556913e4c250e0551c438e3e3e5d7047a84))
* prevent widget creation when required fields are empty ([0b7b5da](https://github.com/inooLabs/intric-frontend/commit/0b7b5da867b3860c6ac10df8c7ce241df2f3ad2d))
* remove guardrail from frontend ([#76](https://github.com/inooLabs/intric-frontend/issues/76)) ([9242aca](https://github.com/inooLabs/intric-frontend/commit/9242aca995532e11092e383fb0a53d5300749d34))

## [1.4.0](https://github.com/inooLabs/intric-frontend/compare/intric/web@v1.3.0...intric/web@v1.4.0) (2024-09-16)


### Features

* add IAM via Zitadel ([#69](https://github.com/inooLabs/intric-frontend/issues/69)) ([c3d20cd](https://github.com/inooLabs/intric-frontend/commit/c3d20cd952b0acfb1d07b8909a0a4bc0c36808eb))


### Bug Fixes

* allow users that login via password to change their name ([7b6a5fc](https://github.com/inooLabs/intric-frontend/commit/7b6a5fcf63a04fbf8745b10318c63dbcef053b93))
* editing username in legacy editor possible again ([6286d2f](https://github.com/inooLabs/intric-frontend/commit/6286d2f0831e0df7f7aeb7c9a107b915e0b0d27c))
* remove can_edit check for info-blobs ([58aea03](https://github.com/inooLabs/intric-frontend/commit/58aea03fe047a3e1823bd9e1733a8eca430d2481))
* show right error message on oidc error ([2f75b83](https://github.com/inooLabs/intric-frontend/commit/2f75b838ca386b6225abc0fafe72c342a30f422d))
* stop dropdown menus from overflowing the screen ([04d9530](https://github.com/inooLabs/intric-frontend/commit/04d9530f35884f258c5ca698429fdcfcb184f0ca))

## [1.3.0](https://github.com/inooLabs/intric-frontend/compare/intric/web@v1.2.0...intric/web@v1.3.0) (2024-09-04)


### Features

* improve insights ([#73](https://github.com/inooLabs/intric-frontend/issues/73)) ([6c00bc0](https://github.com/inooLabs/intric-frontend/commit/6c00bc0a58c9ff792fd6e41baeb69ff2f2d34d66))


### Bug Fixes

* chat input no longer overflowing on small screens ([655a201](https://github.com/inooLabs/intric-frontend/commit/655a20177b8f1834c6eb1ea68a30b9fff1de9bc8))

## [1.2.0](https://github.com/inooLabs/intric-frontend/compare/intric/web@v1.1.1...intric/web@v1.2.0) (2024-09-03)


### Features

* add dashboard prototype ([c25270e](https://github.com/inooLabs/intric-frontend/commit/c25270e8fbc6b675d7e8b8d6b828b2a2a0b57bba))
* overhaul chat interface ([#71](https://github.com/inooLabs/intric-frontend/issues/71)) ([c25270e](https://github.com/inooLabs/intric-frontend/commit/c25270e8fbc6b675d7e8b8d6b828b2a2a0b57bba))


### Bug Fixes

* add intric error codes ([042e579](https://github.com/inooLabs/intric-frontend/commit/042e57973eabfda1bd7c97d2897701388580e45a))
* improve server error display ([f4f3ff9](https://github.com/inooLabs/intric-frontend/commit/f4f3ff97715e7f45c69be3f878d748893b90ea80))
* show website url in knowledge selector ([faf2651](https://github.com/inooLabs/intric-frontend/commit/faf2651af3929c922548aa1d09f1cc5616d44973))

## [1.1.1](https://github.com/inooLabs/intric-frontend/compare/intric/web@v1.1.0...intric/web@v1.1.1) (2024-08-27)


### Bug Fixes

* improve error handling for invalid/missing auth token ([80d0e63](https://github.com/inooLabs/intric-frontend/commit/80d0e6309456936fc6a8994d55e9c14de5fabcca))

## [1.1.0](https://github.com/inooLabs/intric-frontend/compare/intric/web@v1.0.2...intric/web@v1.1.0) (2024-08-19)


### Features

* add services to spaces ([#68](https://github.com/inooLabs/intric-frontend/issues/68)) ([23cd41a](https://github.com/inooLabs/intric-frontend/commit/23cd41a21c67096c8d109d55c6436b20726b8d10))
* show index info blobs for website crawls ([d1cfdd8](https://github.com/inooLabs/intric-frontend/commit/d1cfdd8125bb9112230321fd57c0c7d84dd6dfd3))


### Bug Fixes

* only allow knowledge selection of one embedding model at a time ([#66](https://github.com/inooLabs/intric-frontend/issues/66)) ([3107def](https://github.com/inooLabs/intric-frontend/commit/3107def85c1c6de57a2a1db6574be0b8dd349847))
* remove CORS config from front-end ([34d3633](https://github.com/inooLabs/intric-frontend/commit/34d3633ca739be1cfb0ca812cd34e0025fb6e75d))
* respect question's new lines in sessions ([36af1ee](https://github.com/inooLabs/intric-frontend/commit/36af1ee23d67ede3efd34dbc16ce34094d1e041b))
* show space selector in front of page header ([c75411c](https://github.com/inooLabs/intric-frontend/commit/c75411c9d5e48e5eefdda47dd49b5857d821b8b5))

## [1.0.2](https://github.com/inooLabs/intric-frontend/compare/intric/web@v1.0.1...intric/web@v1.0.2) (2024-08-08)


### Bug Fixes

* allow crawl type setting when creating a website ([dcf8816](https://github.com/inooLabs/intric-frontend/commit/dcf881656ad10553a52a0bf9b9a3bb98724123be))
* improve session handling when switching assistants ([#65](https://github.com/inooLabs/intric-frontend/issues/65)) ([ef620d0](https://github.com/inooLabs/intric-frontend/commit/ef620d0aeca27305d73e77981358f4af57f0ba59))
* page titles updated  ([#59](https://github.com/inooLabs/intric-frontend/issues/59)) ([3e2aa7c](https://github.com/inooLabs/intric-frontend/commit/3e2aa7c8bbac36ee96ee8d7012b3436057cf44c8))
* show "no options" hint in select menus ([#62](https://github.com/inooLabs/intric-frontend/issues/62)) ([586bed3](https://github.com/inooLabs/intric-frontend/commit/586bed392619c1113703bc53c6c842f427f4fcc9))
* show model names in knowledge selector ([#63](https://github.com/inooLabs/intric-frontend/issues/63)) ([e9216aa](https://github.com/inooLabs/intric-frontend/commit/e9216aaa61a2af032505b738ed660874c9367a14))

## [1.0.1](https://github.com/inooLabs/intric-frontend/compare/intric/web@v1.0.0...intric/web@v1.0.1) (2024-08-06)


### Bug Fixes

* redirect /assistants to /spaces/personal ([1283ecb](https://github.com/inooLabs/intric-frontend/commit/1283ecbfc7556f599a2a0ed42acc49867d2cdd1c))

## [1.0.0](https://github.com/inooLabs/intric-frontend/compare/intric/web@v0.28.0...intric/web@v1.0.0) (2024-08-05)


### ⚠ BREAKING CHANGES

* introduce workspaces
* remove legacy pages ([#52](https://github.com/inooLabs/intric-frontend/issues/52))

### Features

* add image upload to vision capable models ([#57](https://github.com/inooLabs/intric-frontend/issues/57)) ([ed7e809](https://github.com/inooLabs/intric-frontend/commit/ed7e809ff31960765211534d9d98c5779194734a))
* add knowledge to spaces ([#46](https://github.com/inooLabs/intric-frontend/issues/46)) ([7a23fd0](https://github.com/inooLabs/intric-frontend/commit/7a23fd06816e7aef100f945e2523254ea8106210))
* add members to spaces ([#48](https://github.com/inooLabs/intric-frontend/issues/48)) ([000ed6f](https://github.com/inooLabs/intric-frontend/commit/000ed6fe0c3d5aafdd28944c89d8fa272824911d))
* add personal space and tweaks ([#49](https://github.com/inooLabs/intric-frontend/issues/49)) ([d25d034](https://github.com/inooLabs/intric-frontend/commit/d25d03452b5f49e46a4173f65a6e0c91a5864c0d))
* add space overview table ([#52](https://github.com/inooLabs/intric-frontend/issues/52)) ([d51bfce](https://github.com/inooLabs/intric-frontend/commit/d51bfce577c6d906a886d813013658cdc7e16050))
* introduce workspaces ([5d4430d](https://github.com/inooLabs/intric-frontend/commit/5d4430d07d67eee61bb8b939fdef3b55802998a9))
* remove legacy pages ([#52](https://github.com/inooLabs/intric-frontend/issues/52)) ([d51bfce](https://github.com/inooLabs/intric-frontend/commit/d51bfce577c6d906a886d813013658cdc7e16050))
* resources can be moved between spaces ([#55](https://github.com/inooLabs/intric-frontend/issues/55)) ([713e48f](https://github.com/inooLabs/intric-frontend/commit/713e48f69ed274e8069fcc81d54934e95f39bd95))
* show used models in group and website table ([c656a89](https://github.com/inooLabs/intric-frontend/commit/c656a89910cd5d2e4bbccf31bc89cb602267fdda))
* spaces can have multiple embedding models ([#54](https://github.com/inooLabs/intric-frontend/issues/54)) ([8e953b5](https://github.com/inooLabs/intric-frontend/commit/8e953b528d3cc96563d712aaad8b4260c4941803))


### Bug Fixes

* allow scrolling on assistant and member list ([5c8b9c0](https://github.com/inooLabs/intric-frontend/commit/5c8b9c0e7127c9de6c028b3d73dba2774859dc60))
* hide member tile on personal space ([d7544b7](https://github.com/inooLabs/intric-frontend/commit/d7544b77ab1e4d986b7890670ab244a84d19bde2))
* implement permissions in personal space ([f713728](https://github.com/inooLabs/intric-frontend/commit/f713728a0a3e571ad3cadb616153be9978bae105))
* model label for vision ([#56](https://github.com/inooLabs/intric-frontend/issues/56)) ([7add198](https://github.com/inooLabs/intric-frontend/commit/7add1988297bb449a7c441a77f252b271b919fc7))
* move insights to admin ([#52](https://github.com/inooLabs/intric-frontend/issues/52)) ([d51bfce](https://github.com/inooLabs/intric-frontend/commit/d51bfce577c6d906a886d813013658cdc7e16050))
* some ui tweaks ([6aa4dc5](https://github.com/inooLabs/intric-frontend/commit/6aa4dc5e5dd68530c42a41e796d9252f8ce966ea))
* split personal space into its own menu item ([#52](https://github.com/inooLabs/intric-frontend/issues/52)) ([d51bfce](https://github.com/inooLabs/intric-frontend/commit/d51bfce577c6d906a886d813013658cdc7e16050))
* update wording on members page ([1427384](https://github.com/inooLabs/intric-frontend/commit/1427384f7ab4d19ac850b95be3342aa3b954415a))
* URL shortening for websites + new crawl status ([#51](https://github.com/inooLabs/intric-frontend/issues/51)) ([347ffae](https://github.com/inooLabs/intric-frontend/commit/347ffaedaede9a09c245e88083567eaf578f9869))

## [0.28.0](https://github.com/inooLabs/intric-frontend/compare/intric/web@v0.27.0...intric/web@v0.28.0) (2024-07-19)


### Features

* add assistants to spaces INTRC-245 ([#43](https://github.com/inooLabs/intric-frontend/issues/43)) ([c6f1d1d](https://github.com/inooLabs/intric-frontend/commit/c6f1d1d82575f9efa4d0b9746d1d21aa8f15ee5b))
* add settings to spaces ([#45](https://github.com/inooLabs/intric-frontend/issues/45)) ([3c9b57c](https://github.com/inooLabs/intric-frontend/commit/3c9b57c05a73ed165b6b1e9e5bd1b72388f6ea4a))


### Bug Fixes

* add completion model to assistant in spaces ([53cd874](https://github.com/inooLabs/intric-frontend/commit/53cd874e295d0878f53372d1b9558c047a3b953b))
* change creative model behaviour to a temperature of 1.25 ([e1bc808](https://github.com/inooLabs/intric-frontend/commit/e1bc80800aa14fee47a4b3cee165b8a8d9dc36da))
* only load websites when user has appropriate permissions ([3e60f87](https://github.com/inooLabs/intric-frontend/commit/3e60f87546ebff903a4b1553c740cdf8418739c7))

## [0.27.0](https://github.com/inooLabs/intric-frontend/compare/intric/web@v0.26.2...intric/web@v0.27.0) (2024-07-15)


### Features

* add sections on model page ([ce959f4](https://github.com/inooLabs/intric-frontend/commit/ce959f437be1a27b6bd116ac51201371cde7000a))
* add SpacesManager and SpaceSelector ([#41](https://github.com/inooLabs/intric-frontend/issues/41)) ([6300dd7](https://github.com/inooLabs/intric-frontend/commit/6300dd790a1c227accc08636946c13be6afef29a))
* move to new layout ([#38](https://github.com/inooLabs/intric-frontend/issues/38)) ([0d202db](https://github.com/inooLabs/intric-frontend/commit/0d202db5fd385d95bd04e36e59b2d1e29c5a44e0))


### Bug Fixes

* add aria labels to profile and notification buttons ([ba9a75f](https://github.com/inooLabs/intric-frontend/commit/ba9a75f45809912013546f6a77cb87d7079e4f48))
* rename "knowledge base" to "knowledge" ([de794b5](https://github.com/inooLabs/intric-frontend/commit/de794b508945e22b651f78696f376dcfe2f8e5e4))

## [0.26.2](https://github.com/inooLabs/intric-frontend/compare/intric/web@v0.26.1...intric/web@v0.26.2) (2024-07-05)


### Bug Fixes

* add logos to models ([0f3fb33](https://github.com/inooLabs/intric-frontend/commit/0f3fb3364fe060ab538e3de7f709b2bafc3ce123))
* remove model description placeholder ([1f3bd1b](https://github.com/inooLabs/intric-frontend/commit/1f3bd1b72dd34352bac6d611c31e536da37c3e31))
* unhide model cards ([a74f5c4](https://github.com/inooLabs/intric-frontend/commit/a74f5c44885d51131be08d12fef88a10659ca0ee))

## [0.26.1](https://github.com/inooLabs/intric-frontend/compare/intric/web@v0.26.0...intric/web@v0.26.1) (2024-07-04)


### Bug Fixes

* hide model cards ([f72d26e](https://github.com/inooLabs/intric-frontend/commit/f72d26ea12a9a58e65d889aba96ea78482d1c5b4))

## [0.26.0](https://github.com/inooLabs/intric-frontend/compare/intric/web@v0.25.0...intric/web@v0.26.0) (2024-07-04)


### Features

* add grid view/cards for models ([#32](https://github.com/inooLabs/intric-frontend/issues/32)) ([f39e927](https://github.com/inooLabs/intric-frontend/commit/f39e92756ee1267f025a784b611596b5c9781eef))
* add references component for links([#30](https://github.com/inooLabs/intric-frontend/issues/30)) ([c53e8e5](https://github.com/inooLabs/intric-frontend/commit/c53e8e599f3bac7d6708ca20b5c98c13d38d05d9))
* **intric/ui:** add labels component ([f39e927](https://github.com/inooLabs/intric-frontend/commit/f39e92756ee1267f025a784b611596b5c9781eef))

## [0.25.0](https://github.com/inooLabs/intric-frontend/compare/intric/web@v0.24.0...intric/web@v0.25.0) (2024-07-01)


### Features

* combine websites and collections into knowledge base INTRC-160 INTRC-165 ([#29](https://github.com/inooLabs/intric-frontend/issues/29)) ([a058415](https://github.com/inooLabs/intric-frontend/commit/a058415785d02f408e7ad1012b600c39980a3024))


### Bug Fixes

* Hide top_p from custom model config INTRC-207 ([34c5c9e](https://github.com/inooLabs/intric-frontend/commit/34c5c9ef70907aa9696fcc2774e696db11781b1a))

## [0.24.0](https://github.com/inooLabs/intric-frontend/compare/intric/web@v0.23.2...intric/web@v0.24.0) (2024-06-27)


### Features

* added model temperature and top P config (INTRC-155) ([#20](https://github.com/inooLabs/intric-frontend/issues/20)) ([6df1a5f](https://github.com/inooLabs/intric-frontend/commit/6df1a5fd8067e925c696d1587a44832db743e088))
* allow uploading of files via drag and drop in chats (INTRC-187) ([#24](https://github.com/inooLabs/intric-frontend/issues/24)) ([51620c9](https://github.com/inooLabs/intric-frontend/commit/51620c9be71e6eb53603d53ef8e8b6c92ff1a175))


### Bug Fixes

* fixed overflow-x on chats and other small bugs ([04ea84d](https://github.com/inooLabs/intric-frontend/commit/04ea84de66d10319d39e59854ed813140a3fbf0f))

## [0.23.2](https://github.com/inooLabs/intric-frontend/compare/intric/web@v0.23.1...intric/web@v0.23.2) (2024-06-25)


### Bug Fixes

* fixed a bug where a normal user could not create a collection ([c3284bf](https://github.com/inooLabs/intric-frontend/commit/c3284bffd63806dfe6ee51e921187b4baffb0bf8))

## [0.23.1](https://github.com/inooLabs/intric-frontend/compare/intric/web@v0.23.0...intric/web@v0.23.1) (2024-06-20)


### Bug Fixes

* don't show unneeded scrollbars in ChatView ([7d5f7e1](https://github.com/inooLabs/intric-frontend/commit/7d5f7e1ed29fb97a9ab470aee2b1915cd2a32bde))

## [0.23.0](https://github.com/inooLabs/intric-frontend/compare/intric/web@v0.22.1...intric/web@v0.23.0) (2024-06-20)


### Features

* add model admin page ([#18](https://github.com/inooLabs/intric-frontend/issues/18)) ([659be17](https://github.com/inooLabs/intric-frontend/commit/659be172f7f8e71b38910a0cd2222ae3116dcaf0))
* file uploads in sessions ([#16](https://github.com/inooLabs/intric-frontend/issues/16)) ([8bf04fa](https://github.com/inooLabs/intric-frontend/commit/8bf04fa236257117ecd2771b04a4be5c62875cd5))
* new and simplified collections selector ([#14](https://github.com/inooLabs/intric-frontend/issues/14)) ([3d37514](https://github.com/inooLabs/intric-frontend/commit/3d37514da27354a2481eb7859cc6d7cd7e5c6861))


### Bug Fixes

* prevent chat autoscroll when user scrolled up ([#21](https://github.com/inooLabs/intric-frontend/issues/21)) ([e06b302](https://github.com/inooLabs/intric-frontend/commit/e06b3020b4dc45597d555aaec27c8073447ba4e4))
* remove uploads form queue when they fail ([bab3bd5](https://github.com/inooLabs/intric-frontend/commit/bab3bd52a6efa944c0b3d4c3a1964cc66bb61078))
* update SelectCompletionModel to new models API (INTRC-134) ([93c13ec](https://github.com/inooLabs/intric-frontend/commit/93c13ecac5e5d63c0fc0d45e1805e8c565dabe1b))

## [0.22.1](https://github.com/inooLabs/intric-frontend/compare/intric/web@v0.22.0...intric/web@v0.22.1) (2024-06-07)


### Bug Fixes

* embedding model name in collection now visible ([#12](https://github.com/inooLabs/intric-frontend/issues/12)) ([dfd17ee](https://github.com/inooLabs/intric-frontend/commit/dfd17eebca95f77e33d94d94a7ecf9382d2ce41a))

## [0.22.0](https://github.com/inooLabs/intric-frontend/compare/intric/web-v0.21.1...intric/web@v0.22.0) (2024-06-04)


### Features

* add git info to vercel previews ([24d93d7](https://github.com/inooLabs/intric-frontend/commit/24d93d7b2875d8525a4394b69d50aa6439c6381c))
