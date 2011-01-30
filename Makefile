all: run

# Files we want to ship.
PACKAGE=`find . -type f \( ! -regex '.*/\..*' \) -and -not -iname '*psd'`

run:
	@love .

deploy: *.lua
	zip -r ../RainbowDeathSwarm.love $(PACKAGE)
	#cat $(which love) ../RainbowDeathSwarm.love > ../rds
	cat /usr/bin/love ../RainbowDeathSwarm.love > ../rds
	chmod +x ../rds
