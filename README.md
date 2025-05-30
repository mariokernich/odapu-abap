<img src="./images/odapu-logo.png" alt="Logo" width="250"/>

# OData & APC Test Tool

This app gives you a powerful tool to test ODATA services – whether it’s modern ABAP RAP/CDS or classic SEGW projects – as well as APC (ABAP Push Channels).
With its intuitive UI, you can easily build test cases, run them instantly, and save them for quick access later.
No more manual hassle – just click, test, repeat. ⚡

## 🚀 Highlights

- **One Tool for everything:** ODATA and ABAP Push channel in one place. Whether using old or newer, modern technolgoies. 
- **Parallel Testing:** Run multiple requests or channels simultaneously – perfect for complex debugging and real-time monitoring. Each project will be placed in it's own tab, which can be switched anytime. 
- **ODATA Request builder:** Easily switch between entity (and CRUD operation), function and action to pick the right ressource you want to test. Based on the selection, you will see the right inputs to fill. 
- **Extended ODATA entity functions:** Detailed and user friendly options to define filter, sorter, header and general request options with no need of manual URL build. 
- **Project Management:** Save, load, and organize your test cases.
- **Service & Channel Search:** Quickly find OData services and Push Channels.
- **Flexible Data View:** Switch between different views to display data.

## 🔧 System Requirements
- At least one system with S/4HANA components
- Works both on-premise and in the SAP BTP (Cloud) environment

## Feature Showcase

Main screen of ODATA service testing.

![Main Screen](./images/main.png)

Switch from JSON data preview to table view mode. 

![Table view](./images/table-switch.gif)

Easily add and modify filter and sorter definitions by choosing properties from the selected entity. 

![Filter](./images/filter.gif)

Just search and pick your service from a list. 

![Service Search](./images/pick-service.gif)

Save and load your projects. 

![Project Load](./images/project-load.png)

Create parallel projects and test multiple resources at the same time. 

![New Project](./images/new-project.png)

Pick any ABAP Push Channel which is available on the system.

![APC Search](./images/apc-search.png)

Push channel main view. Connect or disconnect the selected ABAP Push Channel. Write and Receive Messages.

![APC](./images/apc.png)

## 📌 How to use

To set up and use this project, you need to use abapgit. Follow these steps:

1. Install abapgit in your ABAP system.
2. Clone this repository using abapgit.
3. Follow the abapgit instructions to pull and activate the project.

For more details, visit the [abapgit documentation](https://docs.abapgit.org/).

Afterwards assign role **ZODPU** to your SAP user and start Fiori Launchpad to use it. 

The source code of the UI5 application can be found here: https://github.com/mariokernich/odapu-ui5

## License

This project is licensed under the Apache Software License, version 2.0 except as noted otherwise in the [LICENSE](LICENSE) file.
