export function parseMetadata(content: string) {
  const title = content.match(/title:\s*"(.*?)"/)?.[1] ?? 'Untitled';
  const date = content.match(/date:\s*"(.*?)"/)?.[1] ?? '';
  const body = content.split('---').slice(2).join('---');
  return { title, date, body };
}
