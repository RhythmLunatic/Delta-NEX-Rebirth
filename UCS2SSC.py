import sys

remapDictionary = {
	"M":'2',
	"W":'3',
	"X":'1'
}

with open(sys.argv[1]) as file_read:
	content = file_read.readlines()
	chart = []
	for line in content:
		if line.startswith(":"):
			continue
		sscLine = ["0"]*5
		for i in range(len(line)):
			if line[i] == '.' or line[i] == 'H' or line[i] == "\n":
				pass
			#elif line[i] == 'M':
			#	sscLine[i] = '2'
			elif line[i] in remapDictionary:
				sscLine[i] = remapDictionary[line[i]]
		chart.append(sscLine)
	for i in range(len(chart)):
		print(''.join(chart[i]))
		if (i+1)%8 == 0 and i != len(chart)-1:
			print(",")
