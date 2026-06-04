# Contributing to octo

Thanks for your interest! This project is built incrementally and values correctness and
security over speed (it handles crypto keys).

## Development setup

- **Rust 1.84.1** — pinned via `rust-toolchain.toml`; `rustup` will install it automatically.
- **Docker** — for the local Postgres (`docker compose up -d db`).
- **just** — task runner (`cargo install just`), optional but recommended.

```bash
cp .env.example .env
just build && just test
```

## Before opening a PR

Run the same checks CI runs:

```bash
just fmt        # cargo fmt
just lint       # cargo clippy -- -D warnings
just test       # cargo test
cargo deny check   # licenses + advisories (cargo install cargo-deny)
```

All of `fmt --check`, `clippy -D warnings`, and the test suite must pass.

> **Note on local clippy:** some Rust toolchains built from a source tarball ship a
> `clippy-driver` that rejects pre-compiled dependency metadata with `E0514` even though its
> version matches `rustc`. If `cargo clippy` fails locally with "compiled by an incompatible
> version of rustc" on third-party crates, that's the toolchain — not your code. Rely on CI's
> clippy gate (which uses an official toolchain), and keep code clippy-clean by review. `cargo
> build`/`test`/`fmt` are unaffected.

## Conventions

- **Commits:** [Conventional Commits](https://www.conventionalcommits.org/) (`feat:`, `fix:`,
  `docs:`, `refactor:`, `test:`, `chore:`).
- **Secrets:** never log seeds, private keys, or decrypted material. Secret-bearing types live in
  `wallet-core` and must `zeroize` on drop.
- **Tests:** crypto and derivation code must include test vectors (e.g. SEP-0005).

## Branching

Work on a feature branch; open a PR against `main`. CI must be green before merge.
