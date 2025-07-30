<main class="max-w-2xl mx-auto px-4 py-16">
  <slot />
</main>

<style>
  :global(body) {
    font-family: system-ui, sans-serif;
    font-size: 16px;
    background-color: light-dark(oklch(100% 0 0), oklch(14% 0 0));
    color: light-dark(oklch(0 0 0), oklch(100% 0 0));
    line-height: 1.6;
    -webkit-font-smoothing: antialiased;
  }

  :global(a) {
    color: inherit;
    text-decoration: none;
  }

  :global(img),
  :global(video) {
    max-width: 100%;
    border-radius: 0.75rem;
    display: block;
  }

  :global(h1),
  :global(h2) {
    font-weight: 500;
  }

  :global(.animate-fade-in-up) {
    animation: fadeIn 0.6s ease, enterUp 0.6s ease;
  }

  @keyframes fadeIn {
    from { opacity: 0 }
    to { opacity: 1 }
  }

  @keyframes enterUp {
    from { transform: translateY(24px) }
    to { transform: translateY(0) }
  }
</style>
