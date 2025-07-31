import fs from 'fs';
import path from 'path';
import { marked } from 'marked';

export function loadMarkdown(dir: string) {
  const files = fs.readdirSync(dir);
  return files.map((file) => {
    const slug = file.replace('.md', '');
    const content = fs.readFileSync(path.join(dir, file), 'utf-8');
    const html = marked(content.split('---').slice(2).join('---'));
    const title = content.match(/title:\s*"(.*?)"/)?.[1] ?? 'Untitled';
    const date = content.match(/date:\s*"(.*?)"/)?.[1] ?? '';
    return { slug, title, date, content: html };
  });
}

