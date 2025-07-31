import { loadGuide } from '$lib/server/guides';

export const load = async ({ params }) => {
  return {
    content: loadGuide(params.slug).content
  };
};
