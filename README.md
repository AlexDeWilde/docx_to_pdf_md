# docx_to_pdf_md

A portable Windows batch script that converts every `.docx` file in its folder (and one level of subfolders) into two formats simultaneously:

- **`.md`** — clean Markdown for use in [Obsidian](https://obsidian.md/) or any Markdown-based workflow
- **`.pdf`** — PDF with fully clickable hyperlinks preserved

Drop the script into any folder and double-click. No configuration required.

---

## Requirements

Both tools must be installed on the machine:

| Tool | Purpose | Install | Expected location |
|------|---------|---------|-------------------|
| [Pandoc](https://pandoc.org/installing.html) | DOCX → Markdown | `winget install --id JohnMacFarlane.Pandoc` | `%LOCALAPPDATA%\Pandoc\pandoc.exe` |
| [LibreOffice](https://www.libreoffice.org/download/) | DOCX → PDF (with hyperlinks) | `winget install --id TheDocumentFoundation.LibreOffice` | `C:\Program Files\LibreOffice\program\soffice.bin` |

The script resolves Pandoc via `%LOCALAPPDATA%` (no PATH dependency) and expects LibreOffice at its default Program Files path.

### Portability

- **Across folders:** drop the `.bat` into any folder and double-click — it uses `%~dp0` to find `.docx` files relative to itself.
- **Across machines:** install both dependencies via the `winget` commands above. The script uses `%LOCALAPPDATA%` for Pandoc, so it works for any Windows user without PATH changes.
- **Folder names with special characters:** paths containing spaces, parentheses, or other special characters (e.g. `(mfd)`) are handled correctly via delayed expansion.

---

## Usage

1. Copy `__convert_docx_to_pdf_md.bat` into any folder containing `.docx` files.
2. Double-click it.
3. The script runs silently and exits. For each `document.docx` it finds, it produces:
   - `document.md` in the same folder
   - `document.pdf` in the same folder

**Subfolder support:** the script also processes `.docx` files found one level deep. Files in sub-subfolders are ignored.

**Overwrite behaviour:** existing `.md` and `.pdf` files are overwritten without prompting.

**No files found:** the script exits silently with no output.

---

## How it works

When run, the script writes a temporary PowerShell script to `%TEMP%`, executes it, then deletes it. The PowerShell script:

1. Uses **pandoc** (`--wrap=none`, `--from docx`, `--to markdown`) to produce clean, unwrapped Markdown.
2. Uses **LibreOffice** (`soffice.bin --headless --convert-to pdf`) to produce a PDF. Calling `soffice.bin` directly (rather than the `soffice.exe` launcher) ensures the process is fully awaited before moving to the next file.

Hyperlinks in the source `.docx` are preserved as clickable links in both output formats.

---

## Notes

- Images embedded in `.docx` files are not extracted into the Markdown output.
- The LibreOffice path is hardcoded to `C:\Program Files\LibreOffice\program\soffice.bin`. The Pandoc path is resolved via `%LOCALAPPDATA%\Pandoc\pandoc.exe`. If either tool is installed elsewhere, edit the corresponding path in the script.
- The script does not recurse beyond one subfolder level by design.
