<script lang="ts">
  let name = '';
  let email = '';
  let message = '';

  function handleSubmit() {
    // Placeholder for future form submission logic
    name = '';
    email = '';
    message = '';
  }
</script>

<section class="space-y-6 animate-fade-in-up">
  <h1 class="text-3xl font-medium">Contact</h1>
  <p class="text-neutral-700 dark:text-neutral-300 text-lg">
    Want to collaborate? Share something? Ask a question? Fill out the form below and I’ll be in touch.
  </p>

  <form class="space-y-4" on:submit|preventDefault={handleSubmit}>
    <div>
      <label for="name" class="block text-sm mb-1 text-neutral-600 dark:text-neutral-400">Name</label>
      <input
        id="name"
        bind:value={name}
        required
        class="w-full p-2 rounded border border-neutral-300 dark:border-neutral-700 bg-transparent"
      />
    </div>

    <div>
      <label for="email" class="block text-sm mb-1 text-neutral-600 dark:text-neutral-400">Email</label>
      <input
        id="email"
        type="email"
        bind:value={email}
        required
        class="w-full p-2 rounded border border-neutral-300 dark:border-neutral-700 bg-transparent"
      />
    </div>

    <div>
      <label for="message" class="block text-sm mb-1 text-neutral-600 dark:text-neutral-400">Message</label>
      <textarea
        id="message"
        rows="4"
        bind:value={message}
        required
        class="w-full p-2 rounded border border-neutral-300 dark:border-neutral-700 bg-transparent"
      ></textarea>
    </div>

    <button
      type="submit"
      class="px-4 py-2 text-sm rounded border border-neutral-300 dark:border-neutral-700 hover:bg-neutral-100 dark:hover:bg-neutral-800 transition"
    >
      Submit
    </button>
  </form>
</section>
