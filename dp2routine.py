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
	foundCoopChart = False
	insideNotesBlock = False
	currentMeasure = 0
	ChartTracks = [[],[],[],[]]
	
	#Since StepF2 combines hold ends together, we have to keep track of which one started
	#the hold head so we can put the hold end in the right chart.
	HoldEnds= []
	for i in range(len(ChartTracks)):
		HoldEnds.append([False,False,False,False,False,False,False,False,False,False])
	for line in content:
		if (line.startswith("#CHARTNAME")):
			if 'CO-OP' in line:
				foundCoopChart = True
		#Skip until we find a co-op chart
		if not foundCoopChart:
			continue
			
		if (line == "#NOTES:\n"): #Start of #NOTES block
			insideNotesBlock = True
			#print("#START")
		if (insideNotesBlock):
			if line[0] == ",":
				currentMeasure+=1
				for chart in ChartTracks:
					chart.append(", //Measure "+ str(currentMeasure))
			elif (line[0] == ";"): #End of #NOTES block
				insideNotesBlock = False
				#print("Measures: "+str(len(noteChart)))
				#print(noteChart[0])
				for i in range(len(ChartTracks)):
					if '1' not in ''.join(ChartTracks[i]):
						print("Track for player " +str(i+1) + " is empty.")
				for i in range(len(ChartTracks)):
					for line in ChartTracks[i]:
						print(line)
					if i != len(ChartTracks):
						print("&\n")
				print(";")
				sys.exit(0)
			else:
				#print("Current measure:"+str(currentMeasure))
				NoteLines = []
				for i in range(len(ChartTracks)):
					NoteLines.append(["0","0","0","0","0","0","0","0","0","0"])
				
				for i in range(len(line)):
					#print(str(i) + " "+ line[i])
					#Player 1
					if line[i] == "x":
						NoteLines[0][i] = "2"
						HoldEnds[0][i] = True
					elif line[i] == "X":
						NoteLines[0][i] = "1"
					#Player 2
					elif line[i] == "y":
						NoteLines[1][i] = "2"
						HoldEnds[1][i] = True
					elif line[i] == "Y":
						NoteLines[1][i] = "1"
					#Player 3
					elif line[i] == "z":
						NoteLines[2][i] = "2"
						HoldEnds[2][i] = True
					elif line[i] == "Z":
						NoteLines[2][i] = "1"
					#Player 4
					elif line[i] == "2":
						NoteLines[3][i] = "2"
						HoldEnds[3][i] = True
					elif line[i] == "1":
						NoteLines[3][i] = "1"
					#Hold ends
					elif line[i] == "3":
						for j in range(len(HoldEnds)):
							if HoldEnds[j][i]:
								NoteLines[j][i] = "3"
								HoldEnds[j][i] = False
					#Just shove it into the p1 track
					elif line[i] == "F":
						NoteLines[0][i] = "F"
					elif line[i] == "M":
						NoteLines[0][i] = "M"
					elif line[i] == "\n" or line[i] == "0":
						pass
					else:
						print("WARNING: Line contains unknown characters: "+line)

				for i in range(len(ChartTracks)):
					ChartTracks[i].append("".join(NoteLines[i]))
