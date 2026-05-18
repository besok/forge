# Forge 🔨

**Deterministic, Real-Time Safe Memory Allocators for Zig**

Forge is a pure-Zig memory allocation suite specifically designed for robotics, industrial automation, and hard real-time operating systems (RTOS). 
It provides custom allocators conforming to Zig's `std.mem.Allocator` interface, eliminating unbounded latency (OS syscalls) and non-deterministic memory fragmentation.
Forge guarantees bounded, predictable execution times ($O(1)$ worst-case execution time) for safety-critical control loops.

---

## Architecture Roadmap

### 1. `SlobAllocator` (Simple List Of Blocks)  
An ultra-compact memory manager using a first-fit linked list strategy over a pre-allocated memory block.
* **Objective:** Minimal overhead baseline for highly memory-constrained microcontrollers or isolated task nodes.
* **Industrial Use Case:** Low-frequency auxiliary logging, configuration parsing, or string formatting on isolated MCU nodes.

### 2. `SlabAllocator` (Fixed-Size Object Pools)  
A deterministic object-cache allocator that slices a backing buffer into an array of uniform, fixed-size slots using an embedded inline freelist.
* **Objective:** True $O(1)$ performance with zero fragmentation by recycling slots of the exact same size.
* **Industrial Use Case:** High-frequency CAN/EtherCAT telemetry frames, actuator state-space updates, and hardware sensor data ingestion.

### 3. `TLSFAllocator` (Two-Level Segregated Fit) 
A constant-time dynamic memory allocator designed for variable-sized requests under hard real-time constraints.
* **Objective:** Bounded $O(1)$ execution time for dynamic allocations without random latency spikes.
* **Industrial Use Case:** Software-defined PLCs, complex dynamic state machines, and real-time HMI data generation.

---

## Design Principles

* **Explicit Memory Bounds:** Allocators initialize using statically sized, pre-allocated buffers (stack array or dedicated DMA memory sections). No dynamic OS allocation occurs during real-time execution.
* **Runtime Defenses:** Panics on double-frees, memory leaks, or invalid alignments in `Debug` and `ReleaseSafe` modes before software is deployed to physical machinery.
* **Thread Locality:** Forge allocators are **not thread-safe by default** to completely avoid mutex overhead and priority inversion vulnerabilities. They are designed to back thread-local arenas or single-threaded execution loops.
* **Zero Dependencies:** Built using pure Zig pointer arithmetic. Runs perfectly on `freestanding` bare-metal embedded targets.

---

## Quick Integration Example
 
```zig
```

License
MIT License. Ready for commercial industrial systems and open-source robotics projects.