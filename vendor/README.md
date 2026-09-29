# Vendored packages

## sql-formatter-2.3.3-b61a6dce.tgz

The upstream Redash `package.json` installs `sql-formatter` from
`git+https://github.com/getredash/sql-formatter.git`, locked to commit
`b61a6dce3b451e38e87090b0675a43be1638e5b6`. Installing from git pulls from
GitHub on every build. This tarball holds that same commit, so installs
don't need to reach GitHub.

To rebuild it, check out that commit, run `npm ci` then `npm pack` with node 18.
`npm pack` runs the package's `prepare` build (babel `lib/`, webpack `dist/`),
the same step yarn runs for a git dependency.

sha256: `9bc2734313a0a3553745087f9ba6594b28730bd57d17dd06f1a7007b1758a189`
