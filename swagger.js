//const swaggerJsdoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');
const fs = require('fs');
const path = require('path');

const swaggerDocument = JSON.parse(fs.readFileSync(path.join(__dirname, 'swagger.json'), 'utf8'));

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
