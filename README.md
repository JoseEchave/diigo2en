# diigo2en
Move the highlights from Diigo to Evernote

**Note: This has been only tested in Windows and locally,report any problems you might find**

This works in two steps

First the function import_bookmars() calls the diigo API to retrieve the highlights into a data frame with lists.

In second step, export_note_EN_enex() takes the a bookmark and creates an ENEX file (Evernote note file for import and export).
The Enex file is saved and then command line is used to import it to Evernote.

Finally run_batch() function provides an easy way to iterate and import all the new highlights (it looks at the last function run date and takes only the new ones)


