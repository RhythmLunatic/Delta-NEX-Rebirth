#x = P1 2 (hold head)
#X = P1 1 (tap note)

#y = P2 2 (hold head)
#Y = P2 1 (tap note)
#3 = unchanged. Because there can only be one 3 at a time, it's probably determined by checking
#which side started the hold.
"""
Convert StepF2 Double Performance to Routine, starting from the #NOTES block.
Usage: python3 dp2routine file.txt > output.txt
"""
import sys
with open(sys.argv[1]) as file_read:
	content = file_read.readlines()					
	insideNotesBlock = False
	currentMeasure = 0
	p1Chart = []
	p2Chart = []
	#Since StepF2 combines hold ends together, we have to keep track of which one started
	#the hold head so we can put the hold end in the right chart.
	p1IsHoldEnd = [False,False,False,False,False,False,False,False,False,False]
	p2IsHoldEnd = [False,False,False,False,False,False,False,False,False,False]
	for line in content:
		if (line == "#NOTES:\n"): #Start of #NOTES block
			insideNotesBlock = True
			#print("#START")
		if (insideNotesBlock):
			if line[0] == ",":
				currentMeasure+=1
				p1Chart.append(", //Measure "+ str(currentMeasure))
				p2Chart.append(", //Measure "+ str(currentMeasure))
			elif (line[0] == ";"): #End of #NOTES block
				insideNotesBlock = False
				#print("Measures: "+str(len(noteChart)))
				#print(noteChart[0])
				for line in p1Chart:
					print(line)
				print("&\n")
				for line in p2Chart:
					print(line)
				print(";")
				sys.exit(0)
			else:
				#print("Current measure:"+str(currentMeasure))
				p1Line = ["0","0","0","0","0","0","0","0","0","0"]
				p2Line = ["0","0","0","0","0","0","0","0","0","0"]
				for i in range(len(line)):
					#print(str(i) + " "+ line[i])
					#Player 1
					if line[i] == "x":
						p1Line[i] = "2"
						#print("Hold end at "+str(i))
						p1IsHoldEnd[i] = True
					elif line[i] == "X":
						p1Line[i] = "1"
					#Player 2
					elif line[i] == "y":
						p2Line[i] = "2"
						#print("Hold end at "+str(i))
						p2IsHoldEnd[i] = True
					elif line[i] == "Y":
						p2Line[i] = "1"
					#Hold ends
					elif line[i] == "3":
						if p1IsHoldEnd[i]:
							p1Line[i] = "3"
							p1IsHoldEnd[i] = False
						elif p2IsHoldEnd[i]:
							p2Line[i] = "3"
							p2IsHoldEnd[i] = False
						else:
							raise Exception("Neither P1 or P2 had active holds! Line:"+line)
					elif line[i] == "\n" or line[i] == "0":
						pass
					else:
						print("WARNING: Line contains unknown characters: "+line)
				p1Chart.append("".join(p1Line))
				p2Chart.append("".join(p2Line))