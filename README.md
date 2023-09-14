Hello and welcome to my complete repository for the Apex Specialist SuperBadge on Trailhead.com. You can visit this page to see the guidelines for this project: https://trailhead.salesforce.com/content/learn/superbadges/superbadge_apex

Project Overview:

- Created an "after update" trigger to fire the helper class "MaintenanceRequestHelper." The helper class contains all the logic for updating and creating records. I modularized all the methods in this class to decouple and optimize for flexibility. Overall, this code helps automate the process of creating new maintenance requests and their associated maintenance items based on existing requests and their equipment maintenance details.

- "ParseEquipment" takes the response from the Warehouse and returns a list of objects created from the parsed JSON response.

- "TestDataFactory" was created by choice to reduce lines of code in the test classes. I've used it in most test classes during the test setup section, so that test classes are optimized. Data is exposed to each test method, and is created at the initial test setup method.

- "WarehouseCalloutService" implements the Queueable interface and allows callouts. This class is designed to synchronize and update product inventory data in Salesforce by fetching external equipment information through an HTTP callout and updating the corresponding records in the database. I created several methods so that testing each was easier. Since it had a callout method, it made it more difficult to test.

- "WarehouseCalloutServiceMock" was created to mock a real callout response for testing purposes.

- "WarehouseSyncSchedule" implements the Schedulable interface and allows me to schedule the WarehouseCalloutService class to be programmed programmatically through APEX.

- ALL APEX CONTROLLERS HAVE A CORRESPONDING APEX TEST CLASS.

- "StaticResource.Warehouse_Callout_Mock" was added to show best practices when dealing with test data. This text file is the same text that is returned from the actual response.

- "External_Equipment_Integration__mdt" record was added so that multiple headers could be added to the request body. This wasn't required; I just thought it was a nice extra touch on the project.