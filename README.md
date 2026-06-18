# OpenClaw Keeper

Keeper is OpenClaw's operational steward. It observes approved service state,
records operational evidence, preserves history, compares observations over
time, and makes service lifecycle changes visible.

Keeper is intentionally evidence-first. The current repository provides a
small shell-based operational foundation; it does not contain an AI reasoning
layer, severity engine, incident automation, autonomous recovery, or runtime
integration.

## Purpose

Keeper exists to preserve trustworthy operational awareness across the
OpenClaw ecosystem.

Its current responsibilities are to:

- observe whether selected services appear online or offline
- write a current health report
- preserve timestamped historical health evidence
- compare the two newest historical reports
- identify services that were added or removed
- detect `ONLINE` and `OFFLINE` status transitions
- archive comparison conclusions with references to their source reports
- summarize the size and latest entry of its health history
- preserve accountability through explicit evidence and governance boundaries

Keeper's role is operational stewardship, not unrestricted operational
authority. Observation does not grant permission to act, a detected recovery is
not the same as closure, and a liveness result is not proof of complete service
health.

## Core Capabilities

The capabilities below are implemented in the current repository.

### Historical Memory

Each health-check run creates a timestamped report under
`reports/history/`. These records preserve what Keeper observed at a particular
time rather than retaining only the latest result.

`scripts/keeper-summary.sh` reports:

- the total number of historical report files
- the newest report filename

### Evidence Archive

Keeper maintains two evidence layers:

- health observations in `reports/history/`
- comparison conclusions in `reports/comparisons/`

Comparison archives identify the latest and previous source reports when that
metadata is available. This preserves the basis for each comparison conclusion
and supports later review.

### Change Identification

`scripts/keeper-compare.sh` extracts service names from the two newest
historical reports and identifies:

- services present only in the latest report
- services present only in the previous report

New and removed services remain separate from status changes, preventing a
newly observed service from being incorrectly reported as a lifecycle
transition.

### Status Detection

The comparison workflow builds a `Service=STATUS` map for each source report.
For services present in both reports, it records transitions where the status
changed, such as:

```text
OpenClaw Runtime
OFFLINE → ONLINE
```

The current health workflow observes:

| Service | Current check |
| --- | --- |
| OpenClaw Runtime | Whether a configured runtime process is observable |
| OpenClaw Scheduler | Whether a configured scheduler process is observable |
| OpenClaw Communications | Whether a configured communications process is observable |
| Keeper | Reported online by the executing health-check script |

These are narrow operational observations. They do not establish readiness,
correctness, capacity, or complete service health.

### Operational Stewardship

Keeper currently supports stewardship by:

- keeping current state distinct from historical evidence
- preserving material observations and comparison results
- exposing additions, removals, and status transitions
- retaining uncertainty and operational boundaries in its governance
  foundation
- maintaining incident categories and escalation rules as identity artifacts

The incident schema and escalation rules are governance foundations only.
Keeper does not currently create incidents, classify severity, restart
services, request analysis, or prepare repair packages automatically.

### Governance Foundations

Keeper's current governance foundation is
[`docs/governance/KEEPER_OPERATIONAL_FOUNDATIONS_v0.1.md`](docs/governance/KEEPER_OPERATIONAL_FOUNDATIONS_v0.1.md).

It defines enduring principles for:

- operational stewardship
- authoritative evidence and derived views
- explicit operational state
- change and lifecycle visibility
- accountability
- multidimensional health governance
- failure classification
- continuous reconciliation
- governance boundaries

Its foundational statement is:

> Keeper watches carefully, records faithfully, distinguishes clearly,
> reconciles continuously, and preserves accountability.

### Shared Foundations Inheritance

Keeper Caleb adopts OpenClaw Shared Foundations as a governance and
compatibility layer using the Reference + Inheritance model.

The Shared Foundations adoption records are under
[`docs/governance/shared-foundations/`](docs/governance/shared-foundations/).
They reference the canonical Shared Foundations repository rather than copying
Foundation documents into this repository.

Shared Foundations inheritance does not replace
`KEEPER_OPERATIONAL_FOUNDATIONS_v0.1.md`, grant runtime authority, enable
incident automation, authorize recovery actions, enable MCP or Obsidian, or
permit cross-steward sharing. Keeper-specific governance, operational
evidence, scripts, reports, and service records remain Caleb-owned.

## Repository Structure

```text
OpenClaw_Operations_Keeper_Bot/
├── docs/
│   ├── governance/        Operational governance foundations
│   │   └── shared-foundations/
│   │                       Shared Foundations adoption and inheritance records
│   └── handoffs/          Historical milestone and maturity records
├── failure-patterns/      Reserved for recurring failure knowledge
├── health-history/        Reserved historical health area
├── identity/              Steward identity, incident categories, and escalation boundaries
├── incidents/             Incident record schema
├── reports/
│   ├── comparisons/       Archived change reports
│   ├── history/           Timestamped health reports
│   └── latest-health-report.txt
├── scripts/
│   ├── keeper-health-check.sh
│   ├── keeper-compare.sh
│   └── keeper-summary.sh
├── services/
│   └── services.json      Descriptive service registry
└── README.md
```

