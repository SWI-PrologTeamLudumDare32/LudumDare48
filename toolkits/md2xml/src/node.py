class WorldNode:
    def __init__(self, name):
        self.name = name
        self.children = {}
        self.parent = None
        self.depth = 0
        self.text = ""

    @property
    def display_name(self):
        return self.name.strip("#")

    def add_child(self, node):
        if node.name in self.children:
            print("{} already exists.".format(node.name))
        self.children[node.name] = node
        node.parent = self
        node.depth = self.depth + 1