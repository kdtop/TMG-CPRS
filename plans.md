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

## Later work: synchronize to an active note

The current-note branch remains intentionally unimplemented. Use
`uHTMLNoteAnalysis.AnalyzeHTMLNote` on the exact editor HTML to find HPI topic
insertion points and all table ranges. Its offsets are zero-based UTF-16 source
offsets with exclusive ends.

- Make all replacements/insertions from the greatest source position to the
  smallest so earlier offsets stay valid.
- A topic insertion belongs at the end of that topic's threaded narrative and
  before its first table. If the requested as-of date is absent, add it; if it
  is already present, append after all text already under that date.
- Tables may occur in or outside HPI and may have multiple copies. Preserve a
  distinct range for every occurrence; never collapse copies merely because
  they have the same canonical name.
- Before implementation, provide/confirm an `fNotes` API that obtains the
  live editor HTML and assigns the updated source once, marks the editor
  modified, and preserves normal save/sign behavior.

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
4. For the later current-note branch, confirm that several changes applied in
   one operation do not shift later targets, and that the edited note saves,
   reopens, and signs normally.
