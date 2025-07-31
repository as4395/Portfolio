<script lang="ts">
  export let title = 'Abhiram S.';
  export let description = 'Portfolio and notes from Sokolov.';
  export let image = '/og.webp';
  export let url = 'https://example.org';
</script>

<svelte:head>
  <title>{title}</title>
  <meta name="description" content={description} />
  <meta property="og:title" content={title} />
  <meta property="og:description" content={description} />
  <meta property="og:image" content={image} />
  <meta property="og:url" content={url} />
  <meta property="og:type" content="website" />
  <meta name="twitter:card" content="summary_large_image" />
</svelte:head>
