from md2xml import to_xml
import os, sys

if __name__ == '__main__':
    if len(sys.argv) > 1:
        dir = sys.argv[1]
    else:
        dir = './'

    for file in os.listdir(dir):
        if file[-3:] != '.md':
            continue
        filepath = dir + '/' + file
        xml = to_xml(filepath)

        with open(filepath.replace('.md', '.xml'), 'w') as f:
            f.write(xml)