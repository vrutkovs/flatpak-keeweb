all: install-deps build prune install-repo
	flatpak update --user info.keeweb.App

install-deps:
	flatpak --user remote-add --if-not-exists --from gnome-nightly https://sdk.gnome.org/gnome.flatpakrepo
	flatpak --user install gnome-nightly org.freedesktop.Platform/x86_64/1.6 org.freedesktop.Sdk/x86_64/1.6 || true

build:
	flatpak-builder --force-clean --ccache --require-changes --repo=repo \
		--subject="Nightly build of Keeweb, `date`" \
		${EXPORT_ARGS} app info.keeweb.App.json

prune:
	flatpak build-update-repo --prune --prune-depth=20 repo

install-repo:
	flatpak --user remote-add --if-not-exists --no-gpg-verify nightly-keeweb ./repo
	flatpak --user -v install nightly-keeweb info.keeweb.App || true
