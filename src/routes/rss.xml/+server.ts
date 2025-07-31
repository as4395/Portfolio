import { logs } from '$lib/server/logs';

export const GET = async () => {
  const body = `<?xml version="1.0" encoding="UTF-8" ?>
<rss version="2.0">
<channel>
  <title>Sokolov — 2025</title>
  <link>https://example.org</link>
  <description>Experiments and logs from Sokolov</description>
  ${logs
    .map(
      (post) => `
  <item>
    <title>${post.title}</title>
    <link>https://example.org/2025/${post.slug}</link>
    <pubDate>${new Date(post.date).toUTCString()}</pubDate>
    <description>${post.title}</description>
  </item>`
    )
    .join('\n')}
</channel>
</rss>`;

  return new Response(body, {
    headers: {
      'Content-Type': 'application/rss+xml'
    }
  });
};
