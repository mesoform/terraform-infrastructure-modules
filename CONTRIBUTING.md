## Contributing
* use 2 character indents
* if writing an adapter module, each adapter should have its own main file for defining defining 
resources
* if writing an adapter module, each adapter should have its own locals file for defining logic
* all effort should be made to keep any logic is locals sections to make testing easier
* default values outside of variable declarations should be kept in locals sections
* hard-coded values (I.e. for security) should be added in a locals section and evaluated in other
blocks from there
* Cloud Service Provider (CSP) modules should be kept in the CSP named directory
* MCP module is considered a special module for MMCF adapters for serverless deployment modules
* tests directory contains example and testable cases for each module, or module adapter, logic

Feel free to ask any questions in issues or on this [email](mailto:support@mesoform.com).

### Code of Conduct

Mesoform officially incorporates the [Mozilla Community Participation Guidelines](https://www.mozilla.org/en-US/about/governance/policies/participation/) as its Code of Conduct with the exception that the reporting email address is changed to [support](mailto:support@mesoform.com).
