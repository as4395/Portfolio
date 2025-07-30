<script lang="ts">
  import { logs } from '$lib/server/logs';
</script>

<section class="space-y-6 animate-fade-in-up">
  <h1 class="text-3xl font-medium">2025</h1>

  <ul class="space-y-4">
    {#each logs as entry}
      <li>
        <a href={`/2025/${entry.slug}`} class="text-lg hover:underline">
          {entry.title}
        </a>
        <p class="text-neutral-500 text-sm">{entry.date}</p>
      </li>
    {/each}
  </ul>
</section>
