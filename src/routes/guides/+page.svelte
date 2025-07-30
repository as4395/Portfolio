<script lang="ts">
  import { guides } from '$lib/server/guides';
</script>

<section class="space-y-6 animate-fade-in-up">
  <h1 class="text-3xl font-medium">Guides</h1>

  <ul class="space-y-4">
    {#each guides as guide}
      <li>
        <a href={`/guides/${guide.slug}`} class="text-lg hover:underline">
          {guide.title}
        </a>
        <p class="text-neutral-500 text-sm">{guide.date}</p>
      </li>
    {/each}
  </ul>
</section>
