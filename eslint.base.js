const path = require('path');

module.exports = {
  root: true,
  extends: ['eslint:recommended', 'plugin:@typescript-eslint/recommended'],
  parser: '@typescript-eslint/parser',
  parserOptions: { project: 'tsconfig.json' },
  plugins: ['@typescript-eslint'],
  rules: {
    'no-empty': 'off',
    '@typescript-eslint/no-empty-function': 'off',

    '@typescript-eslint/no-explicit-any': 'off',
    '@typescript-eslint/no-non-null-assertion': 'off',

    '@typescript-eslint/explicit-member-accessibility': 'error',
    '@typescript-eslint/consistent-type-imports': 'error',

    'no-constant-condition': 'off',

    // no-unused-vars

    'no-unused-vars': 'off', // this base version must be turned off for the typescript version to work
    // TypeScript typically allows unused vars if they're explicitly prefixed with `_`.
    '@typescript-eslint/no-unused-vars': [
      'error',
      { argsIgnorePattern: '^_', varsIgnorePattern: '^_' },
    ],
  },
};
