const request = require('supertest');
const mongoose = require('mongoose');
const app = require('../server');

describe('Domain Lookup Endpoint', () => {
	it('should require a domain parameter', async () => {
		const res = await request(app).get('/v1/tools/lookup');
		expect(res.statusCode).toEqual(400);
	});

	it('should return IPs for a valid domain', async () => {
		const res = await request(app).get('/v1/tools/lookup?domain=google.com');
		expect(res.statusCode).toEqual(200);
		expect(res.body).toHaveProperty('ips');
	}, 10000);
});

describe('History Endpoint', () => {
	it('should return the latest queries', async () => {
		const res = await request(app).get('/v1/history');
		expect(res.statusCode).toEqual(200);
		expect(res.body.length).toBeLessThanOrEqual(20);
	});
});


describe('IP Validation Endpoint', () => {
	it('should validate a correct IPv4 address', async () => {
		const res = await request(app)
			.post('/v1/tools/validate')
			.send({ ip: '192.168.1.1' });
		expect(res.statusCode).toEqual(200);
		expect(res.body).toEqual({ ip: '192.168.1.1', isValid: true });
	});

	it('should invalidate an incorrect IPv4 address', async () => {
		const res = await request(app)
			.post('/v1/tools/validate')
			.send({ ip: '256.256.256.256' });
		expect(res.statusCode).toEqual(200);
		expect(res.body).toEqual({ ip: '256.256.256.256', isValid: false });
	});

	it('should invalidate a non-IPv4 address string', async () => {
		const res = await request(app)
			.post('/v1/tools/validate')
			.send({ ip: 'not.an.ip.address' });
		expect(res.statusCode).toEqual(200);
		expect(res.body).toEqual({ ip: 'not.an.ip.address', isValid: false });
	});
});

beforeAll(async () => {
	console.log("Connecting to MongoDB...");
	await mongoose.connect(process.env.MONGODB_URI);
	console.log("Connected to MongoDB.");
}, 10000); // increases the default timeout to 10 seconds

afterAll(async () => {
	console.log("Disconnecting from MongoDB...");
	await mongoose.connection.close();
	console.log("Disconnected from MongoDB.");
}, 10000); // increases the default timeout to 10 seconds
