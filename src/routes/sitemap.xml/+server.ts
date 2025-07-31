import { logs } from '$lib/server/logs';
import { guides } from '$lib/server/guides';

export const GET = async () => {
  const urls = [
    '/',
    '/2025',
    ...logs.map((e) => `/2025/${e.slug}`),
    '/guides',
    ...guides.map((e) => `/guides/${e.slug}`),
    '/about',
    '/contact',
    '/sokolov',
    '/privacy'
  ];

  const body = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${urls
  .map(
    (url) => `<url><loc>https://example.org${url}</loc></url>`
  )
  .join('\n')}
</urlset>`;

  return new Response(body, {
    headers: {
      'Content-Type': 'application/xml'
    }
  });
};
