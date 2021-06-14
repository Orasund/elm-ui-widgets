(cd explorer && elm make src/Main.elm --optimize --output main.js) &&
  cp explorer/main.js docs/ &&
  cp explorer/main.js docs/3.0.0
