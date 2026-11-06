# Contributing to Texign

Texign is one person's LaTeX ecosystem with a deliberately small author
interface and one visual identity. Suggestions and fixes are welcome, but
read this first: a change that adds options or alters the look needs a
reason, and the reason is recorded.

## Before you start

- **Read [`DECISIONS.md`](DECISIONS.md).** Every agreed value (fonts,
  colours, layout, components, citation rules) is there, with the date and
  the reason. A visual change that contradicts it needs the decision changed
  first.
- **Read the [Architecture](../../wiki/Architecture) page** for how the
  packages fit together.
- **For anything nontrivial, open an issue first**, describing what you want
  to change and why.

## Development setup

```bash
git clone https://github.com/istorie-petru/texign.git
cd texign
scripts/texign-ctl install --dev   # TeX and `texign` now use this clone
scripts/texign-ctl status          # fonts and tools
```

## Running the tests

```bash
tests/smoke.sh     # every example in every note mode and citation convention,
                   # the Romanian Academy norms, the Romanian glossary order
tests/install.sh   # install, update, revert and remove in a throwaway home
tools/release-check
```

Each prints only `ok` lines when everything passes. CI runs all three on
every push and pull request, in the `texlive/texlive` image.

## Making a change

1. Fork the repository and create a branch.
2. Keep the author interface small. New user-visible strings go into both
   string tables (Romanian and English) in `texign-core.sty`. Internal code
   is expl3 with the `texign` prefix.
3. Add an example or a test for what you change; a visual change shows up
   in `examples/showcase`.
4. Run the tests. A change that breaks a test updates the test in the same
   change, with the reason.
5. Write commit messages that say what changed and why, not "wip" or "fix".
6. Open a pull request describing the change and linking any issue.

## Release process

Every release is one commit titled `Release vX.Y.Z: <short title>` that
updates, together:

- [`VERSION`](VERSION), the source of truth;
- the version in `\ProvidesExplClass` of `texign-article.cls` and
  `texign-book.cls` (with today's date);
- [`CHANGELOG.md`](CHANGELOG.md): the `[Unreleased]` items move under a new
  `## [X.Y.Z]` heading, in the same terse bullet style.

`tools/release-check` confirms the three agree. Then tag the commit
`vX.Y.Z` and push the tag: the Release workflow runs the tests again and
publishes the GitHub release with the CHANGELOG entry as notes, the source
archives and the example PDFs. Installed copies pick it up with
`texign-update`.

Versions follow SemVer: bump the minor version (`0.X.0`) for a batch of
features, the patch version for fixes only, and the major version for a
change that breaks existing documents.

`main` is never force-pushed, and pushed commits are never rewritten: fix
forward with a new commit. Commits that land on `main` don't carry AI
co-authorship trailers (`Co-Authored-By: Claude …` or similar).

## Reporting bugs

Open an issue with a minimal `.tex` file, the output of `texign-ctl status`,
what you expected and what happened. The full log is in
`.texign/<name>.log` next to your document.

## Licence

By contributing, you agree that your contributions are distributed under the
project's [AGPL-3.0](LICENSE).
