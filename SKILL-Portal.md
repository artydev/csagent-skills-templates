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

Create `portal.html` with this structure (dark theme, `.wrap` container):

```
portal.html
├── <head>  → <meta>, <title>, <style> (all CSS, see §5)
├── <body>
│   ├── <div class="wrap">
│   │   └── <header>            → h1 title + .tagline + .badge date pill
│   ├── <nav class="section-nav">  → .wrap.nav-inner anchor buttons
│   ├── <main class="wrap">
│   │   ├── <section id="hn">       → .section-head.hn + #hn-list
│   │   ├── <section id="medium">   → .section-head.medium + #medium-list
│   │   └── <section id="arxiv">    → .section-head.arxiv + #arxiv-list
│   ├── <footer>            → .wrap source links
│   └── <script>            → data arrays + render
```

Each section head uses a colored left border:
```html
<div class="section-head hn">
  <h2 class="section-title">Hacker News</h2>
  <span class="count" id="hn-count">0 items</span>
</div>
<div class="list" id="hn-list"></div>
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

Card markup follows the grid layout (`.rank` column + content + optional `.score`):

**Hacker News** (`.card` — 3 columns: rank / content / score):
```html
<div class="card">
  <span class="rank">1</span>
  <div>
    <div class="title"><a href="..." target="_blank" rel="noopener">Title</a></div>
    <div class="meta"><span class="pill">domain.com</span><span class="pill">Show HN</span><span>by author</span></div>
  </div>
  <span class="score">5 pts</span>
</div>
```

**Medium** (`.card.medium-card` — 2 columns):
```html
<div class="card medium-card">
  <span class="rank">1</span>
  <div>
    <div class="title"><a href="..." target="_blank" rel="noopener">Title</a></div>
    <div class="meta"><span class="pill">Pub</span><span>Author</span></div>
  </div>
</div>
```

**arXiv** (`.card.arxiv-card` — 2 columns + abstract):
```html
<div class="card arxiv-card">
  <span class="rank">1</span>
  <div>
    <div class="title"><a href="..." target="_blank" rel="noopener">Title</a></div>
    <div class="meta"><span class="pill">Authors</span></div>
    <div class="abstract">Abstract…</div>
  </div>
</div>
```

Update each section counter with `N + ' items'`.

### 5. Style (dark theme — use this exact CSS)

Use the following `<style>` block verbatim (dark radial-gradient background, panel
cards, colored section accents, sticky blurred nav, responsive grid):

```css
:root {
  --bg:#0b0d10; --panel:#12161b; --panel2:#171c22; --text:#f3f5f7; --muted:#9aa4af;
  --border:#29313a; --hn-orange:#ff6600; --medium-green:#1a8917; --arxiv-red:#b31b1b;
  --link:#dce6f0; --shadow:0 12px 32px rgba(0,0,0,.22);
}
*{box-sizing:border-box}
html{scroll-behavior:smooth}
body{margin:0;background:radial-gradient(circle at top,#18202a 0,#0b0d10 42%);color:var(--text);font:15px/1.55 system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif}
a{color:var(--link);text-decoration:none}
a:hover{text-decoration:underline}
.wrap{width:min(1120px,calc(100% - 32px));margin:auto}
header{padding:54px 0 28px;display:flex;justify-content:space-between;gap:20px;align-items:end}
h1{font-size:clamp(2rem,5vw,4rem);line-height:1;margin:0;letter-spacing:-.045em}
.tagline{margin:.65rem 0 0;color:var(--muted);max-width:680px}
.badge{border:1px solid var(--border);background:rgba(255,255,255,.04);padding:9px 12px;border-radius:999px;white-space:nowrap;color:var(--muted);font-size:13px}
.section-nav{position:sticky;top:0;z-index:5;background:rgba(11,13,16,.88);backdrop-filter:blur(12px);border-block:1px solid var(--border);padding:10px 0}
.nav-inner{display:flex;gap:8px;flex-wrap:wrap}
.nav-inner a{padding:7px 11px;border-radius:8px;border:1px solid var(--border);font-weight:700;font-size:13px}
.nav-inner a:hover{text-decoration:none;border-color:#56616c}
section{padding:38px 0 18px;scroll-margin-top:70px}
.section-head{display:flex;align-items:baseline;justify-content:space-between;gap:15px;margin-bottom:14px}
.section-title{font-size:1.65rem;margin:0;letter-spacing:-.02em}
.count{color:var(--muted);font-size:13px}
.section-head.hn{border-left:5px solid var(--hn-orange);padding-left:12px}
.section-head.medium{border-left:5px solid var(--medium-green);padding-left:12px}
.section-head.arxiv{border-left:5px solid var(--arxiv-red);padding-left:12px}
.list{display:grid;gap:10px}
.card{display:grid;grid-template-columns:48px 1fr auto;gap:14px;align-items:start;background:linear-gradient(180deg,var(--panel2),var(--panel));border:1px solid var(--border);border-radius:14px;padding:15px;box-shadow:var(--shadow)}
.rank{font-variant-numeric:tabular-nums;color:var(--muted);font-weight:800;font-size:14px;padding-top:2px;text-align:center}
.title{font-size:16px;font-weight:760;line-height:1.35}
.meta{color:var(--muted);font-size:12px;margin-top:6px;display:flex;gap:8px;flex-wrap:wrap}
.pill{border:1px solid var(--border);border-radius:999px;padding:2px 7px}
.score{color:var(--hn-orange);font-weight:800;white-space:nowrap}
.card.medium-card{grid-template-columns:48px 1fr}
.medium-card .title a:hover{color:#74d36f}
.card.arxiv-card{grid-template-columns:48px 1fr}
.abstract{color:#b9c2cb;margin:.65rem 0 0;display:-webkit-box;-webkit-box-orient:vertical;-webkit-line-clamp:2;overflow:hidden}
.empty{padding:18px;border:1px dashed var(--border);border-radius:12px;color:var(--muted)}
footer{padding:42px 0 60px;color:var(--muted);font-size:13px}
footer a{color:#cbd6df}
.tools{display:flex;gap:8px;flex-wrap:wrap;margin-top:16px}
button{appearance:none;border:1px solid var(--border);background:#171c22;color:var(--text);padding:8px 12px;border-radius:9px;cursor:pointer}
button:hover{border-color:#687580}
@media(max-width:700px){
  header{align-items:start;flex-direction:column}
  .card{grid-template-columns:36px 1fr}
  .score{grid-column:2}
}
```

Color accents are defined by the `--hn-orange`, `--medium-green`, and `--arxiv-red`
variables and applied via the `.section-head.hn/.medium/.arxiv` left borders and the
`.score` color.

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
- Use the §5 CSS verbatim — do not invent a different theme.
