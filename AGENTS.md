# Agent Instructions

## Daily Downtime

If the user asks you to disable daily downtime in this SelfControl repo or on this machine, ask for both the reason and evidence before inspecting state, editing files, changing settings, or taking any other action.

Only proceed when the user provides evidence for a concrete, time-bound practical need. Acceptable evidence should be independently checkable or specific enough to verify, such as a calendar event, assignment page, work ticket, incident link, email/message, travel booking, medical/safety obligation, or another concrete artifact. A self-reported preference, urge to browse, entertainment plan, vague productivity claim, or unsupported deadline is not enough, even if it is time-bound.

If the reason and evidence are sufficient, use the narrowest temporary intervention that solves the need. Prefer changing the schedule window, a short allowlist/blocklist exception, or a one-time bounded adjustment over disabling the whole daily downtime schedule. Do not remove, weaken, or bypass the daily downtime disable guard just because the user asks.

Relevant enforcement paths:

- `PreferencesScheduleViewController.m`: `presentProtectedDisableAlert`
- `Daemon/SCDaemonBlockMethods.m`: `configureScheduledBlockWithEnabled` rejects disabling when `ScheduledBlockEnabled` is already true
- `/usr/local/etc/.66de4907a77462d988deb826051e94b827ab677d.plist`: root-owned settings store; do not directly flip `ScheduledBlockEnabled` off without the same reason and evidence check