### Major Directories

`docs/governance/` contains the active operational governance foundation.
`docs/governance/shared-foundations/` contains Caleb-owned records that map
Keeper to OpenClaw Shared Foundations without copying canonical Foundation
documents.

`docs/handoffs/` preserves project decisions, completed milestones, validation
results, maturity assessments, and approved next-step candidates.

`identity/` defines Keeper Caleb's local steward identity, incident
classification vocabulary, and escalation model. These files describe intended
governance boundaries; their recovery and escalation actions are not
implemented by the current scripts.

`incidents/` contains the JSON shape reserved for future incident records. No
incident instances are currently generated.

`reports/history/` is the authoritative archive of timestamped health
observations used by the comparison workflow.

`reports/comparisons/` stores conclusions derived from pairs of historical
health reports.

`scripts/` contains the active operational workflows. Files with names such as
`.before-keeper` or `.phase2a4b-backup` are historical backups, not active
entry points.

`services/services.json` records the currently recognized service inventory
and service-check metadata. The active health-check script currently defines
its checks directly and does not load this file dynamically.

`failure-patterns/` and `health-history/` are currently empty and do not
provide active capabilities.

## Operational Workflows

Run the scripts from the repository root because they use repository-relative
paths.

### Requirements

- Bash with process-substitution support
- standard Unix utilities: `awk`, `comm`, `find`, `grep`, `join`, `ls`,
  `pgrep`, `sed`, `sort`, `tee`, and `tr`
- `lsof` when port-based observations are configured

### Health Checks

Run:

```bash
./scripts/keeper-health-check.sh
```

The script:

1. records the current timestamp
2. observes the configured port and process signals
3. writes the complete result to `reports/latest-health-report.txt`
4. writes the same result to
   `reports/history/health-YYYYMMDD-HHMMSS.txt`
5. prints the report to the terminal

The latest report is a replaceable current view. The timestamped history file
is the preserved evidence for that run.

### Comparison Workflow

Run:

```bash
./scripts/keeper-compare.sh
```

The script selects the two newest `reports/history/*.txt` files and:

1. records both source paths
2. extracts each report's service inventory
3. identifies new services
4. identifies removed services
5. aligns shared services by name
6. detects status changes
7. prints the change report
8. archives it as
   `reports/comparisons/comparison-YYYYMMDD-HHMMSS.txt`

If fewer than two historical reports exist, the script records that there is
not enough evidence to compare and exits without claiming a change result.

### Report Generation

Health reports use this form:

```text
=== Keeper Health Check ===
Time: YYYY-MM-DD HH:MM:SS

[Service]
STATUS: ONLINE

=== End Report ===
```

Comparison reports contain:

- source report references
- `NEW SERVICES`
- `REMOVED SERVICES`
- `STATUS CHANGES`

The repository includes historical examples under `reports/history/` and
`reports/comparisons/`.

### Evidence Preservation

Keeper separates replaceable views from durable evidence:

- `reports/latest-health-report.txt` is the latest operational view
- `reports/history/` preserves individual observations
- `reports/comparisons/` preserves derived change conclusions

Historical records should not be edited to make newer conclusions appear
older. Corrections should retain the fact that reconciliation occurred and
should not erase material history.

### Status Change Detection

Status transitions are evaluated only for services present in both source
reports. A service found only in the latest report is classified as new; a
service found only in the previous report is classified as removed.

The workflow currently compares literal status values from the report format.
It does not determine severity, cause, required action, or incident status.

### History Summary

Run:

```bash
./scripts/keeper-summary.sh
```

This prints the number of files in `reports/history/` and the newest report
filename. It is an archive summary, not an analytical health assessment.

## Governance

Keeper operates under the principles in
[`KEEPER_OPERATIONAL_FOUNDATIONS_v0.1.md`](docs/governance/KEEPER_OPERATIONAL_FOUNDATIONS_v0.1.md).
The foundation treats operational knowledge as a governed asset and requires
Keeper to:

- distinguish evidence from interpretation
- keep authoritative evidence separate from derived views
- make state and lifecycle transitions inspectable
- preserve accountability for material operational matters
- disclose uncertainty and unresolved conditions
- avoid treating silence as evidence of health or resolution
- distinguish recovery from closure
- reconcile current understanding with authoritative evidence

Supporting governance artifacts include:

- [`identity/KEEPER_STEWARD_IDENTITY_v0.1.md`](identity/KEEPER_STEWARD_IDENTITY_v0.1.md)
  for the Caleb-owned steward identity spine
- [`identity/incident_categories.md`](identity/incident_categories.md) for the
  current failure-classification vocabulary
- [`identity/escalation_rules.md`](identity/escalation_rules.md) for intended
  escalation boundaries
- [`incidents/incident-template.json`](incidents/incident-template.json) for
  the reserved incident record shape
