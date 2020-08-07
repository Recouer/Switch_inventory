.PHONY: switch clean


switch:
	./src/script.sh

merge:
	./src/merge.sh



remove_data:
	rm -r ./SwitchData/Data/*
	rm *~

remove_all:	remove_data
	rm -r ./Rendu/*
	rm -r ./SwitchData/tmp/*
	> feedMeSwitchs.txt
