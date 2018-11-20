function processCSV(text){
	var allTextLines = text.split(/\r\n|\n/);
	var headers = allTextLines[0].split(',');
	var lines = [];
	for (var i = 1; i < allTextLines.length; i++) {
		var data = allTextLines[i].split(',');
		if (data.length == headers.length) {
			var line = {};
			for (var j = 0; j < headers.length; j++) {
				line[headers[j]] = data[j];
			}
			lines.push(line);
		}
	}
	return lines;
}

function loadCSV(filename, callback){
	fetch(filename)
		.then(e => e.text())
		.then(e => {
			let data = processCSV(e);
			if(callback != null){
				callback(data);
			}
		});
}
