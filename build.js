var fs = require('fs');

var targets = {
	c5: ["LAMP with concrete5 site", ["lamp"]],
	haxe: ["Plain haxe", []],
	node: ["Latest Node.js with npm", []],
	git: ["Git source control", []],
	haxe_targets: ["Haxe with environment for all targets, including Node.js", ["haxe", "node"]],
	haxe_full: ["Haxe for all targets and LAMP with mod_neko", ["lamp", "haxe", "node", "haxe_targets", "haxe_mod_neko"]],
	lamp: ["LAMP box", []],
	haxe_mod_neko: ["LAMP with Haxe/mod_neko", ["lamp", "haxe"]]
};

var args = (function(args) {
	var output = {};
	for (var j = 0; j < args.length; j++) {
		var found = 0
		for (var i = 0; i < process.argv.length; i++) {
			if(process.argv[i] == "-" + args[j]) {
				output[args[j]] = process.argv[i+1];
				found = i;
				break;
			}
		}
		if(found) process.argv.splice(found, 2);
	}
	return output;
})(['p', 'o']);

if(!process.argv[2] || !(process.argv[2] in targets)) {
	console.log('Usage: node build.js [-p port=4567] [-o dir="bin"] <main-target> <targets...>' + '\n');
	console.log('Available targets');
	console.log('=================');
	for(var key in targets) {
		console.log(key + ": " + targets[key][0]);
	}
	process.exit(1);
}

var srcdir = 'src';
var port = args.p != undefined ? args.p : 4567;
var outputdir = args.o != undefined ? args.o : 'bin';

process.argv.splice(0, 2);

try {
fs.mkdirSync(outputdir);
} catch(_) {}

var file = fs.readFileSync(srcdir + '/Vagrantfile', {encoding: 'utf8'});
var forward = port != 0 ? 'config.vm.network "forwarded_port", guest: 80, host: ' + port : '';

file = file.replace('{{forwarded_port}}', forward);
fs.writeFileSync(outputdir + '/Vagrantfile', file);

var deps = ["header"].concat(targets[process.argv[0]][1]).concat(process.argv);
var output = fs.writeFileSync(outputdir + '/provision.sh', '');

console.log(deps);

for(var i in deps) {
	var file = srcdir + '/' + deps[i] + '.sh';
	if(!fs.existsSync(file)) continue;
	
	var input = fs.readFileSync(file);
	fs.appendFileSync(outputdir + '/provision.sh', input);
}
