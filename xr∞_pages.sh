#!/bin/bash
mkdir -p docs
cp pulsar_badge.svg docs/
echo '<!DOCTYPE html><html><head><title>XR∞ Pages</title></head><body><iframe src="http://localhost:5000" width="100%" height="800"></iframe></body></html>' > docs/index.html
git checkout --orphan gh-pages
git add docs/
git commit -m "🌐 Pubblicazione dashboard XR∞ su GitHub Pages"
git push origin gh-pages
