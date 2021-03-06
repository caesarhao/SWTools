# lvm cache of 20G has been created for /fedora/root logical volume with the following script.
# caesarhao
# Mar 5, 2018

# change ssd /dev/sdb to physical volume, to be used by lvm2
sudo pvcreate /dev/sdb
# add ssd into "volume group" which already exists
sudo vgextend fedora /dev/sdb
# create cache volume
sudo lvcreate -L 20G -n root_cache fedora /dev/sdb
# create cache meta volume, at least 20M
sudo lvcreate -L 20M -n root_cache_meta fedora /dev/sdb
# show current state
sudo lvs -a
# combine cache and cache_meta into cache pool
sudo lvconvert --type cache-pool --cachemode writethrough --poolmetadata fedora/root_cache_meta fedora/root_cache
# show current state
sudo lvs -a
# combine the cache pool with slow original volume
sudo lvconvert --type cache --cachepool fedora/root_cache fedora/root
# rebuild initramfs
sudo dracut -v -f



