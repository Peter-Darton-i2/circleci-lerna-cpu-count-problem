module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  modulePathIgnorePatterns: ['build/*'],
  reporters: [
    'default',
    [
      'jest-junit',
      {
        outputDirectory: '../junit-reports',
        outputName: 'app-one.xml',
        includeConsoleOutput: 'true',
        reportTestSuiteErrors: 'true',
      },
    ],
  ],
};
