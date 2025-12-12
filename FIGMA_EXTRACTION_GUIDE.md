# Figma Design Extraction Quick Guide

## 🎯 Quick Reference for Extracting Design Values

This guide provides step-by-step instructions for extracting design specifications from the Figma file.

---

## 📐 How to Extract Values from Figma

### 1. Extracting Colors

**Method 1: From Design Panel**
1. Select any element with a color
2. Look at the right panel → "Fill" section
3. Click the color to see hex code
4. Copy the hex value (e.g., `#38593F`)

**Method 2: From Color Styles**
1. Open Figma → Right panel → "Design" tab
2. Scroll to "Color styles" section
3. Click on any color style to see its value
4. Document all color styles with their names and values

**Method 3: Using Inspect Mode**
1. Select an element
2. Click "Inspect" in the right panel
3. View CSS properties to see color values

**Example Output:**
```
Primary Color: #38593F
Background: #F0F0F0
Text Primary: #000000
Text Secondary: #848484
Error: #FF0040
Success: #28A745
```

---

### 2. Extracting Typography

**Steps:**
1. Select a text element
2. Right panel shows:
   - Font family (e.g., "Roboto", "Poppins")
   - Font size (e.g., 16px, 24px)
   - Font weight (e.g., Regular 400, Bold 700)
   - Line height (e.g., 24px or 1.5)
   - Letter spacing (e.g., 0px, -0.5px)
   - Color

**Document Each Text Style:**
```
Heading 1:
- Font: Roboto
- Size: 36px
- Weight: 800 (Extra Bold)
- Line Height: 44px
- Letter Spacing: 0px
- Color: #000000

Body Text:
- Font: Roboto
- Size: 16px
- Weight: 400 (Regular)
- Line Height: 24px
- Letter Spacing: 0px
- Color: #4B4B4B
```

---

### 3. Extracting Spacing

**Using Measurement Tool:**
1. Select two elements
2. Hold `Option` (Mac) or `Alt` (Windows)
3. Hover between elements to see distance
4. Note the spacing value

**Common Spacing Values to Document:**
- Padding inside cards: __px
- Margin between cards: __px
- Padding inside buttons: __px
- Spacing between list items: __px
- Screen edge padding: __px

**Example:**
```
Card Padding: 16px
Card Margin: 12px
Button Padding: 12px horizontal, 16px vertical
Screen Padding: 20px
List Item Spacing: 8px
```

---

### 4. Extracting Border Radius

**Steps:**
1. Select an element (button, card, etc.)
2. Right panel → "Corner radius" section
3. Note the radius value (e.g., 8px, 12px, 16px)

**Document:**
```
Small Radius: 4px (used for small badges)
Medium Radius: 8px (used for buttons)
Large Radius: 12px (used for cards)
Extra Large Radius: 16px (used for large cards)
```

---

### 5. Extracting Component Sizes

**Button Sizes:**
1. Select a button
2. Check width and height in right panel
3. Note padding values

**Example:**
```
Primary Button:
- Height: 48px
- Padding: 16px horizontal, 12px vertical
- Border Radius: 8px
- Min Width: 120px
```

**Input Field Sizes:**
1. Select an input field
2. Check height, padding, border radius
3. Note label and placeholder styles

**Example:**
```
Text Input:
- Height: 56px
- Padding: 16px horizontal
- Border Radius: 8px
- Border: 1px solid #D4D4D4
```

---

### 6. Extracting Icons

**Steps:**
1. Select an icon
2. Right-click → "Copy as SVG" or "Export"
3. Export as SVG (preferred) or PNG
4. Note the icon size (width × height)
5. Save with descriptive name (e.g., `home_icon_24.svg`)

**Icon Sizes to Document:**
- Small icons: 16px
- Medium icons: 24px
- Large icons: 32px
- Extra large icons: 48px

---

### 7. Extracting Shadows/Elevation

**Steps:**
1. Select an element with shadow
2. Right panel → "Effects" section
3. Note shadow properties:
   - X offset
   - Y offset
   - Blur radius
   - Spread
   - Color
   - Opacity

**Example:**
```
Card Shadow:
- X: 0px
- Y: 2px
- Blur: 8px
- Spread: 0px
- Color: #000000
- Opacity: 10%
```

**Flutter Equivalent:**
```dart
BoxShadow(
  color: Colors.black.withOpacity(0.1),
  offset: Offset(0, 2),
  blurRadius: 8,
  spreadRadius: 0,
)
```

