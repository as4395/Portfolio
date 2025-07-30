import { parse } from 'marked';
import { readFileSync, readdirSync } from 'fs';
import path from 'path';

const guidesDir = 'src/routes/guides';

export const guides = readdirSync(guidesDir)
  .filter((file) => file.endsWith('.md'))
  .map((file) => {
    const slug = file.replace('.md', '');
    const content = readFileSync(path.join(guidesDir, file), 'utf8');
    const title = content.match(/title:\s*"(.*?)"/)?.[1] ?? slug;
    const date = content.match(/date:\s*"(.*?)"/)?.[1] ?? '';
    return { slug, title, date };
  });

export function loadGuide(slug: string) {
  const file = readFileSync(path.join(guidesDir, `${slug}.md`), 'utf8');
  const content = parse(file.split('---').slice(2).join('---'));
  return { content };
}
