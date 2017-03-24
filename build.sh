#!/bin/sh

set -eux

rm -rf app

flatpak-builder --ccache --require-changes --repo=repo --subject="Nightly build of Keeweb, `date`" app info.keeweb.App.json

flatpak build-update-repo --prune --prune-depth=20 repo

# The following commands should be performed once
flatpak --user remote-add --no-gpg-verify nightly-keeweb ./repo || true
flatpak --user -v install nightly-keeweb info.keeweb.App || true

flatpak update --user info.keeweb.App
