import { logs } from '$lib/server/logs';
import type { PageLoad } from './$types';

export const load: PageLoad = ({ params }) => {
  const post = logs.find((entry) => entry.slug === params.slug);
  if (!post) throw new Error('Not found');
  return { post };
};
