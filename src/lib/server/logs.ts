import { parse } from 'marked';
import { readFileSync, readdirSync } from 'fs';
import path from 'path';

const logsDir = 'src/routes/2025';

export const logs = readdirSync(logsDir)
  .filter((file) => file.endsWith('.md'))
  .map((file) => {
    const slug = file.replace('.md', '');
    const content = readFileSync(path.join(logsDir, file), 'utf8');
    const title = content.match(/title:\s*"(.*?)"/)?.[1] ?? slug;
    const date = content.match(/date:\s*"(.*?)"/)?.[1] ?? '';
    return { slug, title, date };
  });

export function loadLog(slug: string) {
  const file = readFileSync(path.join(logsDir, `${slug}.md`), 'utf8');
  const content = parse(file.split('---').slice(2).join('---'));
  return { content };
}
