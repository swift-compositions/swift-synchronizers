# swift-synchronizers

Use this package when threads share state behind one lock and need to block until another thread signals, on one or more separate conditions. Start from `Synchronizer.Blocking<N>`, which pairs a mutex with N condition variables. Write code against `Synchronizer.Protocol` when it should accept any synchronizer, wrap one in `Synchronize` to store it without its concrete type, and conform to `Synchronizable` to expose the synchronizer a type owns. If you want a barrier, gate or counting semaphore rather than raw waits and signals, use swift-threads, which builds them on `Synchronizer.Blocking<N>`.

## Laws

- All N conditions of a `Synchronizer.Blocking<N>` share its single mutex. `Synchronizer.Blocking.synchronize(_:)` holds that mutex for the body. A wait releases it while blocked and holds it again when it returns.
- A timed wait returns false when the timeout passed before a signal.
- Waiter counts only include threads in `Synchronizer.Blocking.waitTracked(condition:)`. A thread in a plain wait is not counted, so `Synchronizer.Blocking.signalIfWaiters(condition:)` and `Synchronizer.Blocking.broadcastIfWaiters(condition:)` do nothing and return false when only plain waiters are blocked. A tracked waiter leaves the count when it returns, also after a timeout.
- On `Synchronizer.Blocking<2>`, `worker` is condition 0 and `deadline` is condition 1. `Synchronizer.Blocking.Broadcast.all()` wakes every waiter on both.
- Copies of a `Synchronize` share the synchronizer they wrap, and a body run through them throws its own error unchanged.
