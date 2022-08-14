# dependencies pandas, xlrd
# command to install --> python.exe -m pip install pandas
# command to install --> python.exe -m pip install xlrd

import pandas

#Variables
SourceFile = 'C:\\Users\\jmont\\source\\Book1.xlsx'
DestinationFile = 'C:\\Users\\jmont\\source\\Book1.json'

xlsfile = pandas.read_excel(SourceFile, sheet_name='Open File')
xlsfile.to_json(DestinationFile)

json_str = xlsfile.to_json()

print('Excel Sheet to JSON:\n', json_str)