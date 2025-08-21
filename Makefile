.PHONY: build # Build the snap package
build:
	snapcraft pack

.PHONY: remote-build # Build the snap package remotely
remote-build:
	snapcraft remote-build

.PHONY: install # Install the snap package
install:
	snap install --dangerous zbctl_*_amd64.snap

.PHONY: refresh # Refresh the snap package
refresh:
	snap refresh zbctl --channel=edge --amend

.PHONY: test # Test the snap package
test:
	snap run zbctl version

.PHONY: clean # Clean up the build artifacts
clean:
	snapcraft clean

.PHONY: update # Update to latest stable version
update:
	./update.sh ""
	echo "Pushing in 30 seconds... (Ctrl+C to interrupt)"
	sleep 30
	git push

.PHONY: alpha # Perform alpha release
alpha:
	./update.sh --alpha
	echo "Pushing in 30 seconds... (Ctrl+C to interrupt)"
	sleep 30
	git push
