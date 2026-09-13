---
name: tech-daily-portal
description: >-
  Build or update a self-contained HTML portal page that aggregates the latest
  news from Hacker News, Medium, and arXiv into a single styled page. Use when
  the user asks to "create a tech portal", "build a news dashboard", "fetch the
  latest HN/Medium/arXiv articles and make a page", or "update the portal".
---

# Tech.Daily Portal Builder

## Goal

Produce a single, self-contained `portal.html` file that displays the latest
items from three sources — **Hacker News**, **Medium**, and **arXiv** — each in
its own color-coded section, with clickable links and a clean responsive design.

The file must be **fully autonomous**: HTML + CSS + JavaScript embedded in one
file, no external dependencies, no build step, no server.

## When to use

- "create a portal page with all we have requested"
- "fetch the latest HN / Medium / arXiv articles and make a page"
- "build a news dashboard"
- "update the portal with fresh data"

## Workflow

### 1. Fetch the data (3 API calls)

**Hacker News** (Firebase API):
```
GET https://hacker-news.firebaseio.com/v0/newstories.json?print=pretty
GET https://hacker-news.firebaseio.com/v0/item/<ID>.json?print=pretty
```
Take the first N IDs (default 20), fetch each item, keep `title`, `by`, `score`, `url`.
Mark `show: true` when the title starts with "Show HN".

**Medium** (RSS feed by tag):
```
GET https://medium.com/feed/tag/<tag>
```
Default tag: `technology`. Parse `<item>` entries, keep `title`, `<dc:creator>`,
`<link>`. **Filter out spam** (e.g. phone-number posts in foreign scripts).

**arXiv** (Atom API):
```
GET https://export.arxiv.org/api/query?search_query=cat:<cat>&sortBy=submittedDate&sortOrder=descending&max_results=<N>
```
Default category: `cs.AI`, default count: 10. Parse `<entry>`, keep `title`,
`<author><name>` (join with ", "), `<summary>`, `<id>`. PDF link = replace `abs` with `pdf`.

### 2. Build the HTML

Create `portal.html` with this structure:

```
portal.html
├── <head>  → <meta>, <title>, <style> (all CSS)
├── <body>
│   ├── <header>            → title + date badge
│   ├── <nav class="section-nav">  → anchor buttons to each section
│   ├── <section id="hn">          → Hacker News cards
│   ├── <section id="medium">      → Medium cards
│   ├── <section id="arxiv">       → arXiv cards
│   ├── <footer>            → source links
│   └── <script>            → data arrays + render
```

### 3. Data format (JavaScript arrays)

**Hacker News:**
```js
const hnStories = [
  { rank: 1, title: "...", score: 5, by: "author", url: "https://...", show: false },
];
```

**Medium:**
```js
const mediumArticles = [
  { rank: 1, title: "...", author: "Aya", pub: "MeetCyber", url: "https://..." },
];
```

**arXiv:**
```js
const arxivArticles = [
  { rank: 1, title: "...", authors: "A, B, et al.", url: "https://arxiv.org/abs/...", abstract: "..." },
];
```

### 4. Render

Inject cards via `innerHTML` into `#hn-list`, `#medium-list`, `#arxiv-list`.
Always use `target="_blank" rel="noopener"` on external links.
Use a `hostname(url)` helper to display the domain for HN items.
Truncate arXiv abstracts to ~2 lines with CSS `-webkit-line-clamp`.

### 5. Color scheme (CSS variables in `:root`)

```css
:root {
  --hn-orange: #ff6600;
  --medium-green: #1a8917;
  --arxiv-red: #b31b1b;
}
```

### 6. Verify

- Open the file in a browser (`start msedge portal.html` on Windows).
- Confirm all three sections render.
- Click a few links to confirm they open.
- Check responsive layout at narrow width.

## Output

Write `portal.html` to the working directory. Optionally open it in Edge.
Report the counts per section and the date of the data.

## Notes / pitfalls

- Medium RSS often contains spam — always filter before including.
- HN `newstories` returns newest-first; take the first N.
- arXiv `max_results` controls count; update the section counter to match.
- Keep the file self-contained — never reference external CSS/JS.
