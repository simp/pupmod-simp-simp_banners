# AGENTS.md

This file provides guidance to AI agents when working with code in this repository.

## What this module does

`simp-simp_banners` is a small SIMP Puppet module that is **data plus a single
function** — it has **no manifests, no classes, and no defines**. It ships a
collection of static login-banner text files under `files/` and exposes one
Puppet 4.x function, `simp_banners::fetch`, that reads a named banner off disk
and returns its contents formatted according to a small set of options. Other
SIMP modules call `simp_banners::fetch(...)` to obtain banner text (e.g. for an
SSH login banner or an `/etc/issue` file) rather than embedding the text
themselves (`README.md` "Usage"; `lib/puppet/functions/simp_banners/fetch.rb`).

Because it declares no resources, applying this module does nothing on its own.
Its value is entirely in the function's return value and the banner content it
serves.

### Business logic

The module's only logic lives in the function.

- **`simp_banners::fetch` (`lib/puppet/functions/simp_banners/fetch.rb`)**
  — Puppet 4.x API function. Signature (`fetch.rb`):
  - `$name` (`String[1]`, **required**) — the banner to fetch. This is the
    **path of the file relative to `files/`**, so nested banners include their
    subdirectory, e.g. `'us/department_of_commerce'` (`fetch.rb`,
    `28`).
  - `$format` (`Optional[Struct[{ "cr_escape" => Optional[Boolean],
    "file_source" => Optional[Boolean] }]]`, defaults to `{}`) — formatting
    options (`fetch.rb`, `36`).

  Control flow (`fetch.rb`):
  - Option defaults are `{ 'cr_escape' => false, 'file_source' => false }`,
    merged under any caller-supplied values (`fetch.rb`).
  - It resolves the module's own `files/` directory via
    `call_function('get_module_path', 'simp_banners')` joined with `files`
    (`fetch.rb`) — so the banner set is discovered from **whatever copy of
    this module is on the modulepath**, not a hard-coded list.
  - It walks that directory with Ruby's `Find` and builds a
    `supported_banners` hash mapping **each entry's path relative to `files/`**
    to its absolute path (`fetch.rb`). The `Find.find` walk yields
    directories as well as files, and the map is keyed by `path.slice!(0..len)`.
  - **Errors** (both `Puppet::ParseError`):
    - If `files/` yields nothing, `"No banners found under '<path>'"`
      (`fetch.rb`).
    - If `$name` is not a key in `supported_banners`, it raises
      `"Banner '<name>' not found. Supported banners:\n  * ..."` listing every
      discovered key (`fetch.rb`). This dynamic list is the user-facing
      catalog of valid names.
  - **Return value**, in precedence order (`fetch.rb`):
    - `file_source: true` → returns the Puppet URI string
      `"puppet:///simp_banners/<name>"` and **does not read the file** — the
      value is meant for a `File` resource's `source =>` parameter so the
      agent fetches the content itself. This wins over `cr_escape`
      (`fetch.rb`).
    - else `cr_escape: true` → reads the file and replaces every CR/LF
      (`/[\r\n]/`) with a literal two-character `\n` sequence, yielding a
      single-line string suitable for embedding where real newlines are not
      allowed (`fetch.rb`).
    - else → returns the raw file contents via `File.read` (`fetch.rb`).

### Gotchas / non-obvious details

- **`$name` is a relative file path, not an identifier.** Nested banners must
  include their directory, e.g. `'us/department_of_commerce'` — passing
  `'department_of_commerce'` will not match (`fetch.rb`; the `us/` files
  live under `files/us/`).
- **The list of valid banners is computed from disk at call time,** not from a
  static allow-list. Adding a file under `files/` makes it immediately
  fetchable; the error message enumerates whatever is currently there
  (`fetch.rb`). Keep this in mind when reasoning about what names are
  valid — grep `files/`, don't grep the code.
- **`file_source` short-circuits and never touches the filesystem for content.**
  It returns a `puppet:///` URI regardless of `cr_escape`, and takes precedence
  over it (`fetch.rb`; unit test `spec/functions/simp_banners/fetch_spec.rb`).
  A malformed or unreadable file would still produce a URI here; the "not found"
  check only validates that `$name` is a known key, not that content is
  readable.
- **`Find.find` also records directories as keys** (e.g. `us`), because the walk
  is not filtered to files. Fetching a directory name would try to `File.read`
  a directory and error at read time, not at the "not found" check.
- **`cr_escape` produces a literal backslash-n, not a real newline** — it is for
  contexts that want the escape sequence as text (`fetch.rb`).
- There are **no `simp_options` lookups, no `assert_private`, and no
  `assert_optional_dependency`** in this module — those SIMP manifest idioms do
  not apply here because there is no manifest.

## The `simp_options` / `simplib::lookup` seam

**N/A.** This module has no manifests and performs no `simplib::lookup` /
`simp_options::*` calls. Its configuration surface is entirely the
`simp_banners::fetch` function's `$name` and `$format` arguments (see Business
logic above). There is no Hiera-driven feature-toggle seam to test.

## Class / defined-type API

**N/A.** This module declares no classes and no defined types. The only public
API is the function `simp_banners::fetch` (`lib/puppet/functions/simp_banners/fetch.rb`).

## Dependencies

Module dependencies (from `metadata.json`):

- `puppetlabs/stdlib` `>= 8.0.0 < 10.0.0` — the sole declared dependency.

