import { hello } from './bar';

describe('bar hello', () => {
  it(`says hello`, async () => {
    const expected = 'Hello Mr Flibble';
    const who = 'Mr Flibble';

    const actual = hello(who);

    expect(actual).toStrictEqual(expected);
  });
});
