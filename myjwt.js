// "use strict";
// // This is an example plugin that add a header to the response

// class KongPlugin {
//   constructor(config) {
//     this.config = config;
//   }

//   async access(kong) {
//     await Promise.all([
//       kong.response.setHeader("x-hello-from-javascript", "Javascript"),
//       kong.response.setHeader("x-javascript-pid", process.pid),
//     ]);
//   }
// }

// module.exports = {
//   Plugin: KongPlugin,
//   Schema: [{ message: { type: "string" } }],
//   Version: "0.1.0",
//   Priority: 0,
// };

"use strict";
const xml2js = require("xml2js");

// This is an example plugin that adds a header to the response
class KongPlugin {
  constructor(config) {
    this.config = config;
  }

  async access(kong) {
    const json = {
      name: "myjwt",
      version: "0.1.0",
      description: "hello JS plugin from kong",
      dependencies: {
        "kong-pdk": "^0.5.5",
      },
    };

    const builder = new xml2js.Builder({ pretty: true });

    // Convert JSON to XML
    const xml = builder.buildObject(json);

    kong.log.info("calling xml from json", xml);

    await Promise.all([
      kong.response.setHeader("x-hello-from-javascript", xml),
      kong.response.setHeader("x-javascript-pid", process.pid),
    ]);
  }

  async header_filter(kong) {
    kong.response.setHeader("x-hello-from-javascript", "Javascript");
  }

  async body_filter(kong) {
    // Manipulating the response body
    const responseBody = kong.response.getBody(); // Get the response body

    if (responseBody) {
      // Example: Append some text to the response body
      const modifiedBody = responseBody + "\n<!-- Added by MyPlugin -->";

      // Log the modified response body for debugging
      kong.log.info("Modified body:", modifiedBody);

      // Set the new body
      await kong.response.setBody(modifiedBody);
    } else {
      kong.log.info("No body found to modify.");
    }
  }
}

module.exports = {
  Plugin: KongPlugin,
  Schema: [{ message: { type: "string" } }],
  Version: "0.1.0",
  Priority: 0,
};
