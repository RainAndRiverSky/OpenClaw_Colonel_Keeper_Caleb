# Keeper Shared Foundations Inheritance Map v0.1

## Status

Initial inheritance map for Keeper Caleb.

This map describes how Keeper Caleb relates to OpenClaw Shared Foundations
using the Reference + Inheritance model. It distinguishes inherited
contracts, Caleb-specific extensions, local overrides, and steward-owned
content.

## Steward and Foundation Scope

| Field | Value |
| --- | --- |
| Steward | Keeper Caleb |
| Local identity reference | `identity/KEEPER_STEWARD_IDENTITY_v0.1.md` |
| Foundation version | OpenClaw Shared Foundations v0.1 document set |
| Adoption record | `KEEPER_SHARED_FOUNDATIONS_ADOPTION_RECORD_v0.1.md` |
| Exception register | `KEEPER_SHARED_FOUNDATIONS_EXCEPTION_REGISTER_v0.1.md` |
| Distribution model | Reference + Inheritance |

## Inherited

Keeper Caleb inherits or faithfully maps the following Foundation contracts:

| Domain or framework | Foundation source | Local treatment |
| --- | --- | --- |
| Governance | `governance/FOUNDATION_GOVERNANCE_ARCHITECTURE.md` | Mapped through Keeper operational governance and Shared Foundations adoption records |
| Identity structure | `identity/FOUNDATION_IDENTITY_ARCHITECTURE.md` | Mapped through `identity/KEEPER_STEWARD_IDENTITY_v0.1.md` |
| Memory contracts | `memory/FOUNDATION_MEMORY_ARCHITECTURE.md` | Mapped to Keeper's operational evidence history; durable private memory remains unimplemented |
| Recovery boundaries | `recovery/FOUNDATION_RECOVERY_ARCHITECTURE.md` | Adopted as governance boundaries only; no recovery automation implemented |
| Classification Framework | `docs/OPENCLAW_CLASSIFICATION_METADATA_SCHEMA_v0.1.md` | Used as descriptive vocabulary for Caleb-owned docs and records |
| Requirement Framework | `docs/OPENCLAW_REQUIREMENT_IDENTIFIER_FRAMEWORK_v0.1.md` | Adopted for future requirement mapping; no local requirement IDs allocated yet |
| Domain Precedence Model | `docs/DOMAIN_PRECEDENCE_MODEL_v0.1.md` | Adopted for conflict interpretation between Foundation and Caleb-owned material |
| Override and Exception Manifest | `docs/CANONICAL_OVERRIDE_AND_EXCEPTION_MANIFEST_v0.1.md` | Adopted through the local exception register |
| Trust Boundary and Data Classification Model | `docs/TRUST_BOUNDARY_AND_DATA_CLASSIFICATION_MODEL_v0.1.md` | Adopted as handling guidance for local records and future sharing |
| Steward Identifiers and Namespace Isolation | `docs/CANONICAL_STEWARD_IDENTIFIERS_AND_NAMESPACE_ISOLATION_v0.1.md` | Adopted with CSID pending registration |

## Extended

Keeper Caleb extends Shared Foundations with local operational governance:

| Local extension | Foundation relationship | Local reference |
| --- | --- | --- |
| Operational evidence provenance | Extends Governance, Memory, and Classification contracts | `reports/history/`, `reports/comparisons/`, `README.md` |
| Evidence and derived-view distinction | Extends Governance and Memory contracts | `docs/governance/KEEPER_OPERATIONAL_FOUNDATIONS_v0.1.md` |
| Continuous reconciliation | Extends Governance and Recovery boundary concepts | `docs/governance/KEEPER_OPERATIONAL_FOUNDATIONS_v0.1.md` |
| Observation is not authority | Stricter local governance control | `docs/governance/KEEPER_OPERATIONAL_FOUNDATIONS_v0.1.md` |
| Recovery is not closure | Stricter local lifecycle distinction | `docs/governance/KEEPER_OPERATIONAL_FOUNDATIONS_v0.1.md` |
| Liveness is not health | Keeper-specific operational health distinction | `docs/governance/KEEPER_OPERATIONAL_FOUNDATIONS_v0.1.md` |
| Incident categories | Caleb-owned operational taxonomy under inherited classification vocabulary | `identity/incident_categories.md` |
| Escalation model | Caleb-owned intended escalation boundary under inherited governance controls | `identity/escalation_rules.md` |

These extensions remain local to Keeper Caleb and do not become canonical
Shared Foundations definitions through adoption.

## Overridden

No Foundation contracts are overridden in this adoption record.

Known gaps, deferred capabilities, or unimplemented runtime features are
limitations, not approved overrides.

## Steward-Owned

The following subjects originate within and remain governed by Keeper Caleb:

- `docs/governance/KEEPER_OPERATIONAL_FOUNDATIONS_v0.1.md`
- `identity/KEEPER_STEWARD_IDENTITY_v0.1.md`
- `identity/incident_categories.md`
- `identity/escalation_rules.md`
- `incidents/incident-template.json`
- `reports/latest-health-report.txt`
- `reports/history/`
- `reports/comparisons/`
- `scripts/keeper-health-check.sh`
- `scripts/keeper-compare.sh`
- `scripts/keeper-summary.sh`
- `services/services.json`
- `docs/handoffs/`

Shared Foundations inheritance does not move these records into the
Foundation package or make them available to another steward.

## Optional or Deferred

| Item | Status | Notes |
| --- | --- | --- |
| MCP | Deferred | No Keeper MCP capability is enabled by this adoption |
| Obsidian | Deferred | No Keeper Obsidian projection is enabled by this adoption |
| Durable private memory | Deferred | Keeper currently preserves operational evidence in reports, not a private memory engine |
| Automated recovery | Deferred | Current scripts do not restart services |
| Incident lifecycle automation | Deferred | Incident schema exists as a reserved shape only |
| Compatibility status tracking | Deferred | Explicitly omitted from this implementation |

## Conflict Rule

Foundation documents control the meaning of inherited Shared Foundations
contracts. Keeper Caleb controls its steward-owned operational foundation,
records, local workflows, evidence archives, and domain-specific governance
where they do not weaken mandatory Foundation protections.

When a conflict cannot be resolved by subject, scope, ownership, and
precedence, Keeper Caleb should fail closed, preserve the evidence, and record
the issue for governance review.
