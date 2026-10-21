# PixelForge

Learning Rust by building a reusable 2D game engine, one milestone at a time.

## Windows x64 quick start

Install these once per machine:

- [Rust via rustup](https://rustup.rs/) using the default MSVC toolchain.
- Visual Studio 2022 or Build Tools 2022 with **Desktop development with C++**, including the Windows SDK.

Then, from a clone of this repository:

```powershell
.\setup.ps1
cargo build --locked
cargo run --locked
```

If PowerShell blocks the script, run it with a process-only policy override:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\setup.ps1
```

Setup downloads CMake 3.31.6 and libclang 18.1.1 Windows x64 wheels from PyPI,
verifies pinned SHA-256 checksums, and extracts their native tools without needing
Python. Their bundled license files stay in `.tools`. It also installs the pinned
Rust toolchain through rustup as needed and fetches the locked Cargo dependencies.
Internet access is required on the first setup.

Tools are local to `.tools`; no administrator access or permanent PATH change is
needed by the script itself. The prerequisite installers may require elevation.
The generated `.cargo/config.toml` points Cargo at those tools in every new terminal.
Both generated locations are ignored by Git; run setup again on each new clone.
Setup refuses to overwrite a Cargo config it did not generate.

For Windows x64 MSVC, the generated config selects `rust-lld.exe`, the LLVM
linker bundled with the pinned Rust toolchain. No separate LLD installation is
needed. Visual Studio C++ tools and the Windows SDK are still required for the
native raylib build and system libraries. This setting changes Rust linking;
it does not change the CMake/MSBuild toolchain used to compile raylib's C code.

Setup can be rerun: downloaded archives are checksum-verified and reused.
If an archive fails verification, remove the named archive and rerun setup.
An interrupted download is retried automatically. If an extracted tool is damaged,
remove that tool's subfolder in `.tools` and rerun setup.

The generated config uses one build job because the initial parallel MSBuild
invocation failed on the development machine; its underlying cause is unresolved.
This script only supports Windows x64. Linux and macOS setup is not automated.
See the [raylib-rs platform guides](https://raylib-rs.github.io/raylib-rs/book/getting-started/install-windows.html)
for the upstream setup approach, including installing LLVM through Visual Studio.

## M1.2: Dependencies

- Rust is pinned to `1.95.0` in `rust-toolchain.toml`.
- `raylib = "=6.0.0"` pins the direct dependency to exactly that version.
- `Cargo.lock` records the resolved versions of transitive dependencies.

The current program still prints `Hello, world!`. Window creation is M1.3.