---

### 8. Extracting Gradients

**Steps:**
1. Select element with gradient
2. Right panel → "Fill" section
3. Click gradient to see:
   - Gradient type (linear, radial, angular)
   - Color stops
   - Angle/direction

**Example:**
```
Background Gradient:
- Type: Linear
- Angle: 180° (top to bottom)
- Color 1: #A8D8FF (top)
- Color 2: #FFFFFF (bottom)
```

**Flutter Equivalent:**
```dart
LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFFA8D8FF),
    Color(0xFFFFFFFF),
  ],
)
```

---

## 📋 Extraction Checklist Template

Use this template when extracting from Figma:

```markdown
## Screen: [Screen Name]

### Colors Used
- [ ] Primary: #_______
- [ ] Secondary: #_______
- [ ] Background: #_______
- [ ] Text Primary: #_______
- [ ] Text Secondary: #_______

### Typography
- [ ] Heading Style: [Font] [Size] [Weight]
- [ ] Body Style: [Font] [Size] [Weight]
- [ ] Caption Style: [Font] [Size] [Weight]

### Spacing
- [ ] Screen Padding: ___px
- [ ] Card Padding: ___px
- [ ] Element Spacing: ___px

### Components
- [ ] Button: [Height] [Padding] [Radius]
- [ ] Input: [Height] [Padding] [Radius]
- [ ] Card: [Padding] [Radius] [Shadow]

### Icons
- [ ] Icon 1: [Name] [Size]
- [ ] Icon 2: [Name] [Size]

### Images
- [ ] Image 1: [Aspect Ratio] [Size]
- [ ] Image 2: [Aspect Ratio] [Size]
```

---

## 🔍 Figma Shortcuts

**Measurement:**
- `Option/Alt` + Hover = Show distance between elements
- `Option/Alt` + Click = Copy properties

**Selection:**
- `Cmd/Ctrl + D` = Duplicate
- `Cmd/Ctrl + G` = Group
- `Cmd/Ctrl + Shift + G` = Ungroup

**Navigation:**
- `Space + Drag` = Pan canvas
- `Cmd/Ctrl + Scroll` = Zoom in/out
- `Shift + 1` = Fit to screen

**Inspect:**
- Right-click element → "Inspect" = See CSS/Flutter code

---

## 📱 Screen-Specific Extraction

### For Each Screen in Figma:

1. **Take Screenshot** - Capture the full screen design
2. **Document Layout** - Note the structure (header, body, footer)
3. **Extract Colors** - All colors used in the screen
4. **Extract Typography** - All text styles
5. **Extract Spacing** - All padding and margins
6. **Extract Components** - Buttons, inputs, cards, etc.
7. **Extract Icons** - All icons with sizes
8. **Extract Images** - All images with dimensions
9. **Note Interactions** - Any animations or transitions
10. **Document States** - Default, hover, active, disabled, error

---

## 🎨 Design System Organization

After extraction, organize values like this:

```
Design Tokens/
├── Colors/
│   ├── Primary Colors
│   ├── Semantic Colors
│   └── Neutral Colors
├── Typography/
│   ├── Font Families
│   ├── Font Sizes
│   ├── Font Weights
│   └── Line Heights
├── Spacing/
│   ├── Padding Scale
│   ├── Margin Scale
│   └── Gap Scale
├── Components/
│   ├── Buttons
│   ├── Inputs
│   ├── Cards
│   └── Navigation
└── Effects/
    ├── Shadows
    └── Gradients
```

---

## ✅ Verification Steps

After extraction:
1. ✅ All colors documented with hex codes
2. ✅ All typography styles documented
3. ✅ All spacing values documented
4. ✅ All icons exported and named
5. ✅ All images exported and optimized
6. ✅ All component specifications documented
7. ✅ All screen designs captured
8. ✅ All interactions/animations noted

---

## 🚀 Next: Update Flutter Code

Once extraction is complete:
1. Update `lib/core/app_colors.dart` with extracted colors
2. Update `lib/core/font_manager.dart` with extracted typography
3. Update `lib/core/app_spacing.dart` and `app_padding.dart` with extracted spacing
4. Add exported icons to `assets/icons/`
5. Add exported images to `assets/images/`
6. Update `lib/core/assets_manager.dart` with asset paths
7. Start implementing screens based on extracted specifications

---

**Tip:** Use Figma's "Inspect" mode to get Flutter code snippets directly from the design!

