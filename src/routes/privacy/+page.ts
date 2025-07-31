import type { PageLoad } from './$types';

export const load: PageLoad = () => {
  return {
    title: 'Privacy',
    description: 'This site collects no analytics or personal data.'
  };
};
