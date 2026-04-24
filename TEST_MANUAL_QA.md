# IronM Manual QA Checklist

## ONBOARDING FLOW
- [ ] **Fresh install:** Onboarding screen shown correctly.
- [ ] **Setup:** Complete setup with gym name and owner name redirects to PIN setup.
- [ ] **PIN Setup:** Set PIN redirects to dashboard.
- [ ] **Re-launch:** App shows PIN lock screen on relaunch.
- [ ] **Unlock:** Correct PIN unlocks the dashboard.
- [ ] **Lockout:** Enter wrong PIN 3-5 times; verify lockout timer or severe failure behavior (wipe after 10).

## MEMBER LIFECYCLE
- [ ] **Add Member:** Add a member with a selected plan; verify they appear in the list with "ACTIVE" status.
- [ ] **Expiring Status:** Add/Edit a member with `expiryDate` set to today; status should show "0 days" or "EXPIRING".
- [ ] **Expired Status:** Verify member shows "EXPIRED" in red the day after their expiry date.
- [ ] **Archiving:** Archive a member; verify they disappear from "Active/Expiring/Expired" tabs but exist in raw data.
- [ ] **Renewal:** Renew an expired member; verify new `expiryDate` is set (e.g., +1 month) and status returns to "ACTIVE".
- [ ] **Editing:** Edit member details (name/phone); verify updates reflect in lists, detail screens, and invoices.
- [ ] **Deletion:** Delete a member; verify they are removed from all lists (payments should remain for accounting).

## PAYMENT & INVOICE
- [ ] **Incremental Invoices:** Record 2 payments; verify invoice numbers are sequential (e.g., GYM-00001, GYM-00002).
- [ ] **Settings Sync:** Change Gym Name/GSTIN in Settings; verify new invoices reflect changes immediately.
- [ ] **Invoice Period:** Verify invoice shows correct period (Date to ExpiryDate).
- [ ] **GST Math:** Subtotal + GST Amount should exactly equal the Total Amount.
- [ ] **Payment List:** Record a payment and verify it appears in the Payments screen with the correct member name and MTD total.

## ATTENDANCE
- [ ] **Marking:** Mark attendance for a member today; verify they appear in the "Today" list.
- [ ] **Date Strip:** Tap different dates in the 7-day strip; verify the list filters correctly.
- [ ] **Validation:** Search for a member in check-in; verify expired members are filtered out by default.
- [ ] **Duplicate Check:** (Optional) Check if a member can be checked in twice and if that's intended.

## SETTINGS
- [ ] **Plan Management:** Add a new plan; verify it appears in the Quick Add plan selector.
- [ ] **Plan Deletion:** Delete a plan; verify it is removed from selection but doesn't affect existing payment records.
- [ ] **Bank Details:** Update bank details; verify they appear in the invoice footer.

## DATA SAFETY & EDGE CASES
- [ ] **Force Stop:** Kill app mid-save; verify data integrity on relaunch.
- [ ] **Scale:** Add 50+ members; verify list scrolling is smooth and dashboard stats are correct.
- [ ] **Backup/Restore:** Initiate backup, then restore from the file; verify all data (members, payments, attendance) is intact.
- [ ] **Special Characters:** Save member with name "Rāj Kumar"; verify no UI crashes.
- [ ] **Empty Fields:** Save member with blank phone; verify it saves and shows "No Phone".
- [ ] **Zero Price:** Plan with ₹0 price doesn't cause division errors.
- [ ] **Month Overflow:** 1-month plan starting Jan 31 results in Feb 28 expiry.
- [ ] **Offline Mode:** Use app without internet for several days; verify all core features work.
