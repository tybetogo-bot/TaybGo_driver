# TaybGo Driver — QA Testing Checklist

> Mark each item `[x]` when it passes. All items in a section must pass before the section is considered green.
> Last updated: 2026-04-03

---

## How to use this file

1. Work through each section top-to-bottom for a full regression pass.
2. For a targeted test (e.g. after changing auth code), jump to the relevant section.
3. Record failures with a note: `[x]` → `[F] <brief description>` and open a bug.
4. The **End-to-End Happy Path** (Section 20) is the minimum bar before any release.

---

## Table of Contents

1. [Authentication](#1-authentication)
2. [Driver Registration](#2-driver-registration)
3. [Home Screen — Online Toggle](#3-home-screen--online-toggle)
4. [New Order Arrival](#4-new-order-arrival)
5. [Order Acceptance & Rejection](#5-order-acceptance--rejection)
6. [Order Lifecycle — Status Transitions](#6-order-lifecycle--status-transitions)
7. [Navigation / Map Screen](#7-navigation--map-screen)
8. [Order Detail Screen](#8-order-detail-screen)
9. [Orders Screen (Tabs)](#9-orders-screen-tabs)
10. [Earnings Screen](#10-earnings-screen)
11. [Profile Screen](#11-profile-screen)
12. [Edit Profile](#12-edit-profile)
13. [Settings](#13-settings)
14. [Notifications](#14-notifications)
15. [Knowledge Base](#15-knowledge-base)
16. [Support Tickets](#16-support-tickets)
17. [Tour System](#17-tour-system)
18. [Error Scenarios & Edge Cases](#18-error-scenarios--edge-cases)
19. [UI / UX & Theme](#19-ui--ux--theme)
20. [End-to-End Happy Path](#20-end-to-end-happy-path)

---

## 1. Authentication

### 1.1 Phone Screen

- [ ] App opens on phone screen when unauthenticated and onboarding is done
- [ ] App opens on onboarding screen when onboarding has not been seen
- [ ] Country picker opens and displays a searchable list of countries
- [ ] Selecting a country updates the dial code displayed next to the phone field
- [ ] Default country is Austria (+43)
- [ ] Submitting an empty phone number shows a validation error — no API call made
- [ ] Submitting a valid phone number calls `POST /auth/otp/request/` with the correct formatted number
- [ ] Loading spinner shown on the button during the API call
- [ ] On success, app navigates to OTP screen and passes the phone number
- [ ] Network error shows a retry-able error message

### 1.2 OTP Screen

- [ ] Correct phone number is displayed at the top
- [ ] "Change number" link navigates back to phone screen
- [ ] Submitting empty OTP shows a validation error — no API call made
- [ ] Submitting a valid 6-digit OTP calls `POST /auth/otp/verify/` with `{phone, code}`
- [ ] If `isNewUser = true`, navigates to `/application`
- [ ] If `isNewUser = false`, navigates to `/home`
- [ ] Invalid OTP shows the backend error message
- [ ] Resend button is disabled for 30 seconds after arrival on screen
- [ ] Countdown timer counts down visibly from 30
- [ ] At 0, resend button becomes tappable
- [ ] Tapping resend calls `POST /auth/otp/request/` again and resets the 30-second countdown
- [ ] `debugOtp` in the response pre-fills or logs the OTP for test environments

### 1.3 Token Management

- [ ] After successful OTP verify, access and refresh tokens are stored in secure storage
- [ ] API requests include `Authorization: Bearer <access_token>` header
- [ ] A 401 response triggers an automatic token refresh via `POST /auth/token/refresh/`
- [ ] After refresh, the original failed request is retried automatically
- [ ] If refresh fails, all tokens are cleared and user is redirected to phone screen
- [ ] Logout calls `POST /auth/token/blacklist/` and clears all tokens and cached data
- [ ] After logout, navigating back (OS back gesture) does not reopen protected screens

---

## 2. Driver Registration

### 2.1 Step 1 — Personal Info

- [ ] Name field and birthdate picker are visible
- [ ] Submitting with an empty name shows "Please enter your name"
- [ ] Submitting with no birthdate selected shows "Please enter age"
- [ ] Selecting a birthdate that results in age < 18 shows "Invalid age"
- [ ] Selecting a birthdate that results in age > 65 shows "Invalid age"
- [ ] Selecting a birthdate with age 18–65 allows advancing to step 2
- [ ] "Next" button does not fire an API call — it is purely local navigation

### 2.2 Step 2 — Vehicle Type

- [ ] All four options are shown: Bike, Motorcycle, Car, Van
- [ ] Default selected option is Car
- [ ] Tapping another option visually deselects the previous and selects the new one
- [ ] "Next" advances to step 3, "Back" returns to step 1

### 2.3 Step 3 — Vehicle Details

- [ ] Car size dropdown shows exactly 4 options: X, Comfort, XL, Black
- [ ] Advancing without selecting a car size shows "Please select car size"
- [ ] Advancing with an empty plate number shows "Please enter plate number"
- [ ] Advancing with an empty vehicle color shows the appropriate validation error
- [ ] Make, model, and year fields are optional — no error if blank
- [ ] All entered values persist if user goes back to a previous step and returns

### 2.4 Step 4 — Service Acceptance

- [ ] Food delivery toggle is ON by default
- [ ] Taxi and Shipping toggles are OFF by default
- [ ] Each toggle can be independently turned on/off
- [ ] Advancing with all toggles OFF shows a validation error (at least one required)
- [ ] Any single toggle ON allows advancing to step 5

### 2.5 Step 5 — Document Upload

- [ ] Six document upload fields are displayed: Driving License, ID, Health Insurance, Address, Bank Document, Other
- [ ] Tapping an upload button opens the native image picker
- [ ] After selecting an image, an upload-in-progress indicator is shown
- [ ] After upload, the button changes state to indicate completion (shows URL or check)
- [ ] Two uploads cannot be triggered simultaneously on the same field
- [ ] Submitting without required documents (Driving License, ID) shows an error
- [ ] With required documents uploaded, the Submit button calls `POST /driver/profile/`
- [ ] On success with `status = PENDING`, app navigates to `/pending-approval`
- [ ] On success with an approved status, app navigates to `/home`
- [ ] Upload failure shows an error with a retry option
- [ ] Back button from step 5 returns to step 4 without losing entered data

### 2.6 Pending Approval Screen

- [ ] Screen correctly displays that the application is under review
- [ ] No action buttons are available (user cannot proceed further)
- [ ] Logout is still accessible from this screen

---

## 3. Home Screen — Online Toggle

### 3.1 Going Online — Success

- [ ] Toggle starts in the correct state matching the backend value on screen load
- [ ] Tapping to go online checks location permission before calling the API
- [ ] With permission granted, `getCurrentLocation()` is called
- [ ] Initial location is sent to the backend
- [ ] `POST /drivers/toggle-online/` is called with `{isOnline: true}`
- [ ] On success, continuous location tracking starts
- [ ] Order polling starts (15-second interval)
- [ ] UI updates to show "Online" state

### 3.2 Going Offline — Success

- [ ] `POST /drivers/toggle-online/` is called with `{isOnline: false}`
- [ ] Location tracking stops
- [ ] Order polling stops
- [ ] UI updates to show "Offline" state

### 3.3 Going Online — Location Failures

- [ ] Location permission DENIED → shows dialog explaining why and offers "Open Settings"
- [ ] Location permission DENIED_FOREVER → shows dialog with "Open App Settings" button
- [ ] Location services DISABLED → shows dialog with "Open Location Settings" button
- [ ] `getCurrentLocation()` timeout → shows error "Unable to get your current location", stays offline
- [ ] In all failure cases, the toggle reverts to offline, no API call is made

### 3.4 Going Online — Account Not Verified

- [ ] If `isVerified = false`, tapping toggle shows an error: "Your account is not verified"
- [ ] No API call is made

### 3.5 Location Tracking While Online

- [ ] Continuous location updates are sent to the backend as position changes
- [ ] A forced location update is sent every 5 minutes regardless of movement
- [ ] Location permission is checked every 30 seconds while online
- [ ] If permission is revoked while online, a warning is shown to the driver

---

## 4. New Order Arrival

### 4.1 Polling

- [ ] When online, `GET /drivers/suggested-orders/` is called every 15 seconds
- [ ] When offline, polling does not occur
- [ ] Empty response clears any displayed pending order card

### 4.2 Order Card Display

- [ ] New order card slides in with animation and fade (approx 500 ms)
- [ ] Card has a glowing border animation for ~6 seconds
- [ ] Device vibrates with a double haptic pattern on card arrival
- [ ] Card shows: pickup name/address, dropoff address, customer name, order type icon
- [ ] Card shows: distance (formatted to 1 decimal, e.g. "2.4 km")
- [ ] Card shows: estimated time (e.g. "12 min")
- [ ] Card shows: items list with quantity and name
- [ ] Card shows: delivery fee, tip (if any), total
- [ ] Card shows: payment type (Cash / Card)
- [ ] Restaurant name is shown for FOOD orders

### 4.3 JSON Parsing Resilience

- [ ] Order parses correctly when items are under `items` key
- [ ] Order parses correctly when items are under `order_items` key
- [ ] Order parses correctly when items are under `line_items` key
- [ ] Pickup/dropoff parses when provided as nested address object
- [ ] Pickup/dropoff parses when provided as a plain string
- [ ] Distance is used from API if provided; Haversine calculated if missing
- [ ] Minimum distance capped at 0.5 km if Haversine result is below threshold
- [ ] Estimated minutes used from API if provided; calculated as `(dist/25)*60+5` if missing
- [ ] Minimum estimated time capped at 5 minutes

---

## 5. Order Acceptance & Rejection

### 5.1 Acceptance — Happy Path

- [ ] Tapping "Accept" shows a loading state on the button
- [ ] `POST /drivers/accept-order/` is called with the correct `order_id`
- [ ] On success: pending order card is dismissed, active order is set, app navigates to orders screen

### 5.2 Acceptance — Error Cases

- [ ] 409 response → shows "Order already taken by another driver", pending order cleared
- [ ] 403 response → shows "Order suggestion expired", pending order cleared
- [ ] 404 response → shows "Order not found", pending order cleared
- [ ] Network error → shows retry option, pending order card remains visible

### 5.3 Rejection

- [ ] Tapping "Skip" immediately dismisses the order card (optimistic)
- [ ] `POST /drivers/reject-order/` is called with the `order_id`
- [ ] API error on rejection is silently ignored (order is gone anyway)

---

## 6. Order Lifecycle — Status Transitions

### 6.1 ACCEPTED → ON_THE_WAY

- [ ] "Start Delivery" button is shown when order status is ACCEPTED
- [ ] Tapping calls `POST /drivers/update-order-status/` with `{order_id, status: ON_THE_WAY}`
- [ ] On success: order status in UI updates to ON_THE_WAY, button changes to "Arrived"
- [ ] On failure: error message shown, order stays in ACCEPTED

### 6.2 ON_THE_WAY → DELIVERED

- [ ] "Arrived" button is shown when order status is ON_THE_WAY
- [ ] Tapping calls `POST /drivers/update-order-status/` with `{order_id, status: DELIVERED}`
- [ ] On success: order status updates to DELIVERED, button changes to "Complete"
- [ ] On failure: error message shown, order stays in ON_THE_WAY

### 6.3 DELIVERED → COMPLETED

- [ ] "Complete" button is shown when order status is DELIVERED
- [ ] Tapping calls `POST /drivers/update-order-status/` with `{order_id, status: COMPLETED}`
- [ ] On success: `activeOrder` is cleared
- [ ] Completed order is prepended to order history list
- [ ] `totalOrders` increments by 1
- [ ] `totalEarnings` increments by `(deliveryFee + tip)` for that order
- [ ] Earnings screen reflects updated totals without a manual refresh
- [ ] If backend returns "already completed" (idempotent): UI treated as success, no error shown
- [ ] On failure (non-idempotent): error message shown, order stays in DELIVERED

### 6.4 Rapid Taps / Double Submit

- [ ] Tapping a status button twice quickly does not send duplicate API calls
- [ ] Button is disabled or shows loading after first tap

---

## 7. Navigation / Map Screen

### 7.1 Screen Load

- [ ] Accessible via `/navigation/:orderId`
- [ ] Order is loaded from active order, pending order, or history (in that priority)
- [ ] If order not found, an error state is shown

### 7.2 Target Selection Based on Status

- [ ] ACCEPTED / PENDING → target is the **pickup** location
- [ ] ON_THE_WAY / DELIVERED / COMPLETED → target is the **dropoff** location

### 7.3 Map & Route Display

- [ ] Driver's current position is shown as a marker
- [ ] Pickup location is shown as a marker
- [ ] Dropoff location is shown as a marker
- [ ] A route polyline is drawn from driver to target using OSRM
- [ ] Current turn instruction is shown as text
- [ ] Distance remaining is displayed
- [ ] Estimated time remaining is displayed
- [ ] Map auto-fits bounds to show the full route
- [ ] Map and markers update as driver position changes

### 7.4 GPS / Location Failure

- [ ] GPS unavailable → map falls back to pickup location coordinates
- [ ] "Location unavailable" message is displayed to the driver
- [ ] OSRM route fetch failure → show error, allow retry

---

## 8. Order Detail Screen

### 8.1 Content Display

- [ ] Full pickup address (name, street, city) is shown
- [ ] Full dropoff address (street, city) is shown
- [ ] Customer name and phone are shown
- [ ] Items list with quantity and name is shown
- [ ] Customizations (if any) are shown per item
- [ ] Subtotal, delivery fee, tip, and total are shown
- [ ] Real-time distance to the current target is displayed and updates as driver moves

### 8.2 Payment Type Banner

- [ ] `CASH` order → banner: "Driver needs to collect cash from customer"
- [ ] `CARD` order → banner: "Payment already processed"
- [ ] No payment info → no banner displayed

### 8.3 Action Buttons

- [ ] "Call Customer" button opens a phone call to the customer number
- [ ] "Message Customer" button opens the SMS app to the customer number
- [ ] Correct status-action button is shown (see Section 6)
- [ ] Button is in a loading state during API call

---

## 9. Orders Screen (Tabs)

### 9.1 Active Orders Tab

- [ ] Shows orders with status ACCEPTED, ON_THE_WAY, or DELIVERED
- [ ] Empty state message shown when no active orders
- [ ] Tapping an order navigates to order detail screen

### 9.2 History Tab

- [ ] Shows orders with status COMPLETED or CANCELLED
- [ ] Empty state message shown when no history
- [ ] Tapping an order navigates to order detail screen (read-only)
- [ ] Orders are sorted newest-first

---

## 10. Earnings Screen

### 10.1 Stats Display

- [ ] Only COMPLETED orders are counted in totals (not ACCEPTED/ON_THE_WAY/DELIVERED)
- [ ] Total earnings = sum of `(deliveryFee + tip)` across all COMPLETED orders
- [ ] Total orders count matches number of COMPLETED orders
- [ ] Average per order = totalEarnings / totalOrders (shows 0 if no orders)
- [ ] "Today" total correctly filters by today's date
- [ ] "Last 7 days" total correctly filters the date range
- [ ] Currency values are formatted correctly (e.g., "€23.50")

### 10.2 Data Freshness

- [ ] Screen pulls latest data on open
- [ ] Data reflects orders completed in the current session without a manual refresh

---

## 11. Profile Screen

### 11.1 Content Display

- [ ] Driver name, phone, and star rating are shown
- [ ] Avatar displays profile image if set, or a default icon
- [ ] Vehicle details are shown: plate, make, model, year, color, car size
- [ ] Service acceptance icons (Food, Taxi, Shipping) shown correctly
- [ ] "Member since" formatted as "Mon YY" (e.g., "Jan 25")
- [ ] Verification status is visually indicated

### 11.2 Navigation

- [ ] "Edit Profile" button navigates to edit profile screen
- [ ] "Settings" button navigates to settings screen

---

## 12. Edit Profile

- [ ] All current profile values are pre-filled in the form
- [ ] Name, email, vehicle fields can be updated
- [ ] Birthdate picker respects the 18–65 age rule
- [ ] Service acceptance toggles can be changed
- [ ] Documents can be re-uploaded (same Cloudinary flow as registration)
- [ ] Save calls `PATCH /driver/profile/` with only the changed fields
- [ ] On success: profile data refreshes, user is returned to profile screen
- [ ] On failure: error shown, form data preserved

---

## 13. Settings

### 13.1 Language

- [ ] All 12 language options are listed with their flag emoji and name
- [ ] Selecting a language immediately updates all visible UI strings
- [ ] Language preference persists across app restarts
- [ ] RTL layout is applied correctly for Arabic

### 13.2 Theme

- [ ] Light/Dark toggle correctly flips the entire app theme
- [ ] Theme preference persists across app restarts
- [ ] All screens look correct in dark mode (sufficient contrast, no unreadable elements)

### 13.3 Notifications

- [ ] "Order Notifications", "Sound", and "Vibration" toggles are present
- [ ] Toggle states persist across app restarts

### 13.4 Tour

- [ ] Tour replay button is visible only when `totalOrders = 0`
- [ ] Tapping it starts the tour from the home screen
- [ ] Button is hidden once the driver has completed any order

### 13.5 Logout

- [ ] Logout calls `POST /auth/token/blacklist/`
- [ ] All tokens are cleared from secure storage
- [ ] All cached data is cleared (cache, provider state)
- [ ] Location tracking is stopped
- [ ] Order polling is stopped
- [ ] User is redirected to the phone screen
- [ ] OS back gesture from phone screen cannot return to protected screens

### 13.6 Delete Account

- [ ] Tapping shows a confirmation dialog with a warning that it is irreversible
- [ ] Cancelling the dialog does nothing
- [ ] Confirming calls `DELETE /me/`
- [ ] All local data is cleared (same as logout)
- [ ] User is redirected to phone screen

---

## 14. Notifications

### 14.1 List Display

- [ ] Notifications are grouped into: Today, Yesterday, Earlier
- [ ] Within each group, newest notification is at the top
- [ ] Unread count badge is shown on the screen title or icon
- [ ] Read notifications are visually distinct from unread ones

### 14.2 Actions

- [ ] Tapping a notification opens the relevant screen (if it has a deep link)
- [ ] Swipe action marks a single notification as read
- [ ] "Mark all as read" action works and updates the unread badge to 0

### 14.3 FCM Push Notifications

- [ ] On first launch (authenticated), device FCM token is registered via `POST /notifications/device`
- [ ] When the FCM token rotates, it is re-registered automatically
- [ ] A push notification received while the app is in the foreground is displayed (local notification or in-app banner)
- [ ] A push notification received in the background appears in the system tray
- [ ] Tapping the system notification opens the app and navigates to the correct screen

---

## 15. Knowledge Base

- [ ] Categories are loaded from the correct locale-specific JSON asset
- [ ] All categories and their articles are displayed
- [ ] Tapping a category expands its article list
- [ ] Tapping an article navigates to the detail screen with full content
- [ ] Search field filters articles by title and content in real time
- [ ] Clearing the search restores the full list
- [ ] Switching app language refreshes the KB content to the new locale

---

## 16. Support Tickets

### 16.1 Ticket List

- [ ] Tickets are fetched from `GET /support/tickets/` (paginated)
- [ ] Each ticket shows: subject, status chip, last message preview, and timestamp
- [ ] Status filter chips (All, Open, Pending, Resolved) correctly filter the list
- [ ] Scrolling near the bottom of the list loads the next page (infinite scroll)

### 16.2 Create Ticket

- [ ] FAB button opens the create ticket form
- [ ] Submitting with empty subject or description shows validation errors
- [ ] Submit calls `POST /support/tickets/` with subject and description
- [ ] On success: user is returned to ticket list, new ticket appears at the top

### 16.3 Ticket Detail

- [ ] Full message thread is displayed in chronological order
- [ ] Timestamps are shown per message
- [ ] Current ticket status is displayed
- [ ] Reply field is available when ticket is open
- [ ] Submitting a reply calls `POST /support/tickets/{id}/messages/`
- [ ] New reply appears in the thread immediately after submission

---

## 17. Tour System

### 17.1 Tour Trigger

- [ ] Tour starts automatically for a driver with 0 orders who has not previously seen it
- [ ] Tour does NOT start if `totalOrders > 0`
- [ ] Tour does NOT start again if it was previously completed
- [ ] Skipping is session-only: tour welcome card reappears on next cold start (until completed)
- [ ] Tour replay via Settings only visible when `totalOrders = 0`

### 17.2 Tour Flow (Stage by Stage)

- [ ] **Home stage**: Online toggle is highlighted with a coach mark and description
- [ ] **Order Acceptance**: Mock order card is injected; card is highlighted
- [ ] **Active Order**: Orders screen is shown with mock order in Active tab
- [ ] **Order Detail**: Order detail screen is shown with action button highlighted
- [ ] **Ongoing Trip**: Navigation/map screen is shown with a mock route
- [ ] **Orders tab**: Orders screen with tab highlighted
- [ ] **Earnings tab**: Earnings screen with totals highlighted
- [ ] **Profile tab**: Profile screen highlighted; tour completes

### 17.3 Tour Controls

- [ ] "Next" button advances each step
- [ ] "Skip" button exits the tour at any point
- [ ] After completion, a congratulations message is shown
- [ ] Tour flag is persisted: `isTourCompleted = true` after finishing
- [ ] All tour actions use mock data — no real API calls are made during the tour

---

## 18. Error Scenarios & Edge Cases

### 18.1 Network Errors

- [ ] Request timeout (>60 s) shows an error with a retry button
- [ ] Complete network loss shows an offline indicator
- [ ] Server 5xx response shows a generic "Something went wrong" error with retry
- [ ] Malformed JSON response does not crash the app — shows a generic error

### 18.2 Authentication Edge Cases

- [ ] Token expires mid-session → auto-refresh, user never sees a logout
- [ ] Refresh token is also expired → forced logout, user redirected to phone screen
- [ ] Two simultaneous 401 responses → only one refresh request is sent (queued interceptor)

### 18.3 Order Race Conditions

- [ ] Accepting an order just taken by another driver → 409, pending card cleared, correct message
- [ ] Accepting an order after suggestion expired → 403, pending card cleared, correct message
- [ ] Completing an order the backend already marked complete → treated as success (no error)
- [ ] Rapid double-tap on status button → only one API call sent

### 18.4 Location Edge Cases

- [ ] Permission revoked while online → warning shown, driver can re-enable from the app
- [ ] GPS signal lost while navigating → last known position held, "Location unavailable" shown
- [ ] Going online then immediately offline before location is fetched → no stale location state
- [ ] Location update arrives after going offline → update is discarded silently

### 18.5 Document Upload Edge Cases

- [ ] Upload fails mid-way → error shown, field returns to "Upload" state for retry
- [ ] User picks an unsupported file type → file picker or validation rejects it
- [ ] User picks a very large image → upload proceeds (progress indicator visible)

### 18.6 Localization Edge Cases

- [ ] Switching language while on a form screen does not lose entered data
- [ ] Dates and currency are formatted according to the selected locale
- [ ] All strings on all screens are translated (no hardcoded English visible when another language is selected)

---

## 19. UI / UX & Theme

### 19.1 Animations

- [ ] New order card slides in and fades in on arrival (~500 ms)
- [ ] New order card has a glowing border for ~6 seconds
- [ ] No janky or dropped frames during the order card animation
- [ ] Loading spinners appear promptly during all API calls

### 19.2 Bottom Navigation

- [ ] 4 tabs: Home, Orders, Earnings, Profile
- [ ] Active tab is visually highlighted
- [ ] Switching tabs is immediate (no noticeable lag)
- [ ] Tab state is preserved when switching between tabs (no full reload)

### 19.3 Dark Mode

- [ ] All text is readable against its background in dark mode
- [ ] All icons are visible in dark mode
- [ ] Input fields, cards, and dialogs use the correct dark surface colors
- [ ] Status chips (order status, ticket status) are readable in dark mode

### 19.4 Responsive Layout

- [ ] On a small screen (360 dp width) nothing overflows or clips
- [ ] On a large screen (414+ dp width) layout scales sensibly
- [ ] Landscape orientation does not break any screen layout
- [ ] Keyboard appearing does not push content off-screen unexpectedly

---

## 20. End-to-End Happy Path

> This is the **minimum release gate**. Every item must pass.

- [ ] **1. Launch**: App opens, shows onboarding (or phone screen if already seen)
- [ ] **2. Auth**: Enter phone → receive OTP → verify → navigate correctly (new vs returning user)
- [ ] **3. Registration** *(new user)*: Complete all 5 steps → upload at least 2 required documents → submit
- [ ] **4. Home**: Profile loads, online toggle is visible and in correct initial state
- [ ] **5. Go Online**: Toggle online → location permission granted → driver goes online → polling starts
- [ ] **6. Order Arrives**: After at most 15 s, a new order card appears with correct details
- [ ] **7. Accept**: Tap Accept → order accepted → navigate to orders screen, active tab shows the order
- [ ] **8. Start Delivery**: Open order detail → tap "Start Delivery" → status changes to ON_THE_WAY
- [ ] **9. Navigate**: Open map screen → route to pickup shown → driver marker visible
- [ ] **10. Mark Arrived**: Tap "Arrived" → status changes to DELIVERED
- [ ] **11. Complete**: Tap "Complete" → order moves to history, active tab is empty
- [ ] **12. Earnings**: Open earnings screen → total reflects the just-completed order
- [ ] **13. Profile**: Open profile screen → correct name, phone, rating displayed
- [ ] **14. Settings**: Open settings → change language → UI updates → change back
- [ ] **15. Go Offline**: Toggle offline → location tracking stops
- [ ] **16. Logout**: Tap logout → all data cleared → phone screen shown → back gesture blocked

---

*Generated by Claude Code based on full codebase analysis — 2026-04-03*
