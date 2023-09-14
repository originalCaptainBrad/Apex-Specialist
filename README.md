Hello and welcome to my complete repo for Apex Specialist SuperBadge on Trailhead.com . You can visit this page to see the guidelines for this project here https://trailhead.salesforce.com/content/learn/superbadges/superbadge_apex.

Project Overview
- Created a is after update trigger to fire the helper class
-"MaintenanceRequestHelper" the helper class contains all the logic for the for updating and creating records. I modularized all the methods in this class to decouple and optimize for flexibility. Overall, this code helps automate the process of creating new maintenance requests and their associated maintenance items based on existing requests and their equipment maintenance details.
- "ParseEquipment" takes the response from the Warehouse and returns a list of objects created from the parsed JSON response.
- "TestDataFactory" Was created by choice to reduce lines of code in the test classes. I've used it in most test classes during the test setup section so that test classes are optimized and data is exposed to each test method and is created at the intial testsetup method.
- "WarehouseCalloutService" implements the queueable interface and allows callouts. This class is designed to synchronize and update product inventory data in Salesforce by fetching external equipment information through an HTTP callout and updating the corresponding records in the database. I created several methods, so that testing each was easier. Since it had a callout method it made it more difficult to test.
- "WarehouseCalloutServiceMock" was created to mock a real callout response for testing purposes.
- "WarehouseSyncSchedule" implements the schedulable interface and allows me to schedule the WarehouseCalloutService class to be programmed programmatically through APEX.
- ALL APEX CONTROLLERS HAVE A CORRISPONDING APEX TEST CLASS.
- "StaticResource.Warehouse_Callout_Mock" Was added to show best practices when dealing with test data. This txt file is the same text that is return from the actual response.
- "External_Equipment_Integration__mdt" Record was added so that multiple headers could be added to the request body. This wasn't required I just thought it was a nice extra touch on the project.