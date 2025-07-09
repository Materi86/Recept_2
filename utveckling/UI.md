**Part 1: High-Level Goal**

Generate a series of key user interface screens for a cozy, warm, and user-friendly family recipe app built with Flutter. The overall aesthetic should feel like a modern, digital version of a beloved, well-used family recipe binder. The design should be clean, intuitive, and inviting for users of all technical skill levels.

---

**Part 2: Detailed Instructions & Visual Style Guide**

**A. Overall Visual Style:**
* **Mood:** Cozy, personal, handmade, rustic but clean, organized. Avoid a cold, corporate, or overly minimalist feel.
* **Color Palette:**
    * **Primary Background:** A soft, warm off-white or cream color (`#FDFBF6`).
    * **Primary Accent / Buttons:** A warm, muted terracotta or burnt orange (`#E57373`).
    * **Primary Text:** A dark, soft brown or charcoal, not pure black (`#4E342E`).
    * **Secondary Accent (for tags/categories):** A gentle sage green (`#A5D6A7`).
* **Typography:**
    * **Headings (Titles, etc.):** A friendly "Slab Serif" font like 'Roboto Slab' or 'Arvo'. It should feel substantial and traditional, like a typewriter.
    * **Body Text (Ingredients, Instructions):** A highly readable, slightly rounded sans-serif font like 'Lato' or 'Nunito Sans'.
* **Layout & Elements:**
    * Use plenty of white space. The layout should feel uncluttered.
    * Use rounded corners on all cards, buttons, and input fields for a softer, friendlier look.
    * Use subtle, soft drop shadows on cards to lift them from the background.
    * **Icons:** Use a simple, clean "line-art" icon set.

**B. Specific Screen Designs:**

1.  **Screen 1: The Recipe List (Home Screen)**
    * A clean screen with the app title "Familiens Recept" at the top.
    * Below the title, display a grid of interactive "Recipe Cards".
    * Each card should be rectangular with rounded corners and a soft shadow.
    * The card must prominently display the recipe's image, with the recipe's `title` overlaid at the bottom of the image.
    * Below the image, show small, pill-shaped "category tags" in the sage green accent color.
    * In the bottom right corner, there should be a round Floating Action Button (FAB) with a '+' icon, using the primary terracotta color.

2.  **Screen 2: The Recipe Detail Screen**
    * At the very top, display a large, high-quality "hero image" of the dish.
    * Below the image, show the `title` in the large heading font.
    * Below the title, have a section titled "Ingredienser" with a bulleted list of ingredients.
    * Below that, have a section titled "Instruktioner" with a numbered list of steps.
    * The text should be large and easy to read.

3.  **Screen 3: The Add/Edit Recipe Form**
    * A simple, single-page form with the title "Nytt Recept".
    * A large area to tap to "Välj en bild", which shows a placeholder icon of a camera.
    * A simple text input field for "Titel".
    * A larger, multi-line text area for "Ingredienser".
    * An even larger, multi-line text area for "Instruktioner".
    * A section for "Kategorier" where all available categories are shown as selectable "chips" (pills). The user can tap to select/deselect them.
    * A prominent "Spara Recept" button at the bottom in the terracotta color.

---

**Part 3: Constraints**
* **Framework:** The design must be achievable in **Flutter** using the **Material 3** design system as a base.
* **Simplicity:** Do not use complex animations or gestures. Focus on a clear, static, and beautiful design.
* **Responsiveness:** The design must work well on standard mobile phone screen sizes (portrait orientation).

---

**Part 4: Scope**
* Generate these three screens as separate, high-fidelity visual mockups. You do not need to generate code. The goal is to create a visual target that a developer can implement.