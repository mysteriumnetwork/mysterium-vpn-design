generate:
	fvm dart run build_runner build --delete-conflicting-outputs

invalidate-web-cache:
	@HTML_FILE=web/index.html; \
	CACHE_BUST=$$(git rev-parse --short HEAD 2>/dev/null || openssl rand -hex 6 2>/dev/null || date +%s); \
	perl -0777 -i.bak -pe 's/src="flutter_bootstrap.js(?:\?v=[^"]*)?"/src="flutter_bootstrap.js?v='$$CACHE_BUST'"/s' $$HTML_FILE; \
	if grep -q "src=\"flutter_bootstrap.js?v=$$CACHE_BUST\"" $$HTML_FILE; then \
	  echo "Updated cache-bust to $$CACHE_BUST in $$HTML_FILE"; \
	else \
	  echo "Error: Failed to update $$HTML_FILE"; \
	  mv "$$HTML_FILE.bak" "$$HTML_FILE"; \
	  exit 1; \
	fi; \
	rm -f "$$HTML_FILE.bak"
