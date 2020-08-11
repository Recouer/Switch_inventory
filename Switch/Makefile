.PHONY: switch clean range clean

MIN=-1
MAX=-1
REMOVE=


switch:
	./src/script.sh

merge:
	./src/merge.sh


range:
	./src/range.sh $(MIN) $(MAX) $(REMOVE)




clean:
	rm -fr *~ ./src/*~ ./SwitchData/tmp/* ./SwitchData/Data/* ./SwitchData/tmp/* ./Rendu/*

	> feedMeSwitchs.txt
