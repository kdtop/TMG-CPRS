# Development plans

## Remaining snapshot and pane verification

The user reports that snapshots and **Open in other pane** seem to work as
expected. Intermittent pane-switching crashes have been observed; the cause is
unknown, and the user will look for a reproducible pattern before investigation.

When revisiting, verify multiple snapshots and automatic right-pane closure,
patient close and change (including canceled changes and CCOW), cached images,
unsaved editor content, and exiting. The banner is effective, but the user did
not see the SVG background watermark. See [HANDOFF.md](HANDOFF.md) for current
context and [changelog.md](changelog.md) for completed implementation details.

# Topics push and carry-forward plan

## Remaining sync diagnostic work

The diagnostic capture and server save path are implemented; see
[changelog.md](changelog.md). A forced capture after successful insertion was
verified. Test a real topic-not-found failure and, if feasible, a failure after
partial insertion. Confirm that dismissing the prompt saves nothing, server
failure preserves pending changes, and the captured pre-attempt HTML remains
accurate after later edits or signing. Evaluate whether additional DOM matching
details and post-failure HTML are needed, and establish retention/deletion for
saved clinical diagnostic files. Preserve byte-oriented Broker handling and
follow the server-edit and compilation constraints in [HANDOFF.md](HANDOFF.md).

## Objective

`fTopics` should eventually be able to place pending topic updates in either
the current note or a newly created carry-forward note.  The important outcome
is a clinically useful, curated threaded history for each selected topic—not
merely the single FMDT entry added during this visit.

## Current implementation and its limitation

- The new-note branch uses frmSingleNote and its Carry Forward tags. It accepts reviewed entries, curated edits, and edited tables.
- As of November 19, the builder prefixes each selected topic with its cached curated narrative, or the selected curated edit. A retrieval failure stops the push before note creation and preserves pending changes. Embedded cached table blocks are omitted as in the curated pane; selected table changes are inserted separately.
- This latest change needs a Windows build and runtime testing with multiple topics, no cached text, retrieval failure, curated edits, tables, and the next normal note template. Confirm historical narrative survives parsing and pending state is correct.
- The broader PastHPI integration below remains a possible future approach for carrying forward relevant topics and tables beyond the selected changes; it has not been implemented.

## Deferred: evaluate PastHPI data on the server

Reuse or expose the existing PastHPI process so the client can request the
curated topic content from the relevant past note before creating a
carry-forward note if the broader carry-forward behavior is requested.

1. Inspect the existing PastHPI server entry points and their callers. Identify
   the authoritative choice of prior note and all required request context
   (patient, provider, current note/date, topic selection, and any other
   filters).
2. Determine the result contract. Prefer exact HTML that is safe to place
   between the carry-forward tags; otherwise define a small structured result
   that retains topic order, threaded text, tables, and provider bullet style.
3. Confirm that the returned content includes each topic's curated threaded
   conversation and any associated tables that should appear in the next note.
   It must not silently reduce a topic to only today's new entry.
4. Define how a locally added FMDT entry is merged with the server result. It
   must appear once, at the end of its topic's thread, while topics that have no
   new entry still carry their curated history.
5. Add only the necessary RPC/client wrapper after the server contract is
   understood. Do not modify server routines or call mutating server code
   without explicit authorization; any M-routine change must be compiled by
   the user before it is called.

Once that data is available, the new-note flow is:

1. Refuse to proceed if another `frmSingleNote` is already open.
2. Launch `frmSingleNote`, invoke its Carry Forward action, and replace only
   the content between its carry-forward tags with the returned/merged topic
   HTML.
3. Let the normal Single Note save/sign flow remain responsible for creating,
   saving, and optionally signing the note.
4. Clear only the pending model items actually represented in the successful
   output. Preserve pending entries or table edits when retrieval, launch, or
   insertion fails.

## Current-note sync

Topic text sync is implemented using the live MSHTML DOM rather than replacing
the editor's entire HTML source. Kevin-style insertion was runtime-tested;
see `HANDOFF.md` and the current source for details. Selected table changes can
also be synchronized; insertion and replacement edge cases still need testing.
When revisiting this work, preserve existing narrative/table
separators, selection and scroll behavior, and pending state on failures.

