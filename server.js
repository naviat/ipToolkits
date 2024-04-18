require('dotenv').config();
const express = require('express');
const axios = require('axios');
const promBundle = require('express-prom-bundle');
const Lookup = require('./models/Lookup');
const { swaggerDocs, swaggerDocument } = require('./swagger');

const app = express();
const port = process.env.PORT || 3000;
app.use(express.json());
app.use(promBundle({ includeMethod: true })); // For expose prometheus metrics

/**
 * Handles the root GET request.
 * This endpoint provides basic information about the API including its version, the current server time in UNIX timestamp format, and a boolean indicating if the server is running in a Kubernetes environment.
 * 
 * @param {Object} req - The request object from the client. Not used in this function but required by Express.js routing.
 * @param {Object} res - The response object used to send back the API information.
 * @returns {void} - Sends a JSON response with the API version, current server time, and Kubernetes environment status.
 */
app.get('/', (req, res) => {
	res.json({
		version: swaggerDocument.info.version,
		date: Math.floor(Date.now() / 1000),
		kubernetes: process.env.KUBERNETES === 'true'
	});
});

/**
 * Handles the health check GET request.
 * Responds with the status of the application, indicating it is running and healthy.
 * 
 * @param {Object} req - The request object from the client.
 * @param {Object} res - The response object to send back the health status.
 * @returns {void} - Sends a JSON response with the health status of the application.
 */
app.get('/health', (req, res) => {
	res.json({ status: 'healthy' });
});

/**
 * Asynchronous function to handle the IP Lookup endpoint.
 * This function processes a GET request to resolve a domain name to its IP addresses using Google's DNS service.
 * It requires a 'domain' query parameter to perform the lookup.
 * If the domain is resolved successfully, it stores the lookup result in the database and returns the IPs to the client.
 * In case of missing 'domain' parameter or any error during the domain resolution, it responds with an appropriate error message.
 * 
 * @param {Object} req - The request object from the client, expected to contain a 'domain' query parameter.
 * @param {Object} res - The response object used to send back the resolved IPs or error messages.
 * @returns {Promise<void>} - A promise that resolves with no value, indicating the asynchronous operation has completed.
 */
app.get('/v1/tools/lookup', async (req, res) => {
	if (!req.query.domain) {
		return res.status(400).json({ error: "Domain parameter is required" });
	}

	try {
		const url = `https://dns.google/resolve?name=${req.query.domain}&type=A`;
		const response = await axios.get(url);

		// Check if the domain was not found (Status: 3 indicates NXDOMAIN)
		if (response.data.Status === 3) {
			return res.status(404).json({ error: 'Domain not found' });
		}

		// Check if there are any IP addresses returned
		if (!response.data.Answer) {
			return res.status(404).json({ error: 'No IP addresses found for the domain' });
		}

		const ips = response.data.Answer.map(ans => ans.data);
		await Lookup.create({ domain: req.query.domain, ips });
		res.json({ domain: req.query.domain, ips });
	} catch (error) {
		console.error('Error fetching DNS data:', error);
		res.status(500).json({ error: 'Failed to resolve domain', details: error.message });
	}
});


/**
 * Handles the IP validation POST request.
 * This endpoint receives an IP address in the request body and validates whether it is a valid IPv4 address.
 * 
 * @param {Object} req - The request object from the client, expected to contain an 'ip' property in the body.
 * @param {Object} res - The response object used to send back the validation result.
 * @returns {void} - Sends a JSON response with the original IP and a boolean indicating its validity.
 */
app.post('/v1/tools/validate', (req, res) => {
	const { ip } = req.body;
	const ipv4Regex = /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){2}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
	const isValid = ipv4Regex.test(ip);
	res.json({ ip, isValid });
});

/**
 * Asynchronous function to handle the history endpoint GET request.
 * This function retrieves the last 20 lookup operations from the database, sorted by creation date in descending order.
 * It then sends this data back to the client as a JSON response.
 * 
 * @param {Object} req - The request object from the client.
 * @param {Object} res - The response object used to send back the lookup history.
 * @returns {Promise<void>} - A promise that resolves with no value, indicating the asynchronous operation has completed.
 */
app.get('/v1/history', async (req, res) => {
	const queries = await Lookup.find().sort({ createdAt: -1 }).limit(20);
	res.json(queries);
});

swaggerDocs(app, port);
module.exports = app;
