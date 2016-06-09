Quick 'n dirty node script for building Vagrant files.

`node viagrant.js` for listing targets.

`node viagrant.js <target>` creates a Vagrantfile and provision.sh in `bin` that can be copied to an empty directory and started with `vagrant up`.

`node viagrant.js -o "<outputdir>" <target>` as above, but places the files in the specified directory (creating it if doesn't exist).

`node viagrant.js -p 4567:80 -o "<outputdir>" <target>` as above, but specifies that port 4567 should be forwarded to port 80 on the vagrant machine.

`node viagrant.js <target> <target...>` adds more targets to the provision file.
