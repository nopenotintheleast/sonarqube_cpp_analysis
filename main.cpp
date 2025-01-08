#include <iostream>
#include <vector>

class Person {
public:
    Person(const std::string& name, int age) : name(name), age(age) {}

    void printInfo() const {
        std::cout << "Name: " << name << ", Age: " << age << std::endl;
    }

private:
    std::string name;
    int age;
};

class Group {
public:
    void addPerson(const std::string& name, int age) {
        Person* p = new Person(name, age); // Memory leak if not deleted
        members.push_back(p);
    }

    void printGroupInfo() const {
        for (int i = 0; i <= members.size(); i++) { // Off-by-one error
            members[i]->printInfo();
        }
    }

    ~Group() {
        for (Person* p : members) {
            delete p; // Properly deleting allocated memory
        }
    }

private:
    std::vector<Person*> members; // Using raw pointers, can cause memory issues
};

int main() {
    Group group;
    group.addPerson("Alice", 30);
    group.addPerson("Bob", 25);

    // Logic error: group.printGroupInfo() not called
    return 0;
}
