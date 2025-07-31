<script lang="ts">
  export let href: string;
  export let label: string;
</script>

<a href={href} target="_blank" rel="noopener noreferrer" class="hover:underline text-sm text-neutral-700 dark:text-neutral-300">
  {label} ↗
</a>
