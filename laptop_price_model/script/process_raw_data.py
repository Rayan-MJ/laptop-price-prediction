import pandas as pd
from pathlib import Path

cwd = Path().resolve()



def processRawData(data,Is_main):
    if Is_main:
        templateData_path = cwd / 'data' / 'processed' / 'row.csv'
        templateData = pd.read_csv(templateData_path)

    else:
        templateData_path = cwd.parent / 'data' / 'processed' / 'row.csv'
        templateData = pd.read_csv(templateData_path)

    rawData = pd.DataFrame(data)
    processedData = templateData.copy()

    processedData[[('Brand_'+rawData[0]),('Type_'+rawData[1]),('Screen Specs_'+rawData[3]),('CPU_'+rawData[4]),('Hard Disk_'+rawData[6]),('GPU_'+rawData[7]),('Operating System_'+rawData[8])]] = 1
    processedData['RAM'] = rawData[5].str.replace('GB', '', regex=False).astype(int)
    processedData['Weight'] = rawData[9].str.replace('kg', '', regex=False).astype(float)
    processedData['Screen Size'] = rawData[2].astype(float)

    return processedData

