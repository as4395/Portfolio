<script lang="ts">
  const email = "notifysec@proton.me";
</script>

<!-- Intro Header -->
<hgroup class="space-y-2 animate-fade-in-up">
  <h1 class="text-3xl font-medium">Abhiram Singireddy</h1>
  <p class="text-neutral-500 dark:text-neutral-400">Student</p>
</hgroup>

<main class="space-y-24">

  <!-- About / Bio -->
  <section class="space-y-5 animate-fade-in-up delay-100">
    <p class="text-neutral-700 dark:text-neutral-300 text-lg">
      Passionate about cybersecurity, AI, and building privacy-forward tools.
      Pursuing mastery and exploration through hands-on engineering.
    </p>
  </section>

  <!-- Projects -->
  <section class="space-y-6 animate-fade-in-up delay-200">
    <h2 class="text-xl font-medium">Selected Projects</h2>
    <div class="grid gap-8 md:grid-cols-2" id="projects">

      <!-- Project 1 -->
      <div>
        <a href="https://github.com/as4395/password-generator" target="_blank" class="space-y-2 block">
          <img src="/static/password-gen.png" alt="Password Generator" class="rounded-lg border border-neutral-300 dark:border-neutral-700 aspect-video" />
          <p class="font-medium">Password Generator</p>
        </a>
        <p class="text-neutral-500 dark:text-neutral-400">
          Entropy-based CLI password generator with crack-time feedback.
        </p>
      </div>

      <!-- Project 2 -->
      <div>
        <a href="https://github.com/as4395/port-scanner" target="_blank" class="space-y-2 block">
          <img src="/static/port-scanner.png" alt="Port Scanner" class="rounded-lg border border-neutral-300 dark:border-neutral-700 aspect-video" />
          <p class="font-medium">Port Scanner</p>
        </a>
        <p class="text-neutral-500 dark:text-neutral-400">
          TCP/UDP scanner with banner grabbing and JSON/CSV output.
        </p>
      </div>

    </div>
  </section>

  <!-- Work Experience -->
  <section class="space-y-6 animate-fade-in-up delay-300">
    <h2 class="text-xl font-medium">Work Experience</h2>
    <div class="flex flex-col gap-3" id="cards">
      <div class="border border-neutral-300 dark:border-neutral-700 rounded-xl p-4 flex justify-between">
        <div>
          <div class="font-medium">Cybersecurity Intern</div>
          <div class="text-neutral-500 dark:text-neutral-400">NeoTech Solutions</div>
        </div>
        <div class="text-neutral-500 dark:text-neutral-400">May 2025 – Present</div>
      </div>

      <div class="border border-neutral-300 dark:border-neutral-700 rounded-xl p-4 flex justify-between">
        <div>
          <div class="font-medium">Information Technology Intern</div>
          <div class="text-neutral-500 dark:text-neutral-400">NeoTech Solutions</div>
        </div>
        <div class="text-neutral-500 dark:text-neutral-400">Dec 2024 – Apr 2025</div>
      </div>

      <div class="border border-neutral-300 dark:border-neutral-700 rounded-xl p-4 flex justify-between">
        <div>
          <div class="font-medium">AI Developer</div>
          <div class="text-neutral-500 dark:text-neutral-400">Outlier</div>
        </div>
        <div class="text-neutral-500 dark:text-neutral-400">Jun 2024 – Sep 2024</div>
      </div>
    </div>
  </section>

  <!-- Connect -->
  <section class="space-y-6 animate-fade-in-up delay-400">
    <h2 class="text-xl font-medium">Connect</h2>
    <p class="text-neutral-500 dark:text-neutral-400">
      Feel free to contact me at
      <a href="mailto:{email}" class="underline">{email}</a>
    </p>
    <div class="flex gap-3 flex-wrap" id="pills">
      <a href="https://github.com/as4395" class="bg-neutral-100 dark:bg-neutral-800 px-3 py-1 rounded-full hover:scale-105 transition" target="_blank">GitHub ↗</a>
      <a href="https://linkedin.com/in/abhiram-singireddy" class="bg-neutral-100 dark:bg-neutral-800 px-3 py-1 rounded-full hover:scale-105 transition" target="_blank">LinkedIn ↗</a>
    </div>
  </section>

</main>
