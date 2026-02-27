# Skill Independence Plan — March to September 2026

**Goal:** In 3 months, be able to sit in front of Sagonas or Zoe, open a blank editor, and solve a non-trivial problem from scratch with confidence. By September, be ready for an industry interview loop at the level described in the Anthropic post.

**Philosophy:** You are not starting from zero. You have PL theory, compiler courses, formal verification intuition, and a 37k LOC project you directed. What you're missing is *fluency under constraint* — the ability to produce clean, correct code from a blank file with no assistance, under time pressure. That's a trainable skill.

---

## Phase 1: Foundations (Weeks 1–4, March)

**Theme: Write code every day with nothing but a compiler, a terminal, and documentation.**

The goal here is to rebuild your confidence that you *can* code alone. Every exercise below should be done in a blank file. No Claude, no Copilot, no Stack Overflow copy-paste. Reference documentation is fine (cppreference, Python docs, OCaml manual). Getting stuck and thinking for 20 minutes is fine — that's where learning happens.

### Week 1–2: Core Data Structures from Scratch

Pick either C++ or Python (probably Python first since interviews use it, then repeat some in C++ for your dissertation context). Implement each of these:

1. **Doubly-linked list** — insert, delete, iterate, reverse. Get the pointer updates right.
2. **Hash map with chaining** — handle resizing, hash collisions, deletion.
3. **LRU Cache** — combine the above two. This is the Anthropic OA problem #1.
4. **Binary search tree** — insert, delete (with all 3 cases), in-order traversal.
5. **Min-heap / priority queue** — heapify, push, pop. Then use it for a priority task scheduler.
6. **Graph (adjacency list)** — BFS, DFS, topological sort, cycle detection. This covers OA problem #2.

**Daily routine:** ~90 minutes. Implement one structure or algorithm. After finishing, write a 3-line comment at the top: what the complexity is, what the tricky part was, what you'd do differently.

**Checkpoint:** By end of week 2, you should be able to implement an LRU cache from scratch in under 40 minutes. Time yourself.

### Week 3–4: Concurrency Fundamentals

This is the skill gap the Anthropic post highlights most. Do these exercises:

1. **Thread-safe queue** (Python `threading`): producer-consumer with a bounded buffer. Use `Lock`, `Condition`. Then redo it with `queue.Queue` and understand what it does for you.
2. **Async web fetcher** (Python `asyncio`): fetch 20 URLs concurrently with a semaphore limiting to 5 at a time. Handle timeouts, exceptions.
3. **Thread-safe LRU cache**: take your week 1 LRU cache and make it safe for concurrent access. Think about lock granularity — one big lock vs. striped locks.
4. **Simple thread pool**: implement a fixed-size worker pool that pulls tasks from a queue. Graceful shutdown matters.
5. **Dining philosophers**: classic exercise, but actually implement it and cause a deadlock, then fix it.

**Key concepts to internalize:** mutex vs. semaphore vs. condition variable, Python's GIL (what it does and doesn't protect), `asyncio` event loop (single-threaded concurrency vs. thread-based parallelism), when to use threads vs. async vs. multiprocessing in Python.

---

## Phase 2: Applied Building (Weeks 5–8, April)

**Theme: Build small but complete tools under time pressure, simulating interview conditions.**

Each project below is scoped to be completable in 2–4 hours. Do them in a single sitting. Set a timer. The point is not perfection — it's practicing decomposition, making tradeoffs, and shipping something that works.

### Project 1: Web Crawler (Anthropic Coding Round 1 analog)

Build a BFS web crawler in Python. Requirements:
- Start from a URL, crawl to depth N
- Extract and normalize links (handle relative URLs, fragments, query params)
- Concurrent fetching with `asyncio` + `aiohttp` + semaphore
- Respect rate limiting (delay between requests to same domain)
- Deduplication
- Output a site map (URL → list of outgoing links)

**Stretch:** Add robots.txt parsing, redirect loop detection, timeout handling.

**Time target:** Working basic version in 90 minutes. Full version with edge cases in 3 hours.

### Project 2: Log/Trace Analyzer (Anthropic Coding Round 2 analog)

Build a tool that takes stack sampling profiler output and reconstructs a trace. Input: periodic snapshots of the call stack (list of function names, bottom to top). Output: a list of (function, start_time, end_time) events.

The key insight to discover: you diff consecutive samples to detect function entry/exit. The hard case is recursive functions — same function name at multiple stack positions. You need to track by position, not name.

**Time target:** 90 minutes for the core algorithm, 2 hours with edge cases.

### Project 3: Rate Limiter

Implement a production-quality rate limiter supporting:
- Token bucket algorithm
- Sliding window counter
- Per-client tracking
- Thread-safe
- Configurable rates

This is a common system design building block and a great concurrency exercise.

**Time target:** 2 hours.

### Project 4: Task Scheduler with Dependencies

A mini version of `make` or a CI pipeline runner:
- Tasks have names, commands, and dependency lists
- Build a DAG, topological sort for execution order
- Detect circular dependencies
- Execute independent tasks concurrently (thread pool or asyncio)
- Handle task failure (cancel dependents)
- Status reporting

This combines graphs, concurrency, and error handling — the exact mix Anthropic tests.

**Time target:** 3 hours.

### Project 5: Simple Key-Value Store

An in-memory key-value store with:
- Get/Set/Delete operations
- TTL (time-to-live) expiration
- Snapshotting to disk (serialize/deserialize)
- Thread-safe concurrent access
- Simple TCP server accepting text commands

