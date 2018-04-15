# docker-blockcollider

How to easily run [Bock Collider's bcnode](https://github.com/blockcollider/bcnode) on Linux using Docker and docker-compose.

Please don't create Github issues:
- if you don't know how to use Linux and/or Docker and/or git/Github.
- if you don't know how to run Docker on Windows or the Mac.
- if you have questions about Block Collider, these should go to the appropriate Telegram channels.

Any other issues are welcome. However, please consider contributing by submitting pull requests instead.

## Installation & running Block Collider

1. Install the latest Docker CE environment.
2. Install docker-compose
	1. On Debian/Ubuntu: ```sudo apt -y install python-pip && sudo pip install docker-compose```
3. Clone this repo and cd into it
4. ```sudo docker-compose up -d``` (this will build it and run it in the background)

Once the build has been completed, check the log output of the running Docker container with ```docker-compose logs -f```

To stop the container use ```docker-compose down```

All saved block data is persisted in the data Docker volume.

To see what the rovers do you can access http://localhost:3000 or, if your server's IP address is accessible from the internet, http://your-servers-public-ip:3000/. The UI shows the latest received blocks from the participating blockchains.

![rovers](https://i.imgur.com/MP5cQGI.png)

## Configuration

See the conf directory. As of now there's no documentation on the JSON configuration file. However, the configuration will be read from this directory whenever the container is started with the up command.

## Limitations

Known limitations in bcnode v0.1.0:

- No wallet/emblem support.
- Only the Rovers are working, mined blocks are not getting broadcasted.
- Eats up lots of CPU and bandwith resources (approximately 18 GB/day) if it runs continuously.
- You won't get rich if by running bcnode nor will you earn any NRG tokens.
- Essentially, there's no point in running this at the moment unless you want to experiment with it.
