const mongoose = require('mongoose');

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

module.exports = mongoose.model('Lookup', LookupSchema);
