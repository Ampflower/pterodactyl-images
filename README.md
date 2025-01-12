#  Ampflower's Pterodactyl Docker Images

General purpose Pterodactyl docker images, with the intent of reducing page leaks.

> [!NOTE]
> These containers are made assumed that there's no manual access being made.
> As such, the documentation has been stripped, and the JREs are running headless.

### Java with Jemalloc

Observed to have reduced RSS memory usage,
these may be useful if you have a JVM that keeps using over a gigabyte of native memory.

> [!TIP]
> If you're experiencing out of memory conditions that cause Java to be killed without warning,
> first try giving the JVM *less* heap.
> Up to 2 gigabytes of headroom relative to the amount Pterodactyl is allocating to Java is generally considered normal,
> particularly if you're using a high render distance, or have a lot of concurrent players.

> [!NOTE]
> This will not fix any real memory leaks caused by bad memory manage, either through Unsafe, Panama or JNI.
> This will only fix page leaks caused by excessive sparse page allocation
> by attempting to reuse sparse pages first before allocating new pages from the kernel.

<details><summary>Random technical nitpicks:</summary>

You may see the jemalloc allocator as an odd choice for the JVM if you know that it manages its own heap,
and in many cases, it often is not needed.
This is for the few cases where it is needed, 
largely for applications that churn through enough memory that the garbage collector, or any of its native libraries,
end up allocating memory to deal with the load, pushing the allocator to its limits in some cases.
In simpler allocators, it ends up causing it to allocate more pages or arenas than they actually need,
and due to the usually non-linear nature of allocating and freeing memory,
end up with a bunch of sparse pages that can't be handed back to the kernel,
inflating the RSS of the JVM well beyond what it is actually using. 

Root causes as to why the allocator ends up leaking pages haven't been well studied,
but it's theorized that it is caused by excessive garbage collection and thread churn in pure Java contexts,
and that the new allocations by garbage collectors or threads won't necessarily free what it allocates immediately.

This can be easily caused in Minecraft's context by using mods like C2ME,
which can push I/O and threading to its limit for generating, writing and reading chunks to and from disk.

If you wonder why not tcmalloc, mimalloc, or another allocator, it's simple.
In testing on a dual-socket Intel E5-2670 system, totalling 16 cores, 32 threads,
using C2ME and Sodium on a Minecraft client,
tcmalloc and mimalloc, in raw RSS, performed as well as glibc's allocator,
meaning there was no improvement in sparse page allocation.

I don't have raw numbers to give, as this was done 3-4 years ago as of January 2025,
although if interest shows through, I can do my own testing.
Tho if you'd like further reading regardless, check out:

- <https://medium.com/@sohelcts/solving-unbounded-java-process-memory-growth-using-jemalloc-a43de47e5d0b>
- <https://blog.malt.engineering/java-in-k8s-how-weve-reduced-memory-usage-without-changing-any-code-cbef5d740ad?gi=82998d28af49>
- *not Java related, but*: <https://blog.cloudflare.com/the-effect-of-switching-to-tcmalloc-on-rocksdb-memory-use/>

If you're curious if any of the native allocators would have any effect on Java's heap, generally, no.
Java bypasses the allocator to directly memory map from the kernel,
and manages its own memory via its own garbage collectors.
The most you'll ever see on Java's side is an impact on garbage collection time,
which is generally negligible on concurrent collectors that don't stop the world.

</details>

- `ghcr.io/ampflower/pterodactyl-java:bookworm-jemalloc-17-jre`
- `ghcr.io/ampflower/pterodactyl-java:bookworm-jemalloc-17-jdk`