## Verification when work resumes

1. Use both `kt_test_note.html` and `dt_test_note.html` to verify topic and
   table detection, including duplicate table occurrences and both bullet
   styles.
2. Test PastHPI retrieval against a safe representative note. Confirm that a
   generated carry-forward note shows curated historical threads, relevant
   tables, and a new entry only once in the correct topic.
3. Test a topic with no new entry, a new topic with no historical thread,
   multiple tables, and retrieval failure. Pending state must be retained on
   every failure path.
4. For current-note sync, confirm that several changes applied in
   one operation do not shift later targets, and that the edited note saves,
   reopens, and signs normally.

## Deferred: reversible topic linking

Similar topics can accumulate for one patient, for example “cough variant
asthma” and “asthma.” The existing Merge Topics action moves entries into a
destination and deletes the source topic, losing the original categorization.
When old notes are reparsed, their original topic names can cause the deleted
source topic to be created again. A reversible link would allow related topics
to be presented together without changing their original records.

The proposed model is a patient-specific relationship such as “cough variant
asthma” → “asthma.” The destination is the primary topic shown in the list;
the combined view would include the source topic's entries, with their original
topic names and record identities available. Linking and unlinking should not
move or rewrite historical entries. New entries could default to the primary
topic. Use terminology such as **Link topics** to distinguish this operation
from the existing destructive merge. This is a proposal for later discussion,
not an instruction to implement it now.

Points to resolve before implementation:

- Decide where to store the relationship. A “merged into” reference on the
  source topic is one option, but first inspect the actual rebuild paths and
  confirm whether they preserve topic records and their identifiers. The link
  must survive any supported rebuild; a reference tied only to a record that is
  deleted and recreated would not be sufficient. Evaluate FileMan's support
  for the chosen relationship rather than assuming a subfile pointer works.
- Keep note parsing and storage faithful to the original topic name, then
  combine related topics on read. Existing `FILE1B^TMGTIUT5` finds or creates
  a patient topic by the name parsed from the note.
- Ensure each displayed entry retains its source topic and entry identity, so
  editing or deleting it affects the correct original record even when two
  topics have entries with the same date and time.
- Define how linked topics' associated tables, curated text, group labels,
  hidden status, and last-used dates appear in the combined view. Do not
  silently discard conflicting or distinct data.
- Allow users to see and remove links. Validate the patient and target, reject
  self-links and cycles, and define what happens when a linked topic is
  renamed or deleted. Decide whether chains are permitted or normalized.
- Update current-note sync and carry-forward as needed to recognize the
  original topic names as well as the primary name. A note may still contain
  the source heading instead of the displayed primary heading.
- Review `TOPICLST`, `GET1`, curated-text retrieval, reports, and other topic
  readers before choosing a shared resolution strategy. Existing retrieval
  paths generally address one topic at a time.

Verify linking, unlinking, same-date entries, edits and deletes of source
entries, reparsing/rebuild behavior, and notes containing either topic name.
Do not modify database records or server routines until that work is explicitly
requested; follow the handoff's server-edit and M-compilation instructions.

## Remaining Imaging work

The dedicated Imaging tab is implemented and its basic display and note creation
were confirmed; see [changelog.md](changelog.md). Verify independent selection
and refresh in side-by-side use, printing, imaging-result alerts, font and
layout updates, selection preferences, and form destruction.

### Deferred: print scanned TIU imaging results

Printing a selected radiology report from Reports via **File → Print** was
confirmed to work. When the selected imaging result is a scanned TIU document,
the printer can be selected but printing reports “No Exam identified.” The
cause has not been confirmed. Compare Imaging's scanned-document and radiology
paths with Notes printing, then preserve radiology printing while adding the
appropriate scanned TIU behavior. Verify both result types in Reports and
Imaging, including selected-document identity and printer selection.

### Deferred: shared imaging data

The two Reports-form instances load imaging data independently on demand. If a
shared patient-scoped cache or service is added, keep each form's selection and
presentation state separate, key the cache by relevant context and parameters,
and invalidate it on patient changes, refresh, and study changes. Do not share
the mutable `uLocalReportData` scratch buffer; verify refresh and patient
isolation before relying on cached results.
