all: dist/index.html dist/main.css dist/main.js

dist/index.html: src/index.html
	cp src/index.html dist/index.html

dist/main.css: src/main.css
	cp src/main.css dist/main.css

dist/main.js: src/*.elm
	elm make src/main.elm --output $@
