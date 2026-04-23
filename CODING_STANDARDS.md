# IronBook G Coding Standards

### Rule 1 — const constructors everywhere
// ✅ Good — const = compiled once, never rebuilt
const Text('Members')
const SizedBox(height: 16)
const Icon(Icons.person)

// ❌ Bad
Text('Members')
SizedBox(height: 16)

### Rule 2 — No logic in build()
// ✅ Good — logic in ViewModel
Widget build(BuildContext context, WidgetRef ref) {
  final members = ref.watch(membersViewModelProvider);
  return MemberList(members: members.valueOrNull ?? []);
}

// ❌ Bad
Widget build(BuildContext context) {
  final filtered = allMembers.where((m) => m.isActive).toList(); // DON'T
  return ...;
}

### Rule 3 — Split large widgets
Any widget over 80 lines must be split into smaller widgets. This prevents the cascade-of-bugs issue.

### Rule 4 — Never use setState for shared data
// ✅ Good — Riverpod handles shared state
ref.watch(membersViewModelProvider)

// ❌ Bad — setState only for truly local UI state (animations, toggles)
setState(() { members = newList; }) // NEVER for data

### Rule 5 — Always handle AsyncValue states
// Every Riverpod stream/future MUST have all 3 states:
asyncValue.when(
  loading: () => const CircularProgressIndicator(),
  error: (e, s) => ErrorView(message: e.toString()),
  data: (data) => YourWidget(data: data),
);