**Time target:** 3–4 hours.

---

## Phase 3: Depth and Interview Readiness (Weeks 9–16, May–June)

**Theme: System design knowledge, mock interview practice, and polishing.**

### System Design Study (ongoing, 2–3 hours/week)

Since you're working on compiler testing, you already understand some systems deeply. Build breadth in:

1. **Inference serving** (read the vLLM and Orca papers) — batching strategies, KV cache, GPU memory management, autoscaling. This is Anthropic's system design round.
2. **Distributed systems basics** — consistent hashing, replication, CAP theorem, consensus (Raft at a high level). Not for Anthropic specifically, but for any infra role.
3. **How a request flows** through a modern web service — load balancer → API server → queue → worker → database → cache → response. Be able to draw this and discuss tradeoffs at each layer.

For each topic: draw the architecture on paper, identify the 3 hardest problems, and think about what metrics you'd monitor.

### Mock Interview Practice (weekly)

Once Phase 2 is done, start doing timed mock sessions:

- Pick a problem from the Phase 2 list (or find new ones — Advent of Code, past interview questions)
- Set a 45-minute timer
- Code in a blank file with no assistance
- After finishing, review: what was slow, what was wrong, what did you forget

If you have friends in the program who are also preparing, trade mock interviews. Explaining your approach out loud while coding is a skill in itself.

### Rocq/Formal Verification (parallel track for Zoe)

Your work with Zoe on mechanizing Act's metatheory is actually the *perfect* environment for building genuine skill — Rocq proofs can't be faked or LLM'd effectively. The proof assistant tells you immediately if you're wrong. As you work through the pointer semantics formalization:

- Write each inductive definition yourself
- When a proof doesn't go through, resist the urge to ask Claude. Sit with `Admitted` for a day. Try different tactics. Read Rocq documentation.
- Keep a journal of proof techniques that work: what did `inversion` solve, when did you need `destruct` vs `induction`, how do you handle mutual recursion.

This will build exactly the kind of deep understanding that Sagonas and Zoe will recognize.

---

## Phase 4: Integration and Confidence (Weeks 17–24, July–August)

**Theme: Tie everything together. Bigger projects, faster execution.**

### Capstone Project: Build Something Real, Alone

Pick one substantial project and build it over 2–3 weeks without AI assistance. Ideas that align with your background:

- **A simple bytecode interpreter** for a toy language (you know compilers, this should be reachable). Lexer → parser → bytecode compiler → stack VM. Add a REPL.
- **A concurrent fuzzing harness** — you already built one with Claude Code, now see how far you can get alone. Even a simplified version will teach you what you actually understand vs. what Claude understood for you.
- **A simple proof checker** — parse a tiny proof language and verify proofs. Connects your PL theory knowledge with implementation.

The point is not to build something as large as clos. The point is to build something non-trivial where *every line is yours* and you can explain every design decision.

### Dissertation Preparation

By this point you should be able to:
- Present your clos tool and explain every architectural decision, even the ones Claude Code made, because you've internalized those patterns through independent practice
- Discuss tradeoffs in your design with Sagonas confidently
- Show your independent Rocq formalization work to Zoe
- Write code on a whiteboard if asked

---

## Weekly Schedule Template

| Day | Activity | Time |
|-----|----------|------|
| Mon | Data structure / algorithm (Phase 1) or Project work (Phase 2+) | 90 min |
| Tue | Rocq formalization work (Zoe's project) | 2 hrs |
| Wed | Concurrency exercise or system design study | 90 min |
| Thu | Rocq formalization or dissertation writing | 2 hrs |
| Fri | Timed mock problem (45 min) + review (30 min) | 75 min |
| Sat | Project work (Phase 2+) or capstone | 2–3 hrs |
| Sun | Rest or light reading (papers, blog posts) | optional |

**Total: roughly 10–12 hours/week** on top of your remaining coursework and research.

---

## Rules

1. **No AI assistance during study plan exercises.** Documentation, textbooks, and man pages are fine. The whole point is building the muscle you're worried you lack.
2. **Time yourself.** Write down how long each exercise takes. Track improvement.
3. **Keep a journal.** After each session, write 2–3 sentences: what was hard, what you learned, what to review. This is also useful for your dissertation defense prep.
4. **Don't skip the uncomfortable parts.** If pointer manipulation feels shaky, do more of it. If async confuses you, build three things with it.
5. **It's okay to be slow at first.** You'll be frustrated in week 1 when things take 3x longer without Claude. That's the point. By week 8 it'll feel different.
6. **Keep using Claude Code for clos.** This plan is *in addition to* your existing workflow, not a replacement. The goal is to build independent ability alongside tool-assisted productivity.

---

## Measuring Progress

By end of Phase 1 (week 4): You can implement an LRU cache and a concurrent producer-consumer from scratch in under 45 minutes each.

By end of Phase 2 (week 8): You can build a working web crawler with async concurrency in a single timed session. You feel comfortable decomposing a new problem into components.

By end of Phase 3 (week 16): You can draw an inference serving architecture on a whiteboard and discuss batching, caching, and autoscaling tradeoffs. You can do a 45-minute mock coding round and produce working code.

By end of Phase 4 (week 24): You have a capstone project that is entirely yours. You can sit in front of Sagonas or Zoe and write code live without anxiety. You're ready for an interview loop.
