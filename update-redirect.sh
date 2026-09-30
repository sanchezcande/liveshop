#!/bin/sh
# Points https://sanchezcande.github.io/liveshop to the current live-shop tunnel.
# Usage: ./update-redirect.sh https://xxxx.trycloudflare.com
set -e
TARGET="${1:?tunnel URL}"
cd "$(dirname "$0")"
for f in index.html 404.html; do
cat > "$f" <<HTML
<!doctype html>
<html lang="en"><head><meta charset="utf-8">
<meta name="robots" content="noindex,nofollow">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Buyamia Live Shop</title>
<script>
  var t = "$TARGET";
  var p = location.pathname.replace(/^\/liveshop\/?/, "/");
  location.replace(t + p + location.search + location.hash);
</script>
</head><body style="font-family:system-ui,sans-serif;padding:24px">
<p>Opening Buyamia Live Shop&hellip; <a href="$TARGET">Continue</a></p>
</body></html>
HTML
done
printf 'User-agent: *\nDisallow: /\n' > robots.txt
git add index.html 404.html robots.txt update-redirect.sh
if ! git diff --cached --quiet; then
  git commit -q -m "Point live shop link to $TARGET" -m "Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
fi
git push -q -u origin main
echo "redirect -> $TARGET"
