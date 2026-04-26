# UI/UX Audit Report - IronBook GM

**Date**: 2026-04-25
**Auditor**: Antigravity (UI/UX Designer & Coding Assistant)

## Executive Summary
The IronBook GM application has a solid foundation with a modern aesthetic, but suffers from several "polish" issues and critical navigation gaps. The most significant issues are the double status bars (stacking headers), missing navigation items for core features (Attendance, Analytics), and broken routing for certain sub-pages.

---

## Detailed Audit Findings

### 1. Visual Inconsistencies & Layout Issues

#### [CRITICAL] Double Status Bar / Stacking Headers
- **Location**: All main screens (Dashboard, Members, etc.)
- **Error**: The `StatusBarWrapper` is applied in `MainShell` and then RE-APPLIED in individual screens (e.g., `DashboardScreen`).
- **Effect**: This creates a double vertical spacing/overlay at the top of the screen, wasting valuable real estate and looking unprofessional.

#### [HIGH] Missing Navigation Items
- **Location**: `AppBottomNavBar`
- **Error**: Attendance (Index 3) and Analytics (Index 4) are completely missing from the bottom navigation bar.
- **Effect**: Users cannot access these core features via the primary navigation.

#### [MEDIUM] Inconsistent Iconography
- **Location**: Bottom Navigation
- **Error**: The 'Add' FAB uses `Icons.add_rounded`, while other items use thin-line rounded icons. The 'POS' icon (`Icons.description_rounded`) might be better as a 'receipt' or 'shopping_cart' icon to match its function.

### 2. UX Friction Points

#### [CRITICAL] Broken Routing / 404 Errors
- **Location**: Deep links and direct navigation.
- **Error**: Navigating to `#/gym` or `#/analytics` via URL results in a `GoException: no routes for location`.
- **Cause**: Potential mismatch in how `StatefulShellRoute` handles top-level paths versus branch-level paths.

#### [MEDIUM] Information Hierarchy on Dashboard
- **Error**: The 'Total Members' card is highlighted with a gradient, but 'Expired' members (which requires urgent action) is just a simple card.
- **Improvement**: High-risk items (Expired, Expiring) should have more visual weight or 'danger' indicators.

### 3. Technical Issues

#### Unimplemented Settings Pages
- **Location**: Settings -> Backup, Plans, Account
- **Error**: These routes exist but lead to "Coming Soon" or empty screens.

---

## Screenshots captured in this folder:
- `dashboard.png`
- `pos.png`
- `attendance.png`
- `settings.png`
- `gym_error.png`
- `analytics_error.png`
- `add_member_error.png`
