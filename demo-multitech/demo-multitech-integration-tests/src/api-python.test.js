const request = require('request-promise');

// const serviceApiPython = 'http://localhost/api-python/';
const serviceApiPython = 'http://demo-multitech-python';

test('Test Python API', async () => {
  await request.get(serviceApiPython);
});
