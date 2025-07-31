<script lang="ts">
  import LayoutContainer from '$lib/components/LayoutContainer.svelte';
  import BackLink from '$lib/components/BackLink.svelte';
  export let data;
</script>

<LayoutContainer>
  <BackLink href="/guides" />
  <article class="prose dark:prose-invert" bind:this>
    {@html data.post.content}
  </article>
</LayoutContainer>
