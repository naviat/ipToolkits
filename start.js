const app = require('./server');
const mongoose = require('mongoose');

// MongoDB connection
mongoose.connect(process.env.MONGODB_URI)
	.then(() => console.log('Successfully connected to MongoDB'))
	.catch(err => console.log('MongoDB connection error:', err));

const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`Server running on port ${port}`));

/**
 * Handles the graceful shutdown of the server and MongoDB connection.
 * This function is triggered by the 'SIGTERM' signal, indicating the process is being terminated.
 * It first closes the Express server and then the MongoDB connection.
 * Upon successful closure of both, it exits the process with a status code of 0, indicating a successful termination.
 */
process.on('SIGTERM', () => {
	server.close(() => {
		console.log('Server closed');
		mongoose.connection.close(false, () => {
			console.log('MongoDB connection closed');
			process.exit(0);
		});
	});
});