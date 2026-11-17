# Topics push and carry-forward plan

## Deferred: capture diagnostics when current-note sync fails

When a Topic sync fails during patient care, the note may be edited or signed
before there is time to investigate. Preserve the information from the failed
attempt so it can be analyzed later. At first, offer this only on a sync failure,
not as a general-purpose Topics button.

Proposed workflow:

1. Attempt **Sync to Current Note** as usual. If it fails, offer **Save
   Diagnostic Snapshot** in the error dialog, along with an option to dismiss it.
2. Capture the relevant state in memory at the time of the attempted sync so
   later note edits do not change the evidence. If the user clicks the button,
   send that snapshot to the server.
3. Save each snapshot under a unique identifier in a designated server
   diagnostic folder. Return the identifier and confirm success, or report a
   save failure clearly so the user can continue their work.
4. Capturing or saving diagnostics must not alter the note or clear pending
   Topic changes. Preserve existing handling of failures that may have already
   partially inserted text.

Include the live editor HTML from before the attempt, including unsaved edits;
the exact error, timestamp, CPRS version, and relevant note and patient
identifiers; the requested topic names, selected pending entries, generated
insertion HTML, and insertion/replacement flags; and useful matching details
such as HPI detection and the topic headings found. Capture failure details
before temporary lists and objects are freed. The snapshot should distinguish
pre-attempt state from any post-failure state if the latter is included.

The reported error was that the target topic could not be found in the current
note. `TfrmNotes.InsertHTMLAtTopicEnds` in `CPRS-Chart/fNotes.pas` searches
underlined headings in the HPI region; the message alone does not establish why
matching failed. It checks requested topics before inserting, though other
failures can occur after insertion starts and leave a partial insertion.

Use the Topics command channel to communicate with the server through its
established RPC. Before implementing, inspect that channel's payload and
response handling and choose an appropriate server-side save mechanism. The snapshot may contain a complete
clinical note and unsaved patient information: choose a restricted location,
unique filenames, and an appropriate retention/deletion approach, and avoid a
temporary folder that may be cleared before investigation. Preserve the
Broker's byte-oriented payload conventions and test that HTML survives transfer
without truncation or character corruption. Do not modify or call mutating
server code without the user's explicit authorization; compile changed M
routines as required by the handoff before calling them.

Verify a failed sync can be captured and later reproduced from the saved data;
that dismissing the dialog does not save anything; that a server failure is
reported without losing pending changes; and that the saved pre-attempt state
remains accurate if the note is subsequently edited or signed. Include both
topic-not-found and potentially partial-insertion failures in testing.

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

## In progress: dedicated Imaging tab

### Deferred: print scanned TIU imaging results

Printing a selected radiology report from Reports via **File → Print** was
confirmed to work. When the selected imaging result is a scanned TIU document,
the printer can be selected but printing reports “No Exam identified.” The
scanned-document display was added to Imaging more recently; the cause of this
printing failure has not yet been confirmed.

Investigate how Imaging distinguishes scanned TIU documents from radiology
exams and compare the Notes tab's printing path. Adapt the appropriate existing
TIU document printing behavior for scanned results, while preserving radiology
printing. Verify both result types, including selected-document identity and
printer selection, in Reports and the new Imaging tab when available.

### User request

> To display imaging results, we currently go into the reports tab and select the Imaging (local only) report. I would like imaging to have a separate tab. Can you check the feasibility of making a duplicate of the report tab, calling it "Imaging", and then filter out all other reports that might have been displayed in the parent. Extra points if we could somehow still have one codebase, but have there be a flag at tab instantiation that tells it which mode it is working it. And extra extra points if didn't have to load all the data for both versions of the tab separately.

The first client implementation compiles, and the user confirmed the Imaging tab appears between Labs and Reports. The user confirmed that both tabs show the expected studies, including scanned TIU and traditional radiology results, after switching to another patient and back. The user confirmed that a note created from Imaging copies the Imaging selection even when Reports has a different study selected. Printing from the new tab and independent selections in side-by-side use still need runtime verification. It reuses the Reports form in Imaging mode; imaging data is still loaded independently on demand, without a shared cache.

### Findings and recommended approach

- `CPRS-Chart/fReports.pas` already implements the local imaging list and viewer. Its `QT_IMAGING` path calls `ListImagingExams` and handles both radiology results and scanned TIU documents. Reuse this behavior rather than duplicating its source.
- Two `TfrmReports` instances now keep report buffers, selection state, and graph state separately. Printing and single-note actions receive their source form. Continue reviewing shared state and direct references as remaining workflows are tested.
- In imaging mode, select the existing Imaging (local only) report automatically. Hide both the single-item report tree and the lower-left procedures tree, which duplicates the study list in the main display. Keep the main study list and viewer available.
- Leave Imaging (local only) available in the existing Reports tab, with its current layout and behavior, so users can continue finding it in the familiar location.
- The distinct Imaging page is registered in `CPRS-Chart/fFrame.pas` and the page-ID definitions. Continue verifying split-screen placement, printing, font and layout updates, notification routing, selection preferences, and form destruction. Existing imaging notifications continue to route to Reports; the office does not use remote-site printing.
- Reports load selected content on demand; two tabs do not require preloading every report twice. If both tabs need the same imaging list, use a shared patient-scoped cache or data service, rather than sharing the current mutable `uLocalReportData` scratch buffer. Cache keys must reflect parameters and context affecting results. Define explicit invalidation for patient changes, refresh, and operations that add, edit, or delete studies; avoid displaying stale data. Keep presentation and selection state separate for the two instances.
- Initial inspection did not identify a need for a new server RPC. Confirm the existing contracts during implementation.

### Verification

Exercise both tabs independently and side by side, including selection and refresh, printing, imaging notifications, existing report types, and local radiology and scanned TIU results. If a shared imaging cache is added, verify reuse and refresh after relevant changes without leaking data across patients. Follow the CPRS workspace's own handoff, change attribution, build, and testing instructions.
