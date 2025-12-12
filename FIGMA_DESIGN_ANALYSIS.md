# Figma Design Analysis for ScoreLivePro

## 📋 Overview
This document provides a comprehensive analysis of the Figma design for the ScoreLivePro real-time sports application and how it maps to the current Flutter implementation.

**Figma Design URL:** [https://www.figma.com/design/qELaE6whdSA1rqBluVB1zx/scorelivepro%7C%7C-Real-time-Sports-App?node-id=20-1048&t=zMP40PdHVEpe9PFq-0](https://www.figma.com/design/qELaE6whdSA1rqBluVB1zx/scorelivepro%7C%7C-Real-time-Sports-App?node-id=20-1048&t=zMP40PdHVEpe9PFq-0)

---

## 🎨 Design System Analysis

### Current Implementation Status

#### ✅ Already Implemented
1. **Design Tokens Structure**
   - Color system (`app_colors.dart`)
   - Typography system (`font_manager.dart`)
   - Spacing system (`app_spacing.dart`)
   - Padding system (`app_padding.dart`)
   - Responsive design setup (ScreenUtil with 390x851 design size)

2. **Project Structure**
   - Views organized by feature (home, login, favorites, league, news, notifications, settings)
   - Core design system files
   - Asset management structure

#### ⚠️ Needs Review/Update
1. **Splash Screen** - Currently placeholder
2. **View Implementations** - Most views are not yet implemented
3. **Design Token Alignment** - Need to verify if current tokens match Figma

---

## 🔍 Figma Design Extraction Checklist

### 1. Color Palette Extraction

**Current Colors in `app_colors.dart`:**
- Primary: `#FF7931` (dark orange)
- Background: `#F0F0F0`
- Accent colors: Red, Yellow, Green, Blue
- Various grey shades

**Action Items:**
- [ ] Extract exact color values from Figma
- [ ] Verify primary color matches design
- [ ] Extract semantic colors (success, error, warning, info)
- [ ] Extract gradient colors if any
- [ ] Extract shadow colors
- [ ] Update `app_colors.dart` with Figma values

**Figma Extraction Steps:**
1. Open Figma file
2. Check "Design" panel → Colors section
3. Note all color styles and their hex values
4. Check for color variables if using Figma variables
5. Document color usage context (buttons, text, backgrounds, etc.)

---

### 2. Typography System Extraction

**Current Typography in `font_manager.dart`:**
- Font families: Poppins, Inter, Roboto, Montserrat
- Font weights: 400, 600, 700, 800
- Text styles: Title, Big Title, General, Hint, Subtitle, Button

**Action Items:**
- [ ] Extract exact font families from Figma
- [ ] Extract font sizes for all text styles
- [ ] Extract line heights
- [ ] Extract letter spacing
- [ ] Extract font weights
- [ ] Verify Google Fonts availability
- [ ] Update `font_manager.dart` with Figma values

**Figma Extraction Steps:**
1. Check "Text" styles in Figma
2. Document each text style:
   - Font family
   - Font size
   - Font weight
   - Line height
   - Letter spacing
   - Color
3. Map to Flutter text styles

---

### 3. Spacing & Layout System

**Current Spacing in `app_spacing.dart` & `app_padding.dart`:**
- Height spacing: 2h to 144h
- Width spacing: 2w to 144w
- Padding: 4r to 48r
- Border radius: 4r to 40r

**Action Items:**
- [ ] Extract spacing scale from Figma (4, 8, 12, 16, 24, 32, etc.)
- [ ] Extract padding values used in components
- [ ] Extract border radius values
- [ ] Extract margin values
- [ ] Verify current spacing matches Figma grid
- [ ] Update spacing system if needed

**Figma Extraction Steps:**
1. Check component spacing in Figma
2. Use Figma's measurement tool to check distances
3. Document common spacing values
4. Check if Figma uses a spacing grid system (8px, 4px, etc.)

---

### 4. Component Analysis

**Screens to Analyze in Figma:**

#### A. Splash Screen
- [ ] Background color/gradient
- [ ] Logo size and position
- [ ] Animation requirements
- [ ] Loading indicators

#### B. Onboarding Screens
- [ ] Number of screens
- [ ] Illustration/image sizes
- [ ] Text content and styling
- [ ] Button styles and positions
- [ ] Navigation indicators (dots, progress bar)

#### C. Login/Authentication
- [ ] Input field styles
- [ ] Button styles
- [ ] Social login buttons
- [ ] Form layout
- [ ] Error state styling

#### D. Home Screen
- [ ] Navigation bar style
- [ ] Live score cards
- [ ] Match list layout
- [ ] Filter/search components
- [ ] Tab bar design
- [ ] Refresh indicators

#### E. League Views
- [ ] League list/grid layout
- [ ] League card design
- [ ] Filter options
- [ ] Standings table design

#### F. News Views
- [ ] News card layout
- [ ] Article detail page
- [ ] Image aspect ratios
- [ ] Category filters

#### G. Favorites Views
- [ ] Favorite teams/leagues list
- [ ] Empty state design
- [ ] Card layouts

#### H. Notification Views
- [ ] Notification list item design
- [ ] Notification types (match, news, etc.)
- [ ] Settings toggles

#### I. Settings
- [ ] Settings list layout
- [ ] Toggle switches
- [ ] Profile section
- [ ] Logout button

---

### 5. Component Specifications

For each component in Figma, extract:

**Buttons:**
- [ ] Primary button: size, padding, border radius, colors, text style
- [ ] Secondary button: same specifications
- [ ] Icon buttons: size, icon size
- [ ] Disabled states
- [ ] Loading states

**Input Fields:**
- [ ] Text field: height, padding, border radius, border color
- [ ] Label style
- [ ] Placeholder style
- [ ] Error state styling
- [ ] Focus state styling

**Cards:**
- [ ] Card padding
- [ ] Border radius
- [ ] Shadow/elevation
- [ ] Background color
- [ ] Content spacing

**Navigation:**
- [ ] Bottom navigation bar: height, icon size, active/inactive states
- [ ] Top app bar: height, title style, action buttons
- [ ] Tab bar: style, indicator, active/inactive states

**Lists:**
- [ ] List item height
- [ ] Divider style
- [ ] Spacing between items
- [ ] Swipe actions (if any)

---

### 6. Icon System

**Action Items:**
- [ ] Extract all icon names from Figma
- [ ] Note icon sizes used (16px, 24px, 32px, etc.)
- [ ] Check if icons are from a specific icon set
- [ ] Export icons as SVG (preferred) or PNG
- [ ] Organize icons in `assets/icons/` folder
- [ ] Update `assets_manager.dart` with icon paths

**Figma Extraction Steps:**
1. Identify all icons in the design
2. Export as SVG (vector) for scalability
3. Use consistent naming convention
4. Document icon sizes and usage context

---

### 7. Image Assets

**Action Items:**
- [ ] Extract placeholder images
- [ ] Note image aspect ratios
- [ ] Extract logo files
- [ ] Extract onboarding illustrations
- [ ] Organize in `assets/images/` folder
- [ ] Optimize images for mobile

---

### 8. Animation & Interactions

**Action Items:**
- [ ] Document page transitions
- [ ] Document micro-interactions (button press, card tap)
- [ ] Document loading animations
- [ ] Document pull-to-refresh animations
- [ ] Document scroll behaviors
- [ ] Note animation durations and easing curves

**Figma Extraction Steps:**
1. Check Figma prototype for interactions
2. Document animation types:
   - Fade in/out
   - Slide transitions
   - Scale animations
   - Rotation animations
3. Note timing: duration and easing

---

### 9. Responsive Breakpoints

**Current Setup:**
- Design size: 375x812 (iPhone X/11 Pro)

**Action Items:**
- [ ] Verify if Figma uses same design size
- [ ] Check tablet designs (if any)
- [ ] Document breakpoints for different screen sizes
- [ ] Update ScreenUtil design size if needed

---

## 📐 Design Implementation Roadmap

### Phase 1: Design Token Extraction
1. Extract all colors from Figma → Update `app_colors.dart`
2. Extract typography → Update `font_manager.dart`
3. Extract spacing values → Verify `app_spacing.dart` and `app_padding.dart`
4. Export and organize icons → Update `assets_manager.dart`

### Phase 2: Core Components
1. Create reusable button components
2. Create input field components
3. Create card components
4. Create navigation components
5. Create list item components

### Phase 3: Screen Implementation
1. Splash screen
2. Onboarding screens
3. Login/authentication screens
4. Home screen
5. League views
6. News views
7. Favorites views
8. Notification views
9. Settings screen

### Phase 4: Polish & Animation
1. Add page transitions
2. Add micro-interactions
3. Add loading states
4. Add error states
5. Add empty states

---

## 🔧 Tools & Resources

### Figma Plugins (Recommended)
1. **Figma to Flutter** - Export design tokens
2. **Figma to Code** - Generate Flutter code snippets
3. **Design Tokens** - Export design system tokens

### Flutter Packages (Already in use)
- `flutter_screenutil` - Responsive design
- `google_fonts` - Typography
- `flutter_svg` - SVG icons
- `cached_network_image` - Image loading
- `lottie` - Animations

---

## 📝 Design Token Mapping

### Color Mapping Example
```dart
// Figma Color → Flutter Implementation
// Primary Green: #38593F → AppColors.primaryColor
// Background: #F0F0F0 → AppColors.bgColor
// Error Red: #FF0040 → AppColors.red
```

### Typography Mapping Example
```dart
// Figma Text Style → Flutter TextStyle
// Heading 1 → FontManager.bigTitleText()
// Body Text → FontManager.generalText()
// Caption → FontManager.subSubtitleText()
```

---

## ✅ Verification Checklist

Before starting implementation, verify:
- [ ] All design tokens extracted from Figma
- [ ] Icons exported and organized
- [ ] Images exported and optimized
- [ ] Component specifications documented
- [ ] Animation requirements documented
- [ ] Responsive breakpoints defined
- [ ] Design system matches Flutter implementation

---

## 🚀 Next Steps

1. **Open Figma File** - Access the design file using the provided URL
2. **Extract Design Tokens** - Follow the extraction checklist above
3. **Update Core Files** - Update `app_colors.dart`, `font_manager.dart`, etc.
4. **Create Components** - Build reusable components based on Figma specs
5. **Implement Screens** - Build each screen following the design
6. **Test & Refine** - Compare implementation with Figma design

---

## 📚 Additional Resources

- [Figma Design Tokens Guide](https://www.figma.com/community/plugin/888356646278934516/Design-Tokens)
- [Flutter Design System Best Practices](https://docs.flutter.dev/ui/widgets)
- [Material Design 3](https://m3.material.io/) - For reference on design patterns

---

## 📞 Notes

- Design size in Flutter: **375x812** (iPhone X/11 Pro)
- ScreenUtil is configured for responsive design
- Current color scheme uses green as primary (sports theme)
- Typography uses Google Fonts (Roboto, Montserrat, Poppins, Inter)

---

**Last Updated:** [Current Date]
**Design Version:** [Check Figma for version]
**Implementation Status:** In Progress

