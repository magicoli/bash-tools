# Development rules

## Bash Tools

- `bin/`: commands, plus the `bash-helpers` and `ini_parser` loaders
- `src/lib/`: sourced libraries (`bash-helpers`, `ini_parser`, `path-helpers`), not executable
- `etc/`: optional profile, prompt and completion extras, never activated by the package
- `packaging/nfpm.yaml`: Debian package definition, built and published with `apt-package` from the apt-repo repository

The loaders in `bin/` only source their library from `src/lib/`: they keep `source bash-helpers` working from the PATH and from composer `vendor/bin`. Commands and loaders are often reached through a link (package, composer `vendor/bin`): always locate the repository files from the real path (`realpath "$0"`, `realpath "${BASH_SOURCE[0]}"`), never from the link.

The commands linked in `/usr/bin` by the package are the `bin` list of `composer.json`: keep both in sync.

To build the package into `dist/` (requires [nfpm](https://nfpm.goreleaser.com) and a clone of apt-repo, e.g. in `/opt/apt-repo`):

```bash
/opt/apt-repo/bin/apt-package
```

To release, tag the version (bare semver, e.g. `1.0.0` or `1.0.0-beta.2`: pre-releases then sort before the release), then:

```bash
/opt/apt-repo/bin/apt-package --publish
```

---

## General rules

- **Avoid writing custom code for common needs**: always look for available solutions (current framework, extensions, modules, libraries...)
- Smart use of composer and npm packages, only code parts that are specific to this project, use well-known libraries when available.
- Smart use of classes and autoload

## Coding rules

- Make it short, clear and concise
- Always favor classes, methods and functions provided by the framework
- Avoid creating complex routines if a library is available to get a similare result
- If a variable, constant or function is only used once, it is probably not necessary
- If the same routine is used twice or more, it probably requires a function or method
- If the same value is used twice or more, it probably requires a variable or property
- Never include inline scripts or css in html. Scripts and styles are saved in separated files, main files for general use, or specific files for parts needed only in specific situations
- Never include direct styling classes in html and templates, use business classes, favor standard business classes provided by the framework
- Never include direct links to css and js in generated code, use standard framework methods or the bundler (e.g. Vite)

## Code style

- English for all code, comments, and documentation
- Prefer simple, well-tested constructs. Avoid global mutable state.
- Reuse existing libraries and patterns already in the project.
- Small, focused unit tests for new logic.
- Do not hard-wrap prose (Markdown files, comments, git messages...): write each paragraph as a single line and let the editor and terminal soft-wrap it. Hard wrap only makes diffs noisier and paragraphs harder to reflow when edited.

### Testing

Use the testing track appropriate for the project type. All tests belong to `tests/` folder. Prefer pest for PHP, vitest for JavaScript/TypeScript, and bashunit for shell scripts.

If a change is committed before testing, mark it `(untested)` so it's easy to find in the log.

## Commit message format

```
type (scope): short subject

- detail
- detail

Optional additional context.
```

- **type**: lowercase, no trailing period, type of change (e.g. `feature`, `fix`, `update`, `refactor`, `test`, `doc`)
- **scope**: area of the change — e.g. `api`, `lsl`, `build`, `tests`, `config`
- **subject**: imperative, lowercase, no trailing period
- **details**: bullet list with `-`, one item per logical change
- Omit details for trivial single-change commits
- Prefix with `(untested)` when the change has not been verified yet; reword after a successful test

## Local development of dependencies

Packages developed alongside this one (e.g. `magicoli/bash-tools`) are declared as path repositories in `composer.json`:

```json
{
    "type": "path",
    "url": "../{bash-tools}",
    "canonical": false,
    "options": {
        "symlink": true,
        "versions": { "magicoli/bash-tools": "dev-dev" }
    }
}
```

- Keep these definitions permanently, they don't prevent installation on other machines: the braces make Composer ignore the path when the folder does not exist, and `canonical: false` falls back to Packagist or VCS
- During development, require `dev-dev`: Composer symlinks the local copy
- `@dev` does not select the local copy, always use the exact `dev-dev` constraint
- The switch only depends on the require constraint: any other constraint (`dev-master`, `^1.0`...) is installed from Packagist or VCS
- npm has no such fallback, so never declare `file:` dependencies in `package.json`: `npm link ../package` symlinks the local copy into `node_modules/` without touching `package.json`, and the next `npm install` restores the registry version

## Version releases

```
v1.2.3 Main change if applicable
- new ...
- new ...
- fix ...
- update ...
```

- **subject** first line begins exactly with "v" + the version number to allow automated workflows and maintenance scripts. An option description of the main change might be added if relevant
- **details** a list of the main changes since the previous version release commit
- create a version release only when the version is fully tested and approved: bumping the version number in files does not mean the version must be released yet
- Be concise, full explanation can be found in git history
- Omit small patches and fixes, focus on essential features
- Make sure to update all relevant files (.version, README.md, composer.json, package.json... ) and update CHANGELOG.md with the exact same description
- For npm packages, `npm version 1.2.3 --no-git-tag-version` updates `package.json` and `package-lock.json` without committing or tagging
- Replace `dev-dev` requires with released constraints (e.g. `^1.0`) and run `composer update` so that `composer.lock` no longer points to local paths, otherwise the release cannot be installed on another machine. Switch back to `dev-dev` after the release
- after commit, add a tag named with the bare version number ("1.2.3"), with the exact same message as the commit (starting with "v1.2.3")
