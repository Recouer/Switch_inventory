.PHONY: switch clean range clean_data clean_all

MIN=-1
MAX=-1

switch:
	./src/script.sh

merge:
	./src/merge.sh


clean_data:
	rm -r ./SwitchData/Data/*
	rm ./SwitchData/tmp/*
	rm ./src/*~
	rm *~

clean_all:	remove_data
	rm -r ./Rendu/*
	rm -r ./SwitchData/tmp/*
	> feedMeSwitchs.txt
