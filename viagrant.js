"use strict";

const fs = require('fs')

const targets = {
	arangodb: ["ArangoDB 2.8.9", []],
	bower: ["Bower, the web package manager", ["node", "git"]],
	c5: ["LAMP with concrete5 5.6.3.3", ["lamp"]],
	c57: ["LAMP with concrete5 5.7.5.1", ["lamp"]],
	git: ["Git source control", []],
	haxe: ["Haxe 3.2.1", []],
	haxe_full: ["Haxe for all targets and LAMP with mod_neko", ["lamp", "haxe", "haxe_mod_neko", "haxe_targets"]],
	haxe_mod_neko: ["LAMP with Haxe and mod_neko", ["lamp", "haxe"]],
	haxe_targets: ["Haxe with environment for all targets", ["node", "phantomjs", "python3", "java", "haxe"]],
	java: ["Java 8 JDK (openjdk)", []],
	lamp: ["Ubuntu 12.04, Apache 2.2.22, Mysql 5.5.4, PHP 5.3", []],
	mongodb: ["Latest MongoDB", []],
	node: ["Node.js 5.11.1 with npm", []],
	phantomjs: ["PhantomJS 1.9.8", ["node"]],
	python3: ["Python 3.4", []],
	ruby: ["Latest Ruby with rvm", []]
}

// Process arguments
const args = (function(args) {
	const output = {};
	for (let j = 0; j < args.length; j++) {
		let found = 0
		for (let i = 0; i < process.argv.length; i++) {
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
	for(let key in targets) {
		console.log(key + ": " + targets[key][0]);
	}
	process.exit(1);
}

const srcdir = 'src'

// Set default values for arguments unless found
const ports = args.p != undefined ? args.p.split(':') : [0]
if(!ports[1]) ports[1] = 80

const outputdir = args.o != undefined ? args.o : 'bin'
const name = args.n != undefined ? args.n : ''

// Remove script from arguments, leaving only the targets.
process.argv.splice(0, 2)

try {
	fs.mkdirSync(outputdir)
} catch(_) {}

// Replace variables in the Vagrantfile
const forward = (ports[0] == 0 ? "# " : "") + `config.vm.network "forwarded_port", guest: ${ports[1]}, host: ${ports[0]}`

let vagrantFile = fs.readFileSync(srcdir + '/Vagrantfile', {encoding: 'utf8'})
vagrantFile = vagrantFile.replace('{{forwarded_port}}', forward)
vagrantFile = vagrantFile.replace('{{name}}', name ? (`v.name = "${name}"`) : '')

fs.writeFileSync(outputdir + '/Vagrantfile', vagrantFile)

// Create the provision file from targets
let deps = ["header"]

function addDeps(name) {
	if(deps.indexOf(name) >= 0) return
	deps.push(name)

	if(!targets[name]) return

	targets[name][1].forEach(function(target) {
		addDeps(target);
	})
}

for(let i in process.argv) addDeps(process.argv[i])

deps.push("footer")

// Filter multiple targets
deps = deps.filter(function(value, index, self) { return self.indexOf(value) === index })

const output = fs.writeFileSync(outputdir + '/provision.sh', '')

for(let i in deps) {
	const file = srcdir + '/' + deps[i] + '.sh'
	if(!fs.existsSync(file)) continue
	
	let input = fs.readFileSync(file, {encoding: 'utf8'})

	// Replace a special variable in footer.
	if(deps[i] == "footer") {
		const rename = name ? "sed -i 's/precise64/"+name+"/g' /etc/hostname /etc/hosts" : ''
		input = input.replace('{{rename}}', rename)

		if(name)
			input = input.replace('{{reload}}', 'echo ""\necho "Execute \'vagrant reload\' to rename the VM and complete the process."')
		else
			input = input.replace('{{reload}}', '')
	}

	// Write to the provision file
	fs.appendFileSync(outputdir + '/provision.sh', input)
}
