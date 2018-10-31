# One click docker updater
Auto update your docker containers from fresh images.

This script takes for granted that you use files like:

```Dockerfile
    docker run -d \
      --name=portainer\
        -v /var/run/docker.sock:/var/run/docker.sock \
        -e PGID=1001 -e PUID=1000  \
        -p 9000:9000 \
   portainer/portainer:latest   
```
and pull the latest images. Also, make sure that you are not losing any data updating.

Point the script to the directory of your docker files, and if you would like some of your containers to not be updated, add them to an ignore list (simple text file ending with `\n`)

### BEWARE!
**Running this script _WILLL_ stop and remove containers that need to be updated _AND_ remove old images in the end.**
