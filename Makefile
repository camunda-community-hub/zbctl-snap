.PHONY: update # Update to latest stable version
update:
	./update.sh ""
	echo "Pushing in 30 seconds... (Ctrl+C to interrupt)"
	sleep 30
	git push

.PHONY: alpha # Perform alpha release
alpha:
	./update.sh -a
	echo "Pushing in 30 seconds... (Ctrl+C to interrupt)"
	sleep 30
	git push
