# MySH

`MySH` is a small Unix-like shell written in C. It provides an interactive prompt, builtin commands, external command execution, pipelines, background jobs, shell variables, and a simple TCP client/server messaging flow.

The codebase is organized around a few focused modules:

- `mysh.c`: main REPL loop, background process handling, and pipeline orchestration
- `builtins.c`: builtin shell commands such as `echo`, `cat`, `wc`, `cd`, `ls`, `ps`, and `kill`
- `io_helpers.c`: terminal I/O, tokenization, command dispatch, and SIGINT handling
- `variables.c`: shell variable storage plus background job tracking
- `commands.c`: TCP server/client helpers and shell networking commands

## Features

- Interactive shell prompt with line length validation
- Builtins for text output, file reading, word counting, directory changes, process management, and directory listing
- External command execution through `fork` and `execvp`
- Pipelines using `pipe` and `dup2`
- Background jobs with job IDs, `ps` listing, and completion notifications
- Shell variables via `name=value` assignment and `$name` expansion
- TCP-based `start-server`, `start-client`, `send`, and `close-server` commands

## Build

```sh
make
```

The build uses:

- `-Wall`
- `-Werror`
- `-fsanitize=address`

Clean artifacts with:

```sh
make clean
```

## Run

```sh
./mysh
```

## Supported Commands

### Builtins

- `echo hello world`
- `cat file.txt`
- `wc file.txt`
- `cd src`
- `ls`
- `ls docs`
- `ls --f test`
- `ls --rec . --d 2`
- `ps`
- `kill 12345`
- `kill 12345 9`

### Variables

```sh
name=world
echo $name
```

### Pipelines

```sh
echo hello | wc
```

### Background jobs

```sh
sleep 5 &
ps
```

### Networking

Start a local server:

```sh
start-server 8080
```

Connect a client interactively:

```sh
start-client 8080 127.0.0.1
```

Send a one-shot message:

```sh
send 8080 127.0.0.1 hello from mysh
```

Stop the server started by the current shell session:

```sh
close-server
```

## Implementation Notes

- Builtins run inside the shell process.
- Non-builtin commands are delegated to the system through `execvp`.
- Pipelines fork one process per command segment and connect them with anonymous pipes.
- Background tasks are tracked in a linked list together with job indices and PIDs.
- Variable expansion is applied to builtin arguments that start with `$`.
- The current input parser is whitespace-based and does not implement quoting or redirection.

## Core System APIs

- Process control: `fork`, `wait`, `waitpid`, `kill`, `sigaction`
- Execution: `execvp`
- IPC: `pipe`, `dup2`
- File and terminal I/O: `read`, `write`, `fopen`, `fclose`, `poll`
- Networking: `socket`, `setsockopt`, `bind`, `listen`, `accept`, `connect`, `select`

## Quick Verification

The current tree was smoke-tested with:

- `echo`
- variable assignment and `$name` expansion
- pipelines with `wc`
- external command execution via `/bin/echo`
- background jobs plus `ps`
