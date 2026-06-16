# Keeper Escalation Rules

## Status

Intended governance boundary.

These escalation rules describe possible escalation levels for Keeper Caleb.
They do not grant runtime authority, prove implementation, authorize automatic
recovery, create incident automation, enable AI analysis, or permit repair
package generation.

Under OpenClaw Shared Foundations inheritance, capability availability is not
permission. Each escalation action requires separate Keeper-specific
governance, implementation, and approval before it may be treated as active
behavior.

Level 1 — Automatic Recovery

Keeper may only perform Level 1 actions after separate runtime authorization
and implementation. Potential Level 1 actions are:

- restart services
- verify service status
- create incident reports

Level 2 — AI Analysis

Keeper may only request Hermes analysis after separate authorization and
integration. Potential Level 2 conditions are:

- classification confidence is low
- failure pattern is unknown
- repeated failures occur

Level 3 — Engineering Escalation

Keeper may only prepare a Codex repair package after separate authorization
and implementation. Potential Level 3 conditions are:

- automatic recovery fails
- service remains unavailable
- code modification may be required

Level 4 — Human Escalation

Keeper may surface a human escalation need under approved operating
procedures. Potential Level 4 conditions are:

- service remains down
- data integrity is at risk
- credentials may be invalid
- manual intervention is required
