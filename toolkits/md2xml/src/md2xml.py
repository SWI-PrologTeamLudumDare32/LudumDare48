# -*- coding: UTF-8 -*-

from node import WorldNode
from xml.dom.minidom import Document
from xml.dom.minidom import parseString
import re

def build_tree(text):
    name_set = set()
    name_set.add("root")
    root = WorldNode("root")

    tmp_text = []

    stack = [root]

    previous_indent = -1

    for line in text.splitlines():
        if str.isspace(line) or line == "":
            continue
        match = re.match(r"^[\t\s]*\+", line)
        if match is None:
            tmp_text += [line.strip(' \t\u200b')]
        else:
            indent = line[:match.end() - 1]
            indent = indent.count('\t')

            stack[-1].text = tmp_text; tmp_text = []

            if indent <= previous_indent:
                for _ in range(indent, previous_indent+1):
                    stack.pop()
            
            _line = line[match.end():]

            if ']' in _line:
                _idx = str.find(_line, ']') + 1
                name = _line[:_idx].strip(' \t[]-\u200b')

                _t = _line[_idx:].strip(' \t\u200b')
                if not (str.isspace(_t) or _t == ""):
                    tmp_text += [_t]
            else:
                name = _line.strip(' []-\t\u200b')

            while(name in name_set):
                name += "#"
            new_node = WorldNode(name)
            name_set.add(name)

            stack[-1].add_child(new_node)
            
            if indent > previous_indent:
                if indent - previous_indent != 1:
                    raise ValueError("Indentation Error!")
            stack.append(new_node)
                
            previous_indent = indent
            
            print('[{}] '.format(new_node.depth) + line)
    return root


def to_xml(filepath):
    with open(filepath, 'rt', encoding='utf-8') as f:
        title = f.readline().strip()
        text = f.read()

    doc = Document()
    dream = doc.createElement('dream')
    dream.setAttribute("name", title)

    tree = build_tree(text)

    dfs_card(doc, dream, tree)

    return dream.toprettyxml()


def dfs_card(doc, dream, root):
    if len(root.children) == 0:
        return
    dream.appendChild(node_to_xml(doc, root))

    for _, child in root.children.items():
        dfs_card(doc, dream, child)

def create_p(doc, text: str):
    if text.startswith("<"):
        return parseString(text).childNodes[0]
    p_elem = doc.createElement('p')
    p_elem.appendChild(doc.createTextNode(text))
    return p_elem

def node_to_xml(doc, root):
    card = doc.createElement("card")
    card.setAttribute("name", root.name)

    sh_elem = doc.createElement('show')
    for t in root.text:
        sh_elem.appendChild(create_p(doc, t))
    card.appendChild(sh_elem)
    
    for _, child in root.children.items():
        btn = doc.createElement('button')
        lb_elem = doc.createElement('label')
        lb_elem.appendChild(create_p(doc, child.display_name))
        btn.appendChild(lb_elem)

        if len(child.children) == 0:
            re_elem = doc.createElement('reveal')

            for t in child.text:
                re_elem.appendChild(create_p(doc, t))

            btn.appendChild(re_elem)
        else:
            go_elem = doc.createElement('go')
            go_elem.setAttribute("card", child.name)
            btn.appendChild(go_elem)

        card.appendChild(btn)
        
    #print(card.toprettyxml())
    return card

