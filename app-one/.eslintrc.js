const path = require('path');

module.exports = {
  root: true,
  extends: '../eslint.base.js',
  parserOptions: { project: [path.join(__dirname, 'tsconfig.json')] },
  plugins: ['@typescript-eslint'],
};
