# docker-blockcollider [![Build Status](https://travis-ci.org/trick77/docker-blockcollider.svg?branch=master)](https://travis-ci.org/trick77/docker-blockcollider)

How to easily run [Block Collider's bcnode](https://github.com/blockcollider/bcnode) on Linux using Docker and docker-compose... and without running the container as root.

Please don't create Github issues:
- If you don't know how to use Linux and/or Docker and/or git/Github.
- If you don't know how to run Docker on Windows or the Mac.
- If you have questions about Block Collider, these should go to the appropriate Telegram channels.

Any other issues are welcome. However, please consider contributing by submitting pull requests instead.

## Installing & running bcnode

1. Install the latest Docker CE environment.
2. Install docker-compose
	1. On Debian/Ubuntu: ```sudo apt -y install python-pip && sudo pip install docker-compose```
3. Clone this repo and cd into it
4. Replace the miner-key in docker-compose.yml with your own miner-key 
5. ```sudo docker-compose up -d``` (this will build it and run it in the background)

Once the build has been completed, check the log output of the running Docker container with ```sudo docker-compose logs -f```

To stop the container use ```sudo docker-compose down```

To see what the block rovers do you can access http://localhost:3000/ or, if your server's IP address is accessible from the internet, http://your-servers-public-ip:3000/. The UI shows the latest received blocks from the supported blockchains.

![rovers](https://i.imgur.com/MP5cQGI.png)

## Configuration

See the conf directory. As of now there's no documentation on the JSON configuration file. However, the configuration will be read from this directory whenever the container is started with the up command.

The Collider's block data is persisted in the data Docker volume and will survive restarting the Docker container:

```
sudo docker volume ls
DRIVER              VOLUME NAME
local               docker-blockcollider_data
```

If you want to get rid of the existing block data, use ```sudo docker-compose down -v```

