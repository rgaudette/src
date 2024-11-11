
test.class: Base.class Derived.class test.java
	javac test.java

Derived.class: Base.class Derived.java
	javac Derived.java

Base.class:	Base.java
	javac Base.java
