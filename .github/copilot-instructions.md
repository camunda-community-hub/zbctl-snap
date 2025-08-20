# zbctl Snap Package Repository

zbctl-snap is a Snap packaging repository for zbctl (the command-line client for Camunda Platform 8). This repository does NOT contain zbctl source code - it packages the official pre-built zbctl binaries from Camunda releases.

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## Working Effectively

### Essential Dependencies
Install required tools before starting any work:
- `wget` - for downloading release checksums (usually pre-installed)
- `jq` - for JSON processing (usually pre-installed) 
- `gh` (GitHub CLI) - for fetching release information
- `snapcraft` - for building snap packages (may not be available in all environments)

### Core Repository Operations
- **Update to latest stable version:**
  - `./update.sh` (no arguments)
  - Takes ~5 seconds. Downloads checksum file and updates snap/snapcraft.yaml
  - NEVER CANCEL: Operation completes in under 30 seconds
- **Update to latest alpha version:**
  - `./update.sh --alpha`
  - Takes ~5 seconds. Same process but fetches alpha releases
- **Make target shortcuts:**
  - `make update` - runs `./update.sh ""` then waits 30 seconds before pushing
  - `make alpha` - runs `./update.sh --alpha` then waits 30 seconds before pushing

**IMPORTANT:** The update.sh script requires either no arguments (for stable) or `--alpha` (for alpha releases). Do not use `--help` or other arguments.

### Build Process (when snapcraft is available)
- **Build snap package:**
  - `snapcraft`
  - NEVER CANCEL: Build takes 10-20 minutes. Downloads ~400MB binary and packages it. Set timeout to 30+ minutes.
  - Produces `zbctl_<version>_amd64.snap` file
- **Install built package for testing:**
  - `snap install zbctl_*.snap --dangerous`
  - Takes ~30 seconds to install

### Validation Commands
After building and installing, validate functionality:
- **Check version:** `zbctl version`
- **Test basic connectivity:** `zbctl status` (may fail without Zeebe cluster, but command should exist)
- **Show help:** `zbctl --help`
- **List available commands:** `zbctl help`

## Repository Structure

### Key Files
- `snap/snapcraft.yaml` - Main snap package configuration file
- `update.sh` - Script to update package to latest zbctl version
- `Makefile` - Simple automation for update and push operations
- `README.md` - User documentation for installing and using the snap
- `CONTRIBUTING.MD` - Contains INCORRECT npm references - ignore npm commands

### Directory Layout
```
/home/runner/work/zbctl-snap/zbctl-snap/
├── .github/             # GitHub templates and this file
├── snap/
│   └── snapcraft.yaml   # Snap package configuration
├── update.sh            # Version update script
├── Makefile            # Build automation
├── README.md           # User documentation
└── CONTRIBUTING.MD     # Contributor guide (has incorrect npm references)
```

## Common Development Tasks

### Updating zbctl Version
1. **Automatic update (recommended):**
   ```bash
   ./update.sh    # Updates to latest stable version
   git push       # Push changes after review
   ```
2. **Manual process:**
   - Find latest version at https://github.com/camunda/camunda/releases
   - Download corresponding `.tar.gz.sha1sum` file
   - Update `version:` field in `snap/snapcraft.yaml`
   - Update `source-checksum:` field with SHA1 from checksum file
   - Commit changes

### Expected Output Examples
**Successful update.sh run:**
```
+ VERSION=8.5.22
+ wget https://github.com/camunda/camunda/releases/download/8.5.22/camunda-zeebe-8.5.22.tar.gz.sha1sum
+ sed -i "s/^version: '[^']*'/version: '8.5.22'/" snap/snapcraft.yaml
+ checksum=ed1a44fa1d3a65709db29e884ba198b61f0b2239
+ git diff --color-words snap/snapcraft.yaml
+ git commit -m "Bump zbctl to 8.5.22" snap/snapcraft.yaml
```

**Valid snapcraft.yaml version format:**
```yaml
version: '8.5.22'  # Must be quoted string
source-checksum: sha1/ed1a44fa1d3a65709db29e884ba198b61f0b2239  # sha1/ prefix required
```

### Testing Changes
1. **If snapcraft is available:**
   ```bash
   snapcraft  # NEVER CANCEL: 10-20 minutes
   snap install zbctl_*.snap --dangerous
   zbctl version
   zbctl --help
   ```
2. **If snapcraft is NOT available:**
   - Validate syntax of `snap/snapcraft.yaml`
   - Verify version and checksum fields are correctly formatted
   - Check that referenced GitHub release exists
   - Submit PR and rely on automated Snapcraft build system

### Validation Without Building
When snapcraft is not available, validate changes by:
- **Check snapcraft.yaml syntax:** `python3 -c "import yaml; yaml.safe_load(open('snap/snapcraft.yaml'))"`
- **Verify release exists:** Check https://github.com/camunda/camunda/releases
- **Validate checksum format:** Ensure SHA1 hash is 40 characters, lowercase hex
- **Test update script:** Run `./update.sh` on a feature branch to verify it works (requires GH_TOKEN)
- **Manual YAML inspection:** Ensure version and source-checksum fields are properly formatted

## Build Timing and Expectations

### Operation Timeouts
- **update.sh execution:** Set timeout to 60+ seconds (usually completes in ~5 seconds)
- **snapcraft build:** Set timeout to 30+ minutes (usually takes 10-20 minutes)
- **snap install:** Set timeout to 5+ minutes (usually takes ~30 seconds)
- **CRITICAL:** NEVER CANCEL build operations - they download large files and may appear to hang

### Expected File Sizes
- `camunda-zeebe-*.tar.gz` release: ~400MB
- Built snap package: ~80-120MB
- Checksum files: ~70 bytes

## Important Notes

### What This Repository IS
- A packaging repository for distributing zbctl via Snap
- Contains snap packaging configuration only
- Downloads and repackages official Camunda zbctl binaries

### What This Repository IS NOT
- NOT a Go development repository
- Does NOT contain zbctl source code
- Does NOT use npm, Node.js, or traditional unit tests
- IGNORE any references to `npm install` or `npm test` in CONTRIBUTING.MD

### Snap Package Behavior
- Installed as: `/snap/bin/zbctl`
- Auto-updates via snap system
- Confinement: strict (limited file system access)
- Requires network access for Zeebe cluster connections

### Environment Limitations
- snapcraft may not be installable in all CI/development environments
- GitHub CLI requires authentication token (GH_TOKEN environment variable)
- Network access required for downloading Camunda releases

## Troubleshooting

### Common Issues
- **"snapcraft not found":** Install via `snap install snapcraft --classic` or use alternative validation
- **"gh: missing GH_TOKEN":** Set environment variable or authenticate with `gh auth login`
- **"wget failed":** Check network connectivity and GitHub release existence
- **Build appears hung:** NEVER CANCEL - snap builds download large files and may take 20+ minutes

### Recovery Steps
- **Reset snapcraft.yaml:** `git checkout snap/snapcraft.yaml`
- **Clean build artifacts:** `snapcraft clean` (if snapcraft available)
- **Verify release exists:** Check https://github.com/camunda/camunda/releases manually

Always wait for operations to complete and validate changes thoroughly before committing.