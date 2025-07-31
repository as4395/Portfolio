<script>
  export let error;
  export let status;
</script>

<svelte:head>
  <title>{status} — Something went wrong</title>
</svelte:head>

<h1 class="text-4xl font-bold">{status}</h1>
<pre class="text-neutral-600 dark:text-neutral-400 mt-4">{error?.message}</pre>
<a href="/" class="text-blue-500 hover:underline mt-6 block">Return home</a>
