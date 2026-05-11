# Forge 🔨

**Deterministic, Real-Time Safe Memory Allocators for Zig**

Forge is a pure-Zig memory allocation suite specifically designed for robotics, industrial automation, and hard real-time systems. 
It provides custom allocators that conform to Zig's `std.mem.Allocator` interface, 
completely eliminating unbounded latency (OS syscalls) and memory fragmentation.

When a 2-millisecond garbage collection or allocation pause means a robotic arm crashes or a telemetry frame is dropped, 
you need deterministic memory. 
Forge guarantees bounded $O(1)$ execution.

## Features (TBD)

Forge is currently in active development. The initial roadmap includes two primary allocators:

### 1. `SlabAllocator` (Work in Progress)
A deterministic pool allocator designed for high-frequency, fixed-size data streams.
* **$O(1)$ latency:** Allocation and deallocation are simple linked-list pop/push operations.
* **Zero Fragmentation:** Slices a pre-allocated fixed buffer into identical components.
* **Use Case:** ECS components, EtherCAT/CANOpen telemetry packets, hardware sensor state ingestion.

### 2. `TLSFAllocator` (Planned)
A Two-Level Segregated Fit (TLSF) allocator for general-purpose real-time heaps.
* **Bounded $O(1)$ latency:** Provides variable-sized memory allocations with strict real-time guarantees.
* **Minimal Fragmentation:** Uses segregated free lists and bitmap searching to find optimal memory blocks.
* **Use Case:** Software-defined PLCs, dynamic state machines, and real-time UI/HMI data generation.

## Integration

Because Forge implements the `std.mem.Allocator` vtable, it can back any standard library collection transparently.

```zig
const std = @import("std");
const forge = @import("forge");

pub fn main() !void {
 
}
```

## Runtime Safe: Designed to panic on double-frees or invalid alignments in Debug and ReleaseSafe modes.

Thread Safety: Currently, Forge allocators are not thread-safe by default to avoid mutex locking overhead. 
They are designed for thread-local arenas or lock-free single-threaded event loops.

No OS Dependencies: Built entirely with pure Zig pointer arithmetic. 
Runs perfectly on bare-metal embedded targets (freestanding), Linux, macOS, and Windows.

License MIT
