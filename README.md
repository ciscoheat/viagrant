Quick 'n dirty node script for building Vagrant files.

`node build.js` for listing targets.

`node build.js <target>` creates a Vagrantfile and provision.sh in `bin` that can be copied to an empty directory and started with `vagrant up`.

`node build.js -o "<outputdir>" <target>` as above, but places the files in the specified directory (creates it if doesn't exist).

`node build.js -p 1234:80 -o "<outputdir>" <target>` as above, but specifies that port 1234 should be forwarded to port 80 on the vagrant machine. (Default is 4567:80, or use `-p 0` for no port forwarding)

`node build.js <target> <target2>` adds another target to the provision file, for example if you want git included where it isn't.
