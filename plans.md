# Topics push and carry-forward plan

## Objective

`fTopics` should eventually be able to place pending topic updates in either
the current note or a newly created carry-forward note.  The important outcome
is a clinically useful, curated threaded history for each selected topic—not
merely the single FMDT entry added during this visit.

## Current implementation and its limitation

- `fTopics` records pending new FMDT topic entries and edited associated
  tables.  Its action button says **Push to New Note** when no note is being
  edited and **Sync to Current Note** otherwise.
- The new-note branch opens `frmSingleNote`, uses its Carry Forward action,
  and fills the region delimited by `TAG_CARRY_FORWARD_START` and
  `TAG_CARRY_FORWARD_END`.
- The temporary payload contains only the newly created topic entry, using the
  provider's bullet style.  It was runtime-tested and works mechanically, but
  it is not the desired carry-forward behavior: the next visit needs the
  curated threaded discussion from a relevant earlier note as well.
- Do not extend or treat this single-entry HTML builder as the finished
  carry-forward solution.  Pending table changes remain pending; they are not
  yet inserted into either kind of note.

## First next step: retrieve PastHPI data on the server

Reuse or expose the existing PastHPI process so the client can request the
curated topic content from the relevant past note before creating a
carry-forward note.  This is deferred until the next work session.

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
see `HANDOFF.md` and the current source for details. Table changes are not yet
synchronized. When revisiting this work, preserve existing narrative/table
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
