# docker-image-upgrade-script
This is a script to monitor and upgrade an image to the latest version, recreate the container if changed and option to remove orphan images 10+ days old


## Comparison with existing solution
Other cleaner solutions such as [containrrr/watchtower](https://github.com/containrrr/watchtower) exist. However, it requireses mounting the docker socket to docker container which may increase the attack surface if the docker socket is exposed even if it is not ment to be.

## Usage
Make sure the script has execution permission and add it to `crontab`
```
0 3 * * * cd /path/to/compose/folder && /path/to/docker_update_script.sh <container_name> <service_name> <target_image_name> # this runs the script every day at 3AM
# clean up use docker prune to clean orphan images
```
