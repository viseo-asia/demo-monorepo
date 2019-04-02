const request = require('request-promise');

// const serverTracker = 'http://localhost:80/api-visits-tracker/';
// const serverCounter = 'http://localhost:80/api-visits-counter/';
const serverTracker = 'http://demo-multitech-visits-tracker/';
const serverCounter = 'http://demo-multitech-visits-counter/';

test('Test visit tracker', async () => {
  const counterBefore = Number(await request.get(serverCounter));
  await request.get(serverTracker);
  const counterAfter = Number(await request.get(serverCounter));
  expect(counterAfter).toEqual(counterBefore + 1);
});
