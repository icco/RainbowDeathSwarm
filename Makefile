all: run

# Files we want to ship.
PACKAGE=`find . -type f \( ! -regex '.*/\..*' \) -and -not -iname '*psd'`

run:
	@love .

deploy: *.lua
	zip -r ../RainbowDeathSwarm.love $(PACKAGE)