Optional dependencies: **none** (`metadata.json` declares no
`simp.optional_dependencies`).

Fixture dependency (from `.fixtures.yml`): `stdlib` is checked out from
`https://github.com/simp/puppetlabs-stdlib.git`, and the module itself is
symlinked in as `simp_banners`. No other fixtures are used.

Runtime requirement (from `metadata.json` `requirements`): `openvox
>= 8.0.0 < 9.0.0`. Note this module names **`openvox`** (not `puppet`) as its
runtime — it is on the newer OpenVox baseline. The `Gemfile` still installs
**both** the `openvox` and `puppet` gems (see Common commands) during the
migration.

Supported OS matrix (from `metadata.json`): CentOS 9/10; RedHat 8/9/10;
OracleLinux 8/9/10; Rocky 8/9/10; AlmaLinux 8/9/10. (Because the module only
serves text files, the OS matrix mostly governs the acceptance/test tooling
rather than the function's behavior.)

## Repository layout

- `lib/puppet/functions/simp_banners/fetch.rb` — the sole source of logic; the
  `simp_banners::fetch` function.
- `files/` — the banner content served by the function. Names are relative to
  this directory:
  - `files/simp` — the full SIMP "RESTRICTED COMPUTER SYSTEM" banner.
  - `files/simp_lite` — a shorter SIMP variant.
  - `files/us/department_of_commerce`, `files/us/department_of_commerce_lite`,
    `files/us/department_of_defense`, `files/us/department_of_energy`,
    `files/us/national_oceanic_and_atmospheric_administration` — US government
    department banners, fetched with the `us/` prefix.
- `metadata.json` — dependency (`stdlib`), OS matrix, and the `openvox` runtime
  requirement.
- `spec/functions/simp_banners/fetch_spec.rb` — the rspec-puppet unit test for
  the function (known banner, unknown banner error, and each `$format` option
  including the `file_source`-over-`cr_escape` precedence).
- `spec/spec_helper.rb` — baseline spec bootstrap; requires
  `puppetlabs_spec_helper/module_spec_helper` (`spec/spec_helper.rb`).
- `REFERENCE.md` — generated Puppet Strings reference (function signature and
  option docs).
- `README.md`, `CHANGELOG` — descriptive docs.
- **No `manifests/`, `data/`, `hiera.yaml`, `types/`, `templates/`, or
  `spec/acceptance/`** — this module has none of these. It is data + one
  function, unit-tested only.
- **CI does NOT run acceptance.** `.github/workflows/pr_tests.yml` defines six
  jobs and no acceptance job: `puppet-syntax` (`rake syntax`), `puppet-style`
  (`rake lint` + `rake metadata_lint`), `ruby-style` (`rake rubocop`),
  `file-checks` (`rake check:dot_underscore` + `rake check:test_file`),
  `releng-checks`, and `spec-tests`. There are no beaker nodesets.

## Common commands

```sh
# Install dependencies
bundle install

# Run all unit tests
bundle exec rake spec

# Run the single function spec
bundle exec rspec spec/functions/simp_banners/fetch_spec.rb

# Puppet syntax + lint (as CI runs them)
bundle exec rake syntax
bundle exec rake lint
bundle exec rake metadata_lint

# Ruby lint
bundle exec rake rubocop

# File checks (as CI runs them)
bundle exec rake check:dot_underscore
bundle exec rake check:test_file

# Regenerate REFERENCE.md from puppet-strings docstrings
puppet strings generate --format markdown --out REFERENCE.md
```

Relevant gem pins (from `Gemfile`): `puppetlabs_spec_helper ~> 8.0.0`,
`simp-rake-helpers ~> 5.24.0`, `simp-rspec-puppet-facts ~> 4.0.0`,
`simp-beaker-helpers ~> 2.0.0`. Rubocop is pinned to `~> 1.88.0`. The `:test`
group defaults `puppet_version` to `['>= 8', '< 9']` (`Gemfile`) and
**installs both the `openvox` and `puppet` gems** by looping over
`['openvox', 'puppet']` (`Gemfile`) — the inline comment notes this is
"temporarily … until the puppet dependency is removed from other gems."

## Conventions

- **Add banners as files, not code.** New banners are new files under `files/`
  (in an appropriate subdirectory); the function discovers them automatically
  and callers fetch them by their `files/`-relative path. Do not add a static
  allow-list to the function.
- Preserve the `@param` / `@option` / `@raise` / `@return` puppet-strings
  docstrings on the function (`fetch.rb`) — they drive `REFERENCE.md`.
  Regenerate `REFERENCE.md` after changing the signature or docs.
- Keep the `$format` option precedence intact: `file_source` wins over
  `cr_escape`, which wins over raw content (`fetch.rb`), and cover any
  change with the corresponding case in
  `spec/functions/simp_banners/fetch_spec.rb`.
- `Gemfile` and `spec/spec_helper.rb` carry a **puppetsync** notice — they are
  baseline-managed and the next baseline sync overwrites local edits. Push
  changes to those files upstream to the baseline, not here. The same applies to
  `.github/workflows/pr_tests.yml`.
- This module targets the **OpenVox** runtime (`metadata.json` `requirements`
  names `openvox >= 8.0.0 < 9.0.0`); keep that baseline in mind rather than
  assuming a `puppet` requirement.
