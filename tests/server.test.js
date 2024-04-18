const request = require('supertest');
const mongoose = require('mongoose');
const app = require('../server');

let server;
let port = 3000;

/**
 * Make sure that Express app is correctly shut down after the tests.
 */
beforeAll(() => {
	server = app.listen(port);
});

afterAll(() => {
	return new Promise(done => {
		server.close(done);
	})
});

/**
 * Tests for the Domain Lookup Endpoint.
 * 
 * This suite of tests verifies the functionality of the domain lookup endpoint.
 * It includes tests to ensure that the endpoint requires a domain parameter and
 * can return IPs for a valid domain.
 */
describe('Domain Lookup Endpoint', () => {
	// Test to ensure the endpoint requires a domain parameter.
	it('should require a domain parameter', async () => {
		// Sends a GET request to the endpoint without a domain parameter.
		const res = await request(app).get('/v1/tools/lookup');
		// Expects the response status code to be 400, indicating a bad request.
		expect(res.statusCode).toEqual(400);
	});
	// Test to ensure the endpoint returns IPs for a valid domain.
	it('should return IPs for a valid domain', async () => {
		// Sends a GET request to the endpoint with a valid domain parameter.
		const res = await request(app).get('/v1/tools/lookup?domain=google.com');
		// Expects the response status code to be 200, indicating success.
		expect(res.statusCode).toEqual(200);
		// Expects the response body to have a property 'ips', containing the IPs.
		expect(res.body).toHaveProperty('ips');
	});
});

/**
 * Test case for the History Endpoint.
 * This test verifies that the History Endpoint correctly returns the latest queries.
 * It sends a GET request to the '/v1/history' endpoint and checks if the response status code is 200,
 * indicating a successful request. Additionally, it verifies that the number of items in the response body
 * does not exceed 20, ensuring that the endpoint correctly limits the number of returned queries.
 */
describe('History Endpoint', () => {
	it('should return the latest queries', async () => {
		const res = await request(app).get('/v1/history');
		expect(res.statusCode).toEqual(200);
		expect(res.body.length).toBeLessThanOrEqual(20);
	});
});

/**
 * Tests for the IP Validation Endpoint.
 * This suite of tests checks the functionality of the IP validation endpoint,
 * ensuring it correctly validates IPv4 addresses, and identifies invalid addresses or strings that are not IPv4 addresses.
 */
describe('IP Validation Endpoint', () => {
	/**
	 * Test to validate a correct IPv4 address.
	 * It sends a POST request with a valid IPv4 address and expects a 200 status code
	 * along with a response body indicating the IP is valid.
	 */
	it('should validate a correct IPv4 address', async () => {
		const res = await request(app)
			.post('/v1/tools/validate')
			.send({ ip: '192.168.1.1' });
		expect(res.statusCode).toEqual(200);
		expect(res.body).toEqual({ ip: '192.168.1.1', isValid: true });
	});

	/**
	 * Test to invalidate an incorrect IPv4 address.
	 * It sends a POST request with an invalid IPv4 address (values out of range) and expects a 200 status code
	 * along with a response body indicating the IP is invalid.
	 */
	it('should invalidate an incorrect IPv4 address', async () => {
		const res = await request(app)
			.post('/v1/tools/validate')
			.send({ ip: '256.256.256.256' });
		expect(res.statusCode).toEqual(200);
		expect(res.body).toEqual({ ip: '256.256.256.256', isValid: false });
	});

	/**
	 * Test to invalidate a non-IPv4 address string.
	 * It sends a POST request with a string that does not represent an IPv4 address and expects a 200 status code
	 * along with a response body indicating the string is not a valid IP address.
	 */
	it('should invalidate a non-IPv4 address string', async () => {
		const res = await request(app)
			.post('/v1/tools/validate')
			.send({ ip: 'not.an.ip.address' });
		expect(res.statusCode).toEqual(200);
		expect(res.body).toEqual({ ip: 'not.an.ip.address', isValid: false });
	});
});


/**
 * Asynchronously connects to the MongoDB database using the Mongoose library.
 * This function is intended to be called before all test suites to ensure that a connection to the database is established.
 * It uses the MONGODB_URI environment variable for the database connection string.
 * 
 * @async
 * @returns {Promise<void>} A promise that resolves when the connection is successfully established.
 */
beforeAll(async () => {
	await mongoose.connect(process.env.MONGODB_URI);
}, 30000);

/**
 * Asynchronously closes the connection to the MongoDB database using the Mongoose library.
 * This function is intended to be called after all test suites have run to ensure that the database connection is properly closed,
 * preventing any potential resource leaks or hanging tests.
 * 
 * @async
 * @returns {Promise<void>} A promise that resolves when the connection is successfully closed.
 */
afterAll(async () => {
	await mongoose.connection.close();
});
