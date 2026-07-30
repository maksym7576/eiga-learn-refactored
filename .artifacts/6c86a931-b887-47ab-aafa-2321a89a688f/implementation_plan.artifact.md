# Implementation Plan: Professional Universal Color Palette

The goal is to replace the current "Purple & Teal" theme with a more "Universal & Professional" palette. We will use a **Modern Slate & Indigo** system, which is widely recognized in high-end educational and productivity apps for its excellent readability and balanced harmony.

## Proposed Palette: "Modern Slate & Indigo"

This palette is based on professionally curated scales (similar to Tailwind CSS) to ensure all tones synchronize perfectly.

### 1. Core Colors
- **Primary (Identity)**: `0xFF4338CA` (Indigo 700) - Deep, trustworthy indigo for primary elements.
- **Accent (Success/Active)**: `0xFF10B981` (Emerald 500) - A sophisticated green-teal for active states.
- **Surface (Backgrounds)**:
    - **Active**: `0xFFEEF2FF` (Indigo 50) - Very soft indigo tint.
    - **Inactive**: `0xFFF8FAFC` (Slate 50) - Clean, neutral off-white.
    - **Finished**: `0xFFF1F5F9` (Slate 100) - Muted slate for past items.
- **Time Sidebar**: `0xFFE2E8F0` (Slate 200) - Clearly defined but neutral.

### 2. Typography
- **Primary Text**: `0xFF1E293B` (Slate 800) - High contrast for Japanese characters.
- **Secondary/Translation**: `0xFF475569` (Slate 600) - Professional grey for translations.
- **Muted/Finished**: `0xFF94A3B8` (Slate 400) - "Ghost" text for finished phrases.

### 3. Highlights (Grammar/Semantic)
- **Warm**: `0xFFF43F5E` (Rose 500) - Instead of harsh orange.
- **Gold**: `0xFFF59E0B` (Amber 500) - Warm amber for secondary highlights.
- **Cool**: `0xFF0EA5E9` (Sky 500) - Bright blue for tertiary highlights.

## User Review Required

> [!IMPORTANT]
> The current theme is quite "vibrant" (Purple/Teal). The new "Slate & Indigo" theme is more "sober" and "premium." Do you prefer this professional direction, or should I try a more "vivid" professional palette like "Deep Sea & Neon"?

> [!TIP]
> This palette ensures that Japanese characters (which are complex) stand out clearly against the background without causing eye strain during long learning sessions.

## Proposed Changes

### [Component] Styles & Theming

#### [MODIFY] [phraseListStyles.dart](file:///C:/Users/fcjhx/StudioProjects/eiga-learn-refactored/lib/ui/styles/phraseListStyles.dart)
- Replace all color hex codes with the new "Modern Slate & Indigo" values.
- Refine `getCardDecoration` to use softer shadows (`Slate` based shadows look more natural than `Black`).
- Update `getHighlightColor` with the new balanced Rose/Amber/Sky scale.

## Verification Plan

### Manual Verification
- Verify that the active card is still the most prominent element but looks more "integrated."
- Ensure the three highlight colors are easily distinguishable from each other.
- Check readability of "Finished" phrases to make sure they are not *too* faded.
