/**
 * 
 * 
 */

function name() {
	output = null;
	input = '1234567&8&'
	if (input != null) {
		var pattern = /\&amp\;/gi;
		output = input.replace(pattern, "&");
	}

	//console('value of output:' + output);
	return output;
}
