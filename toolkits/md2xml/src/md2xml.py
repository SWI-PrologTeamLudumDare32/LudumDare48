from node import WorldNode
from xml.dom.minidom import Document
import re

def build_tree(text):
    root = WorldNode("root")

    tmp_text = []

    stack = [root]

    previous_indent = -1

    for line in text.splitlines():
        if str.isspace(line) or line == "":
            continue
        match = re.match(r"^[\t\s]*\+", line)
        if match is None:
            tmp_text += [line.strip(" \t")]
        else:
            indent = line[:match.end() - 1]
            indent = indent.count('\t')

            stack[-1].text = tmp_text; tmp_text = []

            if indent <= previous_indent:
                for _ in range(indent, previous_indent+1):
                    stack.pop()
            
            name = line[match.end():].strip(' []-')
            new_node = WorldNode(name)

            stack[-1].add_child(new_node)
            
            if indent > previous_indent:
                assert indent - previous_indent == 1
            stack.append(new_node)
                
            previous_indent = indent
            
            print('[{}] '.format(new_node.depth) + line)
    return root


def to_xml(filepath):
    with open(filepath) as f:
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

def create_p(doc, text):
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
    
    for name, child in root.children.items():
        btn = doc.createElement('button')
        lb_elem = doc.createElement('label')
        lb_elem.appendChild(create_p(doc, name))
        btn.appendChild(lb_elem)

        re_elem = doc.createElement('reveal')

        for t in child.text:
            re_elem.appendChild(create_p(doc, t))

        btn.appendChild(re_elem)

        go_elem = doc.createElement('go')
        go_elem.setAttribute("card", name)
        btn.appendChild(go_elem)

        card.appendChild(btn)
        
    #print(card.toprettyxml())
    return card

