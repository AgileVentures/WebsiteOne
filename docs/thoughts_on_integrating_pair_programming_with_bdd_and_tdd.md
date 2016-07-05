PP can be great a great tool for various things, as well as just fun by itself.
In order to get the maximum out of PP, it should be approached bearing some points in mind.
 
The first things that come to mind are – writing production code and learning.  
These are tasks can be very different nature and thus should be approached in a different manner in order to get the maximum potential out of PP
 
### Purposes of Pair Programming
 
  * Write production code
  * Learn and explore together
  * Have fun

Let's look at Writing production code:

**Here's the main idea: Get the job done!**
 
The whole idea of writing the code together is to achieve a goal more efficiently than you would on your own. [actually team communication is just as important as efficiency on a single task]  In this case, the goal would be - to get a working code, working prototype, passing test or functioning feature, while making fewer mistakes, having cleaner code, sharing ideas and finding better solutions together with a partner.
 
Any code can be working or non-working, ugly or beautiful, simple or complicated.  Ideally, we want a simple, beautiful and working code.  But if we need to choose, in this scenario we choose working code and speed.  Get the job done as quickly and simply as you can and then refactor all you want. 
 
This approach is ideally reflected in BDD/TDD Red – Green – Refactor cycle.

**Before you start:**

1. Set up the workspace.  It must be comfortable for both of you.

2. It is crucial to set a time and goal!  Use SMART technique to derive an adequate goal.

## Red – Green phase
<hr>
### As a Driver:

**Write a failing test:**
 
1\.  Choose a simplest to implement example that comes to mind.  The order in which the examples are implemented does not matter.  What matters is getting the business value out of working code in the end.  
  
After finishing with this example, move onto the next simplest one.  Move in short simple steps and add complexity gradually. It will not runaway from you.
 
2\.  Remember that writing an example carries several intentions: 

* To describe or specify the responsibilities and behavior of the future code we wish we had

* To serve as documentation for you, your colleagues, end users and all the people you do not know.  This is your chance to make the world a better place.  Use it.

* Discover and set requirements or specifications on the behavior and interfaces of the future code, i.e. what it should do, who and how to call, what to receive, etc.

* To set expectations on the results of code execution, i.e. on its state after it has been run.  This, however, should be avoided in preference of behavior expectations.

* To provide a test to exercise the code and make sure that it is doing the job the way we expected

* To provide us with a guard or safety net to assist us during refactoring, aka regression test.

* Use the FIRST principle - the test must be:
  - Fast 
  - Independent of other tests
  - Repeatable , i.e. producing the same output given the same input
  - Self-checking, i.e. does not require a human to validate
  - Timely, i.e. in time for the job

3\.  Do it quickly and do it simple:

* The example should be easy to read, i.e it should  make the intention of the code immediately obvious 

* Use simple expectation values, that can be checked in your head, without the need of a calculator

* Use simple language constructs, avoid conditionals, loops and variable declarations which are purposed to reduce duplication in the code, but make the example harder to read.

* Employ the “good enough” principle, i.e. follow the accepted code style conventions, but do not slow yourself down by thinking of 'nice' example descriptions and comments, 'ideal' variable names and funky testing framework constructs and abilities.  The only measures are that your pair partner understands the example's description and purpose, and the interpreter accepts it.

* Once you have chosen the example – keep focused on this and this only task and its implementations.  It is the observer's job to think of larger issues.  Tactics – for you, strategy for the observer.
 
4\.  Work with your pair partner

* Comment your flow of thought and the flow of your hands over the keyboard.  Tell you partner what you are doing and what you want to do, i.e. what example you want to describe, what piece of code you want to write, what requirements you want to impose on the future code, its implementation or its state.

* Discuss your ideas with him as you go.  This way you will be making sure that he is following you and will not make him feel like you are making all the decisions.

* Confirm that your partner agrees or supports you on specifics that you may doubt about, like naming, algorithm or architecture. Ask his advice.  His job is to help you.

* Ask the observer if he thinks the test is valid or the chosen algorithm is adequate.

* Thank the observer when he points out an error or suggests an improvement.

* Ask your partner to lookup documentation, so you do not get distracted away.

5\. If your partner does not understand the code and asks you to make it simpler – do it!
 
