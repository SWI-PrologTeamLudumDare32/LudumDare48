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
        print(filepath)
        try:
            xml = to_xml(filepath)
        except BaseException as e:
            print(str(e))
            input("Press any key to exit.")
            exit(1)
        print(' ')

        with open(filepath.replace('.md', '.xml'), 'w', encoding='utf-8') as f:
            f.write(xml)

    input("All operations are successful. Press any key to exit.")

    