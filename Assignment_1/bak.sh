#!/usr/bin/env bash

# == bak 0.2.0 ==
# A simple backup tool in bash

# -- Defaults --
BACKUP_DIR="${HOME}/Backups"
COMPRESS_FORMAT="tar-gz"
CHECKSUM_TYPE="sha256"
FILE_NAME="$(date +%Y-%m-%dT%H_%M_%S).bak"

# -- Functions --
print_help() {
    cat <<EOF
bak - a simple backup tool

Usage: bak [options] <files/dirs to backup>...

Options:
  -c, --compress FORMAT     Compression format: tar-gz, tar-xz, tar-zst, tar-bz, zip (default: tar-gz)
  -C, --checksum TYPE       Checksum type: none, md5, sha1, sha224, sha384, sha256, sha512, b2 (default: sha256)
  -f, --file-name NAME      Custom backup file name (default: <date>.bak)
  -o, --output-dir DIR      Output directory (default: ~/Backups)
  -e, --exclude PATTERN     Exclude files matching PATTERN
  -h, --help                Show this help message
EOF
}

# Parse args
EXCLUDES=()
while [[ "$#" -gt 0 ]]; do
  case $1 in
    -c|--compress) COMPRESS_FORMAT="$2"; shift ;;
    -C|--checksum) CHECKSUM_TYPE="$2"; shift ;;
    -f|--file-name) FILE_NAME="$2"; shift ;;
    -o|--output-dir) BACKUP_DIR="$2"; shift ;;
    -e|--exclude) EXCLUDES+=("--exclude=$2"); shift ;;
    -h|--help) print_help; exit 0 ;;
    *) FILES+=("$1") ;;
  esac
  shift
done

if [[ ${#FILES[@]} -eq 0 ]]; then
    echo "Error: No files provided!" >&2
    exit 1
fi

mkdir -p "$BACKUP_DIR"

# Backup file name
EXT="tar.gz"
[[ "$COMPRESS_FORMAT" == "zip" ]] && EXT="zip"
BACKUP_FILE="${BACKUP_DIR}/${FILE_NAME}.${EXT}"

# Do backup
echo ":: Creating backup..."
if [[ "$COMPRESS_FORMAT" == "zip" ]]; then
    zip -r "$BACKUP_FILE" "${FILES[@]}" "${EXCLUDES[@]}"
else
    tar -cvpzf "$BACKUP_FILE" "${FILES[@]}" "${EXCLUDES[@]}"
fi

# Checksum
if [[ "$CHECKSUM_TYPE" != "none" ]]; then
    echo ":: Generating checksum ($CHECKSUM_TYPE)..."
    case $CHECKSUM_TYPE in
        md5) md5sum "$BACKUP_FILE" > "$BACKUP_FILE.md5" ;;
        sha1) sha1sum "$BACKUP_FILE" > "$BACKUP_FILE.sha1" ;;
        sha224) sha224sum "$BACKUP_FILE" > "$BACKUP_FILE.sha224" ;;
        sha384) sha384sum "$BACKUP_FILE" > "$BACKUP_FILE.sha384" ;;
        sha512) sha512sum "$BACKUP_FILE" > "$BACKUP_FILE.sha512" ;;
        b2) b2sum "$BACKUP_FILE" > "$BACKUP_FILE.b2" ;;
        sha256|*) sha256sum "$BACKUP_FILE" > "$BACKUP_FILE.sha256" ;;
    esac
fi

echo ":: Backup complete!"
echo "   -> File: $BACKUP_FILE"
