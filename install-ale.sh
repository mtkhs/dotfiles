#!/usr/bin/env bash

cd ~

# Ruby
gem install rubocop

# Python3
pip install -U pyflakes black isort

# JavaScript
npm init -y
npm install --save-dev eslint htmlhint stylelint write-good textlint
npm install --save-dev eslint-plugin-vue
npm install --save-dev --save-exact prettier
npm install --save-dev eslint-plugin-prettier
npm install --save-dev eslint-config-prettier

