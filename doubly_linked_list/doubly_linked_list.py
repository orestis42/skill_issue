class Node:
    __slots__ = ("value", "next", "previous")

    def __init__(self, value=None):
        self.value = value
        self.next = None
        self.previous = None


class DoublyLinkedList:
    def __init__(self):
        self.dummy_head = Node()
        self.dummy_tail = Node()
        self.dummy_head.next = self.dummy_tail
        self.dummy_tail.previous = self.dummy_head

    def insert_front(self, value):
        new = Node(value)
        old_first = self.dummy_head.next
        new.next = old_first
        new.previous = self.dummy_head
        self.dummy_head.next = new
        old_first.previous = new
        return new

    def insert_back(self, value):
        new = Node(value)
        old_last = self.dummy_tail.previous
        new.next = self.dummy_tail
        new.previous = old_last
        old_last.next = new
        self.dummy_tail.previous = new
        return new

    def delete(self, node):
        previous_node = node.previous
        next_node = node.next
        previous_node.next = next_node
        next_node.previous = previous_node
        node.next = None
        node.previous = None
        return node.value

    def traverse_forward(self):
        values = []
        current = self.dummy_head.next
        while current is not self.dummy_tail:
            values.append(current.value)
            current = current.next
        return values

    def traverse_backward(self):
        values = []
        current = self.dummy_tail.previous
        while current is not self.dummy_head:
            values.append(current.value)
            current = current.previous
        return values

    def reverse(self):
        current = self.dummy_head
        while current is not None:
            current.next, current.previous = current.previous, current.next
            current = current.previous
        self.dummy_head, self.dummy_tail = self.dummy_tail, self.dummy_head

    def __repr__(self):
        return f"DoublyLinkedList({self.traverse_forward()})"


def main():
    dll = DoublyLinkedList()
    dll.insert_front(1)
    dll.insert_front(2)
    dll.insert_back(3)
    print(dll.traverse_forward())  # expect [2, 1, 3]
    print(dll.traverse_backward())  # expect [3, 1, 2]

    dll.reverse()
    print(dll.traverse_forward())  # expect [3, 1, 2]
    print(dll.traverse_backward())  # expect [2, 1, 3]

    node = dll.insert_front(99)
    node1 = dll.insert_back(100)
    print(dll.traverse_forward())  # expect [99, 3, 1, 2, 100]
    dll.delete(node)
    dll.delete(node1)
    print(dll)


if __name__ == "__main__":
    main()
