.PHONY: help setup build run check test fmt lint clean

help:
	@echo setup - Prepare Windows build tools and dependencies
	@echo build - Compile the project
	@echo run   - Compile and run the project
	@echo check - Check Rust code without producing an executable
	@echo test  - Run tests
	@echo fmt   - Format Rust code
	@echo lint  - Run Clippy with warnings treated as errors
	@echo clean - Remove Cargo build output

setup:
	powershell -NoProfile -ExecutionPolicy Bypass -File ./setup.ps1

build:
	cargo build --locked

run:
	cargo run --locked

check:
	cargo check --locked

test:
	cargo test --locked

fmt:
	cargo fmt --all

lint:
	cargo clippy --locked --all-targets -- -D warnings

clean:
	cargo clean
