<script lang="ts">
  import { pageTitle, pageDescription } from '$lib/stores/pageMeta';
  export let title = 'Sokolov';
  export let description = 'Portfolio + Personal Website.';
  $: pageTitle.set(title);
  $: pageDescription.set(description);
</script>

<svelte:head>
  <title>{title}</title>
  <meta name="description" content={description} />
</svelte:head>
