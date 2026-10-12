# Client-side push of edited Topic Tables into the active CPRS note

## Goal

Push the table edits already held in `TTopicDataTable` objects into the active
CPRS HTML editor without invoking a server-side MACRO action.  The existing
`SET TABLE DATA` RPC remains responsible for persisting the independent table
data; this work only updates the currently edited TIU note in memory.  The
normal CPRS autosave/sign workflow will then save the note.

## Scope and behavior

- Keep `TTopicDataTable.Changed` as the pending-work indicator.  Do not alter
  the clinician's note automatically when the table-edit dialog closes.
- Add an explicit Topics action to push all changed tables into the current
  HTML note.  It must require an active HTML note in edit mode.
- A table is identified by its full, case-insensitive canonical header:
  `-- [<TableName>] ---------`.  Do not match an arbitrary `[<TableName>]`
  inside narrative text.
- Update every well-formed occurrence of that exact header.  A table can
  legitimately occur more than once in the same note; every copy receives the
  new data, and the user is told how many copies were changed.
- Preserve the original table header and replace only its data lines.  The
  replacement is the table's current plain-text `Lines`, HTML-encoded line by
  line, joined with `<BR>`.
- If a changed table has no identifiable occurrence, leave its `Changed` flag
  set and include it in the completion/error report.  Do not invent a location
  for it in this first version.
- On a successful replacement, clear that table's `Changed` flag.  Retain it
  if no occurrence was replaced or if the push itself fails.

## Supported legacy note structures

The scanner must be tolerant of IE/MSHTML serialization: HTML tag case,
attribute text, CR/LF, and `&nbsp;` can vary.  It scans after each matched
header to the earliest valid boundary, without consuming the boundary:

1. A blank visual line (two `<BR>` breaks, allowing whitespace and `&nbsp;`),
2. `</LI>` or the next `<LI ...>` (the original Topics style in `killthis.txt`),
3. `</P>` or the next `<P ...>` (Dr. Dee's style in `killthis_DT.txt`; an
   opening `<P>` commonly closes the prior paragraph implicitly).

`killthis.txt` and `killthis_DT.txt` are sanitized fixtures for these two
formats.  The scanner should replace all matching copies for each table in
both fixtures.

## Implementation steps

1. Add a note-editor API in `fNotes.pas`, conceptually:

   ```pascal
   function PushTopicTablesToActiveNote(const Tables: TObjectList<TTopicDataTable>;
     out Summary: string): Boolean;
   ```

   Adjust the concrete parameter type as needed to avoid exposing the Topics
   implementation class across units.  A list of table name/lines/changed
   records or a callback is acceptable.  The editor owns the operation; the
   Topics form only supplies pending tables and consumes the results.

2. Put the pure HTML scan-and-replace logic in a small helper (preferably a
   general utility unit, not in the event handler).  For each table:

   - locate all exact headers case-insensitively;
   - find the first valid boundary after each header;
   - build replacement ranges for the table body;
   - apply ranges from the end of the HTML string toward the beginning, so
     earlier offsets remain valid;
   - return the count updated and a specific error for any malformed match.

   A malformed candidate must not cause the scanner to consume the remainder
   of the note.  Report it and leave that occurrence unchanged.

3. In the `fNotes` API, validate that a note is actively being edited and is
   in HTML mode.  Obtain the live editor HTML, run all table replacements in
   one pass, then assign the updated HTML once.  Preserve the current scroll
   location and repaint afterward.  Set `HTMLEditor.KeyStruck := True` so the
   ordinary autosave/save path sees the change.

4. Initially refuse the operation with a clear message when the active editor
   has an embedded HTML template dialog.  Its save-mode transformation needs a
   separate round-trip design; ordinary rich-text notes are the initial scope.

5. Add a Topics-pane command/button, enabled only when at least one loaded
   table has `Changed = True`.  It calls the note-editor API, clears flags only
   for tables whose one-or-more occurrences were replaced, refreshes the
   Topics table display, and shows a concise result summary (including copy
   counts and tables not found).

6. Do not add a M routine, RPC, MACRO action, or FileMan change for this
   feature.  The only server interaction remains the already implemented
   `SET TABLE DATA` call made when the user saves the table-edit dialog.

## Verification

1. Compile CPRS after the Pascal changes.
2. In a test note based on `killthis.txt`, edit a linked table, push it, and
   verify its `<LI>`-bounded occurrence changes while neighboring narrative
   and other tables do not.
3. Repeat with `killthis_DT.txt`; verify the `<P>`-bounded table changes and
   the following topic remains intact.
4. Put the same canonical table header in two valid note locations; confirm
   both copies update and the completion message gives a count of two.
5. Test no-match, malformed/no-boundary, and a table with literal `<`, `>`,
   `&`, or quote characters.  Verify no broad replacement occurs, the error
   is reported, and the changed flag remains when appropriate.
6. Confirm the note is marked modified, autosaves normally, reopens with the
   pushed values, and signs without calling a macro RPC.
7. Verify that the action refuses a non-editing note, non-HTML note, and a
   note containing an embedded template dialog without modifying its content.