Do it, no matter what you think about your partner's abilities and no matter if you think that your code is trivial.  If your partner cannot understand it then it is not simple and in this context - it is useless.   Simple > Short > Long.  
 
Unnecessary complexity is also a smell:

  * Clumsy chained calls
  * Conditionals with more than one assertion
  * Branching conditionals
  * Unjustifiable use of pseudo-beautiful, half-magic language constructs – function references, blocks, lambdas, closures and their friends
 
And never pity losing your super smart code! 
  
The value of code is either in getting the job done, and in PP the job is to get the code working and to get your partner to understand it.  

Another value of your particular code can be in its outstanding ability to satisfy your ego and make you feel extremely pleased with yourself and your coolness.

Fair enough.  We all know that writing code is an art and we all like that feeling of aesthetic pleasure from the code and ourselves. However, PP is not the place nor time for it.  Do it in your own privacy or, on the contrary, do the opposite - go public and tell the world about it.   But save your partner from it – he is here for another reason and he did not ask you for it.

<br> 
**Write the code to make the test pass:**
 
1. Get the code to work.  Do it as quickly as possible.

2. All the points said above about writing examples apply.  The only purpose of the code is to work and be understandable by your partner.

3. I will repeat it – focus on the tasks on hands.  Do not invent something that you can bet your life on you know will be needed in future.  When the need arises – you will implement it.

4. Similarly, do not try to optimize the code you have not written yet.  If the performance of the feature is not satisfactory once you made it work, then optimize it.  This is the emerging design technique.

5. Development and refactoring are different: different skills, using different techniques, to be performed at different times in the overall cycle.

<br>
**Once you get Green, i.e. the test is passing:**
 
1. Celebrate!  Literally!  You are one step closer to your goal.

2. Reflect on what you have just done and discuss with your partner.  Time to move onto refactoring.
 
### As an Observer:

Your job is to observe and help the driver not only by doing things, but also by not doing some of them:

1. Do not distract the driver from the task.  Let him write his code, when turn comes – you will write yours.

2. Watch out for syntax and semantic errors and suggest corrections.  Be gentle and take your time – sometimes it is better to let the driver finish the line or block and then let him know.

3. Stay focused.  While the driver is typing, he relies on you. 

4. If the driver asks you for advice – give your opinion.  Otherwise, if you think there is a better way to name a variable, to make a traversal or to write a comment – make a note and wait till refactor phase.

5. If the driver is stuck and you see a simpler way to implement – suggest it to driver, but do not push it.  If he likes the idea – OK, if not - you can discuss it during refactor.

6. Do not grab onto every details of driver's implementation.  Your job is code review, but more importantly – the strategy.  Think of larger issues arising from the code.  Think about next step and architecture, ways of simplifying and improving the current implementation, potential problems and misses, like inputs that are not covered, unhandled scenarios that may lead to a failure.  Write it down and discuss at refactor phase.

7. Lookup documentation to suggest better constructs for refactoring.

## Refactor phase
<hr>
Martin Fowler describes refactoring as “a change made to internal structure of software to make it easier to understand and cheaper to modify without changing its observable behavior.”   There are very good books about refactoring that a very worth reading.  I will quote and summarize some critical in my view points that the authors give in their books.

1\.  Refactoring is a transition to the simplest design that passes all current tests, by removing any smells you just introduced on the Red – Green phase.

2\.  Simple design is:

* it communicates every intention important to the programmers.
* it has no duplication of code, or of logic, or of knowledge
* it contains no unnecessary code
 
3\.  Refactoring does not include just any changes in a system: focus on making simpler code, not adding new features, i.e. choose one, worst smell, refactor, test and repeat the cycle.
 
4\.  Refactoring is not just any restructuring intended to improve code: all change must me done in simple, short steps and be safe.
   
5\.  Always try to stay in the Green, i.e. spend as little time in the Red while refactoring, as possible.
 
6\.  After updating the code, update the specs if the examples no longer reflect the responsibilities of the objects they describe.
 
7\.  Refactoring can go on pretty much forever, so do decide with your partner on how many internal cycles of refactoring you will be doing each Red – Green – Refactor cycle.
      
## Switch roles and repeat the cycle
<hr>