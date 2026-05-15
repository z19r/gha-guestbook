set shell := ["bash", "-cu"]

default:
	@just --list

check:
	@just check-action
	@just check-readme
	@just check-marketplace

check-action:
	@test -f action.yml || (echo "missing action.yml"; exit 1)
	@rg -Fq "using: 'composite'" action.yml || 	  (echo "action is not composite"; exit 1)
	@rg -q "id: sign" action.yml || 	  (echo "action missing sign step id"; exit 1)
	@echo "action checks passed"

check-readme:
	@test -f README.md || (echo "missing README.md"; exit 1)
	@rg -q "uses: z19r/gha-guestbook@v1" README.md || 	  (echo "README missing usage example"; exit 1)
	@echo "readme checks passed"

check-marketplace:
	@test ! -d .github/workflows || 	  (echo "workflow files disallowed for marketplace"; exit 1)
	@echo "marketplace checks passed"

release-tag tag:
	@if ! [[ "{{tag}}" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then 	  echo "use semver like v1.0.0"; exit 1; 	fi
	git tag "{{tag}}"
	git push origin "{{tag}}"

release-tag-major tag ref:
	@if ! [[ "{{tag}}" =~ ^v[0-9]+$ ]]; then 	  echo "use major tag like v1"; exit 1; 	fi
	@if [ -z "{{ref}}" ]; then 	  echo "usage: just release-tag-major v1 v1.0.0"; exit 1; 	fi
	git tag -f "{{tag}}" "{{ref}}"
	git push -f origin "{{tag}}"
