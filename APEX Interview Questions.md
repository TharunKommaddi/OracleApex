1.PLUGINS:

Plugins enable developers to enhance the existing built in functionality with new item types,region types,process types and dynamic actions to enhance and customize their application

there are several types of plugins are available:

1.Item pulgins:icon picker,print now
2.Region plugin:Year PLanned calender,Google Organization charts
3.Dynamic action plugin:Text area enlarger,Floating scrollbar
4.Authentication Plugin:Facebook authentication plugin,Google authentication plugin
5.Authorization plugin:LDAP Group authorization


2.Name some apex applications you know?
1.Universal theme sample applications
2.P-Track
3.Sample REST Services
4.Sample database applications
5.Apex appication Archieve

3.Apex application builder?
AN appication is a collection of a database driven web pages linked together using tabs,buttons or hypertext links.the pages within an applicationshare a common session state definition and authentication method.Applicationn builder is the tool you to build the pages that comprise an application


4.What is the URL of the application?

https://apex.oracle.com/pls/apex/f?p=4750:50:105905810151901::NO

apex.oracle.com===>It is the basic url
4750=>application number
50=>page number
105905810151901=>session number


5.What is the building blocks/components or apex applications?

pages,items,regions,dynamic actions,validations,computations,authentication,authorization,shared components,lists,themes etc

6.How will you define page cache?
Enabling region caching is an effective way improve the performance of static regions such as regions containing lists that do not use conditions or regions containing static HTML.
The Application Express engine only renders a region from cache if it meets the defined condition. Additionally, regions can be cached specific to a user or cached independent of a user.

7.How a page is rendered?

Show page and accept page process

8.Where will you add logout or custom links?

Goto shared components add in navigation bar list

Or

user interface attributes

9.How will you pass value of one item from one page to another?

Passing bind variable 

10.How will you code dynamic PL/SQL regions?

begin
htp.p(<html statements with escape special characters>)
end;

11.What are different caching methods available?
page
for item
for session
for application

12.How will you use AJAX?

ON DEMAND Process

13.What are the uses of Application level processes or how will you create an application level processes? 

In shared components application proccess can be created

Application process run PLSQL logic at specific points for each page in an application or as defined by the conditions under which they are set to fire.
note that "Ajax Callback" process fire only when from ajax or by "Ajax call back" process defined for pages

14.Whar are available options available to develop list of values?
1.static
2.Dynamic
3.From shared components

15.How will you use lists which can be shared across applications?

16.How will you create tree list?
in shared components lists options available 
create list 
under that create list entries and make sure that the list entry will be under list

17.How will you show default value for an item?

By click on that item
Right side some properties are available in that default option available
ther is dropdown will be available
1.static
2.Item
3.sql query
4.sql query returning colon delimited list
5.PLSQL expression
6.PLSQL Function body
7.Sequence

18.How are items named and referenced?

19.How will you process multiple items or array of items?

20.How will you add javascript function to item?

21.Why / How will you use PL/SQL dynamic content?

22.How will you add validations to an item?
In Process we can add validations
1.item is null
2.item is not null
3.item=value
4.item!=value
5.PLSQL expression
6.plsql function body(returning boolean) etc

23.What are the various reports possible?
a)Interactive report
b)Classic report

24.HOw will you use RTF/PDF report options?

25.How will you create parameterized reports?

26.How will you create editable column link? or “Link Column”.
In reports region we can create link to the column or seperately we can create links
For column
Click on that column right properties are available 
identification---type--link

IN report region attribute option available
the link option available:
1.Link to single row view
2.Link to custom target
3.Exclude LInk column

27.How will you add CHECK BOX option as a column in report? 
APEX_ITEM.CHECKBOX

28.what are different kinds of forms available?
a)Form
b)Editable Interactive grid
c)Report with form
d)List view with from
e)Form on local procedure
f)tabular form

29.What are the various charts available?
Area,bar,box plot,bubble,combination,donut,funnel,gantt,line,line with area,pie,polar,pyramid,radar,range,scatter,stock


	



