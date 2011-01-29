all: run

run:
	@love .

deploy: *.lua
	zip -r ../RainbowDeathSwarm.love *
