Quick 'n dirty node script for building Vagrant files.

`node build.js` for listing targets.

`node build.js <target>` creates a Vagrantfile and provision.sh in `bin` that can be copied to an empty directory and started with `vagrant up`.

`node build.js <target> <outputdir>` as above, but places the files in the specified directory (creates it if doesn't exist).
