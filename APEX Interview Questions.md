1. **PLUGINS**:
   Plugins enable developers to enhance the existing built-in functionality with new item types, region types, process types, and dynamic actions to enhance and customize their application.

   Several types of plugins are available:
   - **Item Plugins**: Icon picker, Print now
   - **Region Plugin**: Year Planned calendar, Google Organization Charts
   - **Dynamic Action Plugin**: Text area enlarger, Floating scrollbar
   - **Authentication Plugin**: Facebook authentication plugin, Google authentication plugin
   - **Authorization Plugin**: LDAP Group authorization

2. **Name some Apex applications you know?**
   - Universal theme sample applications
   - P-Track
   - Sample REST Services
   - Sample database applications
   - Apex application Archive

3. **Apex Application Builder**:
   An application is a collection of database-driven web pages linked together using tabs, buttons, or hypertext links. The pages within an application share a common session state definition and authentication method. Application Builder is the tool used to build the pages that comprise an application.

4. **What is the URL of the application?**

- [https://apex.oracle.com/pls/apex/f?p=4750:50:105905810151901::NO](https://apex.oracle.com/pls/apex/f?p=4750:50:105905810151901::NO)


- `apex.oracle.com`: Basic URL
- `4750`: Application number
- `50`: Page number
- `105905810151901`: Session number

5. **What are the building blocks/components of Apex applications?**
Pages, items, regions, dynamic actions, validations, computations, authentication, authorization, shared components, lists, themes, etc.

6. **How will you define page cache?**
Enabling region caching is an effective way to improve the performance of static regions such as regions containing lists that do not use conditions or regions containing static HTML. The Application Express engine only renders a region from cache if it meets the defined condition. Additionally, regions can be cached specific to a user or cached independent of a user.

7. **How is a page rendered?**
Show page and accept page process.

8. **Where will you add logout or custom links?**
Go to shared components and add in the navigation bar list, or use user interface attributes.

9. **How will you pass the value of one item from one page to another?**
Passing bind variable.

10. **How will you code dynamic PL/SQL regions?**
 ```plsql
 BEGIN
   HTP.P(<html statements with escape special characters>);
 END;
 ```

11. **What are different caching methods available?**
 - Page
 - For item
 - For session
 - For application

12. **How will you use AJAX?**
 ON DEMAND Process.

13. **What are the uses of Application level processes or how will you create an application level processes?**
 In shared components, an application process can be created. Application processes run PL/SQL logic at specific points for each page in an application or as defined by the conditions under which they are set to fire. Note that "Ajax Callback" processes fire only when from AJAX or by "Ajax callback" process defined for pages.

14. **What are available options available to develop a list of values?**
 - Static
 - Dynamic
 - From shared components

15. **How will you use lists which can be shared across applications?**

16. **How will you create a tree list?**
 In shared components, lists options are available. Create a list, and under that create list entries and make sure that the list entry will be under the list.

17. **How will you show the default value for an item?**
 By clicking on that item, some properties are available on the right side. In that, a default option is available. There is a dropdown available:
 - Static
 - Item
 - SQL query
 - SQL query returning colon-delimited list
 - PL/SQL expression
 - PL/SQL Function body
 - Sequence

18. **How are items named and referenced?**

19. **How will you process multiple items or an array of items?**

20. **How will you add a JavaScript function to an item?**

21. **Why / How will you use PL/SQL dynamic content?**

22. **How will you add validations to an item?**
 In Process, we can add validations:
 - Item is null
 - Item is not null
 - Item=value
 - Item!=value
 - PL/SQL expression
 - PL/SQL function body (returning boolean), etc.

23. **What are the various reports possible?**
 - Interactive report
 - Classic report

24. **How will you use RTF/PDF report options?**

25. **How will you create parameterized reports?**

26. **How will you create an editable column link or "Link Column"?**
 In reports region, we can create a link to the column or separately we can create links. For a column, click on that column; right properties are available:
 - Identification—type—link

 In the report region attribute option available, the link option available:
 - Link to single row view
 - Link to custom target
 - Exclude Link column

27. **How will you add CHECK BOX option as a column in a report?**
 APEX_ITEM.CHECKBOX

28. **What are different kinds of forms available?**
 - Form
 - Editable Interactive grid
 - Report with form
 - List view with from
 - Form on local procedure
 - Tabular form

29. **What are the various charts available?**
 Area, bar, box plot, bubble, combination, donut, funnel, Gantt, line, line with area, pie, polar, pyramid, radar, range, scatter, stock
