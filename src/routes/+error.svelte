<script>
  export let error;
</script>

<section class="space-y-6 text-center py-24 animate-fade-in-up">
  <h1 class="text-3xl font-medium">Hmm.</h1>
  <p class="text-neutral-600 dark:text-neutral-400">
    Something went wrong. {error.message}
  </p>
</section>
