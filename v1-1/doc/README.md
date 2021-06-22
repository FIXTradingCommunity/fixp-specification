# Manual steps required after docx generation
Pandoc generates two different docx files for FIX and ISO based on different style files. The following steps are required to be made manually with the final version prior to publication. Pandoc is not able to support all of the necessary layout features.

# FIX layout
1. Remove first paragraph of section *6.8.3 Idempotent flow sequence diagram* (empty plantUML diagram due to Pandoc issue)
2. Changes in the table of section *8.1 FIXP session messages*
    - Change text orientation from horizontal to vertical for the header of the last 4 columns
    - Increase height of header row so that only "Unsequenced / None" still has a line break
    - Change paragraph spacing of header cell "Unsequenced / None" from before=3pt/after=3pt to 0pt/6pt
3. Change section *9 Appendix A – Usage examples (TCP)* from portrait to landscape
    - Add section break with section *10 Appendix B – FIXP Rules of Engagement*
    - Go to page header of this section and remove first "Different First Page" and then "Link to Previous"
    - Go to page footer of this section and remove "Link to Previous"
    - Do the same with section *9 Appendix A – Usage examples (TCP)*
    - Change section *9 Appendix A – Usage examples (TCP)* orientation to landscape
    - Slight right-aligned tab in header (used for the date) to the far right
    - Slight right-aligned tab in footer (used for the page number) to the far right
4. Refresh table of contents (update numbers is sufficient)

# ISO layout
1. Do the steps mentioned above for the FIX layout
2. Change title page
    - Mark blank line between stage information and warning
    - Apply “Body Text” style to it ==> single box will change into two boxes
    - Mark first warning line, choose center text and bold
    - Move ISO copyright page up (between title page and table of contents)
3. Change first page of content (Chapter 1 – Scope)
    - Insert section break at the end of the introduction
    - Remove “Different First Page” for new section
    - Go into header or footer and restart page numbering
    - Go to header or footer of previous page and change page numbering style to i, ii, iii,…
    - If necessary, insert blank page in front matter so that page 1 is a righthand page.
4. Check normative references (session layer document references must be in ISO format)
5. Refresh table of contents (entire table, not just the numbers)
