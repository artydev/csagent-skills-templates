# Instruction Template: Luxury Car Dealership Landing Page
## Inspired by Prestige Motors

### Objective
Build a complete, single-file HTML landing page for a luxury pre-owned car dealership. The page should evoke sophistication, exclusivity, and trust — appealing to discerning buyers looking for high-end vehicles.

### Requirements

#### 1. Structure
- A single `index.html` file containing all HTML, CSS, and JavaScript (inline).
- Responsive design (mobile, tablet, desktop) with breakpoints at 768px and 480px.
- Semantic HTML5 tags (`<nav>`, `<section>`, `<footer>`, etc.).
- All interactive elements must work without external libraries (vanilla JS only).

#### 2. Visual Design (Luxury Automotive Aesthetic)
- **Colour palette:** Deep navy (#0B1D3A) as primary background, gold (#C9A227) for accents, dark charcoal (#1A1A2E) for alternating sections, white (#FFFFFF) for text, cream (#F8F5F0) as optional light accent.
- **Typography:** "Playfair Display" (Google Fonts) for headings and brand name, "Cormorant Garamond" for body text and buttons. Both loaded via Google Fonts `<link>`.
- **Background:** Dark gradient overlays on hero images, semi-transparent card backgrounds (rgba(255,255,255,0.04)).
- **Spacing:** Generous whitespace, large padding (100px section padding, 24px container padding).
- **Borders:** Subtle gold borders (rgba(201,162,39,0.15–0.3)) on cards, buttons, and dividers.

#### 3. Sections (in order)

1. **Sticky Navigation Bar**
   - Brand logo text (e.g., "PrestigeMotors") in gold serif font with white span accent.
   - Navigation links: Home, Inventory, Financing, Contact.
   - Fixed at top with backdrop-filter blur (8px) and semi-transparent background.
   - Gold underline hover effect on links using `::after` pseudo-element.
   - **Mobile:** Hamburger menu (3 gold lines) that toggles a full-width dropdown menu with slide-down animation.

2. **Hero Section with Diaporama (Slideshow)**
   - Full-viewport-height section with absolute-positioned slideshow.
   - 4 background images from Unsplash (use `https://images.unsplash.com/photo-XXXXXX?w=1920&q=80` format).
   - Dark gradient overlay (linear-gradient 135deg, navy 85% → transparent 50% → navy 75%).
   - Central headline with gold span accent (e.g., "Drive Beyond Ordinary").
   - Subheadline describing the dealership.
   - Two CTA buttons: solid gold "View Inventory" and outlined "Book a Test Drive".
   - **Navigation arrows** (prev/next) on left/right sides — circular gold-bordered buttons with hover fill effect.
   - **Dot indicators** at bottom — small circles that highlight active slide with gold glow.
   - **Auto-advance** every 5 seconds, pause on hover, reset on manual navigation.

3. **Featured Vehicles Grid**
   - 3-column grid of vehicle cards.
   - Each card contains:
     - Image area (220px height) with background-image from Unsplash (`w=600&q=80`).
     - "Featured" badge overlay in gold at bottom-left of image.
     - Vehicle name (Playfair Display), price (gold), mileage.
     - Mini specs row: engine, horsepower, drivetrain with Unicode icons.
     - "View Details" button that opens the detail modal.
   - **Hover effect:** Card lifts 8px, scales 1.01, gains gold border and gold box-shadow.

4. **Detail Modal (Expandable Card Detail)**
   - Fixed overlay with dark backdrop and backdrop-filter blur.
   - Centered modal (max-width 800px, max-height 90vh, scrollable).
   - **Animation:** Scale from 0.95 + translateY(20px) on open.
   - Close button (×) in top-right corner with rotate hover effect.
   - Modal content:
     - Large image (340px height) from Unsplash (`w=800&q=80`).
     - Vehicle full name, subtitle (trim level), price + mileage.
     - **10 spec items** in a 2-column grid (1-column on mobile), each with gold left border, uppercase label, and value.
     - Full description paragraph.
     - Two CTA buttons: "Book a Test Drive" (solid) and "Make an Inquiry" (outlined) — both scroll to contact section on click.
   - Close on: X button, overlay click, or Escape key.
   - Body scroll lock when modal is open.

5. **Why Choose Us (Features)**
   - 3-column grid of feature cards.
   - Each card: circular gold-bordered icon (80px) with hover fill effect, heading, description text.
   - Icons use Unicode symbols (★, $, ✉).

6. **Testimonials Slider**
   - Single-slide view with horizontal track (translateX).
   - Each slide: blockquote with large opening quotation mark (gold, Playfair Display), italic text, cite with name and subtitle.
   - Navigation: prev/next circular buttons, dot indicators.
   - Auto-advance every 6 seconds, pause on hover.

7. **Contact Form**
   - Centered form (max-width 600px).
   - Fields: Name, Email, Phone, Message — each with uppercase label and bottom-border input style.
   - Gold underline on focus.
   - Submit button (full-width, solid gold).
   - **Validation:** All fields required, email regex check, phone minimum 7 digits.
   - Success/error message displayed below button.

8. **Footer**
   - Social media icon links (circular gold-bordered, hover fill).
   - Copyright notice.

9. **Back to Top Button**
   - Fixed bottom-right, circular gold button.
   - Hidden by default, appears after scrolling 400px.
   - Smooth scroll to top on click.

#### 4. Interactivity (JavaScript)

- **Hero slideshow:** Auto-advance, prev/next buttons, dot navigation, pause on hover.
- **Mobile hamburger:** Toggle nav-links open/close, close on link click.
- **Detail modal:** Open with vehicle data, close via X/overlay/Escape, body scroll lock.
- **Testimonial slider:** Prev/next, dots, auto-advance, pause on hover.
- **Back to top:** Show/hide on scroll, smooth scroll.
- **Fade-in on scroll:** Intersection Observer API (threshold 0.15) — sections fade up from 40px below.
- **Contact form validation:** Required fields, email pattern, phone digit count, success message.
- **Vehicle data:** Stored as a JavaScript array of objects with name, year, price, mileage, img URL, subtitle, specs array (10 items), and description.

#### 5. Image Guidelines

- Use Unsplash images with specific size parameters:
  - Hero slideshow: `w=1920&q=80`
  - Card images: `w=600&q=80`
  - Modal images: `w=800&q=80`
- **Always verify image URLs return HTTP 200** using curl before including them.
- If an image returns 404, find an alternative Unsplash photo ID that works.
- Use distinct images for each vehicle card and matching larger versions for modals.

#### 6. Performance & Constraints

- No external dependencies except Google Fonts (loaded via `<link>`).
- All code must be valid HTML5, CSS3, and ES6+ JavaScript.
- File size should be under 100 KB.
- All images must be verified working before final delivery.

### Output
Generate the complete `index.html` file in the current working directory.

### Quality Checklist
- [ ] Valid HTML5 structure
- [ ] Responsive (test at 375px, 768px, 1440px)
- [ ] No broken links or missing assets
- [ ] All image URLs verified with HTTP 200
- [ ] Smooth animations and transitions
- [ ] Luxury visual aesthetic consistent throughout
- [ ] Hero slideshow auto-advances and responds to user interaction
- [ ] Modal opens with correct vehicle data and closes properly
- [ ] Contact form validates all fields
- [ ] Testimonial slider auto-advances
- [ ] Fade-in animations work on scroll
- [ ] Mobile hamburger menu works correctly
