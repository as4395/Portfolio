<script lang="ts">
  const schemes = ['light', 'dark', 'light dark'];
  let current = localStorage.getItem('color-scheme') ?? 'light dark';

  function setScheme(scheme: string) {
    current = scheme;
    localStorage.setItem('color-scheme', scheme);
    document.documentElement.classList.remove('light', 'dark');
    if (scheme === 'light' || scheme === 'dark') {
      document.documentElement.classList.add(scheme);
    } else {
      document.documentElement.classList.add(
        window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light'
      );
    }
  }
</script>

<div class="flex gap-2">
  {#each schemes as scheme}
    <button
      class="px-3 py-1 text-sm rounded-full border border-neutral-300 dark:border-neutral-700 transition hover:bg-neutral-200 dark:hover:bg-neutral-800"
      on:click={() => setScheme(scheme)}
      class:selected={current === scheme}
    >
      {scheme}
    </button>
  {/each}
</div>
