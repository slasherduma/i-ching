# BottomBar Reference

## Overview
`BottomBar` is a reusable component that provides consistent bottom CTA (Call-To-Action) bar positioning across all screens. This document defines the canonical implementation rules to prevent accidental breakage.

## Constants (Single Source of Truth)

- **Edge Inset**: `48pt` from screen edge to button text on both sides (symmetric)
- **Minimum Scale Factor**: `0.85` for text scaling in UIKitLabel

These values are defined as constants in `BottomBar.swift`:
- `edgeInsetBase = 48`
- `minimumScaleFactor = 0.85`

**Important**: Do not add extra horizontal padding in parent views. The 48pt inset is handled internally by BottomBar.

## Layout Types

### Single Button Layout (`BottomBar.primary`)
- Full-width button centered on screen
- Used for primary actions
- Reference screens: `CoinsView`, `HexagramView`

### Dual Button Layout (`BottomBar.dual`)
- Two buttons side by side
- Left button: leading-aligned text
- Right button: trailing-aligned text
- Reference screen: `ResultView`

## Dual Layout Structure (Canonical)

The dual layout MUST follow this exact structure:

```swift
let buttons = HStack(spacing: 0) {
    leftButton
        .frame(maxWidth: .infinity, alignment: .leading)
    
    rightButton
        .frame(maxWidth: .infinity, alignment: .trailing)
}
.frame(maxWidth: .infinity)
.padding(.horizontal, horizontalPadding)
```

Where:
- `horizontalPadding = scaledValue(Self.edgeInsetBase, for: geometry)`
- `HStack(spacing: 0)` ensures no gap between columns
- Each button column uses `.frame(maxWidth: .infinity)` to split space equally
- Alignment is applied at the column level (`.leading` for left, `.trailing` for right)

## UIKitLabel Rules

When using `UIKitLabel` in BottomBar:

1. **Always use `lineLimit(1)`** - Prevents text wrapping
2. **Use `minimumScaleFactor: Self.minimumScaleFactor`** (0.85) - Allows text to shrink if needed
3. **Do NOT use `fixedSize(horizontal: true)`** - Allows horizontal compression
4. **Text alignment**: 
   - Left button: `.left` (default)
   - Right button: `.right`

## Modifier Order Rule

For right button in dual layout, the modifier order is critical:

```swift
UIKitLabel(...)
    .lineLimit(1)
    .frame(maxWidth: .infinity, alignment: .trailing)  // Frame BEFORE padding
    .padding(.vertical, ...)  // Only vertical padding
    .frame(height: ...)
```

**Key points**:
- `.frame(maxWidth: .infinity, alignment: .trailing)` must be applied to the label content BEFORE padding
- Only vertical padding is allowed on buttons (no horizontal padding)
- Horizontal spacing is controlled by the HStack's `horizontalPadding`

## Reference Screens

### Single Button Layout
- **CoinsView**: Primary button "БРОСИТЬ МОНЕТЫ"
- **HexagramView**: Primary button "ПРОДОЛЖИТЬ"

### Dual Button Layout
- **ResultView**: 
  - Left: "СОХРАНИТЬ"
  - Right: "ВЫХОД В МЕНЮ"
- **TutorialView**: 
  - Left: "НАЗАД" (when not on first page)
  - Right: "ДАЛЕЕ" / "ВЫХОД В МЕНЮ"
- **DailySignView**: 
  - Left: "СОХРАНИТЬ" (result state)
  - Right: "ВЫЙТИ В МЕНЮ" (result state)

## Common Mistakes to Avoid

1. ❌ Adding horizontal padding in parent views
2. ❌ Using `fixedSize(horizontal: true)` on UIKitLabel
3. ❌ Changing the HStack structure or spacing
4. ❌ Adding horizontal padding to individual buttons
5. ❌ Using different edge inset values
6. ❌ Changing minimumScaleFactor without updating the constant

## Implementation Checklist

When modifying BottomBar:

- [ ] Use `Self.edgeInsetBase` instead of hardcoded `48`
- [ ] Use `Self.minimumScaleFactor` instead of hardcoded `0.85`
- [ ] Maintain canonical HStack structure for dual layout
- [ ] Apply `.frame(maxWidth: .infinity, alignment: .trailing)` to right label BEFORE padding
- [ ] Only use vertical padding on buttons
- [ ] Ensure `lineLimit(1)` on all UIKitLabels
- [ ] Verify no parent views add extra horizontal padding

