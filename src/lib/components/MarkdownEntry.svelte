<script lang="ts">
  export let title: string;
  export let date: string;
  export let href: string;
</script>

<a href={href} class="block group">
  <h2 class="text-lg font-medium group-hover:underline">{title}</h2>
  <p class="text-sm text-neutral-500 dark:text-neutral-400">{date}</p>
</a>

