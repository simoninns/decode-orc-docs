# Migration from legacy vhs-decode builds

## Legacy JSON metadata

The current version of Decode-Orc (and the ld-decode-tools Decode-Orc replaces) require TBC files with metadata in the current SQLite format (previously ld-decode used JSON rather than SQLite).

If you have old decodes the recommended course of action is to re-decode the capture with a current version of ld-decode or vhs-decode.  If that is not possible the legacy ld-decode-tools include a utility called ld-json-converter that will convert legacy JSON .tbc.json files to the new .tbc.db format.

## Separate Y/C sources

Legacy versions of vhs-decode produced TBC Y/C pairs with the format `<name>_chroma.tbc` and `<name>.tbc`.

In order to use these files with Decode-Orc you will need to rename them.  `<name>_chroma.tbc` should become `<name>.tbcc` and `<name>.tbc` should become `<name>.tbcy`.  This is used by Decode-Orc to distinguish composite and separate sources when using features such as "quick project".

