//const swaggerJsdoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');
const fs = require('fs');
const path = require('path');

const swaggerDocument = JSON.parse(fs.readFileSync(path.join(__dirname, 'swagger.json'), 'utf8'));
// const swaggerDefinition = {
// 	openapi: '3.0.0',
// 	info: {
// 		title: 'IP Toolkit - Interview challenge',
// 		version: '1.0',
// 		description: 'Implementation for the interview challenge',
// 	},
// 	servers: [
// 		{
// 			url: 'http://localhost:3000',
// 			description: 'Local server',
// 		},
// 	],
// };

// const options = {
// 	swaggerDefinition,
// 	// Path to the API docs
// 	apis: ['./server.js'],
// };

// const swaggerSpec = swaggerJsdoc(options);

function swaggerDocs(app, port) {
	// Swagger page
	app.use('/docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));

	// Docs in JSON format
	app.get('/docs.json', (req, res) => {
		res.setHeader('Content-Type', 'application/json');
		res.send(swaggerDocument);
	});

	console.log(`Docs available at http://localhost:${port}/docs`);
}

module.exports = { swaggerDocs, swaggerDocument };
