var fs = require('fs');

var targets = {
	c5: ["LAMP with concrete5 site", ["lamp"]],
	haxe: ["Plain haxe", []],
	haxe_targets: ["Haxe with environment for all targets", ["haxe"]],
	haxe_full: ["Haxe for all targets and LAMP with mod_neko", ["lamp", "haxe", "haxe_targets", "haxe_mod_neko"]],
	lamp: ["LAMP box", []],
	haxe_mod_neko: ["LAMP with Haxe/mod_neko", ["lamp", "haxe"]]
};

if(!process.argv[2] || !(process.argv[2] in targets)) {
	console.log('Available targets');
	console.log('=================');
	for(var key in targets) {
		console.log(key + ": " + targets[key][0]);
	}
	process.exit(1);
}

var srcdir = 'src';
var outputdir = process.argv[3] ? process.argv[3] : 'bin';

try {
fs.mkdirSync(outputdir);
} catch(_) {}

fs.createReadStream(srcdir + '/Vagrantfile').pipe(fs.createWriteStream(outputdir + '/Vagrantfile'));

var deps = ["header"].concat(targets[process.argv[2]][1]).concat(process.argv[2]);
var output = fs.writeFileSync(outputdir + '/provision.sh', '');

for(var i in deps) {
	var file = srcdir + '/' + deps[i] + '.sh';
	if(!fs.existsSync(file)) continue;
	
	var input = fs.readFileSync(file);
	fs.appendFileSync(outputdir + '/provision.sh', input);
}
