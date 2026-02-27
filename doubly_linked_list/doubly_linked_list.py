class Node:
    __slots__ = ("value", "prev", "next")

    def __init__(self, value=None):
        self.value = value
        self.prev = None
        self.next = None


class DoublyLinkedList:
    def __init__(self):
        # Sentinel nodes (Always present, never removed)
        self.dummy_head = Node()
        self.dummy_tail = Node()
        self.dummy_head.next = self.dummy_tail
        self.dummy_tail.prev = self.dummy_head

    def insert_front(self, value):
        new = Node(value)
        old_first = self.dummy_head.next
        new.prev = self.dummy_head
        new.next = old_first
        self.dummy_head.next = new
        old_first.prev = new
        return new

    def insert_back(self, value):
        new = Node(value)
        old_last = self.dummy_tail.prev
        new.prev = old_last
        new.next = self.dummy_tail
        old_last.next = new
        self.dummy_tail.prev = new
        return new

    def delete(self, node):
        prev_node = node.prev
        next_node = node.next
        prev_node.next = next_node
        next_node.prev = prev_node
        node.prev = None
        node.next = None
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
        current = self.dummy_tail.prev
        while current is not self.dummy_head:
            values.append(current.value)
            current = current.prev
        return values

    def reverse(self):
        current = self.dummy_head
        while current is not None:
            current.prev, current.next = current.next, current.prev
            current = current.prev
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
    print(dll.traverse_forward())  # expect [99, 3, 1, 2]
    dll.delete(node)
    print(dll.traverse_forward())  # expect [3, 1, 2]


if __name__ == "__main__":
    main()
