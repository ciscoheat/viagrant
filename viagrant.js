var fs = require('fs');

var targets = {
	c5: ["LAMP with concrete5 site", ["lamp"]],
	c57: ["LAMP with concrete5.7 site", ["lamp"]],
	git: ["Git source control", []],
	haxe: ["Plain haxe", []],
	haxe_full: ["Haxe for all targets and LAMP with mod_neko", ["lamp", "haxe", "node", "haxe_targets", "haxe_mod_neko"]],
	haxe_mod_neko: ["LAMP with Haxe/mod_neko", ["lamp", "haxe"]],
	haxe_targets: ["Haxe with environment for all targets, including Node.js", ["haxe", "node"]],
	lamp: ["LAMP box", []],
	mongodb: ["Latest MongoDB", []],
	node: ["Latest Node.js with npm", []],
	bower: ["Bower, the web package manager", ["node", "git"]],
	python3: ["Python 3.4", []],
	ruby: ["Latest Ruby with rvm", []]
};

// Process arguments
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
})(['p', 'o', 'n']);

// Usage
if(!process.argv[2] || !(process.argv[2] in targets)) {
	console.log('Usage: node viagrant.js [-p 4567:80] [-o "bin"] [-n "servername"] <main-target> <targets...>' + '\n');
	console.log('Available targets');
	console.log('=================');
	for(var key in targets) {
		console.log(key + ": " + targets[key][0]);
	}
	process.exit(1);
}

var srcdir = 'src';

// Set default values for arguments unless found
var ports = args.p != undefined ? args.p.split(':') : [4567];
if(!ports[1]) ports[1] = 80;

var outputdir = args.o != undefined ? args.o : 'bin';
var name = args.n != undefined ? args.n : '';

// Remove script from arguments, leaving only the targets.
process.argv.splice(0, 2);

try {
	fs.mkdirSync(outputdir);
} catch(_) {}

// Replace variables in the Vagrantfile
var vagrantFile = fs.readFileSync(srcdir + '/Vagrantfile', {encoding: 'utf8'});

var forward = 'config.vm.network "forwarded_port", guest: ' + ports[1] + ', host: ' + ports[0];
if(ports[0] == 0) forward = '# ' + forward;

vagrantFile = vagrantFile.replace('{{forwarded_port}}', forward);
vagrantFile = vagrantFile.replace('{{name}}', name ? ('v.name = "' + name + '"') : '');

fs.writeFileSync(outputdir + '/Vagrantfile', vagrantFile);

// Create the provision file from targets
var deps = ["header"];
for(var i in process.argv) {
	// Add dependencies first
	deps = deps.concat(targets[process.argv[i]][1]).concat(process.argv[i]);
}
// Filter multiple targets
deps = deps.filter(function(value, index, self) { return self.indexOf(value) === index; });

var output = fs.writeFileSync(outputdir + '/provision.sh', '');

for(var i in deps) {
	var file = srcdir + '/' + deps[i] + '.sh';
	if(!fs.existsSync(file)) continue;
	
	var input = fs.readFileSync(file, {encoding: 'utf8'});

	// Replace variables in header file.
	if(deps[i] == "header") {
		var rename = name ? "sed -i 's/precise64/"+name+"/g' /etc/hostname /etc/hosts" : '';
		input = input.replace('{{rename}}', rename);
	}

	// Write to the provision file
	fs.appendFileSync(outputdir + '/provision.sh', input);
}
