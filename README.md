# docker-image-upgrade-script
This is a script to monitor and upgrade an image to the latest version, recreate the container if changed and option to remove orphan images 10+ days old


## Comparison with existing solution
Other cleaner solutions such as [containrrr/watchtower](https://github.com/containrrr/watchtower) exist. However, it requireses mounting the docker socket to docker container which may increase the attack surface if the docker socket is exposed even if it is not ment to be.

## Usage
Make sure the script has execution permission and add it to `crontab`
```
0 3 * * * /path/to/docker_update_script.sh <image-tag> <service-name-in-docker-compose> <clean-up[true, false]> # this runs the script every day at 3AM
# clean up use docker prune to clean orphan images
```

## Limitation
- Do NOT use in development host as there is an option to clean all orphan image which will delete them. This is to ensure the image don't fill up a production service host but will delete other image non selectively.
