<script>
  const links = [
    { name: 'Sokolov', href: '/' },
    { name: '2025', href: '/2025' },
    { name: 'About', href: '/about' },
    { name: 'Guides', href: '/guides' },
    { name: 'Contact', href: '/contact' }
  ];
</script>

<nav class="flex gap-4 text-sm mb-12 justify-center text-neutral-600 dark:text-neutral-400">
  {#each links as link}
    <a href={link.href} class="hover:text-black dark:hover:text-white transition">
      {link.name}
    </a>
  {/each}
</nav>
