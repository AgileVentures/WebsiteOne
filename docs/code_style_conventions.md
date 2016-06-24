Sub-documents   
   * [[Rails Asset Pipeline]]
   * [[Create tags for project]]
   * [[Adding title to page view]]


<font size="2" color="green"><ul>
<li>In order to keep the code style consistent across the project</li>
     <li> As a project maintainer</li>
     <li> I would like to have a document which describes accepted code style</li>
     <li> And I would like developers to follow it</li>
     <li> And I would like the document to be maintained by the code reviewer and updated with pull requests from project members</li>
</ul></font>
### Collaborative Software Development
Within the WebsiteOne project, we are fully dedicated to Pair Programming and Crowdsourced Learning. 
That means that we strive to solve programming challenges in pairs and document our efforts so that 
other members can review our work after the fact. That means that we make use of Hangouts on Air, GitHub Pong, 
Peer review, etc for ALL code and documentation we produce within the WebsiteOne project. By fully 
adopting those methods, we can make sure that all AgileVentures members can benefit from our work. 


### Altering someone's code
#### Simply don't do it unless you really have to in order to deliver your feature.  
If it is the case, then:

    * Discuss the issue with the author on slack (or by other means)
    * Leave a comment in the code for the author, e.g. 'Consider refactoring using helper methods'
    * Leave a comment on altered lines in the commit, explaining the reasons for alterations
    * Make sure all tests are passing

If it is a refactoring issue, it is better to point out the the issue to the author and 
let them do it themselves or alter code in a pairing session with him.

### Comments in code
    * The code should simple enough to self-explanatory, so you should not comment on **HOW** the code works
    * Comments can be added to to explain **WHY** this code is here and is doing what it is doing
    * Comments can also be used to leave a message for other developers, e.g. 'needs refactoring', 'will be replaced',  etc.
    * Comments should be done in the following format: 
        * # Comment (general comment)
        * #TODO NS Comment (a personal todo, where NS = NameSurname initials)
        * #TODO Comment (anyone's todo)
    * Hardcoded data - when hardcoding test data, e.g. a parameter for a method call ( get :edit, id: **1** ):
        - leave a comment in the code, indicating that this hardcoded data is to be replaced.  
        - This comment is mainly for yourself, but for others too, in case you forget to remove the hardcoded data.

