const mongoose = require('mongoose');

/**
 * Schema definition for the Lookup model.
 * This schema represents the structure of the Lookup documents in the MongoDB database.
 * 
 * Fields:
 * - domain: A string that is required for each document. Represents the domain name being looked up.
 * - ips: An array of strings, each representing an IP address associated with the domain.
 * - createdAt: A date indicating when the document was created. Defaults to the current date and time.
 */
const LookupSchema = new mongoose.Schema({
	domain: {
		type: String,
		required: true
	},
	ips: [String],
	createdAt: {
		type: Date,
		default: Date.now
	}
});

// Export the Lookup model, which is a compiled version of the LookupSchema.
// This model provides an interface to the database for creating, querying, updating, and deleting documents.
module.exports = mongoose.model('Lookup', LookupSchema);
