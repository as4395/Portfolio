<script lang="ts">
  import ThemeToggle from '$lib/components/ThemeToggle.svelte';
  import { onMount } from 'svelte';

  let colorScheme = 'light dark';

  onMount(() => {
    const stored = localStorage.getItem('color-scheme');
    colorScheme = stored ?? 'light dark';
    applyTheme(colorScheme);
  });

  function applyTheme(scheme: string) {
    const html = document.documentElement;
    html.classList.remove('light', 'dark');
    if (scheme === 'light' || scheme === 'dark') {
      html.classList.add(scheme);
    } else {
      html.classList.add(
        window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light'
      );
    }
    localStorage.setItem('color-scheme', scheme);
  }
</script>

<svelte:head>
  <title>Abhiram Singireddy</title>
  <meta name="description" content="Student. Exploring systems with curiosity and precision." />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
</svelte:head>

<div class="min-h-screen px-4 sm:px-6 md:px-8 max-w-3xl mx-auto py-20 space-y-24">
  <slot />

  <!-- Footer -->
  <footer class="pt-10 mt-20 border-t border-neutral-200 dark:border-neutral-700 text-sm flex justify-between items-center">
    <div class="italic text-neutral-500 dark:text-neutral-400">Never stop creating.</div>
    <ThemeToggle />
  </footer>
</div>