- [`docs/governance/shared-foundations/`](docs/governance/shared-foundations/)
  for Shared Foundations adoption, inheritance, and exception records
- [`docs/handoffs/`](docs/handoffs/) for milestone evidence and maturity
  decisions

Keeper's governance role is to preserve trustworthy operational awareness. It
does not convert observation into decision authority, and it does not govern
discovery or commerce.

Shared Foundations provides shared architecture, classification, precedence,
namespace, exception, and inheritance contracts. Keeper Caleb inherits those
contracts by reference while preserving independent operational governance.

## OpenClaw Ecosystem

The current governance structure identifies three independent and
complementary responsibilities:

| Identity | Governance responsibility |
| --- | --- |
| Xavier | Discovery Governance |
| Keeper | Operational Governance |
| Zayne | Commerce Governance |

Xavier governs discovery concerns. Keeper governs operational awareness,
evidence, state, lifecycle, and accountability. Zayne governs commerce
concerns.

These identities remain independent. Their responsibilities complement one
another, but evidence or conclusions from one domain do not automatically
grant authority in another.

## Current Status

Keeper has completed the following foundations:

| Foundation | Status |
| --- | --- |
| Historical Memory | Implemented |
| Evidence Archive | Implemented |
| Change Identification | Implemented |
| Status Detection | Implemented |
| Operational Stewardship | Defined |
| Governance Foundations | Established |
| Shared Foundations adoption | Documented through Reference + Inheritance |
| Operational Foundations acceptance readiness | Ready for review |
| Runtime responsibility discovery | Not yet completed |

The implemented maturity path is:

```text
Observe
  → Record
  → Remember
  → Summarize
  → Monitor Ecosystem
  → Compare History
  → Identify New Services
  → Identify Removed Services
  → Archive Comparison Evidence
  → Detect Status Changes
  → Archive Operational State Transitions
```

The latest governance handoff assesses the operational foundation as strong,
identity-consistent, bounded, and ready for acceptance review. The repository
is currently an early operational foundation rather than a complete runtime
service.

Current non-capabilities include:

- severity classification
- automatic incident creation or lifecycle management
- cause analysis
- automated recovery
- AI reasoning
- Shared Foundations compatibility status tracking
- runtime interaction with Xavier or Zayne
- dynamic execution from the service registry

## Roadmap

The current roadmap is limited to the items already identified in the latest
governance handoff.

### Operational Foundations Acceptance Review

Create and conduct the formal acceptance review for
`KEEPER_OPERATIONAL_FOUNDATIONS_v0.1.md`.

### Acceptance Actions

Record and resolve actions produced by the operational-foundations acceptance
review.

### Governance Status Tracking

Create a governed status record for Keeper's foundation, acceptance state, open
actions, and unresolved governance matters.

### Shared Foundations Compatibility Status Tracking

Create a governed status record for Caleb's Shared Foundations compatibility
assessment when that work is explicitly approved. The current integration
documents adoption, inheritance, and exceptions only.

### Runtime Integration Reconnaissance

Investigate Keeper's actual responsibilities inside the future OpenClaw
runtime, including observable events, consumed data, generated reports,
permissions, escalation responsibilities, and interactions with Xavier and
Zayne.

This is a runtime-capability investigation, not approval for implementation or
governance expansion.

## Contributing

Future maintainers should keep changes small, evidence-based, and consistent
with Keeper's operational boundaries.

### Before Changing Behavior

1. Read the operational foundation under `docs/governance/`.
2. Review the Shared Foundations adoption records under
   `docs/governance/shared-foundations/` when the change affects governance,
   identity, inheritance, classification, or cross-steward boundaries.
3. Review the relevant milestone records under `docs/handoffs/`.
4. Inspect the active script and its current report examples.
5. Confirm whether the change affects authoritative evidence, a current view,
   or a derived comparison.
6. Back up the active file before risky edits.

The established maintenance discipline is:

```text
Inspect → Backup → Patch → Verify → Run → Verify Again
```

### Validation

At minimum, validate active shell scripts without executing service checks:

```bash
bash -n scripts/keeper-health-check.sh
bash -n scripts/keeper-compare.sh
bash -n scripts/keeper-summary.sh
```

When behavior changes, use controlled report fixtures or deliberate local
conditions and verify:

- current report formatting
- creation of a timestamped health record
- new and removed service classification
- status-transition classification
- comparison source metadata
- archived comparison output
- unchanged historical evidence

Do not claim a capability is complete because a script parses. Confirm the
result through the real repository workflow and preserve the validation
evidence.

### Contribution Boundaries

- Do not introduce unrelated refactors.
- Do not edit historical reports to fabricate validation.
- Do not describe planned incident, recovery, severity, reasoning, or runtime
  behavior as implemented.
- Keep Xavier, Keeper, and Zayne responsibilities independent.
- Update governance or handoff documentation when a material capability or
  boundary actually changes.
- Preserve executable permissions on active scripts.
